PRAGMA synchronous = OFF;

BEGIN;
CREATE TABLE xrefs  (xid  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, xref TEXT NOT NULL UNIQUE ON CONFLICT FAIL,  class TEXT, href TEXT);
CREATE TABLE html   (hfid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, file TEXT NOT NULL UNIQUE ON CONFLICT IGNORE          );
CREATE TABLE static (sfid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, file TEXT NOT NULL UNIQUE ON CONFLICT IGNORE          );
CREATE TABLE dirs   (did  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, dir  TEXT NOT NULL UNIQUE ON CONFLICT IGNORE          );
CREATE TABLE pcre   (version TEXT NOT NULL UNIQUE, date TEXT NOT NULL UNIQUE);
COMMIT;

BEGIN;

INSERT INTO xrefs  (xref, class, href) VALUES ("@catch", "code", "http://developer.apple.com/documentation/Cocoa/Conceptual/ObjectiveC/Articles/chapter_4_section_9.html#//apple_ref/doc/uid/TP30001163-CH7-BCIGHBBA");
INSERT INTO xrefs  (xref, class, href) VALUES ("@try", "code", "http://developer.apple.com/documentation/Cocoa/Conceptual/ObjectiveC/Articles/chapter_4_section_9.html#//apple_ref/doc/uid/TP30001163-CH7-BCIGHBBA");
INSERT INTO xrefs  (xref, class, href) VALUES ("@selector", "code", "http://developer.apple.com/documentation/Cocoa/Conceptual/ObjectiveC/Articles/chapter_4_section_6.html#//apple_ref/doc/uid/TP30001163-CH7-TPXREF128");
INSERT INTO xrefs  (xref, class)       VALUES ("ASCII", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("BOOL", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("CFArray", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("CFArrayCallBacks", "code");
INSERT INTO xrefs  (xref, class, href) VALUES ("CFBundleShortVersionString", "code", "http://developer.apple.com/documentation/MacOSX/Conceptual/BPRuntimeConfig/Articles/PListKeys.html#//apple_ref/doc/uid/20001431-111349");
INSERT INTO xrefs  (xref, class, href) VALUES ("CFBundleVersion", "code", "http://developer.apple.com/documentation/MacOSX/Conceptual/BPRuntimeConfig/Articles/PListKeys.html#//apple_ref/doc/uid/20001431-102364");
INSERT INTO xrefs  (xref, class)       VALUES ("CFDictionaryKeyCallBacks", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("CFMutableDictionary", "code");
INSERT INTO xrefs  (xref, class, href) VALUES ("Foundation", "section-link", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/ObjC_classic/index.html");
INSERT INTO xrefs  (xref, class)       VALUES ("FOUNDATION_STATIC_INLINE", "code");
INSERT INTO xrefs  (xref, class, href) VALUES ("GNUstep", "section-link", "http://www.gnustep.org/");
INSERT INTO xrefs  (xref, class)       VALUES ("INT_MIN", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("INT_MAX", "code");

INSERT INTO xrefs  (xref, class)       VALUES ("NSArray", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("NSAttributedString", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("NSAutoreleasePool", "code");
INSERT INTO xrefs  (xref, class, href) VALUES ("NSBackgroundColorAttributeName", "code", "http://developer.apple.com/documentation/Cocoa/Reference/ApplicationKit/Classes/NSAttributedString_AppKitAdditions/Reference/Reference.html#//apple_ref/doc/c_ref/NSBackgroundColorAttributeName");
INSERT INTO xrefs  (xref, class, href) VALUES ("NSCalendarDate", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/NSCalendarDate_Class/Reference/Reference.html");
INSERT INTO xrefs  (xref, class)       VALUES ("NSColor", "code");
INSERT INTO xrefs  (xref, class, href) VALUES ("NSCoding", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Protocols/NSCoding_Protocol/Reference/Reference.html#//apple_ref/occ/intf/NSCoding");
INSERT INTO xrefs  (xref, class)       VALUES ("NSColor/redColor", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("NSData", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("NSDate", "code");
INSERT INTO xrefs  (xref, class, href) VALUES ("NSDate/dateWithNaturalLanguageString:", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/NSDate_Class/Reference/Reference.html#//apple_ref/occ/clm/NSDate/dateWithNaturalLanguageString:");
INSERT INTO xrefs  (xref, class)       VALUES ("NSDictionary", "code");
INSERT INTO xrefs  (xref, class, href) VALUES ("NSDictionary/dictionaryWithObjectsAndKeys:", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/NSDictionary_Class/Reference/Reference.html#//apple_ref/occ/clm/NSDictionary/dictionaryWithObjectsAndKeys:");
INSERT INTO xrefs  (xref, class)       VALUES ("NSEnumerator", "code");
INSERT INTO xrefs  (xref, class, href) VALUES ("NSEnumerator/nextObject", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/NSEnumerator_Class/Reference/Reference.html#//apple_ref/occ/instm/NSEnumerator/nextObject");
INSERT INTO xrefs  (xref, class)       VALUES ("NSError", "code");
INSERT INTO xrefs  (xref, class, href) VALUES ("NSException", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/NSException_Class/Reference/Reference.html");
INSERT INTO xrefs  (xref, class, href) VALUES ("NSGarbageCollector", "code", "http://developer.apple.com/documentation/Cocoa/Reference/NSGarbageCollector_class/Introduction/Introduction.html");
INSERT INTO xrefs  (xref, class)       VALUES ("NSIndexSet", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("NSInteger", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("NSIntegerMin", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("NSIntegerMax", "code");
INSERT INTO xrefs  (xref, class, href) VALUES ("NSInvalidArgumentException", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Miscellaneous/Foundation_Constants/Reference/reference.html#//apple_ref/doc/c_ref/NSInvalidArgumentException");
INSERT INTO xrefs  (xref, class, href) VALUES ("NSInvalidArchiveOperationException", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/NSKeyedArchiver_Class/Reference/Reference.html#//apple_ref/doc/c_ref/NSInvalidArchiveOperationException");
INSERT INTO xrefs  (xref, class, href) VALUES ("NSInvalidUnarchiveOperationException", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/NSKeyedUnarchiver_Class/Reference/Reference.html#//apple_ref/doc/c_ref/NSInvalidUnarchiveOperationException");
INSERT INTO xrefs  (xref, class)       VALUES ("NSMakeRange", "code");
INSERT INTO xrefs  (xref, class, href) VALUES ("NSMapTable", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Miscellaneous/Foundation_Functions/Reference/reference.html#//apple_ref/doc/uid/20000055-BCIGHBEC");
INSERT INTO xrefs  (xref, class)       VALUES ("NSMutableArray", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("NSMutableAttributedString", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("NSMutableData", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("NSMutableDictionary", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("NSMutableSet", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("NSMutableString", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("NSNotFound", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("NSNull", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("NSNumber", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("NSNumberFormatter", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("NSNumberFormatterBehavior", "code");
INSERT INTO xrefs  (xref, class, href) VALUES ("NSNumberFormatterBehavior10_4", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/NSNumberFormatter_Class/Reference/Reference.html#//apple_ref/doc/c_ref/NSNumberFormatterBehavior10_4");
INSERT INTO xrefs  (xref, class, href) VALUES ("NSNumberFormatterCurrencyStyle", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/NSNumberFormatter_Class/Reference/Reference.html#//apple_ref/c/econst/NSNumberFormatterCurrencyStyle");
INSERT INTO xrefs  (xref, class, href) VALUES ("NSNumberFormatterDecimalStyle", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/NSNumberFormatter_Class/Reference/Reference.html#//apple_ref/c/econst/NSNumberFormatterDecimalStyle");
INSERT INTO xrefs  (xref, class, href) VALUES ("NSNumberFormatterNoStyle", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/NSNumberFormatter_Class/Reference/Reference.html#//apple_ref/c/econst/NSNumberFormatterNoStyle");
INSERT INTO xrefs  (xref, class, href) VALUES ("NSNumberFormatterPercentStyle", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/NSNumberFormatter_Class/Reference/Reference.html#//apple_ref/c/econst/NSNumberFormatterPercentStyle");
INSERT INTO xrefs  (xref, class, href) VALUES ("NSNumberFormatterScientificStyle", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/NSNumberFormatter_Class/Reference/Reference.html#//apple_ref/c/econst/NSNumberFormatterScientificStyle");
INSERT INTO xrefs  (xref, class, href) VALUES ("NSNumberFormatterSpellOutStyle", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/NSNumberFormatter_Class/Reference/Reference.html#//apple_ref/c/econst/NSNumberFormatterSpellOutStyle");
INSERT INTO xrefs  (xref, class, href) VALUES ("NSNumberFormatterStyle", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/NSNumberFormatter_Class/Reference/Reference.html#//apple_ref/doc/c_ref/NSNumberFormatterStyle");
INSERT INTO xrefs  (xref, class)       VALUES ("NSObjCRuntime.h", "file");
INSERT INTO xrefs  (xref, class, href) VALUES ("NSObject", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/NSObject_Class/Reference/Reference.html");
INSERT INTO xrefs  (xref, class, href) VALUES ("NSObject/load", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/NSObject_Class/Reference/Reference.html#//apple_ref/occ/clm/NSObject/load");
INSERT INTO xrefs  (xref, class)       VALUES ("NSRange", "code");
INSERT INTO xrefs  (xref, class, href) VALUES ("NSRangeException", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Miscellaneous/Foundation_Constants/Reference/reference.html#//apple_ref/doc/c_ref/NSRangeException");
INSERT INTO xrefs  (xref, class)       VALUES ("NSScanner", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("NSSet", "code");
INSERT INTO xrefs  (xref, class, href) VALUES ("NSSet/anyObject", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/NSSet_Class/Reference/Reference.html#//apple_ref/occ/instm/NSSet/anyObject");
INSERT INTO xrefs  (xref, class)       VALUES ("NSString", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("NSThread", "code");
INSERT INTO xrefs  (xref, class, href) VALUES ("NSToolTipAttributeName", "code", "http://developer.apple.com/documentation/Cocoa/Reference/ApplicationKit/Classes/NSAttributedString_AppKitAdditions/Reference/Reference.html#//apple_ref/doc/c_ref/NSToolTipAttributeName");
INSERT INTO xrefs  (xref, class)       VALUES ("NSUInteger", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("NSUIntegerMax", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("NSValue", "code");
INSERT INTO xrefs  (xref, class, href) VALUES ("NS_DURING", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Miscellaneous/Foundation_Functions/Reference/reference.html#//apple_ref/c/func/NS_DURING");
INSERT INTO xrefs  (xref, class, href) VALUES ("NS_ENDHANDLER", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Miscellaneous/Foundation_Functions/Reference/reference.html#//apple_ref/c/func/NS_ENDHANDLER");
INSERT INTO xrefs  (xref, class, href) VALUES ("NS_HANDLER", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Miscellaneous/Foundation_Functions/Reference/reference.html#//apple_ref/c/func/NS_HANDLER");
INSERT INTO xrefs  (xref, class, href) VALUES ("PCRE_EXTRA_MATCH_LIMIT", "code", "pcre/pcreapi.html#SEC14");
INSERT INTO xrefs  (xref, class, href) VALUES ("PCRE_EXTRA_MATCH_LIMIT_RECURSION", "code", "pcre/pcreapi.html#SEC14");
INSERT INTO xrefs  (xref, class)       VALUES ("RK_PROBE", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("RKAtomicCompareAndSwapInt", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("RKAtomicCompareAndSwapPtr", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("RKAtomicDecrementInt", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("RKAtomicIncrementInt", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("RKAtomicMemoryBarrier", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("RKCaptureIndexForCaptureNameCharacters", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("RKFrameworkBundle", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("RKIsMainThread", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("RKLocalizedStringForPCRECompileErrorCode", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("RKLock", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("RKLOCK_MAX_SPURIOUS_ERROR_ATTEMPTS", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("RKReadWriteLock", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("RKRegexGarbageCollect", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("RKThreadYield", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("UINT_MAX", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("UTF8", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("UTF16", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("UTF32", "code");
INSERT INTO xrefs  (xref, class, href) VALUES ("Unicode", "section-link", "http://www.unicode.org/");
INSERT INTO xrefs  (xref, class)       VALUES ("alloca", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("allocWithZone:", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("autorelease", "code");
INSERT INTO xrefs  (xref, class, href) VALUES ("dateWithNaturalLanguageString:", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/NSDate_Class/Reference/Reference.html#//apple_ref/occ/clm/NSDate/dateWithNaturalLanguageString:");
INSERT INTO xrefs  (xref, class)       VALUES ("description", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("free", "code");
INSERT INTO xrefs  (xref, class, href) VALUES ("hash", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Protocols/NSObject_Protocol/Reference/NSObject.html#//apple_ref/occ/intfm/NSObject/hash");
INSERT INTO xrefs  (xref, class)       VALUES ("initialize", "code");
INSERT INTO xrefs  (xref, class, href) VALUES ("isEqual:", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Protocols/NSObject_Protocol/Reference/NSObject.html#//apple_ref/occ/intfm/NSObject/isEqual:");
INSERT INTO xrefs  (xref, class)       VALUES ("isKindOfClass:", "code");
INSERT INTO xrefs  (xref, class, href) VALUES ("isMultiThreaded", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/NSThread_Class/Reference/Reference.html#//apple_ref/occ/clm/NSThread/isMultiThreaded");
INSERT INTO xrefs  (xref, class, href) VALUES ("lowercaseString", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/Reference/NSString.html#//apple_ref/occ/instm/NSString/lowercaseString");
INSERT INTO xrefs  (xref, class)       VALUES ("malloc", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("mutableBytes", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("numberWithUnsignedInt:", "code");
INSERT INTO xrefs  (xref, class, href) VALUES ("pcre", "section-link", "pcre/index.html");
INSERT INTO xrefs  (xref, href)        VALUES ("pcre/syntax/subpattern", "pcre/pcrepattern.html#SEC11");
INSERT INTO xrefs  (xref, href)        VALUES ("pcre/syntax/namedSubpattern", "pcre/pcrepattern.html#SEC12");
INSERT INTO xrefs  (xref, class, href) VALUES ("pcre_callout", "code", "pcre/pcrecallout.html#SEC1");
INSERT INTO xrefs  (xref, class, href) VALUES ("pcre_compile", "code", "pcre/pcre_compile.html");
INSERT INTO xrefs  (xref, class, href) VALUES ("pcre_exec", "code", "pcre/pcre_exec.html");
INSERT INTO xrefs  (xref, class, href) VALUES ("pcre_free", "code", "pcre/pcreapi.html#SEC1");
INSERT INTO xrefs  (xref, class, href) VALUES ("pcre_fullinfo", "code", "pcre/pcreapi.html#SEC11");
INSERT INTO xrefs  (xref, class, href) VALUES ("pcre_malloc", "code", "pcre/pcreapi.html#SEC1");
INSERT INTO xrefs  (xref, class)       VALUES ("pcre_stack_free", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("pcre_stack_malloc", "code");
INSERT INTO xrefs  (xref, class, href) VALUES ("pcre_study", "code", "pcre/pcre_study.html");
INSERT INTO xrefs  (xref, class, href) VALUES ("pcre_version", "code", "pcre/pcre_version.html");
INSERT INTO xrefs  (xref, class)       VALUES ("printf", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("pthread", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("pthread_getspecific", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("pthread_setspecific", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("realloc", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("regexUTF8String", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("release", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("retain", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("scanf", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("spin_lock", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("stack_logging_log_stack", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("stringWithFormat:", "code");
INSERT INTO xrefs  (xref, class)       VALUES ("substringWithRange:", "code");
INSERT INTO xrefs  (xref, class, href) VALUES ("uppercaseString", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/Reference/NSString.html#//apple_ref/occ/instm/NSString/uppercaseString");
INSERT INTO xrefs  (xref, class, href) VALUES ("userInfo", "code", "http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/NSException_Class/index.html#//apple_ref/doc/uid/TP40003656");
INSERT INTO xrefs  (xref, class)       VALUES ("va_list", "code");


INSERT INTO html   (file) VALUES ("ChangeLog.html");
INSERT INTO html   (file) VALUES ("Constants.html");
INSERT INTO html   (file) VALUES ("DataTypes.html");
INSERT INTO html   (file) VALUES ("Functions.html");
INSERT INTO html   (file) VALUES ("NSArray.html");
INSERT INTO html   (file) VALUES ("NSData.html");
INSERT INTO html   (file) VALUES ("NSDictionary.html");
INSERT INTO html   (file) VALUES ("NSMutableArray.html");
INSERT INTO html   (file) VALUES ("NSMutableDictionary.html");
INSERT INTO html   (file) VALUES ("NSMutableSet.html");
INSERT INTO html   (file) VALUES ("NSMutableString.html");
INSERT INTO html   (file) VALUES ("NSObject.html");
INSERT INTO html   (file) VALUES ("NSSet.html");
INSERT INTO html   (file) VALUES ("NSString.html");
INSERT INTO html   (file) VALUES ("RKCache.html");
INSERT INTO html   (file) VALUES ("RKEnumerator.html");
INSERT INTO html   (file) VALUES ("RKRegex.html");
INSERT INTO html   (file) VALUES ("RegexKitProgrammingGuide.html");
INSERT INTO html   (file) VALUES ("RegexKitImplementationTopics.html");
INSERT INTO html   (file) VALUES ("ReleaseInformation.html");
INSERT INTO html   (file) VALUES ("ReleaseNotes.html");
INSERT INTO html   (file) VALUES ("index.html");
INSERT INTO html   (file) VALUES ("toc.html");


INSERT INTO static (file) VALUES ("index.html");
INSERT INTO static (file) VALUES ("ChangeLog.html");
INSERT INTO static (file) VALUES ("RegexKitProgrammingGuide.html");
INSERT INTO static (file) VALUES ("RegexKitImplementationTopics.html");
INSERT INTO static (file) VALUES ("ReleaseInformation.html");
INSERT INTO static (file) VALUES ("ReleaseNotes.html");


INSERT INTO dirs   (dir)  VALUES ("CSS");
INSERT INTO dirs   (dir)  VALUES ("JavaScript");
INSERT INTO dirs   (dir)  VALUES ("Images");

COMMIT;
