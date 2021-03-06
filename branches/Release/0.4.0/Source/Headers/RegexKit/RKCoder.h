//
//  RKCoder.h
//  RegexKit
//
// NOT in RegexKit.framework/Headers
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

#import <Foundation/Foundation.h>
#import <RegexKit/RegexKitDefines.h>
#import <RegexKit/RegexKitTypes.h>
#import <RegexKit/RKRegex.h>
#import <RegexKit/RKUtility.h>
#import <RegexKit/RegexKitPrivate.h>

#ifndef _RECODER_H_
#define _RECODER_H_ 1

NSDictionary *RKRegexCoderDifferencesDictionary(id self, const SEL _cmd, NSCoder * const coder, id codedRegexString, const RKCompileOption codedCompileOption) RK_ATTRIBUTES(nonnull(1, 2, 3, 4), used, visibility("hidden"));
id RKRegexInitWithCoder(id self, const SEL _cmd, NSCoder * const coder)     RK_ATTRIBUTES(nonnull(1, 2, 3), used, visibility("hidden"));
void RKRegexEncodeWithCoder(id self, const SEL _cmd, NSCoder * const coder) RK_ATTRIBUTES(nonnull(1, 2, 3), used, visibility("hidden"));

#endif // _RECODER_H_
