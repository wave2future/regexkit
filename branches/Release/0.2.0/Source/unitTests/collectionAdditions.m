//
//  collectionAdditions.m
//  RegexKit
//

#import "collectionAdditions.h"

#define RKPrettyObjectMethodString(stringArg, ...) ([NSString stringWithFormat:[NSString stringWithFormat:@"%p [%@ %@]: %@", self, NSStringFromClass([(id)self class]), NSStringFromSelector(_cmd), stringArg], ##__VA_ARGS__])


@implementation extensions

+ (void)setUp
{
  startAutoreleasedObjects = (([NSAutoreleasePool respondsToSelector:@selector(totalAutoreleasedObjects)]) ? [NSAutoreleasePool totalAutoreleasedObjects] : 0);
  startTopPool = [[NSAutoreleasePool alloc] init];
  
  if(getenv("LEAK_CHECK") != NULL) { leakEnvString = [[[NSString alloc] initWithCString:getenv("LEAK_CHECK") encoding:NSUTF8StringEncoding] autorelease]; }
  if(getenv("DEBUG") != NULL) { debugEnvString = [[[NSString alloc] initWithCString:getenv("DEBUG") encoding:NSUTF8StringEncoding] autorelease]; }
  if(getenv("TIMING") != NULL) { timingEnvString = [[[NSString alloc] initWithCString:getenv("TIMING") encoding:NSUTF8StringEncoding] autorelease]; }
  
  startLeakPool = [[NSAutoreleasePool alloc] init];
  
  [[RKRegex regexCache] clearCache];
  [[RKRegex regexCache] clearCounters];
  
  if(([leakEnvString intValue] > 0)) {
    NSString *leakString = [[NSString alloc] initWithFormat:@"This string should leak from [%@ %@] on purpose", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
    NSLog(@"leakString @ %p: %@", leakString, leakString);
    leakString = (NSString *)0xdeadbeef;
    
    if([leakEnvString intValue] > 1) {
      NSString *leaksCommandString = [NSString stringWithFormat:@"/usr/bin/leaks -exclude \"+[%@ %@]\" -exclude \"+[NSTitledFrame initialize]\" -exclude \"+[NSLanguage initialize]\" -exclude \"NSPrintAutoreleasePools\" -exclude \"+[NSWindowBinder initialize]\" -exclude \"+[NSCollator initialize]\" -exclude \"+[NSCollatorElement initialize]\" %d", NSStringFromClass([self class]), NSStringFromSelector(_cmd), getpid()];
      
      if([NSAutoreleasePool respondsToSelector:@selector(showPools)]) { [NSAutoreleasePool showPools]; }
      NSLog(@"starting autoreleased objects: %u  Now: %u  Diff: %u", startAutoreleasedObjects, (([NSAutoreleasePool respondsToSelector:@selector(totalAutoreleasedObjects)]) ? [NSAutoreleasePool totalAutoreleasedObjects] : 0), (([NSAutoreleasePool respondsToSelector:@selector(totalAutoreleasedObjects)]) ? [NSAutoreleasePool totalAutoreleasedObjects] : 0) - startAutoreleasedObjects);
      NSLog(@"autoreleasedObjectCount: %u", (([NSAutoreleasePool respondsToSelector:@selector(autoreleasedObjectCount)]) ? [NSAutoreleasePool autoreleasedObjectCount] : 0));
      NSLog(@"topAutoreleasePoolCount: %u", (([NSAutoreleasePool respondsToSelector:@selector(totalAutoreleasedObjects)]) ? [NSAutoreleasePool totalAutoreleasedObjects] : 0));
      
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
  
  NSLog(RKPrettyObjectMethodString(@"Cache status:\n%@", [RKRegex regexCache]));
  NSSet *regexCacheSet = [[RKRegex regexCache] cacheSet];
  NSLog(@"Cache set count: %d", [regexCacheSet count]);

  NSAutoreleasePool *cachePool = [[NSAutoreleasePool alloc] init];
  [[RKRegex regexCache] clearCache];
  [cachePool release]; cachePool = NULL;
  
  regexCacheSet = [[RKRegex regexCache] cacheSet];
  
  if(([leakEnvString intValue] > 0)) {
    leaksCommandString = [[NSString alloc] initWithFormat:@"/usr/bin/leaks -nocontext -exclude \"+[%@ %@]\" -exclude \"+[NSTitledFrame initialize]\" -exclude \"+[NSLanguage initialize]\" -exclude \"NSPrintAutoreleasePools\" -exclude \"+[NSWindowBinder initialize]\" -exclude \"+[NSCollator initialize]\" -exclude \"+[NSCollatorElement initialize]\" %d", NSStringFromClass([self class]), NSStringFromSelector(_cmd), getpid()];
    
    if([leakEnvString intValue] > 2) {
      if([NSAutoreleasePool respondsToSelector:@selector(showPools)]) { [NSAutoreleasePool showPools]; }
      NSLog(@"starting autoreleased objects: %u  Now: %u  Diff: %u", startAutoreleasedObjects, (([NSAutoreleasePool respondsToSelector:@selector(totalAutoreleasedObjects)]) ? [NSAutoreleasePool totalAutoreleasedObjects] : 0), (([NSAutoreleasePool respondsToSelector:@selector(totalAutoreleasedObjects)]) ? [NSAutoreleasePool totalAutoreleasedObjects] : 0) - startAutoreleasedObjects);
      NSLog(@"autoreleasedObjectCount: %u", (([NSAutoreleasePool respondsToSelector:@selector(autoreleasedObjectCount)]) ? [NSAutoreleasePool autoreleasedObjectCount] : 0));
      NSLog(@"topAutoreleasePoolCount: %u", (([NSAutoreleasePool respondsToSelector:@selector(totalAutoreleasedObjects)]) ? [NSAutoreleasePool totalAutoreleasedObjects] : 0));
    }
    
    if(startLeakPool != nil) { [startLeakPool release]; startLeakPool = nil; }
    
    if([leakEnvString intValue] > 1) {
      NSLog(@"\n\n---------\nReleased setUp autorelease pool\n\n");
      
      if([NSAutoreleasePool respondsToSelector:@selector(showPools)]) { [NSAutoreleasePool showPools]; }
      NSLog(@"starting autoreleased objects: %u  Now: %u  Diff: %u", startAutoreleasedObjects, (([NSAutoreleasePool respondsToSelector:@selector(totalAutoreleasedObjects)]) ? [NSAutoreleasePool totalAutoreleasedObjects] : 0), (([NSAutoreleasePool respondsToSelector:@selector(totalAutoreleasedObjects)]) ? [NSAutoreleasePool totalAutoreleasedObjects] : 0) - startAutoreleasedObjects);
      NSLog(@"autoreleasedObjectCount: %u", (([NSAutoreleasePool respondsToSelector:@selector(autoreleasedObjectCount)]) ? [NSAutoreleasePool autoreleasedObjectCount] : 0));
      NSLog(@"topAutoreleasePoolCount: %u", (([NSAutoreleasePool respondsToSelector:@selector(totalAutoreleasedObjects)]) ? [NSAutoreleasePool totalAutoreleasedObjects] : 0));
    }
    
    NSLog(@"Executing '%@'", leaksCommandString);
    system([leaksCommandString UTF8String]);
  }
  
  
  if(startLeakPool != nil) { [startLeakPool release]; startLeakPool = nil; }
  if(startTopPool != nil) { [startTopPool release]; startTopPool = nil; }
  
  NSLog(@"starting autoreleased objects: %u  Now: %u  Diff: %u", startAutoreleasedObjects, (([NSAutoreleasePool respondsToSelector:@selector(totalAutoreleasedObjects)]) ? [NSAutoreleasePool totalAutoreleasedObjects] : 0), (([NSAutoreleasePool respondsToSelector:@selector(totalAutoreleasedObjects)]) ? [NSAutoreleasePool totalAutoreleasedObjects] : 0) - startAutoreleasedObjects);

  NSLog(@"Elapsed CPU time: %@", [NSDate stringFromCPUTime:testElapsedCPUTime]);
  NSLog(@"Elapsed CPU time: %@", [NSDate microSecondsStringFromCPUTime:testElapsedCPUTime]);
  NSLog(RKPrettyObjectMethodString(@"Teardown complete\n"));
  fprintf(stderr, "-----------------------------------------\n\n");
}

- (void)testArrayExtensions
{
  NSArray *testArray = NULL, *matchedArray = NULL;
  NSMutableArray *mutableArray = NULL;

  STAssertTrueNoThrow((testArray = [NSArray arrayWithObjects:@"zero 0 aaa", @"one 1 aab", @"two 2 ab", @"three 3 bab", @"four 4 aba ", @"five 5 baa", @"six 6 bbb", nil]) != NULL, nil);
    
    
  STAssertTrueNoThrow((matchedArray = [testArray arrayByMatchingObjectsWithRegex:@"ab"]) != NULL, nil);
  //ab array     : ("one 1 aab",   "two 2 ab",    "three 3 bab", "four 4 aba ")
  STAssertTrue([matchedArray count] == 4, @"Count is %u", [matchedArray count]);
  STAssertTrue([[matchedArray objectAtIndex:0] isEqualToString:@"one 1 aab"], nil);
  STAssertTrue([[matchedArray objectAtIndex:1] isEqualToString:@"two 2 ab"], nil);
  STAssertTrue([[matchedArray objectAtIndex:2] isEqualToString:@"three 3 bab"], nil);
  STAssertTrue([[matchedArray objectAtIndex:3] isEqualToString:@"four 4 aba "], nil);

  STAssertTrueNoThrow((matchedArray = [testArray arrayByMatchingObjectsWithRegex:@"aa"]) != NULL, nil);
  //aa array     : ("zero 0 aaa",  "one 1 aab",   "five 5 baa")
  STAssertTrue([matchedArray count] == 3, @"Count is %u", [matchedArray count]);
  STAssertTrue([[matchedArray objectAtIndex:0] isEqualToString:@"zero 0 aaa"], nil);
  STAssertTrue([[matchedArray objectAtIndex:1] isEqualToString:@"one 1 aab"], nil);
  STAssertTrue([[matchedArray objectAtIndex:2] isEqualToString:@"five 5 baa"], nil);  

  STAssertTrueNoThrow((matchedArray = [testArray arrayByMatchingObjectsWithRegex:@"ba"]) != NULL, nil);
  //ba array     : ("three 3 bab", "four 4 aba ", "five 5 baa")
  STAssertTrue([matchedArray count] == 3, @"Count is %u", [matchedArray count]);
  STAssertTrue([[matchedArray objectAtIndex:0] isEqualToString:@"three 3 bab"], nil);
  STAssertTrue([[matchedArray objectAtIndex:1] isEqualToString:@"four 4 aba "], nil);
  STAssertTrue([[matchedArray objectAtIndex:2] isEqualToString:@"five 5 baa"], nil);
  

  STAssertTrueNoThrow((matchedArray = [testArray arrayByMatchingObjectsWithRegex:@"o"]) != NULL, nil);
  //o array      : ("zero 0 aaa",  "one 1 aab",   "two 2 ab",    "four 4 aba ")
  STAssertTrue([matchedArray count] == 4, @"Count is %u", [matchedArray count]);
  STAssertTrue([[matchedArray objectAtIndex:0] isEqualToString:@"zero 0 aaa"], nil);
  STAssertTrue([[matchedArray objectAtIndex:1] isEqualToString:@"one 1 aab"], nil);
  STAssertTrue([[matchedArray objectAtIndex:2] isEqualToString:@"two 2 ab"], nil);
  STAssertTrue([[matchedArray objectAtIndex:3] isEqualToString:@"four 4 aba "], nil);
  
  STAssertTrueNoThrow((matchedArray = [testArray arrayByMatchingObjectsWithRegex:@"2|4|6"]) != NULL, nil);
  //2|4|6 array  : ("two 2 ab",    "four 4 aba ", "six 6 bbb")
  STAssertTrue([matchedArray count] == 3, @"Count is %u", [matchedArray count]);
  STAssertTrue([[matchedArray objectAtIndex:0] isEqualToString:@"two 2 ab"], nil);
  STAssertTrue([[matchedArray objectAtIndex:1] isEqualToString:@"four 4 aba "], nil);
  STAssertTrue([[matchedArray objectAtIndex:2] isEqualToString:@"six 6 bbb"], nil);
  
    
  
  STAssertTrueNoThrow((mutableArray = [NSMutableArray arrayWithArray:testArray]) != NULL, nil);
  //mutable array: ("zero 0 aaa",  "one 1 aab",   "two 2 ab",    "three 3 bab", "four 4 aba ", "five 5 baa", "six 6 bbb")
  STAssertTrue([mutableArray count] == 7, @"Count is %u", [mutableArray count]);
  STAssertTrue([[mutableArray objectAtIndex:0] isEqualToString:@"zero 0 aaa"], nil);
  STAssertTrue([[mutableArray objectAtIndex:1] isEqualToString:@"one 1 aab"], nil);
  STAssertTrue([[mutableArray objectAtIndex:2] isEqualToString:@"two 2 ab"], nil);
  STAssertTrue([[mutableArray objectAtIndex:3] isEqualToString:@"three 3 bab"], nil);
  STAssertTrue([[mutableArray objectAtIndex:4] isEqualToString:@"four 4 aba "], nil);
  STAssertTrue([[mutableArray objectAtIndex:5] isEqualToString:@"five 5 baa"], nil);
  STAssertTrue([[mutableArray objectAtIndex:6] isEqualToString:@"six 6 bbb"], nil);
  

  STAssertNoThrow([mutableArray addObjectsFromArray:testArray matchingRegex:@"ab"], nil);
  //mutable array: ("zero 0 aaa",  "one 1 aab",   "two 2 ab",    "three 3 bab", "four 4 aba ", "five 5 baa", "six 6 bbb", "one 1 aab", "two 2 ab", "three 3 bab", "four 4 aba ")
  STAssertTrue([mutableArray count] == 11, @"Count is %u", [mutableArray count]);
  STAssertTrueNoThrow([mutableArray countOfObjectsMatchingRegex:@"ab"] == 8, @"Count == %u", [mutableArray countOfObjectsMatchingRegex:@"ab"]);
  STAssertTrue([[mutableArray objectAtIndex:0] isEqualToString:@"zero 0 aaa"], nil);
  STAssertTrue([[mutableArray objectAtIndex:1] isEqualToString:@"one 1 aab"], nil);
  STAssertTrue([[mutableArray objectAtIndex:2] isEqualToString:@"two 2 ab"], nil);
  STAssertTrue([[mutableArray objectAtIndex:3] isEqualToString:@"three 3 bab"], nil);
  STAssertTrue([[mutableArray objectAtIndex:4] isEqualToString:@"four 4 aba "], nil);
  STAssertTrue([[mutableArray objectAtIndex:5] isEqualToString:@"five 5 baa"], nil);
  STAssertTrue([[mutableArray objectAtIndex:6] isEqualToString:@"six 6 bbb"], nil);
  STAssertTrue([[mutableArray objectAtIndex:7] isEqualToString:@"one 1 aab"], nil);
  STAssertTrue([[mutableArray objectAtIndex:8] isEqualToString:@"two 2 ab"], nil);
  STAssertTrue([[mutableArray objectAtIndex:9] isEqualToString:@"three 3 bab"], nil);
  STAssertTrue([[mutableArray objectAtIndex:10] isEqualToString:@"four 4 aba "], nil);
  
  STAssertTrueNoThrow([mutableArray indexOfObjectMatchingRegex:@"^four"] == 4, @"Index is %u", [mutableArray indexOfObjectMatchingRegex:@"^four"]);
  STAssertTrueNoThrow([mutableArray indexOfObjectMatchingRegex:@"^four" inRange:NSMakeRange(3, 7)] == 4, @"Index is %u", [mutableArray indexOfObjectMatchingRegex:@"^four" inRange:NSMakeRange(3, 7)]);
  STAssertTrueNoThrow([mutableArray indexOfObjectMatchingRegex:@"^four" inRange:NSMakeRange(5, 5)] == NSNotFound, @"Index is %u", [mutableArray indexOfObjectMatchingRegex:@"^four" inRange:NSMakeRange(5, 5)]);
  STAssertTrueNoThrow([mutableArray indexOfObjectMatchingRegex:@"^four" inRange:NSMakeRange(5, 6)] == 10, @"Index is %u", [mutableArray indexOfObjectMatchingRegex:@"^four" inRange:NSMakeRange(5, 6)]);
  STAssertThrowsSpecificNamed([mutableArray indexOfObjectMatchingRegex:@"^four" inRange:NSMakeRange(5, 7)], NSException, NSRangeException, nil);


  STAssertTrueNoThrow([mutableArray countOfObjectsMatchingRegex:@"^four"] == 2, @"Count is %u", [mutableArray countOfObjectsMatchingRegex:@"^four"]);
  STAssertTrueNoThrow([mutableArray countOfObjectsMatchingRegex:@"^four" inRange:NSMakeRange(3, 8)] == 2, @"Count is %u", [mutableArray countOfObjectsMatchingRegex:@"^four" inRange:NSMakeRange(3, 8)]);
  STAssertTrueNoThrow([mutableArray countOfObjectsMatchingRegex:@"^four" inRange:NSMakeRange(4, 7)] == 2, @"Count is %u", [mutableArray countOfObjectsMatchingRegex:@"^four" inRange:NSMakeRange(4, 7)]);
  STAssertTrueNoThrow([mutableArray countOfObjectsMatchingRegex:@"^four" inRange:NSMakeRange(5, 6)] == 1, @"Count is %u", [mutableArray countOfObjectsMatchingRegex:@"^four" inRange:NSMakeRange(5, 6)]);
  STAssertThrowsSpecificNamed([mutableArray countOfObjectsMatchingRegex:@"^four" inRange:NSMakeRange(5, 7)], NSException, NSRangeException, nil);


  STAssertTrueNoThrow([mutableArray countOfObjectsMatchingRegex:@"ab" inRange:NSMakeRange(3, 5)] == 3, @"Count == %u", [mutableArray countOfObjectsMatchingRegex:@"ab" inRange:NSMakeRange(3, 5)]);
  STAssertNoThrow([mutableArray removeObjectsMatchingRegex:@"ab" inRange:NSMakeRange(3, 5)], nil);
  // mutable array: ("zero 0 aaa", "one 1 aab", "two 2 ab", "five 5 baa", "six 6 bbb", "two 2 ab", "three 3 bab", "four 4 aba ")
  STAssertTrue([mutableArray count] == 8, @"Count is %u", [mutableArray count]);
  STAssertTrue([[mutableArray objectAtIndex:0] isEqualToString:@"zero 0 aaa"], nil);
  STAssertTrue([[mutableArray objectAtIndex:1] isEqualToString:@"one 1 aab"], nil);
  STAssertTrue([[mutableArray objectAtIndex:2] isEqualToString:@"two 2 ab"], nil);
  STAssertTrue([[mutableArray objectAtIndex:3] isEqualToString:@"five 5 baa"], nil);
  STAssertTrue([[mutableArray objectAtIndex:4] isEqualToString:@"six 6 bbb"], nil);
  STAssertTrue([[mutableArray objectAtIndex:5] isEqualToString:@"two 2 ab"], nil);
  STAssertTrue([[mutableArray objectAtIndex:6] isEqualToString:@"three 3 bab"], nil);
  STAssertTrue([[mutableArray objectAtIndex:7] isEqualToString:@"four 4 aba "], nil);
  
  STAssertNoThrow([mutableArray removeObjectsMatchingRegex:@"ab"], nil);
  //mutable array: ("zero 0 aaa",  "five 5 baa",  "six 6 bbb")
  STAssertTrue([mutableArray count] == 3, @"Count is %u", [mutableArray count]);
  STAssertTrue([[mutableArray objectAtIndex:0] isEqualToString:@"zero 0 aaa"], nil);
  STAssertTrue([[mutableArray objectAtIndex:1] isEqualToString:@"five 5 baa"], nil);
  STAssertTrue([[mutableArray objectAtIndex:2] isEqualToString:@"six 6 bbb"], nil);

  // Same thing, should remain the same.
  STAssertNoThrow([mutableArray removeObjectsMatchingRegex:@"ab"], nil);
  //mutable array: ("zero 0 aaa",  "five 5 baa",  "six 6 bbb")
  STAssertTrue([mutableArray count] == 3, @"Count is %u", [mutableArray count]);
  STAssertTrue([[mutableArray objectAtIndex:0] isEqualToString:@"zero 0 aaa"], nil);
  STAssertTrue([[mutableArray objectAtIndex:1] isEqualToString:@"five 5 baa"], nil);
  STAssertTrue([[mutableArray objectAtIndex:2] isEqualToString:@"six 6 bbb"], nil);

  STAssertThrowsSpecificNamed([mutableArray containsObjectMatchingRegex:@"ab" inRange:NSMakeRange(23,42)], NSException, NSRangeException, nil);
  //mutable array: ("zero 0 aaa",  "five 5 baa",  "six 6 bbb") 
  STAssertTrue([mutableArray count] == 3, @"Count is %u", [mutableArray count]);
  STAssertTrue([[mutableArray objectAtIndex:0] isEqualToString:@"zero 0 aaa"], nil);
  STAssertTrue([[mutableArray objectAtIndex:1] isEqualToString:@"five 5 baa"], nil);
  STAssertTrue([[mutableArray objectAtIndex:2] isEqualToString:@"six 6 bbb"], nil);

  STAssertThrowsSpecificNamed([mutableArray removeObjectsMatchingRegex:@".*" inRange:NSMakeRange(13, 17)], NSException, NSRangeException, nil);
  //mutable array: ("zero 0 aaa",  "five 5 baa",  "six 6 bbb") 
  STAssertTrue([mutableArray count] == 3, @"Count is %u", [mutableArray count]);
  STAssertTrue([[mutableArray objectAtIndex:0] isEqualToString:@"zero 0 aaa"], nil);
  STAssertTrue([[mutableArray objectAtIndex:1] isEqualToString:@"five 5 baa"], nil);
  STAssertTrue([[mutableArray objectAtIndex:2] isEqualToString:@"six 6 bbb"], nil);

  STAssertNoThrow([mutableArray removeObjectsMatchingRegex:@".*" inRange:NSMakeRange(0, 0)], nil);
  //mutable array: ("zero 0 aaa",  "five 5 baa",  "six 6 bbb") 
  STAssertTrue([mutableArray count] == 3, @"Count is %u", [mutableArray count]);
  STAssertTrue([[mutableArray objectAtIndex:0] isEqualToString:@"zero 0 aaa"], nil);
  STAssertTrue([[mutableArray objectAtIndex:1] isEqualToString:@"five 5 baa"], nil);
  STAssertTrue([[mutableArray objectAtIndex:2] isEqualToString:@"six 6 bbb"], nil);

  STAssertNoThrow([mutableArray removeObjectsMatchingRegex:@".*" inRange:NSMakeRange(1, 0)], nil);
  //mutable array: ("zero 0 aaa",  "five 5 baa",  "six 6 bbb") 
  STAssertTrue([mutableArray count] == 3, @"Count is %u", [mutableArray count]);
  STAssertTrue([[mutableArray objectAtIndex:0] isEqualToString:@"zero 0 aaa"], nil);
  STAssertTrue([[mutableArray objectAtIndex:1] isEqualToString:@"five 5 baa"], nil);
  STAssertTrue([[mutableArray objectAtIndex:2] isEqualToString:@"six 6 bbb"], nil);

  STAssertNoThrow([mutableArray removeObjectsMatchingRegex:@".*" inRange:NSMakeRange(2, 0)], nil);
  //mutable array: ("zero 0 aaa",  "five 5 baa",  "six 6 bbb") 
  STAssertTrue([mutableArray count] == 3, @"Count is %u", [mutableArray count]);
  STAssertTrue([[mutableArray objectAtIndex:0] isEqualToString:@"zero 0 aaa"], nil);
  STAssertTrue([[mutableArray objectAtIndex:1] isEqualToString:@"five 5 baa"], nil);
  STAssertTrue([[mutableArray objectAtIndex:2] isEqualToString:@"six 6 bbb"], nil);

  STAssertNoThrow([mutableArray removeObjectsMatchingRegex:@".*" inRange:NSMakeRange(3, 0)], nil);
  //mutable array: ("zero 0 aaa",  "five 5 baa",  "six 6 bbb") 
  STAssertTrue([mutableArray count] == 3, @"Count is %u", [mutableArray count]);
  STAssertTrue([[mutableArray objectAtIndex:0] isEqualToString:@"zero 0 aaa"], nil);
  STAssertTrue([[mutableArray objectAtIndex:1] isEqualToString:@"five 5 baa"], nil);
  STAssertTrue([[mutableArray objectAtIndex:2] isEqualToString:@"six 6 bbb"], nil);

  STAssertNoThrow([mutableArray removeObjectsInRange:NSMakeRange(3, 0)], nil);
  STAssertTrue([mutableArray count] == 3, @"Count is %u", [mutableArray count]);
  STAssertTrue([[mutableArray objectAtIndex:0] isEqualToString:@"zero 0 aaa"], nil);
  STAssertTrue([[mutableArray objectAtIndex:1] isEqualToString:@"five 5 baa"], nil);
  STAssertTrue([[mutableArray objectAtIndex:2] isEqualToString:@"six 6 bbb"], nil);
  
  STAssertThrowsSpecificNamed([mutableArray removeObjectsMatchingRegex:@".*" inRange:NSMakeRange(4, 0)], NSException, NSRangeException, nil);
  //mutable array: ("zero 0 aaa",  "five 5 baa",  "six 6 bbb") 
  STAssertTrue([mutableArray count] == 3, @"Count is %u", [mutableArray count]);
  STAssertTrue([[mutableArray objectAtIndex:0] isEqualToString:@"zero 0 aaa"], nil);
  STAssertTrue([[mutableArray objectAtIndex:1] isEqualToString:@"five 5 baa"], nil);
  STAssertTrue([[mutableArray objectAtIndex:2] isEqualToString:@"six 6 bbb"], nil);
  
  STAssertTrueNoThrow([mutableArray countOfObjectsMatchingRegex:@"(?:a|b)" inRange:NSMakeRange(1, 1)] == 1, nil);

  STAssertTrueNoThrow([mutableArray countOfObjectsMatchingRegex:@"^(?:five|six)" inRange:NSMakeRange(0, 2)] == 1, nil);
  STAssertTrueNoThrow([mutableArray countOfObjectsMatchingRegex:@"^(?:five|six)" inRange:NSMakeRange(1, 2)] == 2, nil);
  STAssertThrowsSpecificNamed([mutableArray removeObjectsMatchingRegex:@"^(?:five|six)" inRange:NSMakeRange(2, 2)], NSException, NSRangeException, nil);
  STAssertTrueNoThrow([mutableArray countOfObjectsMatchingRegex:@"^(?:five|six)" inRange:NSMakeRange(2, 1)] == 1, nil);
  STAssertTrueNoThrow([mutableArray countOfObjectsMatchingRegex:@"^(?:five|six)" inRange:NSMakeRange(0, 3)] == 2, nil);

  
  STAssertTrueNoThrow((matchedArray = [mutableArray arrayByMatchingObjectsWithRegex:@"I don't wanna match"]) != NULL, nil);
  STAssertTrue([mutableArray count] == 3, @"Count is %u", [mutableArray count]);
  STAssertTrue([matchedArray count] == 0, @"Count is %u", [matchedArray count]);

  STAssertThrowsSpecificNamed([mutableArray removeObjectsMatchingRegex:NULL inRange:NSMakeRange(0, 1)], NSException, NSInvalidArgumentException, nil);

}

- (void)testDictionaryExtensions
{
  NSMutableDictionary *testDict = [NSMutableDictionary dictionary];
  NSDictionary *regexDictionary = NULL, *staticDictionary = NULL;
  NSArray *testObjects = NULL, *regexObjects = NULL;
  
  STAssertNotNil(testDict, nil);
  [testDict setObject:[NSNumber numberWithInt:0] forKey:@"zero aaa"];
  [testDict setObject:[NSNumber numberWithInt:1] forKey:@"one aab"];
  [testDict setObject:[NSNumber numberWithInt:2] forKey:@"two aba"];
  [testDict setObject:[NSNumber numberWithInt:3] forKey:@"three baa"];
  [testDict setObject:[NSNumber numberWithInt:4] forKey:@"four bab"];  
  STAssertTrue([testDict count] == 5, @"Count = %u", [testDict count]);

  STAssertTrueNoThrow((staticDictionary = [NSDictionary dictionaryWithDictionary:testDict]) != NULL, nil);

  STAssertTrueNoThrow((regexDictionary = [testDict dictionaryByMatchingKeysWithRegex:@"No! They're stealing my regex!"]) != NULL, nil);
  STAssertTrue([regexDictionary count] == 0, @"Count = %u", [regexDictionary count]);


  STAssertTrueNoThrow((regexDictionary = [testDict dictionaryByMatchingKeysWithRegex:@".*"]) != NULL, nil);
  STAssertTrue([regexDictionary count] == 5, @"Count = %u", [regexDictionary count]);
  STAssertTrueNoThrow((regexObjects = [regexDictionary allKeys]) != NULL, nil);
  STAssertTrue([regexObjects containsObject:@"zero aaa"], nil);
  STAssertTrue([regexObjects containsObject:@"one aab"], nil);
  STAssertTrue([regexObjects containsObject:@"two aba"], nil);
  STAssertTrue([regexObjects containsObject:@"three baa"], nil);
  STAssertTrue([regexObjects containsObject:@"four bab"], nil);
  STAssertTrueNoThrow((regexObjects = [regexDictionary allValues]) != NULL, nil);
  STAssertTrue([regexObjects containsObject:[NSNumber numberWithInt:0]], nil);
  STAssertTrue([regexObjects containsObject:[NSNumber numberWithInt:1]], nil);
  STAssertTrue([regexObjects containsObject:[NSNumber numberWithInt:2]], nil);
  STAssertTrue([regexObjects containsObject:[NSNumber numberWithInt:3]], nil);
  STAssertTrue([regexObjects containsObject:[NSNumber numberWithInt:4]], nil);
  STAssertTrue([[regexDictionary objectForKey:@"zero aaa"] isEqualToNumber:[NSNumber numberWithInt:0]], nil);
  STAssertTrue([[regexDictionary objectForKey:@"one aab"] isEqualToNumber:[NSNumber numberWithInt:1]], nil);
  STAssertTrue([[regexDictionary objectForKey:@"two aba"] isEqualToNumber:[NSNumber numberWithInt:2]], nil);
  STAssertTrue([[regexDictionary objectForKey:@"three baa"] isEqualToNumber:[NSNumber numberWithInt:3]], nil);
  STAssertTrue([[regexDictionary objectForKey:@"four bab"] isEqualToNumber:[NSNumber numberWithInt:4]], nil);

  STAssertTrueNoThrow((regexDictionary = [testDict dictionaryByMatchingObjectsWithRegex:@".*"]) != NULL, nil);
  STAssertTrue([regexDictionary count] == 5, @"Count = %u", [regexDictionary count]);
  STAssertTrueNoThrow((regexObjects = [regexDictionary allKeys]) != NULL, nil);
  STAssertTrue([regexObjects containsObject:@"zero aaa"], nil);
  STAssertTrue([regexObjects containsObject:@"one aab"], nil);
  STAssertTrue([regexObjects containsObject:@"two aba"], nil);
  STAssertTrue([regexObjects containsObject:@"three baa"], nil);
  STAssertTrue([regexObjects containsObject:@"four bab"], nil);
  STAssertTrueNoThrow((regexObjects = [regexDictionary allValues]) != NULL, nil);
  STAssertTrue([regexObjects containsObject:[NSNumber numberWithInt:0]], nil);
  STAssertTrue([regexObjects containsObject:[NSNumber numberWithInt:1]], nil);
  STAssertTrue([regexObjects containsObject:[NSNumber numberWithInt:2]], nil);
  STAssertTrue([regexObjects containsObject:[NSNumber numberWithInt:3]], nil);
  STAssertTrue([regexObjects containsObject:[NSNumber numberWithInt:4]], nil);
  STAssertTrue([[regexDictionary objectForKey:@"zero aaa"] isEqualToNumber:[NSNumber numberWithInt:0]], nil);
  STAssertTrue([[regexDictionary objectForKey:@"one aab"] isEqualToNumber:[NSNumber numberWithInt:1]], nil);
  STAssertTrue([[regexDictionary objectForKey:@"two aba"] isEqualToNumber:[NSNumber numberWithInt:2]], nil);
  STAssertTrue([[regexDictionary objectForKey:@"three baa"] isEqualToNumber:[NSNumber numberWithInt:3]], nil);
  STAssertTrue([[regexDictionary objectForKey:@"four bab"] isEqualToNumber:[NSNumber numberWithInt:4]], nil);
  
  
  
  STAssertTrueNoThrow((regexDictionary = [testDict dictionaryByMatchingObjectsWithRegex:@"1|3|4"]) != NULL, nil);
  STAssertTrue([regexDictionary count] == 3, @"Count = %u", [regexDictionary count]);
  STAssertTrue([[regexDictionary allKeys] containsObject:@"one aab"], nil);
  STAssertTrue([[regexDictionary allKeys] containsObject:@"three baa"], nil);
  STAssertTrue([[regexDictionary allKeys] containsObject:@"four bab"], nil);
  STAssertTrue([[regexDictionary allValues] containsObject:[NSNumber numberWithInt:1]], nil);
  STAssertTrue([[regexDictionary allValues] containsObject:[NSNumber numberWithInt:3]], nil);
  STAssertTrue([[regexDictionary allValues] containsObject:[NSNumber numberWithInt:4]], nil);
  STAssertTrue([[regexDictionary objectForKey:@"one aab"] isEqualToNumber:[NSNumber numberWithInt:1]], nil);
  STAssertTrue([[regexDictionary objectForKey:@"three baa"] isEqualToNumber:[NSNumber numberWithInt:3]], nil);
  STAssertTrue([[regexDictionary objectForKey:@"four bab"] isEqualToNumber:[NSNumber numberWithInt:4]], nil);


  STAssertTrueNoThrow((testObjects = [testDict objectsMatchingRegex:@"2|3"]) != NULL, nil);
  STAssertTrue([testObjects count] == 2, @"Count = %u", [testObjects count]);
  STAssertTrue([testObjects containsObject:[NSNumber numberWithInt:2]], nil);
  STAssertTrue([testObjects containsObject:[NSNumber numberWithInt:3]], nil);

  STAssertTrue([regexDictionary containsObjectMatchingRegex:@"0|2"] == NO, nil);
  STAssertTrue([regexDictionary containsObjectMatchingRegex:@"0|1|2"] == YES, nil);
  STAssertTrue([regexDictionary containsObjectMatchingRegex:@"0|1"] == YES, nil);
  STAssertTrue([regexDictionary containsObjectMatchingRegex:@"1|2"] == YES, nil);
  STAssertTrue([regexDictionary containsObjectMatchingRegex:@"0"] == NO, nil);
  STAssertTrue([regexDictionary containsObjectMatchingRegex:@"3"] == YES, nil);
  STAssertTrueNoThrow((regexObjects = [regexDictionary objectsMatchingRegex:@"0|1|2"]) != NULL, nil);
  STAssertTrue([regexObjects count] == 1, @"Count = %u", [regexObjects count]);
  STAssertTrue([regexObjects containsObject:[NSNumber numberWithInt:1]], nil);
  


  STAssertTrueNoThrow((testObjects = [testDict objectsForKeysMatchingRegex:@"o a"]) != NULL, nil);
  STAssertTrue([testObjects count] == 2, @"Count = %u", [regexObjects count]);
  STAssertTrue([testObjects containsObject:[NSNumber numberWithInt:0]], nil);
  STAssertTrue([testObjects containsObject:[NSNumber numberWithInt:2]], nil);

  STAssertTrueNoThrow((testObjects = [testDict objectsMatchingRegex:@"CantMatchThis"]) != NULL, nil);
  STAssertTrueNoThrow((regexObjects = [regexDictionary objectsMatchingRegex:@"CanTooMatchThat"]) != NULL, nil);
  STAssertTrue([testObjects count] == 0, @"Count = %u", [testObjects count]);
  STAssertTrue([regexObjects count] == 0, @"Count = %u", [regexObjects count]);
  
  STAssertTrueNoThrow((regexDictionary = [testDict dictionaryByMatchingKeysWithRegex:@"o a"]) != NULL, nil);
  STAssertTrue([regexDictionary count] == 2, @"Count = %u", [regexDictionary count]);
  STAssertTrue([[regexDictionary allKeys] containsObject:@"zero aaa"], nil);
  STAssertTrue([[regexDictionary allKeys] containsObject:@"two aba"], nil);
  STAssertTrue([[regexDictionary allValues] containsObject:[NSNumber numberWithInt:0]], nil);
  STAssertTrue([[regexDictionary allValues] containsObject:[NSNumber numberWithInt:2]], nil);
  STAssertTrue([[regexDictionary objectForKey:@"zero aaa"] isEqualToNumber:[NSNumber numberWithInt:0]], nil);
  STAssertTrue([[regexDictionary objectForKey:@"two aba"] isEqualToNumber:[NSNumber numberWithInt:2]], nil);
  
  STAssertTrueNoThrow([testDict containsKeyMatchingRegex:@"aaa"], nil);
  STAssertTrueNoThrow([regexDictionary containsKeyMatchingRegex:@"aaa"], nil);
  STAssertTrueNoThrow([testDict containsKeyMatchingRegex:@"aab"], nil);
  STAssertFalseNoThrow([regexDictionary containsKeyMatchingRegex:@"aab"], nil);
  

  STAssertTrueNoThrow((testObjects = [testDict keysMatchingRegex:@"CantMatchThis"]) != NULL, nil);
  STAssertTrueNoThrow((regexObjects = [regexDictionary keysMatchingRegex:@"CanTooMatchThat"]) != NULL, nil);
  STAssertTrue([testObjects count] == 0, @"Count = %u", [testObjects count]);
  STAssertTrue([regexObjects count] == 0, @"Count = %u", [regexObjects count]);
  
  

  STAssertTrueNoThrow((testObjects = [testDict keysMatchingRegex:@".*"]) != NULL, nil);
  STAssertTrueNoThrow((regexObjects = [regexDictionary keysMatchingRegex:@".*"]) != NULL, nil);
  STAssertTrue([testObjects count] == 5, @"Count = %u", [testObjects count]);
  STAssertTrue([regexObjects count] == 2, @"Count = %u", [regexObjects count]);
  STAssertTrue([testObjects containsObject:@"zero aaa"], nil);
  STAssertTrue([testObjects containsObject:@"one aab"], nil);
  STAssertTrue([testObjects containsObject:@"two aba"], nil);
  STAssertTrue([testObjects containsObject:@"three baa"], nil);
  STAssertTrue([testObjects containsObject:@"four bab"], nil);
  STAssertTrue([regexObjects containsObject:@"zero aaa"], nil);
  STAssertTrue([regexObjects containsObject:@"two aba"], nil);
  

  STAssertTrueNoThrow((testObjects = [testDict keysMatchingRegex:@"ba"]) != NULL, nil);
  STAssertTrueNoThrow((regexObjects = [regexDictionary keysMatchingRegex:@"ba"]) != NULL, nil);
  STAssertTrue([testObjects count] == 3, @"Count = %u", [testObjects count]);
  STAssertTrue([regexObjects count] == 1, @"Count = %u", [regexObjects count]);
  STAssertTrue([testObjects containsObject:@"two aba"], nil);
  STAssertTrue([testObjects containsObject:@"three baa"], nil);
  STAssertTrue([testObjects containsObject:@"four bab"], nil);
  STAssertTrue([regexObjects containsObject:@"two aba"], nil);
  

  STAssertTrueNoThrow((testObjects = [testDict objectsForKeysMatchingRegex:@"ab"]) != NULL, nil);
  STAssertTrueNoThrow((regexObjects = [regexDictionary objectsForKeysMatchingRegex:@"ab"]) != NULL, nil);
  STAssertTrue([testObjects count] == 3, @"Count = %u", [testObjects count]);
  STAssertTrue([regexObjects count] == 1, @"Count = %u", [regexObjects count]);
  STAssertTrue([testObjects containsObject:[NSNumber numberWithInt:1]], nil);
  STAssertTrue([testObjects containsObject:[NSNumber numberWithInt:2]], nil);
  STAssertTrue([testObjects containsObject:[NSNumber numberWithInt:4]], nil);
  STAssertTrue([regexObjects containsObject:[NSNumber numberWithInt:2]], nil);


  STAssertTrueNoThrow((testObjects = [testDict objectsForKeysMatchingRegex:@"bab"]) != NULL, nil);
  STAssertTrueNoThrow((regexObjects = [regexDictionary objectsForKeysMatchingRegex:@"bab"]) != NULL, nil);
  STAssertTrue([testObjects count] == 1, @"Count = %u", [testObjects count]);
  STAssertTrue([regexObjects count] == 0, @"Count = %u", [regexObjects count]);
  STAssertTrue([testObjects containsObject:[NSNumber numberWithInt:4]], nil);
 

  STAssertNotNil((regexDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:5], @"five aca", [NSNumber numberWithInt:6], @"six dad", nil]), nil);
  STAssertTrue([regexDictionary count] == 2, nil);

  STAssertTrue([testDict count] == 5, nil);
  STAssertNoThrow([testDict addEntriesFromDictionary:regexDictionary withKeysMatchingRegex:@"^six"], nil);
  STAssertTrue([testDict count] == 6, nil);
  STAssertTrue([regexDictionary count] == 2, nil);

  STAssertTrueNoThrow((testObjects = [testDict objectsForKeysMatchingRegex:@"dad$"]) != NULL, nil);
  STAssertTrue([testObjects containsObject:[NSNumber numberWithInt:6]], nil);
  

  STAssertNoThrow([testDict removeObjectsForKeysMatchingRegex:@"^(\\w+)\\s+(?:a|b)a(?:a|b)$"], nil);
  STAssertTrue([testDict count] == 2, nil);
  

  STAssertTrueNoThrow((testObjects = [testDict objectsForKeysMatchingRegex:@"^(\\w+)\\s+([abd]{3})"]) != NULL, nil);
  STAssertTrue([testObjects containsObject:[NSNumber numberWithInt:2]], nil);
  STAssertTrue([testObjects containsObject:[NSNumber numberWithInt:6]], nil);


  STAssertThrowsSpecificNamed([testDict objectsForKeysMatchingRegex:@"^(\\w+)(?\\s+)([abd]{3})"], NSException, RKRegexSyntaxErrorException, nil);


  STAssertThrows([(NSMutableDictionary *)regexDictionary removeObjectsForKeysMatchingRegex:@"e a"], nil);
  STAssertThrows([(NSMutableDictionary *)regexDictionary addEntriesFromDictionary:testDict withKeysMatchingRegex:@".*"], nil);

  STAssertNotNil((regexDictionary = [NSDictionary dictionary]), nil);
  STAssertTrueNoThrow((regexObjects = [regexDictionary objectsForKeysMatchingRegex:@"^No Match I!$"]) != NULL, nil);
  STAssertTrue([regexObjects count] == 0, nil);

  STAssertNotNil((regexDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:5], @"five aca", [NSNumber numberWithInt:6], @"six dad", nil]), nil);
  STAssertTrue([regexDictionary count] == 2, nil);
  STAssertNotNil((testDict = [NSMutableDictionary dictionary]), nil);
  STAssertTrue([testDict count] == 0, nil);

  STAssertNoThrow([testDict addEntriesFromDictionary:regexDictionary withKeysMatchingRegex:@"^No Match I!$"], nil);
  STAssertTrue([testDict count] == 0, nil);
  STAssertNoThrow([testDict addEntriesFromDictionary:regexDictionary withObjectsMatchingRegex:@"^No Match I!$"], nil);
  STAssertTrue([testDict count] == 0, nil);

  STAssertNoThrow([testDict addEntriesFromDictionary:regexDictionary withKeysMatchingRegex:@".*"], nil);
  STAssertTrue([testDict count] == 2, nil);

  STAssertNoThrow([testDict addEntriesFromDictionary:testDict withKeysMatchingRegex:@".*"], nil);
  STAssertTrue([testDict count] == 2, @"Count is %u", [testDict count]);

  STAssertNoThrow([testDict addEntriesFromDictionary:testDict withKeysMatchingRegex:@"^six"], nil);
  STAssertTrue([testDict count] == 2, @"Count is %u", [testDict count]);

  STAssertNoThrow([testDict addEntriesFromDictionary:testDict withKeysMatchingRegex:@"^six"], nil);
  STAssertTrue([testDict count] == 2, @"Count is %u", [testDict count]);

  STAssertNotNil((testDict = [NSMutableDictionary dictionary]), nil);
  STAssertTrue([testDict count] == 0, nil);

  STAssertNotNil((regexDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:5], @"five aca", [NSNumber numberWithInt:6], @"six dad", nil]), nil);
  STAssertTrue([regexDictionary count] == 2, nil);
  STAssertNoThrow([testDict setDictionary:staticDictionary], nil);
  STAssertTrue([testDict count] == 5, nil);


  STAssertNoThrow([testDict addEntriesFromDictionary:regexDictionary withObjectsMatchingRegex:@"6\\d*"], nil);
  STAssertTrue([testDict count] == 6, nil);
  STAssertTrue([regexDictionary count] == 2, nil);
  
  STAssertTrueNoThrow((testObjects = [testDict objectsMatchingRegex:@"\\d*6"]) != NULL, nil);
  STAssertTrue([testObjects containsObject:[NSNumber numberWithInt:6]], nil);
  
  
  STAssertNoThrow([testDict removeObjectsMatchingRegex:@"^[^26]*$"], nil);
  STAssertTrue([testDict count] == 2, nil);
  
  
  STAssertTrueNoThrow((testObjects = [testDict keysForObjectsMatchingRegex:@"\\d*[26]\\d*"]) != NULL, nil);
  STAssertTrue([testObjects containsObject:@"two aba"], nil);
  STAssertTrue([testObjects containsObject:@"six dad"], nil);
  
  
  STAssertThrowsSpecificNamed([testDict keysForObjectsMatchingRegex:@"^(\\d+)(\\S*)(?[246]{3})"], NSException, RKRegexSyntaxErrorException, nil);
  
  
  STAssertThrows([(NSMutableDictionary *)regexDictionary removeObjectsMatchingRegex:@"\\d+"], nil);
  STAssertThrows([(NSMutableDictionary *)regexDictionary addEntriesFromDictionary:testDict withObjectsMatchingRegex:@".*"], nil);
  
  STAssertNotNil((regexDictionary = [NSDictionary dictionary]), nil);
  STAssertTrueNoThrow((regexObjects = [regexDictionary keysForObjectsMatchingRegex:@"^No Match You!$"]) != NULL, nil);
  STAssertTrue([regexObjects count] == 0, nil);


  STAssertNoThrow([testDict removeObjectsMatchingRegex:@"\\d+"], nil);
  STAssertTrue([testDict count] == 0, nil);
  STAssertNotNil((regexDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:5], @"five aca", [NSNumber numberWithInt:6], @"six dad", nil]), nil);
  STAssertTrue([regexDictionary count] == 2, nil);


  STAssertNoThrow([testDict addEntriesFromDictionary:regexDictionary withKeysMatchingRegex:@"^No Match Zuul!$"], nil);
  STAssertTrue([testDict count] == 0, nil);
  STAssertNoThrow([testDict addEntriesFromDictionary:regexDictionary withObjectsMatchingRegex:@"^No Match Zuul\\?$"], nil);
  STAssertTrue([testDict count] == 0, nil);
  
  STAssertNoThrow([testDict addEntriesFromDictionary:regexDictionary withKeysMatchingRegex:@".*"], nil);
  STAssertTrue([testDict count] == 2, nil);
  
  STAssertNoThrow([testDict addEntriesFromDictionary:testDict withObjectsMatchingRegex:@".*"], nil);
  STAssertTrue([testDict count] == 2, @"Count is %u", [testDict count]);
  
  STAssertNoThrow([testDict addEntriesFromDictionary:testDict withObjectsMatchingRegex:@"\\d+"], nil);
  STAssertTrue([testDict count] == 2, @"Count is %u", [testDict count]);
  
  STAssertNoThrow([testDict addEntriesFromDictionary:testDict withObjectsMatchingRegex:@"6\\d*"], nil);
  STAssertTrue([testDict count] == 2, @"Count is %u", [testDict count]);
  
}


