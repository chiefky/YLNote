//
//  YLSetting.m
//  YLNote
//
//  Created by tangh on 2021/1/15.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLSetting.h"
#import "YLDefaultMacro.h"

/**完整的 statusbar 高度的表:
 iPhone11: 48
 iPhone12、12 pro、12 pro max: 47
 iPhone12 mini: 50
 iPad Pro、iPad Air: 24
 Other iPhones: 44.
 非刘海屏： 20
 */
@import UIKit;

@implementation YLSetting

+ (instancetype)defaultSettingCenter {
    static dispatch_once_t onceToken;
    static YLSetting *instance;
    dispatch_once(&onceToken, ^{
        instance = [[YLSetting alloc] init];
    });
    return instance;
}

- (double)autoSizeScaleX {
    if(YLSCREEN_HEIGHT > 480){
        return YLSCREEN_WIDTH / 320;
    }
    return 1;
}

- (double)autoSizeScaleY {
    if(YLSCREEN_HEIGHT > 480){
        return YLSCREEN_HEIGHT / 568;
    }
    return 1;
}

- (double)statusBarHeight {
    if (@available(iOS 11, *)) {
        CGFloat top = [UIApplication sharedApplication].delegate.window.safeAreaInsets.top;
        return top > 0 ? top: 20;
    }
    return 20;
}

- (double)homeBarHeight {
    if (@available(iOS 11, *)) {
           CGFloat bottom = [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom;
           return bottom;
       }
    
       return 0;
}

@end
