//
//  YLAlertManager.h
//  YLNote
//
//  Created by tangh on 2021/1/11.
//  Copyright © 2021 tangh. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface YLAlertManager : NSObject

+ (void)showAlertWithTitle:(nullable NSString *)title message:(nullable NSString *)content actionTitle:(nullable NSString *)action handler:(void (^ __nullable)(UIAlertAction *action))handler;

+ (void)showToastWithMessage:(nullable NSString *)content senconds:(NSUInteger)seconds;

@end

NS_ASSUME_NONNULL_END
