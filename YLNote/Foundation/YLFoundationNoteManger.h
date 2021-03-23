//
//  YLFoundationNoteManger.h
//  YLNote
//
//  Created by tangh on 2021/1/6.
//  Copyright © 2021 tangh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YLNoteGroup;

NS_ASSUME_NONNULL_BEGIN

@interface YLFoundationNoteManger : NSObject

+ (nonnull instancetype)sharedManager;
+ (YLNoteGroup *)dataGroup;
//+ (NSDictionary *)allNotes;

+ (void)testStaticValue;

+ (void)testSafeArray;

+ (void)testAutomicProperty;
+ (void)testNonAutomicProperty;

+ (void)testIsEqualAndHash;
+ (void)testHashFunction;
@end

NS_ASSUME_NONNULL_END
