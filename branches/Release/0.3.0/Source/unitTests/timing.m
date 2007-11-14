//
//  timing.m
//  RegexKit
//

#import "timing.h"
#import <objc/objc-auto.h>
#import <objc/objc-runtime.h>

#define RKPrettyObjectMethodString(stringArg, ...) ([NSString stringWithFormat:[NSString stringWithFormat:@"%p [%@ %@]: %@", self, NSStringFromClass([(id)self class]), NSStringFromSelector(_cmd), stringArg], ##__VA_ARGS__])

static BOOL garbageCollectionEnabled = NO;
void startGC(void);

@implementation timing

+ (void)setUp
{  
  startGC();
  NSLog(@"Cache status:\n%@", [RKRegex regexCache]);

  startAutoreleasedObjects = (([NSAutoreleasePool respondsToSelector:@selector(totalAutoreleasedObjects)]) ? [NSAutoreleasePool totalAutoreleasedObjects] : 0);
  startTopPool = [[NSAutoreleasePool alloc] init];

  timingResultsArray = [NSMutableArray array];
  
  if(getenv("LEAK_CHECK") != NULL) { leakEnvString = [[[NSString alloc] initWithCString:getenv("LEAK_CHECK") encoding:NSUTF8StringEncoding] autorelease]; }
  if(getenv("DEBUG") != NULL) { debugEnvString = [[[NSString alloc] initWithCString:getenv("DEBUG") encoding:NSUTF8StringEncoding] autorelease]; }
  if(getenv("TIMING") != NULL) { timingEnvString = [[[NSString alloc] initWithCString:getenv("TIMING") encoding:NSUTF8StringEncoding] autorelease]; }


#ifdef ENABLE_MACOSX_GARBAGE_COLLECTION
  if([objc_getClass("NSGarbageCollector") defaultCollector] != NULL) {
    garbageCollectionEnabled = YES;
    //[[NSGarbageCollector defaultCollector] disableCollectorForPointer:leakEnvString];
    //[[NSGarbageCollector defaultCollector] disableCollectorForPointer:debugEnvString];
    //[[NSGarbageCollector defaultCollector] disableCollectorForPointer:timingEnvString];
  }
#endif

  startLeakPool = [[NSAutoreleasePool alloc] init];
  
  [[RKRegex regexCache] clearCache];
  [[RKRegex regexCache] clearCounters];

  iterations = 500000;
  //iterations = 50000;
  //iterations = 10000;
  if(([leakEnvString intValue] > 0) || ([debugEnvString intValue] > 0)) { iterations = 500; }

  if(([leakEnvString intValue] > 0)) {
    NSString *leakString = [[NSString alloc] initWithFormat:@"This string should leak from [%@ %@] on purpose", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
    NSLog(@"leakString @ %p: %@", leakString, leakString);
    leakString = (NSString *)0xdeadbeef;
    
    if([timingEnvString intValue] > 1) {
      //NSString *leaksCommandString = [NSString stringWithFormat:@"/usr/bin/leaks -exclude \"+[%@ %@]\" -exclude \"+[NSTitledFrame initialize]\" -exclude \"+[NSLanguage initialize]\" -exclude \"NSPrintAutoreleasePools\" -exclude \"+[NSWindowBinder initialize]\" -exclude \"+[NSCollator initialize]\" -exclude \"+[NSCollatorElement initialize]\" %d", NSStringFromClass([self class]), NSStringFromSelector(_cmd), getpid()];
      NSString *leaksCommandString = [NSString stringWithFormat:@"/usr/bin/leaks  %d", getpid()];
      
      if([NSAutoreleasePool respondsToSelector:@selector(showPools)]) { [NSAutoreleasePool showPools]; }
      NSLog(@"starting autoreleased objects: %u  Now: %u  Diff: %u", startAutoreleasedObjects, (([NSAutoreleasePool respondsToSelector:@selector(totalAutoreleasedObjects)]) ? [NSAutoreleasePool totalAutoreleasedObjects] : 0), (([NSAutoreleasePool respondsToSelector:@selector(totalAutoreleasedObjects)]) ? [NSAutoreleasePool totalAutoreleasedObjects] : 0) - startAutoreleasedObjects);
      NSLog(@"autoreleasedObjectCount: %u", (([NSAutoreleasePool respondsToSelector:@selector(autoreleasedObjectCount)]) ? [NSAutoreleasePool autoreleasedObjectCount] : 0));
      NSLog(@"topAutoreleasePoolCount: %u", (([NSAutoreleasePool respondsToSelector:@selector(topAutoreleasePoolCount)]) ? [NSAutoreleasePool topAutoreleasePoolCount] : 0));
      
      NSLog(@"Executing '%@'", leaksCommandString);
      system([leaksCommandString UTF8String]);
    }
  }
  testStartCPUTime = [NSDate cpuTimeUsed];
}

+ (void)tearDown
{
  testEndCPUTime = [NSDate cpuTimeUsed];
  testElapsedCPUTime = [NSDate differenceOfStartingTime:testStartCPUTime endingTime:testEndCPUTime];
  
  NSString *leaksCommandString = nil;
  
  NSSet *regexCacheSet = [[RKRegex regexCache] cacheSet];
  NSLog(@"Cache set count: %d", [regexCacheSet count]);
  
  NSAutoreleasePool *cachePool = [[NSAutoreleasePool alloc] init];
  [[RKRegex regexCache] clearCache];
  [cachePool release]; cachePool = NULL;
  NSLog(@"RKRegex cache flushed");
  
  regexCacheSet = [[RKRegex regexCache] cacheSet];
  
  if(([leakEnvString intValue] > 0)) {
    //leaksCommandString = [[NSString alloc] initWithFormat:@"/usr/bin/leaks -nocontext -exclude \"+[%@ %@]\" -exclude \"+[NSTitledFrame initialize]\" -exclude \"+[NSLanguage initialize]\" -exclude \"NSPrintAutoreleasePools\" -exclude \"+[NSWindowBinder initialize]\" -exclude \"+[NSCollator initialize]\" -exclude \"+[NSCollatorElement initialize]\" %d", NSStringFromClass([self class]), NSStringFromSelector(_cmd), getpid()];
    leaksCommandString = [[NSString alloc] initWithFormat:@"/usr/bin/leaks  %d", getpid()];
    
    if([leakEnvString intValue] > 2) {
      if([NSAutoreleasePool respondsToSelector:@selector(showPools)]) { [NSAutoreleasePool showPools]; }
      NSLog(@"starting autoreleased objects: %u  Now: %u  Diff: %u", startAutoreleasedObjects, (([NSAutoreleasePool respondsToSelector:@selector(totalAutoreleasedObjects)]) ? [NSAutoreleasePool totalAutoreleasedObjects] : 0), (([NSAutoreleasePool respondsToSelector:@selector(totalAutoreleasedObjects)]) ? [NSAutoreleasePool totalAutoreleasedObjects] : 0) - startAutoreleasedObjects);
      NSLog(@"autoreleasedObjectCount: %u", (([NSAutoreleasePool respondsToSelector:@selector(autoreleasedObjectCount)]) ? [NSAutoreleasePool autoreleasedObjectCount] : 0));
      NSLog(@"topAutoreleasePoolCount: %u", (([NSAutoreleasePool respondsToSelector:@selector(topAutoreleasePoolCount)]) ? [NSAutoreleasePool topAutoreleasePoolCount] : 0));
    }
    
    if(startLeakPool != nil) { [startLeakPool release]; startLeakPool = nil; }
    
    if([timingEnvString intValue] > 1) {
      NSLog(@"\n\n---------\nReleased setUp autorelease pool\n\n");
      
      if([NSAutoreleasePool respondsToSelector:@selector(showPools)]) { [NSAutoreleasePool showPools]; }
      NSLog(@"starting autoreleased objects: %u  Now: %u  Diff: %u", startAutoreleasedObjects, (([NSAutoreleasePool respondsToSelector:@selector(totalAutoreleasedObjects)]) ? [NSAutoreleasePool totalAutoreleasedObjects] : 0), (([NSAutoreleasePool respondsToSelector:@selector(totalAutoreleasedObjects)]) ? [NSAutoreleasePool totalAutoreleasedObjects] : 0) - startAutoreleasedObjects);
      NSLog(@"autoreleasedObjectCount: %u", (([NSAutoreleasePool respondsToSelector:@selector(autoreleasedObjectCount)]) ? [NSAutoreleasePool autoreleasedObjectCount] : 0));
      NSLog(@"topAutoreleasePoolCount: %u", (([NSAutoreleasePool respondsToSelector:@selector(topAutoreleasePoolCount)]) ? [NSAutoreleasePool topAutoreleasePoolCount] : 0));
    }
    
    NSLog(@"Executing '%@'", leaksCommandString);
    system([leaksCommandString UTF8String]);
  }
  

  NSLog(@"Timing results:\n\n");
  
  //NSArray *sortedTimingResultsArray = [timingResultsArray sortedArrayUsingSelector:@selector(compare:)];
  NSEnumerator *timingEnumerator = [timingResultsArray objectEnumerator];
  NSString *timingString = nil;

  while((timingString = [timingEnumerator nextObject]) != nil) { fprintf(stderr, "%s\n", [timingString UTF8String]); }
  fprintf(stderr, "\n");
  if(startLeakPool != nil) { [startLeakPool release]; startLeakPool = nil; }
  if(startTopPool != nil) { [startTopPool release]; startTopPool = nil; }
  
  NSLog(@"starting autoreleased objects: %u  Now: %u  Diff: %u", startAutoreleasedObjects, (([NSAutoreleasePool respondsToSelector:@selector(totalAutoreleasedObjects)]) ? [NSAutoreleasePool totalAutoreleasedObjects] : 0), (([NSAutoreleasePool respondsToSelector:@selector(totalAutoreleasedObjects)]) ? [NSAutoreleasePool totalAutoreleasedObjects] : 0) - startAutoreleasedObjects);
  NSLog(@"Elapsed CPU time: %@", [NSDate stringFromCPUTime:testElapsedCPUTime]);
  NSLog(@"Elapsed CPU time: %@", [NSDate microSecondsStringFromCPUTime:testElapsedCPUTime]);
  NSLog(RKPrettyObjectMethodString(@"Teardown complete\n"));
  fprintf(stderr, "-----------------------------------------\n\n");
  //fprintf(stderr, "Forcing full collection.\n");
  //objc_collect(OBJC_EXHAUSTIVE_COLLECTION | OBJC_WAIT_UNTIL_DONE);
  //fprintf(stderr, "Sleeping.\n");
  //while(1) { sleep(10); }
}


- (void)testInitSimpleTiming
{
  if([timingEnvString intValue] < 1) { return; }
  RKCPUTime startTime = [NSDate cpuTimeUsed];
  unsigned int x = 0;

  NSAutoreleasePool *loopPool = NULL;
  if(garbageCollectionEnabled == NO) { loopPool = [[NSAutoreleasePool alloc] init]; }
  for(x = 0; x < iterations; x++) {
    [[[RKRegex alloc] initWithRegexString:@".* (\\w+) .*" options:0] release];
  }
  if(garbageCollectionEnabled == NO) { [loopPool release]; }
  
  RKCPUTime elapsedTime = [NSDate differenceOfStartingTime:startTime endingTime:[NSDate cpuTimeUsed]];
  [timingResultsArray addObject:[NSString stringWithFormat:@"%-45.45s | CPU: %@  %u iterations, per: U %9.5fus, S %9.5fus, U+S %9.5fus", [NSStringFromSelector(_cmd) UTF8String], [NSDate stringFromCPUTime:elapsedTime], x, ((elapsedTime.userCPUTime / (double)x)), ((elapsedTime.systemCPUTime / (double)x)), ((elapsedTime.CPUTime / (double)x))]];
}

- (void)testBaseNSObjectCreateRelease
{
  if([timingEnvString intValue] < 1) { return; }
  RKCPUTime startTime = [NSDate cpuTimeUsed];
  unsigned int x = 0;
  
  NSAutoreleasePool *loopPool = NULL;
  if(garbageCollectionEnabled == NO) { loopPool = [[NSAutoreleasePool alloc] init]; }
  for(x = 0; x < iterations; x++) {
    [[[NSObject alloc] init] release];
  }
  if(garbageCollectionEnabled == NO) { [loopPool release]; }
  
  RKCPUTime elapsedTime = [NSDate differenceOfStartingTime:startTime endingTime:[NSDate cpuTimeUsed]];
  [timingResultsArray addObject:[NSString stringWithFormat:@"%-45.45s | CPU: %@  %u iterations, per: U %9.5fus, S %9.5fus, U+S %9.5fus", [NSStringFromSelector(_cmd) UTF8String], [NSDate stringFromCPUTime:elapsedTime], x, ((elapsedTime.userCPUTime / (double)x)), ((elapsedTime.systemCPUTime / (double)x)), ((elapsedTime.CPUTime / (double)x))]];
}

- (void)testBaseNSObjectCreateReleaseAutorelease
{
  if([timingEnvString intValue] < 1) { return; }
  RKCPUTime startTime = [NSDate cpuTimeUsed];
  unsigned int x = 0;
  
  for(x = 0; x < iterations; x++) {
    NSAutoreleasePool *loopPool = NULL;
    if(garbageCollectionEnabled == NO) { loopPool = [[NSAutoreleasePool alloc] init]; }
    [[[NSObject alloc] init] release];
    if(garbageCollectionEnabled == NO) { [loopPool release]; }
  }
  
  RKCPUTime elapsedTime = [NSDate differenceOfStartingTime:startTime endingTime:[NSDate cpuTimeUsed]];
  [timingResultsArray addObject:[NSString stringWithFormat:@"%-45.45s | CPU: %@  %u iterations, per: U %9.5fus, S %9.5fus, U+S %9.5fus", [NSStringFromSelector(_cmd) UTF8String], [NSDate stringFromCPUTime:elapsedTime], x, ((elapsedTime.userCPUTime / (double)x)), ((elapsedTime.systemCPUTime / (double)x)), ((elapsedTime.CPUTime / (double)x))]];
}

- (void)testBaseNSObjectAutorelease
{
  if([timingEnvString intValue] < 1) { return; }
  RKCPUTime startTime = [NSDate cpuTimeUsed];
  unsigned int x = 0;
  
  for(x = 0; x < iterations; x++) {
    NSAutoreleasePool *loopPool = NULL;
    if(garbageCollectionEnabled == NO) { loopPool = [[NSAutoreleasePool alloc] init]; }
    [[[NSObject alloc] init] autorelease];
    if(garbageCollectionEnabled == NO) { [loopPool release]; }
  }
  
  RKCPUTime elapsedTime = [NSDate differenceOfStartingTime:startTime endingTime:[NSDate cpuTimeUsed]];
  [timingResultsArray addObject:[NSString stringWithFormat:@"%-45.45s | CPU: %@  %u iterations, per: U %9.5fus, S %9.5fus, U+S %9.5fus", [NSStringFromSelector(_cmd) UTF8String], [NSDate stringFromCPUTime:elapsedTime], x, ((elapsedTime.userCPUTime / (double)x)), ((elapsedTime.systemCPUTime / (double)x)), ((elapsedTime.CPUTime / (double)x))]];
}

- (void)testConvienenceInitSimpleTiming
{
  if([timingEnvString intValue] < 1) { return; }
  RKCPUTime startTime = [NSDate cpuTimeUsed];
  unsigned int x = 0;
  
  for(x = 0; x < iterations; x++) {
    NSAutoreleasePool *loopPool = NULL;
    if(garbageCollectionEnabled == NO) { loopPool = [[NSAutoreleasePool alloc] init]; }
    [RKRegex regexWithRegexString:@".* (\\w+) .*" options:0];
    if(garbageCollectionEnabled == NO) { [loopPool release]; }
  }
  
  RKCPUTime elapsedTime = [NSDate differenceOfStartingTime:startTime endingTime:[NSDate cpuTimeUsed]];
  [timingResultsArray addObject:[NSString stringWithFormat:@"%-45.45s | CPU: %@  %u iterations, per: U %9.5fus, S %9.5fus, U+S %9.5fus", [NSStringFromSelector(_cmd) UTF8String], [NSDate stringFromCPUTime:elapsedTime], x, ((elapsedTime.userCPUTime / (double)x)), ((elapsedTime.systemCPUTime / (double)x)), ((elapsedTime.CPUTime / (double)x))]];
}

- (void)testStringAdditionsNoNamedCapturesSimpleTiming
{
  if([timingEnvString intValue] < 1) { return; }
  RKCPUTime startTime = [NSDate cpuTimeUsed];
  unsigned int x = 0;
  
  NSString *namedSubjectString = @" 1999 - 12 - 01 / 55 ";
  NSString *namedRegexString = @"(?<date> (?<year>(\\d\\d)?\\d\\d) - (?<month>\\d\\d) - (?<day>\\d\\d) / (?<month>\\d\\d))";
  
  for(x = 0; x < iterations; x++) {
    NSAutoreleasePool *loopPool = NULL;
    if(garbageCollectionEnabled == NO) { loopPool = [[NSAutoreleasePool alloc] init]; }
    
    NSString *subString0 = @"$0", *subString1 = @"$1", *subString2 = @"$2", *subString3 = @"$3", *subString4 = @"$4";
    if([namedSubjectString getCapturesWithRegexAndReferences:namedRegexString, @"${2}", &subString2, @"${4}", &subString4, @"${1}", &subString1, @"${0}", &subString0, @"${3}", &subString3, nil] == NO) { NSLog(@"FAILED TO MATCH!"); return; }
    
    if(garbageCollectionEnabled == NO) { [loopPool release]; } //else { objc_collect(OBJC_GENERATIONAL_COLLECTION | OBJC_COLLECT_IF_NEEDED); }
  }
  
  RKCPUTime elapsedTime = [NSDate differenceOfStartingTime:startTime endingTime:[NSDate cpuTimeUsed]];
  [timingResultsArray addObject:[NSString stringWithFormat:@"%-45.45s | CPU: %@  %u iterations, per: U %9.5fus, S %9.5fus, U+S %9.5fus", [NSStringFromSelector(_cmd) UTF8String], [NSDate stringFromCPUTime:elapsedTime], x, ((elapsedTime.userCPUTime / (double)x)), ((elapsedTime.systemCPUTime / (double)x)), ((elapsedTime.CPUTime / (double)x))]];
}


- (void)testStringAdditionsHeavyNamedCaptureSimpleTiming
{
  if([timingEnvString intValue] < 1) { return; }
  RKCPUTime startTime = [NSDate cpuTimeUsed];
  unsigned int x = 0;
  
  NSString *namedSubjectString = @" 1999 - 12 - 01 / 55 ";
  NSString *namedRegexString = @"(?<date> (?<year>(\\d\\d)?\\d\\d) - (?<month>\\d\\d) - (?<day>\\d\\d) / (?<month>\\d\\d))";

  for(x = 0; x < iterations; x++) {
    NSAutoreleasePool *loopPool = NULL;
    if(garbageCollectionEnabled == NO) { loopPool = [[NSAutoreleasePool alloc] init]; }

    NSString *subStringDate = @"${date}", *subStringDay = @"${day}", *subStringYear = @"${year}";
    NSString *subString0 = @"$0", *subString1 = @"$1", *subString2 = @"$2";
    if(subString0) {}
    //if([namedSubjectString getCapturesWithRegexAndReferences:namedRegexString, @"${day}", &subStringDay, @"${date}", &subStringDate, @"${2}", &subString2, @"${1}", &subString1, @"${year}", &subStringYear, nil] == NO) { NSLog(@"FAILED TO MATCH!"); return; }
    if([namedSubjectString getCapturesWithRegexAndReferences:namedRegexString, @"${year}", &subStringDay, @"${day}", &subStringDate, @"${1}", &subString2, @"${0}", &subString1, @"${month}", &subStringYear, nil] == NO) { NSLog(@"FAILED TO MATCH!"); return; }

    if(garbageCollectionEnabled != 2) { [loopPool release]; } //else { objc_collect(OBJC_FULL_COLLECTION); }//objc_collect(OBJC_GENERATIONAL_COLLECTION | OBJC_COLLECT_IF_NEEDED); 
  }
  
  RKCPUTime elapsedTime = [NSDate differenceOfStartingTime:startTime endingTime:[NSDate cpuTimeUsed]];
  [timingResultsArray addObject:[NSString stringWithFormat:@"%-45.45s | CPU: %@  %u iterations, per: U %9.5fus, S %9.5fus, U+S %9.5fus", [NSStringFromSelector(_cmd) UTF8String], [NSDate stringFromCPUTime:elapsedTime], x, ((elapsedTime.userCPUTime / (double)x)), ((elapsedTime.systemCPUTime / (double)x)), ((elapsedTime.CPUTime / (double)x))]];
}

- (void)testInitWithCaptureNamesTiming
{
  if([timingEnvString intValue] < 1) { return; }
  RKCPUTime startTime = [NSDate cpuTimeUsed];
  unsigned int x = 0;
  
  NSAutoreleasePool *loopPool = NULL;
  if(garbageCollectionEnabled == NO) { loopPool = [[NSAutoreleasePool alloc] init]; }
  for(x = 0; x < iterations; x++) {
    [[[RKRegex alloc] initWithRegexString:@"(?<date> (?<year>(\\d\\d)?\\d\\d) - (?<month>\\d\\d) - (?<day>\\d\\d) / (?<month>\\d\\d))" options:RKCompileDupNames] release];
  }
  if(garbageCollectionEnabled == NO) { [loopPool release]; }

  RKCPUTime elapsedTime = [NSDate differenceOfStartingTime:startTime endingTime:[NSDate cpuTimeUsed]];
  [timingResultsArray addObject:[NSString stringWithFormat:@"%-45.45s | CPU: %@  %u iterations, per: U %9.5fus, S %9.5fus, U+S %9.5fus", [NSStringFromSelector(_cmd) UTF8String], [NSDate stringFromCPUTime:elapsedTime], x, ((elapsedTime.userCPUTime / (double)x)), ((elapsedTime.systemCPUTime / (double)x)), ((elapsedTime.CPUTime / (double)x))]];
}

- (void)testConvienceInitWithCaptureNamesTiming
{
  if([timingEnvString intValue] < 1) { return; }
  RKCPUTime startTime = [NSDate cpuTimeUsed];
  unsigned int x = 0;
  
  for(x = 0; x < iterations; x++) {
    NSAutoreleasePool *loopPool = NULL;
    if(garbageCollectionEnabled == NO) { loopPool = [[NSAutoreleasePool alloc] init]; }
    [RKRegex regexWithRegexString:@"(?<date> (?<year>(\\d\\d)?\\d\\d) - (?<month>\\d\\d) - (?<day>\\d\\d) / (?<month>\\d\\d))" options:RKCompileDupNames];
    if(garbageCollectionEnabled == NO) { [loopPool release]; }
  }
  
  RKCPUTime elapsedTime = [NSDate differenceOfStartingTime:startTime endingTime:[NSDate cpuTimeUsed]];
  [timingResultsArray addObject:[NSString stringWithFormat:@"%-45.45s | CPU: %@  %u iterations, per: U %9.5fus, S %9.5fus, U+S %9.5fus", [NSStringFromSelector(_cmd) UTF8String], [NSDate stringFromCPUTime:elapsedTime], x, ((elapsedTime.userCPUTime / (double)x)), ((elapsedTime.systemCPUTime / (double)x)), ((elapsedTime.CPUTime / (double)x))]];
}

- (void)testrangesForTiming
{
  if([timingEnvString intValue] < 1) { return; }
  RKCPUTime startTime = [NSDate cpuTimeUsed];
  unsigned int x = 0;
  NSString *subjectString = @" 1999 - 12 - 01 / 55 ";

  for(x = 0; x < iterations; x++) {
    NSAutoreleasePool *loopPool = NULL;
    if(garbageCollectionEnabled == NO) { loopPool = [[NSAutoreleasePool alloc] init]; }
    RKRegex *regex = [RKRegex regexWithRegexString:@"(?<date> (?<year>(\\d\\d)?\\d\\d) - (?<month>\\d\\d) - (?<day>\\d\\d) / (?<month>\\d\\d))" options:RKCompileDupNames];
    NSRange *ranges = [subjectString rangesOfRegex:regex];
    if(ranges == NULL) {
      NSLog(@"regex: %@ regexString: %@", regex, [regex regexString]);
      NSLog(@"matches %@ ? %@", subjectString, [subjectString isMatchedByRegex:regex] == YES ? @"Yes":@"No");
      if(garbageCollectionEnabled == NO) { [loopPool release]; }
      break;
    }
    if(garbageCollectionEnabled == NO) { [loopPool release]; }
  }
  
  RKCPUTime elapsedTime = [NSDate differenceOfStartingTime:startTime endingTime:[NSDate cpuTimeUsed]];
  [timingResultsArray addObject:[NSString stringWithFormat:@"%-45.45s | CPU: %@  %u iterations, per: U %9.5fus, S %9.5fus, U+S %9.5fus", [NSStringFromSelector(_cmd) UTF8String], [NSDate stringFromCPUTime:elapsedTime], x, ((elapsedTime.userCPUTime / (double)x)), ((elapsedTime.systemCPUTime / (double)x)), ((elapsedTime.CPUTime / (double)x))]];
}


- (void)testPCRERKRegexEquivTiming
{
  if([timingEnvString intValue] < 1) { return; }
  unsigned int x = 0;
  
  const char *subjectCharacters = " 1999 - 12 - 01 / 55 ";
  RKInteger subjectLength = strlen(subjectCharacters);
  NSRange subjectRange = NSMakeRange(0, subjectLength);
  NSRange matchRanges[4096];

  RKRegex *regex = [RKRegex regexWithRegexString:@"(?<date> (?<year>(\\d\\d)?\\d\\d) - (?<month>\\d\\d) - (?<day>\\d\\d) / (?<month>\\d\\d))" options:RKCompileDupNames];
  
  RKCPUTime startTime = [NSDate cpuTimeUsed];

  for(x = 0; x < iterations; x++) {
    [regex getRanges:&matchRanges[0] withCharacters:subjectCharacters length:subjectLength inRange:subjectRange options:0];
  }
  
  RKCPUTime elapsedTime = [NSDate differenceOfStartingTime:startTime endingTime:[NSDate cpuTimeUsed]];
  [timingResultsArray addObject:[NSString stringWithFormat:@"%-45.45s | CPU: %@  %u iterations, per: U %9.5fus, S %9.5fus, U+S %9.5fus", [NSStringFromSelector(_cmd) UTF8String], [NSDate stringFromCPUTime:elapsedTime], x, ((elapsedTime.userCPUTime / (double)x)), ((elapsedTime.systemCPUTime / (double)x)), ((elapsedTime.CPUTime / (double)x))]];
}


- (void)testPCREbaseCaptureNameTiming
{
  if([timingEnvString intValue] < 1) { return; }

  unsigned int x = 0;
  const char *subjectCharacters = " 1999 - 12 - 01 / 55 ";
  RKInteger subjectLength = strlen(subjectCharacters);
  const char *regexCharacters = "(?<date> (?<year>(\\d\\d)?\\d\\d) - (?<month>\\d\\d) - (?<day>\\d\\d) / (?<month>\\d\\d))";

  int ovectors[4096];
  void *_compiledPCRE = NULL;
  void *_extraPCRE = NULL;
  

  int compileErrorOffset = 0;
  const char *errorCharPtr = NULL;
  RKMatchErrorCode errorCode = RKMatchErrorNoError;
  
  _compiledPCRE = pcre_compile2(regexCharacters, RKCompileDupNames, &errorCode, &errorCharPtr, &compileErrorOffset, NULL);
  if((errorCode != RKMatchErrorNoError) || (_compiledPCRE == NULL)) { NSLog(@"DID NOT COMPILE"); goto exitNow; }
  
  _extraPCRE = pcre_study(_compiledPCRE, 0, &errorCharPtr);
  if((_extraPCRE == NULL) && (errorCharPtr != NULL)) { NSLog(@"DID NOT STUDY"); goto exitNow; }
  
  RKCPUTime startTime = [NSDate cpuTimeUsed];

  for(x = 0; x < iterations; x++) {
    errorCode = (RKMatchErrorCode)pcre_exec(_compiledPCRE, _extraPCRE, subjectCharacters, subjectLength, 0, 0, &ovectors[0], 256);
    if(errorCode <= 0) { NSLog(@"DID NOT MATCH"); goto exitNow; }
  }
  
exitNow:
    if(_compiledPCRE) { pcre_free(_compiledPCRE); _compiledPCRE = NULL; }
  if(_extraPCRE) { pcre_free(_extraPCRE); _extraPCRE = NULL; }
    
  RKCPUTime elapsedTime = [NSDate differenceOfStartingTime:startTime endingTime:[NSDate cpuTimeUsed]];
  [timingResultsArray addObject:[NSString stringWithFormat:@"%-45.45s | CPU: %@  %u iterations, per: U %9.5fus, S %9.5fus, U+S %9.5fus", [NSStringFromSelector(_cmd) UTF8String], [NSDate stringFromCPUTime:elapsedTime], x, ((elapsedTime.userCPUTime / (double)x)), ((elapsedTime.systemCPUTime / (double)x)), ((elapsedTime.CPUTime / (double)x))]];
}

- (void)testrangesForNoMatchTiming
{
  if([timingEnvString intValue] < 1) { return; }
  RKCPUTime startTime = [NSDate cpuTimeUsed];
  unsigned int x = 0;
  NSString *subjectString = @" 1999 - 12 - 01 / ab ";

  for(x = 0; x < iterations; x++) {
    NSAutoreleasePool *loopPool = NULL;
    if(garbageCollectionEnabled == NO) { loopPool = [[NSAutoreleasePool alloc] init]; }
    RKRegex *regex = [RKRegex regexWithRegexString:@"(?<date> (?<year>(\\d\\d)?\\d\\d) - (?<month>\\d\\d) - (?<day>\\d\\d) / (?<month>\\d\\d))" options:RKCompileDupNames];
    NSRange *ranges = [subjectString rangesOfRegex:regex];
    if(ranges != NULL) {
      NSLog(@"regex: %@ regexString: %@", regex, [regex regexString]);
      NSLog(@"matches %@ ? %@", subjectString, [subjectString isMatchedByRegex:regex] == YES ? @"Yes":@"No");
      if(garbageCollectionEnabled == NO) { [loopPool release]; }
      break;
    }
    if(garbageCollectionEnabled == NO) { [loopPool release]; }
  }
  
  RKCPUTime elapsedTime = [NSDate differenceOfStartingTime:startTime endingTime:[NSDate cpuTimeUsed]];
  [timingResultsArray addObject:[NSString stringWithFormat:@"%-45.45s | CPU: %@  %u iterations, per: U %9.5fus, S %9.5fus, U+S %9.5fus", [NSStringFromSelector(_cmd) UTF8String], [NSDate stringFromCPUTime:elapsedTime], x, ((elapsedTime.userCPUTime / (double)x)), ((elapsedTime.systemCPUTime / (double)x)), ((elapsedTime.CPUTime / (double)x))]];
}

- (void)testSimplerangesForTiming
{
  if([timingEnvString intValue] < 1) { return; }
  RKCPUTime startTime = [NSDate cpuTimeUsed];
  unsigned int x = 0;
  NSString *regexString = @"^(Match)\\s+the\\s+(MAGIC)";
  NSString *subjectString = @"Match the MAGIC in this string";

  for(x = 0; x < iterations; x++) {
    NSAutoreleasePool *loopPool = NULL;
    if(garbageCollectionEnabled == NO) { loopPool = [[NSAutoreleasePool alloc] init]; }
    RKRegex *regex = [RKRegex regexWithRegexString:regexString options:RKCompileDupNames];
    NSRange *ranges = [subjectString rangesOfRegex:regex];
    if(ranges == NULL) {
      NSLog(@"regex: %@ regexString: %@", regex, [regex regexString]);
      NSLog(@"matches %@ ? %@", subjectString, [subjectString isMatchedByRegex:regex] == YES ? @"Yes":@"No");
      if(garbageCollectionEnabled == NO) { [loopPool release]; }
      break;
    }
    if(garbageCollectionEnabled == NO) { [loopPool release]; }
  }
  
  RKCPUTime elapsedTime = [NSDate differenceOfStartingTime:startTime endingTime:[NSDate cpuTimeUsed]];
  [timingResultsArray addObject:[NSString stringWithFormat:@"%-45.45s | CPU: %@  %u iterations, per: U %9.5fus, S %9.5fus, U+S %9.5fus", [NSStringFromSelector(_cmd) UTF8String], [NSDate stringFromCPUTime:elapsedTime], x, ((elapsedTime.userCPUTime / (double)x)), ((elapsedTime.systemCPUTime / (double)x)), ((elapsedTime.CPUTime / (double)x))]];
}

- (void)testSimpleIntTypeConversionForTiming
{
  if([timingEnvString intValue] < 1) { return; }
  RKCPUTime startTime = [NSDate cpuTimeUsed];
  unsigned int x = 0;
  NSString *regexString = @"(\\d+)";
  NSString *subjectString = @"12345";
  
  for(x = 0; x < iterations; x++) {
    NSAutoreleasePool *loopPool = NULL;
    if(garbageCollectionEnabled == NO) { loopPool = [[NSAutoreleasePool alloc] init]; }
    int convertedInt = 0;
    [subjectString getCapturesWithRegexAndReferences:regexString, @"${1:%d}", &convertedInt, nil];
    if(convertedInt != 12345) {
      NSLog(@"Converte int not expected value of 12345, is %d", convertedInt);
      if(garbageCollectionEnabled == NO) { [loopPool release]; }
      break;
    }
    if(garbageCollectionEnabled == NO) { [loopPool release]; }
  }
  
  RKCPUTime elapsedTime = [NSDate differenceOfStartingTime:startTime endingTime:[NSDate cpuTimeUsed]];
  [timingResultsArray addObject:[NSString stringWithFormat:@"%-45.45s | CPU: %@  %u iterations, per: U %9.5fus, S %9.5fus, U+S %9.5fus", [NSStringFromSelector(_cmd) UTF8String], [NSDate stringFromCPUTime:elapsedTime], x, ((elapsedTime.userCPUTime / (double)x)), ((elapsedTime.systemCPUTime / (double)x)), ((elapsedTime.CPUTime / (double)x))]];
}

- (void)testCachedRegexIntTypeConversionForTiming
{
  if([timingEnvString intValue] < 1) { return; }
  RKCPUTime startTime = [NSDate cpuTimeUsed];
  unsigned int x = 0;
  NSString *regexString = @"(\\d+)";
  NSString *subjectString = @"12345";
  RKRegex *regex = [RKRegex regexWithRegexString:regexString options:RKCompileNoOptions];
  
  for(x = 0; x < iterations; x++) {
    NSAutoreleasePool *loopPool = NULL;
    if(garbageCollectionEnabled == NO) { loopPool = [[NSAutoreleasePool alloc] init]; }
    int convertedInt = 0;
    [subjectString getCapturesWithRegexAndReferences:regex, @"${1:%d}", &convertedInt, nil];
    if(convertedInt != 12345) {
      NSLog(@"Converte int not expected value of 12345, is %d", convertedInt);
      if(garbageCollectionEnabled == NO) { [loopPool release]; }
      break;
    }
    if(garbageCollectionEnabled == NO) { [loopPool release]; }
  }
  
  RKCPUTime elapsedTime = [NSDate differenceOfStartingTime:startTime endingTime:[NSDate cpuTimeUsed]];
  [timingResultsArray addObject:[NSString stringWithFormat:@"%-45.45s | CPU: %@  %u iterations, per: U %9.5fus, S %9.5fus, U+S %9.5fus", [NSStringFromSelector(_cmd) UTF8String], [NSDate stringFromCPUTime:elapsedTime], x, ((elapsedTime.userCPUTime / (double)x)), ((elapsedTime.systemCPUTime / (double)x)), ((elapsedTime.CPUTime / (double)x))]];
}

- (void)testCachedRegexIntTypeConversionUsingNSStringIntValueForTiming
{
  if([timingEnvString intValue] < 1) { return; }
  RKCPUTime startTime = [NSDate cpuTimeUsed];
  unsigned int x = 0;
  NSString *regexString = @"(\\d+)";
  NSString *subjectString = @"12345";
  RKRegex *regex = [RKRegex regexWithRegexString:regexString options:RKCompileNoOptions];
  
  for(x = 0; x < iterations; x++) {
    NSAutoreleasePool *loopPool = NULL;
    if(garbageCollectionEnabled == NO) { loopPool = [[NSAutoreleasePool alloc] init]; }
    NSString *convertedString = nil;
    [subjectString getCapturesWithRegexAndReferences:regex, @"${1}", &convertedString, nil];
    int convertedInt = [convertedString intValue];
    if((convertedString == nil) || (convertedInt != 12345)) {
      NSLog(@"Converted string not expected value of != nil");
      NSLog(@"Converted int not expected value of 12345, is %d", convertedInt);
      if(garbageCollectionEnabled == NO) { [loopPool release]; }
      break;
    }
    if(garbageCollectionEnabled == NO) { [loopPool release]; }
  }
  
  RKCPUTime elapsedTime = [NSDate differenceOfStartingTime:startTime endingTime:[NSDate cpuTimeUsed]];
  [timingResultsArray addObject:[NSString stringWithFormat:@"%-45.45s | CPU: %@  %u iterations, per: U %9.5fus, S %9.5fus, U+S %9.5fus", [NSStringFromSelector(_cmd) UTF8String], [NSDate stringFromCPUTime:elapsedTime], x, ((elapsedTime.userCPUTime / (double)x)), ((elapsedTime.systemCPUTime / (double)x)), ((elapsedTime.CPUTime / (double)x))]];
}

- (void)testCachedRegexNSNumberTypeConversionForTiming
{
  if([timingEnvString intValue] < 1) { return; }
  RKCPUTime startTime = [NSDate cpuTimeUsed];
  unsigned int x = 0;
  NSString *regexString = @"(\\d+)";
  NSString *subjectString = @"12345";
  RKRegex *regex = [RKRegex regexWithRegexString:regexString options:RKCompileNoOptions];
  
  for(x = 0; x < iterations; x++) {
    NSAutoreleasePool *loopPool = NULL;
    if(garbageCollectionEnabled == NO) { loopPool = [[NSAutoreleasePool alloc] init]; }
    NSNumber *convertedNumber = nil;
    [subjectString getCapturesWithRegexAndReferences:regex, @"${1:@n}", &convertedNumber, nil];
    if(convertedNumber == nil) {
      NSLog(@"Converted number not expected value of != nil");
      if(garbageCollectionEnabled == NO) { [loopPool release]; }
      break;
    }
    if(garbageCollectionEnabled == NO) { [loopPool release]; }
  }
  
  RKCPUTime elapsedTime = [NSDate differenceOfStartingTime:startTime endingTime:[NSDate cpuTimeUsed]];
  [timingResultsArray addObject:[NSString stringWithFormat:@"%-45.45s | CPU: %@  %u iterations, per: U %9.5fus, S %9.5fus, U+S %9.5fus", [NSStringFromSelector(_cmd) UTF8String], [NSDate stringFromCPUTime:elapsedTime], x, ((elapsedTime.userCPUTime / (double)x)), ((elapsedTime.systemCPUTime / (double)x)), ((elapsedTime.CPUTime / (double)x))]];
}

- (void)testConvertIntRegexConversion
{
  if([timingEnvString intValue] < 1) { return; }
  RKCPUTime startTime = [NSDate cpuTimeUsed];
  unsigned int x = 0;
  NSString *regexString = @"(\\d+)";
  NSString *subjectString = @"12345";
  RKRegex *regex = [RKRegex regexWithRegexString:regexString options:RKCompileNoOptions];
  
  for(x = 0; x < iterations; x++) {
    int convertedInt = 0;
    [subjectString getCapturesWithRegexAndReferences:regex, @"${1:%d}", &convertedInt, nil];
    if(convertedInt != 12345) {
      NSLog(@"Converte int not expected value of 12345, is %d", convertedInt);
      break;
    }
  }
  
  RKCPUTime elapsedTime = [NSDate differenceOfStartingTime:startTime endingTime:[NSDate cpuTimeUsed]];
  [timingResultsArray addObject:[NSString stringWithFormat:@"%-45.45s | CPU: %@  %u iterations, per: U %9.5fus, S %9.5fus, U+S %9.5fus", [NSStringFromSelector(_cmd) UTF8String], [NSDate stringFromCPUTime:elapsedTime], x, ((elapsedTime.userCPUTime / (double)x)), ((elapsedTime.systemCPUTime / (double)x)), ((elapsedTime.CPUTime / (double)x))]];
}

- (void)testConvertIntatoiBase
{
  if([timingEnvString intValue] < 1) { return; }
  RKCPUTime startTime = [NSDate cpuTimeUsed];
  unsigned int x = 0;
  const char *subjectString = [[NSString stringWithString:@"12345"] UTF8String];
  
  for(x = 0; x < iterations; x++) {
    int convertedInt = 0;
    convertedInt = atoi(subjectString);
    if(convertedInt != 12345) {
      NSLog(@"Converte int not expected value of 12345, is %d", convertedInt);
      break;
    }
  }
  
  RKCPUTime elapsedTime = [NSDate differenceOfStartingTime:startTime endingTime:[NSDate cpuTimeUsed]];
  [timingResultsArray addObject:[NSString stringWithFormat:@"%-45.45s | CPU: %@  %u iterations, per: U %9.5fus, S %9.5fus, U+S %9.5fus", [NSStringFromSelector(_cmd) UTF8String], [NSDate stringFromCPUTime:elapsedTime], x, ((elapsedTime.userCPUTime / (double)x)), ((elapsedTime.systemCPUTime / (double)x)), ((elapsedTime.CPUTime / (double)x))]];
}

- (void)testBaseNullLoop
{
  if([timingEnvString intValue] < 1) { return; }
  RKCPUTime startTime = [NSDate cpuTimeUsed];
  unsigned int x = 0;
  
  for(x = 0; x < iterations; x++) {
    dummyDateFunction(x);
  }
  
  RKCPUTime elapsedTime = [NSDate differenceOfStartingTime:startTime endingTime:[NSDate cpuTimeUsed]];
  [timingResultsArray addObject:[NSString stringWithFormat:@"%-45.45s | CPU: %@  %u iterations, per: U %9.5fus, S %9.5fus, U+S %9.5fus", [NSStringFromSelector(_cmd) UTF8String], [NSDate stringFromCPUTime:elapsedTime], x, ((elapsedTime.userCPUTime / (double)x)), ((elapsedTime.systemCPUTime / (double)x)), ((elapsedTime.CPUTime / (double)x))]];
}


- (void)testConvertIntPCREatoi
{
  if([timingEnvString intValue] < 1) { return; }
  unsigned int x = 0;
  const char *subjectCharacters = "12345";
  RKInteger subjectLength = strlen(subjectCharacters);
  const char *regexCharacters = "(\\d+)";
  
  int ovectors[4096];
  void *_compiledPCRE = NULL;
  void *_extraPCRE = NULL;
  NSRange ranges[2048];
  char convertBuffer[256];
  
  
  int compileErrorOffset = 0;
  const char *errorCharPtr = NULL;
  RKMatchErrorCode errorCode = RKMatchErrorNoError;
  
  _compiledPCRE = pcre_compile2(regexCharacters, RKCompileDupNames, &errorCode, &errorCharPtr, &compileErrorOffset, NULL);
  if((errorCode != RKMatchErrorNoError) || (_compiledPCRE == NULL)) { NSLog(@"DID NOT COMPILE"); goto exitNow; }
  
  _extraPCRE = pcre_study(_compiledPCRE, 0, &errorCharPtr);
  if((_extraPCRE == NULL) && (errorCharPtr != NULL)) { NSLog(@"DID NOT STUDY"); goto exitNow; }
  
  RKCPUTime startTime = [NSDate cpuTimeUsed];
  
  for(x = 0; x < iterations; x++) {
    errorCode = (RKMatchErrorCode)pcre_exec(_compiledPCRE, _extraPCRE, subjectCharacters, subjectLength, 0, 0, (int *)&ovectors[0], 256);
    if(errorCode <= 0) { NSLog(@"DID NOT MATCH"); goto exitNow; }

    if(errorCode > 0) {
      for(unsigned int y = 0; y < (u_int)errorCode; y++) {
        if(RK_EXPECTED(ovectors[(y * 2)] == -1, 0)) { ranges[y] = NSMakeRange(NSNotFound, 0); } else { ranges[y] = NSMakeRange(ovectors[(y * 2)], (ovectors[(y * 2) + 1] - ovectors[(y * 2)])); }
      }
    }
    
    memcpy(&convertBuffer[0], subjectCharacters, ranges[1].length);
    convertBuffer[ranges[1].length] = 0;
    int convertedInt = atoi(&convertBuffer[0]);
    if(convertedInt != 12345) {
      NSLog(@"Converte int not expected value of 12345, is %d", convertedInt);
      break;
    }
    
  }
  
exitNow:
    if(_compiledPCRE) { pcre_free(_compiledPCRE); _compiledPCRE = NULL; }
  if(_extraPCRE) { pcre_free(_extraPCRE); _extraPCRE = NULL; }
  
  RKCPUTime elapsedTime = [NSDate differenceOfStartingTime:startTime endingTime:[NSDate cpuTimeUsed]];
  [timingResultsArray addObject:[NSString stringWithFormat:@"%-45.45s | CPU: %@  %u iterations, per: U %9.5fus, S %9.5fus, U+S %9.5fus", [NSStringFromSelector(_cmd) UTF8String], [NSDate stringFromCPUTime:elapsedTime], x, ((elapsedTime.userCPUTime / (double)x)), ((elapsedTime.systemCPUTime / (double)x)), ((elapsedTime.CPUTime / (double)x))]];
}


@end
