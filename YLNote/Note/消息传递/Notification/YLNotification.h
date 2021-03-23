//
//  YLNotification.h
//  YLNote
//
//  Created by tangh on 2020/7/27.
//  Copyright © 2020 tangh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLNotification : NSObject

@property (readonly, copy) NSString *keyName;
@property (nullable, readonly, retain) id object;
@property (nullable, readonly, copy) NSDictionary *userInfo;

- (instancetype)initWithName:(NSString *)keyName object:(id)object prama:(nullable NSDictionary *)prama;

@end

NS_ASSUME_NONNULL_END
