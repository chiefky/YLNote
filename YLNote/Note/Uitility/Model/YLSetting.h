//
//  YLSetting.h
//  YLNote
//
//  Created by tangh on 2021/1/15.
//  Copyright © 2021 tangh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLSetting : NSObject

@property (nonatomic,assign,readonly) double autoSizeScaleX; // x轴放大系数
@property (nonatomic,assign,readonly) double autoSizeScaleY; // y轴放大系数
@property (nonatomic,assign,readonly) double statusBarHeight; // 顶部statusBar高度
@property (nonatomic,assign,readonly) double homeBarHeight; // 底部homeBar高度


+ (instancetype)defaultSettingCenter;

@end

NS_ASSUME_NONNULL_END