- (void)testSetExtensions
{
  NSSet *testSet = NULL, *matchedSet = NULL;
  NSMutableSet *mutableSet = NULL;
  
  STAssertTrueNoThrow((testSet = [NSSet setWithObjects:@"zero 0 aaa", @"one 1 aab", @"two 2 ab", @"three 3 bab", @"four 4 aba ", @"five 5 baa", @"six 6 bbb", nil]) != NULL, nil);
  
  
  STAssertTrueNoThrow((matchedSet = [testSet setByMatchingObjectsWithRegex:@"ab"]) != NULL, nil);
  //ab array     : ("one 1 aab",   "two 2 ab",    "three 3 bab", "four 4 aba ")
  STAssertTrue([matchedSet count] == 4, @"Count is %u", [matchedSet count]);
  STAssertTrue([matchedSet containsObject:@"one 1 aab"], nil);
  STAssertTrue([matchedSet containsObject:@"two 2 ab"], nil);
  STAssertTrue([matchedSet containsObject:@"three 3 bab"], nil);
  STAssertTrue([matchedSet containsObject:@"four 4 aba "], nil);
  
  STAssertTrueNoThrow((matchedSet = [testSet setByMatchingObjectsWithRegex:@"aa"]) != NULL, nil);
  //aa array     : ("zero 0 aaa",  "one 1 aab",   "five 5 baa")
  STAssertTrue([matchedSet count] == 3, @"Count is %u", [matchedSet count]);
  STAssertTrue([matchedSet containsObject:@"zero 0 aaa"], nil);
  STAssertTrue([matchedSet containsObject:@"one 1 aab"], nil);
  STAssertTrue([matchedSet containsObject:@"five 5 baa"], nil);  
  
  STAssertTrueNoThrow((matchedSet = [testSet setByMatchingObjectsWithRegex:@"ba"]) != NULL, nil);
  //ba array     : ("three 3 bab", "four 4 aba ", "five 5 baa")
  STAssertTrue([matchedSet count] == 3, @"Count is %u", [matchedSet count]);
  STAssertTrue([matchedSet containsObject:@"three 3 bab"], nil);
  STAssertTrue([matchedSet containsObject:@"four 4 aba "], nil);
  STAssertTrue([matchedSet containsObject:@"five 5 baa"], nil);
  
  
  STAssertTrueNoThrow((matchedSet = [testSet setByMatchingObjectsWithRegex:@"o"]) != NULL, nil);
  //o array      : ("zero 0 aaa",  "one 1 aab",   "two 2 ab",    "four 4 aba ")
  STAssertTrue([matchedSet count] == 4, @"Count is %u", [matchedSet count]);
  STAssertTrue([matchedSet containsObject:@"zero 0 aaa"], nil);
  STAssertTrue([matchedSet containsObject:@"one 1 aab"], nil);
  STAssertTrue([matchedSet containsObject:@"two 2 ab"], nil);
  STAssertTrue([matchedSet containsObject:@"four 4 aba "], nil);
  
  STAssertTrueNoThrow((matchedSet = [testSet setByMatchingObjectsWithRegex:@"2|4|6"]) != NULL, nil);
  //2|4|6 array  : ("two 2 ab",    "four 4 aba ", "six 6 bbb")
  STAssertTrue([matchedSet count] == 3, @"Count is %u", [matchedSet count]);
  STAssertTrue([matchedSet containsObject:@"two 2 ab"], nil);
  STAssertTrue([matchedSet containsObject:@"four 4 aba "], nil);
  STAssertTrue([matchedSet containsObject:@"six 6 bbb"], nil);
  
  
  
  STAssertTrueNoThrow((mutableSet = [NSMutableSet setWithSet:testSet]) != NULL, nil);
  //mutable array: ("zero 0 aaa",  "one 1 aab",   "two 2 ab",    "three 3 bab", "four 4 aba ", "five 5 baa", "six 6 bbb")
  STAssertTrue([mutableSet count] == 7, @"Count is %u", [mutableSet count]);
  STAssertTrue([mutableSet containsObject:@"zero 0 aaa"], nil);
  STAssertTrue([mutableSet containsObject:@"one 1 aab"], nil);
  STAssertTrue([mutableSet containsObject:@"two 2 ab"], nil);
  STAssertTrue([mutableSet containsObject:@"three 3 bab"], nil);
  STAssertTrue([mutableSet containsObject:@"four 4 aba "], nil);
  STAssertTrue([mutableSet containsObject:@"five 5 baa"], nil);
  STAssertTrue([mutableSet containsObject:@"six 6 bbb"], nil);
  
  
  STAssertTrueNoThrow([mutableSet countOfObjectsMatchingRegex:@"ab"] == 4, @"Count == %u", [mutableSet countOfObjectsMatchingRegex:@"ab"]);
  STAssertNoThrow([mutableSet addObjectsFromSet:testSet matchingRegex:@"ab"], nil);
  //mutable array: ("zero 0 aaa",  "one 1 aab",   "two 2 ab",    "three 3 bab", "four 4 aba ", "five 5 baa", "six 6 bbb"
  STAssertTrue([mutableSet count] == 7, @"Count is %u", [mutableSet count]);
  STAssertTrueNoThrow([mutableSet countOfObjectsMatchingRegex:@"ab"] == 4, @"Count == %u", [mutableSet countOfObjectsMatchingRegex:@"ab"]);
  STAssertTrue([mutableSet containsObject:@"zero 0 aaa"], nil);
  STAssertTrue([mutableSet containsObject:@"one 1 aab"], nil);
  STAssertTrue([mutableSet containsObject:@"two 2 ab"], nil);
  STAssertTrue([mutableSet containsObject:@"three 3 bab"], nil);
  STAssertTrue([mutableSet containsObject:@"four 4 aba "], nil);
  STAssertTrue([mutableSet containsObject:@"five 5 baa"], nil);
  STAssertTrue([mutableSet containsObject:@"six 6 bbb"], nil);

  STAssertTrueNoThrow([mutableSet countOfObjectsMatchingRegex:@"ba"] == 3, @"Count == %u", [mutableSet countOfObjectsMatchingRegex:@"ba"]);
  STAssertNoThrow([mutableSet addObjectsFromArray:[testSet allObjects] matchingRegex:@"ba"], nil);
  //mutable array: ("zero 0 aaa",  "one 1 aab",   "two 2 ab",    "three 3 bab", "four 4 aba ", "five 5 baa", "six 6 bbb"
  STAssertTrue([mutableSet count] == 7, @"Count is %u", [mutableSet count]);
  STAssertTrueNoThrow([mutableSet countOfObjectsMatchingRegex:@"ba"] == 3, @"Count == %u", [mutableSet countOfObjectsMatchingRegex:@"ba"]);
  STAssertTrue([mutableSet containsObject:@"zero 0 aaa"], nil);
  STAssertTrue([mutableSet containsObject:@"one 1 aab"], nil);
  STAssertTrue([mutableSet containsObject:@"two 2 ab"], nil);
  STAssertTrue([mutableSet containsObject:@"three 3 bab"], nil);
  STAssertTrue([mutableSet containsObject:@"four 4 aba "], nil);
  STAssertTrue([mutableSet containsObject:@"five 5 baa"], nil);
  STAssertTrue([mutableSet containsObject:@"six 6 bbb"], nil);
  
  STAssertTrueNoThrow([mutableSet countOfObjectsMatchingRegex:@"^four"] == 1, @"Count is %u", [mutableSet countOfObjectsMatchingRegex:@"^four"]);  
    
  STAssertNoThrow([mutableSet removeObjectsMatchingRegex:@"ab"], nil);
  //mutable array: ("zero 0 aaa",  "five 5 baa",  "six 6 bbb")
  STAssertTrue([mutableSet count] == 3, @"Count is %u", [mutableSet count]);
  STAssertTrue([mutableSet containsObject:@"zero 0 aaa"], nil);
  STAssertTrue([mutableSet containsObject:@"five 5 baa"], nil);
  STAssertTrue([mutableSet containsObject:@"six 6 bbb"], nil);
  
  // Same thing, should remain the same.
  STAssertNoThrow([mutableSet removeObjectsMatchingRegex:@"ab"], nil);
  //mutable array: ("zero 0 aaa",  "five 5 baa",  "six 6 bbb")
  STAssertTrue([mutableSet count] == 3, @"Count is %u", [mutableSet count]);
  STAssertTrue([mutableSet containsObject:@"zero 0 aaa"], nil);
  STAssertTrue([mutableSet containsObject:@"five 5 baa"], nil);
  STAssertTrue([mutableSet containsObject:@"six 6 bbb"], nil);


  // Add it back in...
  STAssertTrueNoThrow([mutableSet countOfObjectsMatchingRegex:@"ab"] == 0, @"Count == %u", [mutableSet countOfObjectsMatchingRegex:@"ab"]);
  STAssertNoThrow([mutableSet addObjectsFromSet:testSet matchingRegex:@"(b|a)"], nil);
  //mutable array: ("zero 0 aaa",  "one 1 aab",   "two 2 ab",    "three 3 bab", "four 4 aba ", "five 5 baa", "six 6 bbb"
  STAssertTrue([mutableSet count] == 7, @"Count is %u", [mutableSet count]);
  STAssertTrueNoThrow([mutableSet countOfObjectsMatchingRegex:@"ab"] == 4, @"Count == %u", [mutableSet countOfObjectsMatchingRegex:@"ab"]);
  STAssertTrue([mutableSet containsObject:@"zero 0 aaa"], nil);
  STAssertTrue([mutableSet containsObject:@"one 1 aab"], nil);
  STAssertTrue([mutableSet containsObject:@"two 2 ab"], nil);
  STAssertTrue([mutableSet containsObject:@"three 3 bab"], nil);
  STAssertTrue([mutableSet containsObject:@"four 4 aba "], nil);
  STAssertTrue([mutableSet containsObject:@"five 5 baa"], nil);
  STAssertTrue([mutableSet containsObject:@"six 6 bbb"], nil);
  

  // Remove and try with an array
  STAssertNoThrow([mutableSet removeObjectsMatchingRegex:@"ab"], nil);
  //mutable array: ("zero 0 aaa",  "five 5 baa",  "six 6 bbb")
  STAssertTrue([mutableSet count] == 3, @"Count is %u", [mutableSet count]);
  STAssertTrue([mutableSet containsObject:@"zero 0 aaa"], nil);
  STAssertTrue([mutableSet containsObject:@"five 5 baa"], nil);
  STAssertTrue([mutableSet containsObject:@"six 6 bbb"], nil);
  
  STAssertTrueNoThrow([mutableSet countOfObjectsMatchingRegex:@"ba"] == 1, @"Count == %u", [mutableSet countOfObjectsMatchingRegex:@"ba"]);
  STAssertNoThrow([mutableSet addObjectsFromArray:[testSet allObjects] matchingRegex:@"ba"], nil);
  //mutable set: (five 5 baa, six 6 bbb, three 3 bab, zero 0 aaa, four 4 aba )
  STAssertTrue([mutableSet count] == 5, @"Count is %u", [mutableSet count]);
  STAssertTrueNoThrow([mutableSet countOfObjectsMatchingRegex:@"ba"] == 3, @"Count == %u", [mutableSet countOfObjectsMatchingRegex:@"ba"]);
  STAssertTrue([mutableSet containsObject:@"zero 0 aaa"], nil);
  STAssertTrue([mutableSet containsObject:@"three 3 bab"], nil);
  STAssertTrue([mutableSet containsObject:@"four 4 aba "], nil);
  STAssertTrue([mutableSet containsObject:@"five 5 baa"], nil);
  STAssertTrue([mutableSet containsObject:@"six 6 bbb"], nil);
  


  STAssertTrueNoThrow((matchedSet = [mutableSet setByMatchingObjectsWithRegex:@"I don't wanna match"]) != NULL, nil);
  STAssertTrue([mutableSet count] == 5, @"Count is %u", [mutableSet count]);
  STAssertTrue([matchedSet count] == 0, @"Count is %u", [matchedSet count]);
  
  STAssertThrowsSpecificNamed([mutableSet addObjectsFromArray:NULL matchingRegex:@".*"], NSException, NSInvalidArgumentException, nil);
  STAssertThrowsSpecificNamed([mutableSet addObjectsFromSet:NULL matchingRegex:@".*"], NSException, NSInvalidArgumentException, nil);

  STAssertThrowsSpecificNamed([mutableSet addObjectsFromArray:[testSet allObjects] matchingRegex:NULL], NSException, NSInvalidArgumentException, nil);
  STAssertThrowsSpecificNamed([mutableSet addObjectsFromSet:testSet matchingRegex:NULL], NSException, NSInvalidArgumentException, nil);

  STAssertThrowsSpecificNamed([mutableSet removeObjectsMatchingRegex:NULL], NSException, NSInvalidArgumentException, nil);


  STAssertTrueNoThrow([mutableSet countOfObjectsMatchingRegex:@"I don't wanna match"] == 0, nil);
  STAssertTrueNoThrow([mutableSet containsObjectMatchingRegex:@"\\s\\d\\s"] == YES, nil);
  STAssertTrueNoThrow([mutableSet containsObjectMatchingRegex:@"No more matching!"] == NO, nil);
  STAssertTrueNoThrow([mutableSet anyObjectMatchingRegex:@"\\s\\d\\s"] != NULL, nil);
  STAssertTrueNoThrow([mutableSet anyObjectMatchingRegex:@"^Really! I've had enough of your pattern matching (ways|plays)!$"] == NULL, nil);
  
}


