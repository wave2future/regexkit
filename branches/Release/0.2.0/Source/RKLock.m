//
//  RKLock.m
//  RegexKit
//

/*
 Copyright © 2007, John Engelhart
 
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 * Neither the name of the Zang Industries nor the names of its
 contributors may be used to endorse or promote products derived from
 this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/ 

/*
 VERY IMPORTANT!!
 These locks use a fast single threaded bypass.  However, in order for lock / unlock semantics to be atomic in single and multithreaded cases, the following condition MUST be met:
 The users of the lock MUST NOT cause the application to become multithreaded while they own the lock!
 Guaranteeing this condition is trivial and results in a 10% - 20% speed improvement for the single threaded case.
*/

#import <RegexKit/RKLock.h>

static int globalIsMultiThreaded = 0;

@implementation RKLock

- (id)init
{
  [self autorelease];

  if((self = [super init]) == NULL) { goto errorExit; }

  int pthreadError = 0, initTryCount = 0, spuriousErrors = 0;
  lock = (pthread_mutex_t)PTHREAD_MUTEX_INITIALIZER;

  while((pthreadError = pthread_mutex_init(&lock, NULL)) != 0) {
    if(pthreadError == EAGAIN) {
      initTryCount++;
      if(initTryCount > 5) { NSLog(@"pthread_mutex_init returned EAGAIN 5 times, giving up."); goto errorExit; }
      RKThreadYield();
      continue;
    }
    if(pthreadError == EINVAL)  { NSLog(@"pthread_mutex_init returned EINVAL.");  goto errorExit; }
    if(pthreadError == EDEADLK) { NSLog(@"pthread_mutex_init returned EDEADLK."); goto errorExit; }
    if(pthreadError == ENOMEM)  { NSLog(@"pthread_mutex_init returned ENOMEM.");  goto errorExit; }
    
    if(spuriousErrors < RKLOCK_MAX_SPURIOUS_ERROR_ATTEMPTS) {
      spuriousErrors++;
      RKAtomicIncrementInt((int *)&spuriousErrorsCount);
      NSLog(@"pthread_mutex_init returned an unknown error code %d. This may be a spurious error, retry %d of %d.", pthreadError, RKLOCK_MAX_SPURIOUS_ERROR_ATTEMPTS);
    } else {
      NSLog(@"pthread_mutex_init returned an unknown error code %d. Giving up after %d attempts.", pthreadError, RKLOCK_MAX_SPURIOUS_ERROR_ATTEMPTS);
      goto errorExit;
    }
  }

  return([self retain]);

errorExit:
  return(NULL);
}

- (void)dealloc
{
  int pthreadError = 0, destroyTryCount = 0;

  while((pthreadError = pthread_mutex_destroy(&lock)) != 0) {
    if(pthreadError == EBUSY) {
      usleep(50);
      destroyTryCount++;
      if(destroyTryCount > 100) { NSLog(@"pthread_mutex_destroy returned EAGAIN 100 times, giving up."); goto errorExit; }
      RKThreadYield();
      continue;
    }
    if(pthreadError == EINVAL)  { NSLog(@"pthread_mutex_destroy returned EINVAL.");  goto errorExit; }
  }

errorExit:
  [super dealloc];
}

- (unsigned int)hash
{
  return((unsigned int)self);
}

- (BOOL)isEqual:(id)anObject
{
  if(self == anObject) { return(YES); } else { return(NO); }
}

- (BOOL)lock
{
  return(RKFastLock(self));
}

- (void)unlock
{
  RKFastUnlock(self);
}

- (void)setDebug:(const BOOL)enable
{
  debuggingEnabled = enable;
}

- (unsigned int)busyCount
{
  return(busyCount);
}

- (unsigned int)spinCount
{
  return(spinCount);
}

- (void)clearCounters
{
  busyCount = 0;
  spinCount = 0;
}

@end

