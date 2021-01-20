//
//  YLWindowLoader.h
//  YLNote
//
//  Created by tangh on 2021/1/9.
//  Copyright © 2021 tangh. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface YLWindowLoader : NSObject

+ (UIViewController *)getCurrentVC;

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC;

@end

NS_ASSUME_NONNULL_END