/*
 [@"Feb 5th" getCapturesWithRegexAndReferences:@"(?<date>.*)", @"${date:@d}", &dateCapture, nil];


 NSString *searchString = @"<1: Neato!>, <2: Wahoo!>, <3: Zoinks>", *searchRegexString = @"<(\\d+):\\s+(?<what>\\w+)[^>]*>", *replaceString = @"<${what} :$1>";
 
 NSString *searchAndReplacedString = nil;
 
 nsprintf(@"   searchString           : %@\n", searchString);
 searchAndReplacedString = [searchString stringByMatching:searchRegexString replace:RKReplaceAll withString:replaceString];
 nsprintf(@"-- searchAndReplacedString: %@\n", searchAndReplacedString);
 
 printf("\n");
 
 searchAndReplacedString = [searchString stringByMatching:searchRegexString replace:1 withString:replaceString];
 nsprintf(@"1  searchAndReplacedString: %@\n", searchAndReplacedString);
 searchAndReplacedString = [searchString stringByMatching:searchRegexString range:NSMakeRange(3, [searchString length] - 3) replace:1 withString:replaceString];
 nsprintf(@"2  searchAndReplacedString: %@\n", searchAndReplacedString);
 searchAndReplacedString = [searchString stringByMatching:searchRegexString range:NSMakeRange(11, [searchString length] - 11) replace:1 withString:replaceString];
 nsprintf(@"3  searchAndReplacedString: %@\n", searchAndReplacedString);
 searchAndReplacedString = [searchString stringByMatching:searchRegexString range:NSMakeRange(12, [searchString length] - 12) replace:1 withString:replaceString];
 nsprintf(@"4  searchAndReplacedString: %@\n", searchAndReplacedString);
 searchAndReplacedString = [searchString stringByMatching:searchRegexString range:NSMakeRange(13, [searchString length] - 13) replace:1 withString:replaceString];
 nsprintf(@"5  searchAndReplacedString: %@\n", searchAndReplacedString);
 searchAndReplacedString = [searchString stringByMatching:searchRegexString range:NSMakeRange(14, [searchString length] - 14) replace:1 withString:replaceString];
 nsprintf(@"6  searchAndReplacedString: %@\n", searchAndReplacedString);
 searchAndReplacedString = [searchString stringByMatching:searchRegexString range:NSMakeRange(15, [searchString length] - 15) replace:1 withString:replaceString];
 nsprintf(@"7  searchAndReplacedString: %@\n", searchAndReplacedString);
 searchAndReplacedString = [searchString stringByMatching:searchRegexString range:NSMakeRange(16, [searchString length] - 16) replace:1 withString:replaceString];
 nsprintf(@"8  searchAndReplacedString: %@\n", searchAndReplacedString);
 
 printf("\n");
 
 searchAndReplacedString = [searchString stringByMatching:searchRegexString replace:2 withString:replaceString];
 nsprintf(@"1b searchAndReplacedString: %@\n", searchAndReplacedString);
 searchAndReplacedString = [searchString stringByMatching:searchRegexString range:NSMakeRange(3, [searchString length] - 3) replace:2 withString:replaceString];
 nsprintf(@"2b searchAndReplacedString: %@\n", searchAndReplacedString);
 searchAndReplacedString = [searchString stringByMatching:searchRegexString range:NSMakeRange(11, [searchString length] - 11) replace:2 withString:replaceString];
 nsprintf(@"3b searchAndReplacedString: %@\n", searchAndReplacedString);
 searchAndReplacedString = [searchString stringByMatching:searchRegexString range:NSMakeRange(12, [searchString length] - 12) replace:2 withString:replaceString];
 nsprintf(@"4b searchAndReplacedString: %@\n", searchAndReplacedString);
 searchAndReplacedString = [searchString stringByMatching:searchRegexString range:NSMakeRange(13, [searchString length] - 13) replace:2 withString:replaceString];
 nsprintf(@"5b searchAndReplacedString: %@\n", searchAndReplacedString);
 searchAndReplacedString = [searchString stringByMatching:searchRegexString range:NSMakeRange(14, [searchString length] - 14) replace:2 withString:replaceString];
 nsprintf(@"6b searchAndReplacedString: %@\n", searchAndReplacedString);
 searchAndReplacedString = [searchString stringByMatching:searchRegexString range:NSMakeRange(15, [searchString length] - 15) replace:2 withString:replaceString];
 nsprintf(@"7b searchAndReplacedString: %@\n", searchAndReplacedString);
 
 
 
 
 
 NSNumber *convertedNumber = NULL;
 subjectString = @"He said the speed was 'one hundred and five point three two'.";
 
 nsprintf(@"subjectString: %@\n", subjectString);
 [subjectString getCapturesWithRegexAndReferences:@"'([^\\']*)'", @"${1:@wn}", &convertedNumber, nil];
 
 nsprintf(@"Number: %@\n", convertedNumber);
 
 id convertedDate = NULL;
 subjectString = @"Current date and time: 6/20/2007, 11:34PM EDT.";
 [subjectString getCapturesWithRegexAndReferences:@":\\s*(?<date>.*)\\.", @"${date:@d}", &convertedDate, nil];
 nsprintf(@"Date: %@\n", convertedDate);
 
*/

@end
