//
//  YLPicScanViewController.m
//  YLNote
//
//  Created by tangh on 2021/1/15.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLPicScanViewController.h"
#import <Masonry/Masonry.h>
#import "YLDefaultMacro.h"
#import "YLView.h"
#import "YLSetting.h"

@interface YLPicScanViewController ()

@property (nonatomic,strong) YLPictureView *picView;

@end

@implementation YLPicScanViewController

#pragma mark - 生命周期

- (void)loadView {
    NSLog(@"***** %s",__FUNCTION__);
    [super loadView];
}

- (void)viewDidLoad {
    NSLog(@"***** %s",__FUNCTION__);
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"***** %s",__FUNCTION__);
    [super viewWillAppear:animated];
}


- (void)viewWillLayoutSubviews {
    NSLog(@"***** %s",__FUNCTION__);
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews {
    NSLog(@"***** %s",__FUNCTION__);
    [super viewDidLayoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"***** %s",__FUNCTION__);
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"***** %s",__FUNCTION__);
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"***** %s",__FUNCTION__);
    [super viewDidDisappear:animated];
}
- (void)dealloc {
    NSLog(@"***** %s",__FUNCTION__);
}

- (void)didReceiveMemoryWarning {
    NSLog(@"***** %s",__FUNCTION__);
}

#pragma mark - UI
- (void)setupUI {

    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat topHeight = [YLSetting defaultSettingCenter].statusBarHeight + self.navigationController.navigationBar.frame.size.height;
    CGFloat bottomHeight = self.tabBarController.tabBar.frame.size.height;

    self.picView = [[YLPictureView alloc]initWithFrame:CGRectZero];
    self.picView.backgroundColor = [UIColor redColor];
    self.picView.contentSize = CGSizeMake(300, 300);
    [self.view addSubview:self.picView];
    [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topHeight);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-bottomHeight);
    }];
}
#pragma mark -lazy


@end

