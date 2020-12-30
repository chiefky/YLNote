//
//  YLNotificationInfoModel.h
//  YLNote
//
//  Created by tangh on 2020/7/27.
//  Copyright © 2020 tangh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLNotificationInfoModel : NSObject
@property (readonly, nonatomic, copy) NSString *name;
@property (readonly, nonatomic, weak) id observer;
@property (readonly, nonatomic, weak) id object;
@property (readonly, nonatomic, strong) NSOperationQueue *queue;
@property (readonly, nonatomic, assign) SEL selector;


- (instancetype)initWithName:(NSString *)name observer:(id)obs object:(nullable id)obj selector:(SEL)selector queue:(nullable NSOperationQueue *)queue;

@end

NS_ASSUME_NONNULL_END
