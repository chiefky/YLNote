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
/** VC 声明周期
 alloc：创建对象，分配空间
 init (xib和非xib用initWithNibName、stroyBoard用initWithCoder) ：初始化对象，初始化数据
 awakeFromNib：(若控制器有关联xib才调用这方法）
 loadView：优先从nib载入控制器视图 ，其次代码
 viewDidLoad：载入完成，可以进行自定义数据以及动态创建其他控件。
 viewWillAppear：视图将出现在屏幕之前，马上这个视图就会被展现在屏幕上了
 viewWillLayoutSubviews：控制器的view将要布局子控件
 viewDidLayoutSubviews：控制器的view布局子控件完成
 //这期间系统可能会多次调用viewWillLayoutSubviews 、    viewDidLayoutSubviews 俩个方法
 viewDidAppear：视图已在屏幕上渲染完成
 viewWillDisappear：视图将被从屏幕上移除之前执行
 viewDidDisappear：视图已经被从屏幕上移除，用户看不到这个视图了
 dealloc：视图被销毁，此处需要对你在init和viewDidLoad中创建的对象进行释放
 didReceiveMemoryWarning:收到内存警告

 2021-01-18 15:16:49.344595+0800 YLNote[99325:22291021] -[YLPicScanViewController loadView]
 2021-01-18 15:16:49.344833+0800 YLNote[99325:22291021] -[YLPicScanViewController viewDidLoad]
 2021-01-18 15:16:49.346821+0800 YLNote[99325:22291021] -[YLPicScanViewController viewWillAppear:]
 2021-01-18 15:16:49.353522+0800 YLNote[99325:22291021] -[YLPicScanViewController viewWillLayoutSubviews]
 2021-01-18 15:16:49.353735+0800 YLNote[99325:22291021] -[YLPicScanViewController viewDidLayoutSubviews]
 2021-01-18 15:16:49.355414+0800 YLNote[99325:22291021] -[YLPicScanViewController viewWillLayoutSubviews]
 2021-01-18 15:16:49.355552+0800 YLNote[99325:22291021] -[YLPicScanViewController viewDidLayoutSubviews]
 2021-01-18 15:16:49.859532+0800 YLNote[99325:22291021] -[YLPicScanViewController viewDidAppear:]
 2021-01-18 15:16:54.735599+0800 YLNote[99325:22291021] -[YLPicScanViewController viewWillDisappear:]
 2021-01-18 15:16:55.243278+0800 YLNote[99325:22291021] -[YLPicScanViewController viewDidDisappear:]
 2021-01-18 15:16:55.243440+0800 YLNote[99325:22291021] -[YLPicScanViewController dealloc]

 */
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