BOOL RKFastLock(RKLock * const aLock) {
  if(RK_EXPECTED(aLock == NULL, 0)) { return(NO); }
  struct RKLockDef { @defs(RKLock) } * RK_C99(restrict) self = (struct RKLockDef *)aLock;
  int pthreadError = 0, spuriousErrors = 0;
  NSString * RK_C99(restrict) functionString = @"pthread_mutex_trylock";
  BOOL didLock = NO;

  if(globalIsMultiThreaded == 0) {
    if(RK_EXPECTED([NSThread isMultiThreaded] == NO, 1)) { return(YES); }
    RKAtomicCompareAndSwapInt(0, 1, &globalIsMultiThreaded);
  }

  pthreadError = pthread_mutex_trylock(&self->lock);
  
  switch(pthreadError) {
    case 0:                                     didLock = YES; goto exitNow;  break; // Lock was acquired
    case EBUSY:  if(self->debuggingEnabled == YES) { self->busyCount++; }     break; // Do nothing, we need to wait on the lock, which we do after the switch
    case EINVAL: NSLog(@"%@ returned EINVAL.", functionString); goto exitNow; break; // XXX Hopeless?
    default:
      if(spuriousErrors < RKLOCK_MAX_SPURIOUS_ERROR_ATTEMPTS) {
        spuriousErrors++;
        RKAtomicIncrementInt((int *)&self->spuriousErrorsCount);
        NSLog(@"%@ returned an unknown error code %d. This may be a spurious error, retry %d of %d.", functionString, pthreadError, RKLOCK_MAX_SPURIOUS_ERROR_ATTEMPTS);
      } else { NSLog(@"%@ returned an unknown error code %d. Giving up after %d attempts.", functionString, pthreadError, RKLOCK_MAX_SPURIOUS_ERROR_ATTEMPTS); goto exitNow; }
      break;
  }
  
  functionString = (self->debuggingEnabled == YES) ? @"pthread_mutex_trylock":@"pthread_mutex_lock";
  
  do {
    if(self->debuggingEnabled == YES) { pthreadError = pthread_mutex_trylock(&self->lock); } else { pthreadError = pthread_mutex_lock(&self->lock); }
      
    switch(pthreadError) {
      case 0:                                                                                    didLock = YES; goto exitNow; break; // Lock was acquired
      case EBUSY:   if(self->debuggingEnabled == YES) { self->spinCount++; }                                 RKThreadYield(); break; // Yield and then try again
      case EINVAL:  NSLog(@"%@ returned EINVAL after a trylock succeeded without any error.", functionString);  goto exitNow; break; // XXX Hopeless?
      case EDEADLK: NSLog(@"%@ returned EDEADLK after a trylock succeeded without any error.", functionString); goto exitNow; break; // XXX Hopeless?
      default:
        if(spuriousErrors < RKLOCK_MAX_SPURIOUS_ERROR_ATTEMPTS) {
          spuriousErrors++;
          RKAtomicIncrementInt((int *)&self->spuriousErrorsCount);
          NSLog(@"%@ returned an unknown error code %d. This may be a spurious error, retry %d of %d.", functionString, pthreadError, RKLOCK_MAX_SPURIOUS_ERROR_ATTEMPTS);
        } else { NSLog(@"%@ returned an unknown error code %d. Giving up after %d attempts.", functionString, pthreadError, RKLOCK_MAX_SPURIOUS_ERROR_ATTEMPTS); goto exitNow; }
        break;
    }    
  } while(pthreadError != 0);

exitNow:
  return(didLock);
}

void RKFastUnlock(RKLock * const aLock) {
  if(RK_EXPECTED(aLock == NULL, 0)) { return; }
  struct RKLockDef { @defs(RKLock) } * RK_C99(restrict) self = (struct RKLockDef *)aLock;
  int pthreadError = 0;
  
  if(globalIsMultiThreaded == 0) { return; }
  if(RK_EXPECTED((pthreadError = pthread_mutex_unlock(&self->lock)) != 0, 0)) {
    if(pthreadError == EINVAL) { NSLog(@"pthread_mutex_unlock returned EINVAL.");           return; }
    if(pthreadError == EPERM)  { NSLog(@"pthread_mutex_unlock returned EPERM, not owner?"); return; }
  }
}

@implementation RKReadWriteLock

