//
//  YLNotification.m
//  YLNote
//
//  Created by tangh on 2020/7/27.
//  Copyright © 2020 tangh. All rights reserved.
//

#import "YLNotification.h"

@interface YLNotification ()
@property (nonatomic,readwrite, copy) NSString *keyName;
@property (nonatomic, readwrite, retain) id object;
@property (nonatomic, readwrite, copy) NSDictionary *userInfo;

@end

@implementation YLNotification

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}

- (instancetype)initWithName:(NSString *)keyName object:(id)object prama:(NSDictionary *)prama {
    self = [super init];
    if (self) {
        self.keyName = keyName;
        self.object = object;
        self.userInfo = prama;
    }
    return self;
}

@end
