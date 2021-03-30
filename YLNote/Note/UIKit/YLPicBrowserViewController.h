//
//  YLPicBrowserViewController.h
//  YLNote
//
//  Created by tangh on 2021/1/18.
//  Copyright © 2021 tangh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/PHAsset.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLPicBrowserViewController : UIViewController
@property (nonatomic, strong) NSMutableArray <PHAsset *> *imageAssets;
@property (nonatomic, assign) NSInteger selectedIndex;
 
 
/// 删除图片闭包
@property (nonatomic, copy) void (^deletePhotoHandler)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
