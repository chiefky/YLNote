//
//  YLNSOperationTest.h
//  Demo20200420
//
//  Created by tangh on 2020/6/24.
//  Copyright © 2020 tangh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLNSOperationTest : NSObject

- (void)testOperation_invocation;
- (void)testOperation_block;
- (void)testOperation_yuki;

- (void)testOperationQueue;
- (void)testOperationQueue_block;

- (void)testOperationQueue_dependence;

- (void)testOperation_safe;


@end

NS_ASSUME_NONNULL_END
