//
//  YLNotificationCenter.h
//  YLNote
//
//  Created by tangh on 2020/7/27.
//  Copyright © 2020 tangh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YLNotification;

NS_ASSUME_NONNULL_BEGIN

@interface YLNotificationCenter : NSObject
@property (readonly, nonatomic, strong) NSMutableDictionary *observerMap;

+ (instancetype)defaultCenter;

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(nullable NSString *)aName object:(nullable id)anObject;
- (id <NSObject>)addObserverForName:(nullable NSString *)name object:(nullable id)obj queue:(nullable NSOperationQueue *)queue usingBlock:(void (^)(YLNotification *note))block;

- (void)postNotification:(YLNotification *)notification;
- (void)postNotificationName:(NSString *)aName object:(nullable id)anObject userInfo:(nullable NSDictionary *)aUserInfo;

- (void)removeObserver:(id)observer name:(nullable NSString *)aName object:(nullable id)anObject;

@end

NS_ASSUME_NONNULL_END