- (id)init
{
  [self autorelease];
  
  if((self = [super init]) == NULL) { goto errorExit; }
  
  int pthreadError = 0, initTryCount = 0, spuriousErrors = 0;
  readWriteLock = (pthread_rwlock_t)PTHREAD_MUTEX_INITIALIZER;

  while((pthreadError = pthread_rwlock_init(&readWriteLock, NULL)) != 0) {
    if(pthreadError == EAGAIN) {
      initTryCount++;
      if(initTryCount > 5) { NSLog(@"pthread_rwlock_init returned EAGAIN 5 times, giving up."); goto errorExit; }
      RKThreadYield();
      continue;
    }
    if(pthreadError == EINVAL)  { NSLog(@"pthread_rwlock_init returned EINVAL.");  goto errorExit; }
    if(pthreadError == EDEADLK) { NSLog(@"pthread_rwlock_init returned EDEADLK."); goto errorExit; }
    if(pthreadError == ENOMEM)  { NSLog(@"pthread_rwlock_init returned ENOMEM.");  goto errorExit; }
    
    if(spuriousErrors < RKLOCK_MAX_SPURIOUS_ERROR_ATTEMPTS) {
      spuriousErrors++;
      RKAtomicIncrementInt((int *)&spuriousErrorsCount);
      NSLog(@"pthread_rwlock_init returned an unknown error code %d. This may be a spurious error, retry %d of %d.", pthreadError, RKLOCK_MAX_SPURIOUS_ERROR_ATTEMPTS);
    } else {
      NSLog(@"pthread_rwlock_init returned an unknown error code %d. Giving up after %d attempts.", pthreadError, RKLOCK_MAX_SPURIOUS_ERROR_ATTEMPTS);
      goto errorExit;
    }
  }
  
  return([self retain]);
  
errorExit:
    return(NULL);
}

- (void)dealloc
{
  int pthreadError = 0, destroyTryCount = 0;
  
  while((pthreadError = pthread_rwlock_destroy(&readWriteLock)) != 0) {
    if(pthreadError == EBUSY) {
      usleep(50);
      destroyTryCount++;
      if(destroyTryCount > 100) { NSLog(@"pthread_rwlock_destroy returned EAGAIN 100 times, giving up."); goto errorExit; }
      RKThreadYield();
      continue;
    }
    if(pthreadError == EPERM)  { NSLog(@"pthread_rwlock_destroy returned EPERM.");  goto errorExit; }
    if(pthreadError == EINVAL) { NSLog(@"pthread_rwlock_destroy returned EINVAL."); goto errorExit; }
  }
  
errorExit:
  [super dealloc];
}

- (unsigned int)hash
{
  return((unsigned int)self);
}

- (BOOL)isEqual:(id)anObject
{
  if(self == anObject) { return(YES); } else { return(NO); }
}

- (BOOL)lock
{
  return(RKFastReadWriteLock(self, YES)); // Be conservative and assume a write lock
}

- (BOOL)readLock
{
  return(RKFastReadWriteLock(self, NO));
}

- (BOOL)writeLock
{
  return(RKFastReadWriteLock(self, YES));
}

- (void)unlock
{
  RKFastReadWriteUnlock(self);
}

- (void)setDebug:(const BOOL)enable
{
  debuggingEnabled = enable;
}

- (unsigned int)readBusyCount
{
  return(readBusyCount);
}

- (unsigned int)readSpinCount
{
  return(readSpinCount);
}

- (unsigned int)writeBusyCount
{
  return(writeBusyCount);
}

- (unsigned int)writeSpinCount
{
  return(writeSpinCount);
}

- (void)clearCounters
{
  readBusyCount = 0;
  readSpinCount = 0;
  writeBusyCount = 0;
  writeSpinCount = 0;
}

@end

