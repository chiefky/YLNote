//
//  YLNotificationInfoModel.m
//  YLNote
//
//  Created by tangh on 2020/7/27.
//  Copyright © 2020 tangh. All rights reserved.
//

#import "YLNotificationInfoModel.h"

@interface YLNotificationInfoModel ()
@property (nonatomic, copy) NSString *name;
@property (nonatomic,unsafe_unretained) id observer;
@property (nonatomic,unsafe_unretained) id object;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (readwrite, nonatomic, assign) SEL selector;

@end

@implementation YLNotificationInfoModel
- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}

- (instancetype)initWithName:(NSString *)name observer:(id)obs object:(id)obj selector:(SEL)selector queue:(NSOperationQueue *)queue {
    self = [super init];
    if (self) {
        self.name = name;
        self.queue = queue ;
        self.object = obj;
        self.selector = selector;
        self.observer = obs;
    }
    return self;
}

@end
