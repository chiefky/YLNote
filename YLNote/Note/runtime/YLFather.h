//
//  YLFather.h
//  TestDemo
//
//  Created by tangh on 2020/7/11.
//  Copyright © 2020 tangh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLFather : NSObject{
    NSInteger ivar1;
}

@property (nonatomic, assign) NSInteger propertyInt1;

@property (nonatomic,strong) id propertyObj1;

- (NSString *)gender;// 性别

- (void)hairColor; // 发色
- (void)eat;

@end

NS_ASSUME_NONNULL_END
