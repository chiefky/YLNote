//
//  YLView.m
//  YLNote
//
//  Created by tangh on 2021/1/13.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLView.h"
#import <Masonry/Masonry.h>

/// 自动布局过程
/**
 updating constraints->layout->display
 
 第一步：updating constraints，被称为测量阶段，其从下向上(from subview to super view), 为下一步layout准备信息。可以通过调用方法setNeedUpdateConstraints去触发此步。constraints的改变也会自动的触发此步。
 但是，当你自定义view的时候，如果一些改变可能会影响到布局的时候，通常需要自己去通知Auto layout，updateConstraintsIfNeeded。

 自定义view的话，通常可以重写updateConstraints方法，在其中可以添加view需要的局部的contraints。

 第二步：layout，其从上向下(from super view to subview)，此步主要应用上一步的信息去设置view的center和bounds。
 可以通过调用setNeedsLayout去触发此步骤，此方法不会立即应用layout。
 如果想要系统立即的更新layout，可以调用layoutIfNeeded。另外，自定义view可以重写方法layoutSubViews来在layout的工程中得到更多的定制化效果。

 第三步：display，此步时把view渲染到屏幕上，它与你是否使用Auto layout无关，其操作是从上向下(from super view to subview)，通过调用setNeedsDisplay触发，
 因为每一步都依赖前一步，因此一个display可能会触发layout，当有任何layout没有被处理的时候，同理，layout可能会触发updating constraints，当constraint system更新改变的时候。
 需要注意的是，这三步不是单向的，constraint-based layout是一个迭代的过程，layout过程中，可能去改变constraints，有一次触发updating constraints，进行一轮layout过程。
 注意：如果你每一次调用自定义layoutSubviews都会导致另一个布局传递，那么你将会陷入一个无限循环中。
 如下图：
 updateContraints ↔️ layout → display

 */
@implementation YLView

#pragma mark - ***********

- (void)layoutSubviews {
    NSLog(@"%s: [%ld]",__func__,self.tag);
    [super layoutSubviews];
}

- (void)drawRect:(CGRect)rect {
    NSLog(@"%s: [%ld]",__func__,self.tag);
    [super drawRect:rect];
}


@end

@implementation YLScrollView

- (void)layoutSubviews {
    NSLog(@"%s: [%ld]",__func__,self.tag);
    [super layoutSubviews];
}

@end
@interface YLPictureView ()
@end
@implementation YLPictureView

+ (instancetype)showPictureScrollView:(CGRect)frame ParentView:(UIView *)parentview {
    YLPictureView *ylScroll = [[YLPictureView alloc] initWithFrame:frame];
    ylScroll.backgroundColor = [UIColor grayColor];
    return ylScroll;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.contentSize = _contentSize;
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"主标题";
        _titleLabel.textColor = [UIColor cyanColor];
//        _titleLabel.backgroundColor = [UIColor yellowColor];
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self addSubview:_titleLabel];
        
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.numberOfLines = 0;
        _subtitleLabel.text = @"副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题";
//        _subtitleLabel.backgroundColor = [UIColor blueColor];
        _subtitleLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_subtitleLabel];
       
    }
    return self;
}

- (void)layoutSubviews {
    NSLog(@"%s: [%ld]",__func__,self.tag);
    [super layoutSubviews];

    NSLog(@"frames: %@\n%@\n%@",NSStringFromCGRect(self.scrollView.frame),NSStringFromCGRect(self.titleLabel.frame),NSStringFromCGRect(self.subtitleLabel.frame));
    
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.subtitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_subtitleLabel.mas_top).offset(-3);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    NSLog(@"frames: %@\n%@\n%@",NSStringFromCGRect(self.scrollView.frame),NSStringFromCGRect(self.titleLabel.frame),NSStringFromCGRect(self.subtitleLabel.frame));

}

@end
