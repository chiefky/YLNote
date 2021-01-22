//
//  YLView.h
//  YLNote
//
//  Created by tangh on 2021/1/13.
//  Copyright © 2021 tangh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLView : UIView

@end


@interface YLScrollView : UIScrollView

@end

@interface YLPictureView : YLView
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,assign) CGSize contentSize;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subtitleLabel;

+ (instancetype)showPictureScrollView:(CGRect)frame ParentView:(UIView *)parentview;
@end


NS_ASSUME_NONNULL_END