BOOL RKFastReadWriteLock(RKReadWriteLock * const aLock, const BOOL forWriting) {
  if(RK_EXPECTED(aLock == NULL, 0)) { return(NO); }
  struct RKReadWriteLockDef { @defs(RKReadWriteLock) } * RK_C99(restrict) self = (struct RKReadWriteLockDef *)aLock;
  int pthreadError = 0, spuriousErrors = 0;
  NSString * RK_C99(restrict) functionString = NULL;
  BOOL didLock = NO;

  if(globalIsMultiThreaded == 0) {
    if(RK_EXPECTED([NSThread isMultiThreaded] == NO, 1)) { return(YES); }
    RKAtomicCompareAndSwapInt(0, 1, &globalIsMultiThreaded);
  }
  
  if(RK_EXPECTED(forWriting == YES, 0)) {
    functionString = @"pthread_rwlock_trywrlock";
    pthreadError = pthread_rwlock_trywrlock(&self->readWriteLock);
    
    switch(pthreadError) {
      case 0:                                        didLock = YES; goto exitNow; break; // Lock was acquired
      case EAGAIN:                                                                       // drop through
      case EBUSY:   if(self->debuggingEnabled == YES) { self->writeBusyCount++; } break; // Do nothing, we need to wait on the lock, which we do after the switch
      case EDEADLK: NSLog(@"%@ returned EDEADLK.", functionString); goto exitNow; break; // XXX Hopeless?
      case ENOMEM:  NSLog(@"%@ returned ENOMEM.", functionString);  goto exitNow; break; // XXX Hopeless?
      case EINVAL:  NSLog(@"%@ returned EINVAL.", functionString);  goto exitNow; break; // XXX Hopeless?
      default:
        if(spuriousErrors < RKLOCK_MAX_SPURIOUS_ERROR_ATTEMPTS) {
          spuriousErrors++;
          RKAtomicIncrementInt((int *)&self->spuriousErrorsCount);
          NSLog(@"%@ returned an unknown error code %d. This may be a spurious error, retry %d of %d.", functionString, pthreadError, RKLOCK_MAX_SPURIOUS_ERROR_ATTEMPTS);
        } else { NSLog(@"%@ returned an unknown error code %d. Giving up after %d attempts.", functionString, pthreadError, RKLOCK_MAX_SPURIOUS_ERROR_ATTEMPTS); goto exitNow; }
        break;
    }

    if(self->debuggingEnabled == YES) { RKAtomicIncrementInt((int *)&self->writeBusyCount); }
    functionString = @"pthread_rwlock_wrlock";
    
    do {
      pthreadError = pthread_rwlock_wrlock(&self->readWriteLock);  // Don't trylock, allow write lock request to block reads for priority access
      
      switch(pthreadError) {
        case 0:                                                                                    didLock = YES; goto exitNow; break; // Lock was acquired
        case EAGAIN:                                                                                                                   // drop through
        case EBUSY:   if(self->debuggingEnabled == YES) { self->writeSpinCount++; }                            RKThreadYield(); break; // This normally shouldn't happen.
        case EINVAL:  NSLog(@"%@ returned EINVAL after a trylock succeeded without any error.", functionString);  goto exitNow; break; // XXX Hopeless?
        case EDEADLK: NSLog(@"%@ returned EDEADLK after a trylock succeeded without any error.", functionString); goto exitNow; break; // XXX Hopeless?
        case ENOMEM:  NSLog(@"%@ returned ENOMEM after a trylock succeeded without any error.", functionString);  goto exitNow; break; // XXX Hopeless?
        default:
          if(spuriousErrors < RKLOCK_MAX_SPURIOUS_ERROR_ATTEMPTS) {
            spuriousErrors++;
            RKAtomicIncrementInt((int *)&self->spuriousErrorsCount);
            NSLog(@"%@ returned an unknown error code %d. This may be a spurious error, retry %d of %d.", functionString, pthreadError, RKLOCK_MAX_SPURIOUS_ERROR_ATTEMPTS);
          } else { NSLog(@"%@ returned an unknown error code %d. Giving up after %d attempts.", functionString, pthreadError, RKLOCK_MAX_SPURIOUS_ERROR_ATTEMPTS); goto exitNow; }
          break;
      }    
    } while(pthreadError != 0);
    
  } else { // forWriting == NO
    functionString = @"pthread_rwlock_tryrdlock";
    pthreadError = pthread_rwlock_tryrdlock(&self->readWriteLock);
    
    switch(pthreadError) {
      case 0:                                       didLock = YES; goto exitNow; break;  // Lock was acquired
      case EAGAIN:                                                                       // drop through
      case EBUSY:   if(self->debuggingEnabled == YES) { self->readBusyCount++; } break;  // Do nothing, we need to wait on the lock, which we do after the switch
      case EDEADLK: NSLog(@"%@ returned EDEADLK.", functionString); goto exitNow; break; // XXX Hopeless?
      case ENOMEM:  NSLog(@"%@ returned ENOMEM.", functionString);  goto exitNow; break; // XXX Hopeless?
      case EINVAL:  NSLog(@"%@ returned EINVAL.", functionString);  goto exitNow; break; // XXX Hopeless?
      default:
        if(spuriousErrors < RKLOCK_MAX_SPURIOUS_ERROR_ATTEMPTS) {
          spuriousErrors++;
          RKAtomicIncrementInt((int *)&self->spuriousErrorsCount);
          NSLog(@"%@ returned an unknown error code %d. This may be a spurious error, retry %d of %d.", functionString, pthreadError, RKLOCK_MAX_SPURIOUS_ERROR_ATTEMPTS);
        } else { NSLog(@"%@ returned an unknown error code %d. Giving up after %d attempts.", functionString, pthreadError, RKLOCK_MAX_SPURIOUS_ERROR_ATTEMPTS); goto exitNow; }
        break;
    }
    
    functionString = (self->debuggingEnabled == YES) ? @"pthread_rwlock_tryrdlock":@"pthread_rwlock_rdlock";
    
    do {
      if(self->debuggingEnabled == YES) { pthreadError = pthread_rwlock_tryrdlock(&self->readWriteLock); } else { pthreadError = pthread_rwlock_rdlock(&self->readWriteLock); }
      
      switch(pthreadError) {
        case 0:                                                                                    didLock = YES; goto exitNow; break; // Lock was acquired
        case EAGAIN:                                                                                                                   // drop through
        case EBUSY:   if(self->debuggingEnabled == YES) { self->readSpinCount++; }                             RKThreadYield(); break; // Yield and then try again
        case EINVAL:  NSLog(@"%@ returned EINVAL after a trylock succeeded without any error.", functionString);  goto exitNow; break; // XXX Hopeless?
        case EDEADLK: NSLog(@"%@ returned EDEADLK after a trylock succeeded without any error.", functionString); goto exitNow; break; // XXX Hopeless?
        case ENOMEM:  NSLog(@"%@ returned ENOMEM after a trylock succeeded without any error.", functionString);  goto exitNow; break; // XXX Hopeless?
        default:
          if(spuriousErrors < RKLOCK_MAX_SPURIOUS_ERROR_ATTEMPTS) {
            spuriousErrors++;
            RKAtomicIncrementInt((int *)&self->spuriousErrorsCount);
            NSLog(@"%@ returned an unknown error code %d. This may be a spurious error, retry %d of %d.", functionString, pthreadError, RKLOCK_MAX_SPURIOUS_ERROR_ATTEMPTS);
          } else { NSLog(@"%@ returned an unknown error code %d. Giving up after %d attempts.", functionString, pthreadError, RKLOCK_MAX_SPURIOUS_ERROR_ATTEMPTS); goto exitNow; }
          break;
      }    
    } while(pthreadError != 0);
  }
  
exitNow:
    return(didLock);
}

void RKFastReadWriteUnlock(RKReadWriteLock * const aLock) {
  if(RK_EXPECTED(aLock == NULL, 0)) { return; }
  struct RKReadWriteLockDef { @defs(RKReadWriteLock) } * RK_C99(restrict) self = (struct RKReadWriteLockDef *)aLock;
  int pthreadError = 0;
  
  if(globalIsMultiThreaded == 0) { return; }
  if(RK_EXPECTED((pthreadError = pthread_rwlock_unlock(&self->readWriteLock)) != 0, 0)) {
    if(pthreadError == EINVAL) { NSLog(@"pthread_mutex_unlock returned EINVAL.");           return; }
    if(pthreadError == EPERM)  { NSLog(@"pthread_mutex_unlock returned EPERM, not owner?"); return; }
  }
}

