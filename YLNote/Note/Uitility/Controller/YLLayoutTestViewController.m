//
//  YLLayoutTesstViewController.m
//  YLNote
//
//  Created by tangh on 2021/1/14.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLLayoutTestViewController.h"
#import "YLPicScanViewController.h"
#import "YLPicBrowserViewController.h"

#import "YLDefaultMacro.h"
#import "YLView.h"


@interface YLLayoutTestViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) YLView *aView;
@property (nonatomic,strong) YLView *bView;
@property (nonatomic,strong) YLView *cView;
@property (nonatomic,strong) YLView *tmpView;

@property (nonatomic,strong) YLScrollView *scrollView;

@end

@implementation YLLayoutTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
}

/** 验证触发layoutSubViews的条件 【前提：aView，bView，cView均没有添加至父视图】
 1.验证init不会触发
 (结论：子视图若不添加至父视图不会触发子视图的layoutSubViews)
 2.验证initWithfFrame会触发
 (结论：子视图若不添加至父视图不会触发子视图的layoutSubViews)
 【
     1. initWithfFrame:Zero
         a.初始化一个CGRectZero的view，不添加至父View: ❌
         b.初始化一个CGRectZero的view，添到至父View上；
             父View类型：1.self.view ✅、 2.self.aView ❌、 3.self.bView ❌、 4.self.cView ❌
     2. initWithfFrame:非Zero
         a.初始化一个非CGRectZero的view，不添加至父View: ❌
         b.初始化一个非CGRectZero的view，添到至父View上；
             父View类型：1.self.view ✅、 2.self.aView ❌、 3.self.bView ❌、 4.self.cView ❌
 】
 3.验证addSubviews会触发
 （结论：并不是addSubviews一定触发，当父视图没有添加至self.view图层树里时不会触发；另外initWithFrame为非Zero时会触发父视图的layoutSubViews，等同于frame修改）
 4.验证UIScrollView滚动会触发 ✅
 5.验证旋转Screen会触发父View的方法 :未验证
 6.验证修改frame会触发父View的方法 ✅
 （结论：修改tmpView的frame既会触发cView又会触发tmpView的layoutSubviews方法）
 7.验证调用layoutSubviews会触发 ✅
 8.验证调用setNeedsLayout会触发 ✅
 9.验证调用layoutIfNeeded ❌
 （结论：layoutIfNeeded不会触发layoutSubviews）
 
 */

/** 周知：self.view.tag->1000 aView.tag->100 bView.tag->200 cView.tag->300 tmpView->888
 2021-01-14 18:26:19.037996+0800 YLNote[75722:19129130] 是否触发 loadSubviews 情况:
 2021-01-14 18:26:19.038141+0800 YLNote[75722:19129130] init 不add ：❌
 2021-01-14 18:26:19.038386+0800 YLNote[75722:19129130] initWithFrame zero 不add：❌
 2021-01-14 18:26:19.038560+0800 YLNote[75722:19129130] initWithFrame 非zero 不add：❌

****** 以下三组试验 不管frame是否为0 只要addSubview（父：self.view）就会触发自身的layoutSubviews方法 *********
 2021-01-14 18:57:53.358564+0800 YLNote[77096:19200183] init  父view tag[1000]：
 2021-01-14 18:57:53.371870+0800 YLNote[77096:19200183] -[YLView layoutSubviews] 响应view tag[100]

 2021-01-14 18:38:48.026930+0800 YLNote[76382:19158716] initWithFrame zero 父view tag[1000]：
 2021-01-14 18:38:48.039797+0800 YLNote[76382:19158716] -[YLView layoutSubviews] 响应view tag[888]
 
 2021-01-14 18:53:34.627200+0800 YLNote[76921:19190486] initWithFrame 非zero 父view tag[1000]：
 2021-01-14 18:53:34.637470+0800 YLNote[76921:19190486] -[YLView layoutSubviews] 响应view tag[888]
 ***************** ************************************************ ***************
 */
- (void)setupUI {
    self.view.tag = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *changeBounds = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeBounds setTitle:@"修改代码进行调试" forState:UIControlStateNormal];
       [changeBounds addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
       changeBounds.backgroundColor = [UIColor orangeColor];
       [self.view addSubview:changeBounds];
       changeBounds.frame = CGRectMake(40, 480, YLSCREEN_WIDTH - 80, 40);

    UIButton *showUsage = [UIButton buttonWithType:UIButtonTypeCustom];
    [showUsage setTitle:@"layoutSubviews用法" forState:UIControlStateNormal];
    [showUsage addTarget:self action:@selector(showAction) forControlEvents:UIControlEventTouchUpInside];
    showUsage.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:showUsage];
    showUsage.frame = CGRectMake(40, 540, YLSCREEN_WIDTH - 80, 40);

    [self test_addSubview_c];
}

#pragma mark - action
- (void)changeAction {
    [self testLayoutIfNeeded];
}

- (void)showAction {
    [self testUsageForLayoutSubViews];
}

#pragma mark - init & initWithfFrame
///1. init 不add - 不触发
- (void)test_not_addSubview_a {
    YLView *view = [[YLView alloc] init];
    view.tag = 1000;
    NSLog(@"%s: [%ld] init 不add：❌",__func__,view.tag);
}
/// 2.1.a initWithfFrame:CGRectZero 不add
- (void)test_not_addSubview_b {
    YLView *view = [[YLView alloc] initWithFrame:CGRectZero];
    view.tag = 2000;
    NSLog(@"%s: [%ld] initWithFrame zero 不add：❌",__func__,view.tag);
}

/// 2.2.a initWithfFrame:非zero 不add
- (void)test_not_addSubview_c {
    YLView *view = [[YLView alloc] initWithFrame:CGRectMake(20, 120, 300, 300)];
    view.tag = 3000;
    NSLog(@"%s: [%ld] initWithFrame 非zero 不add：❌",__func__,view.tag);
}

#pragma mark - 验证addSubviews会触发
///1. init add - 触发自身
- (void)test_addSubview_a {
    NSLog(@"%s: init [%ld] addTo [%ld]：",__func__,self.aView.tag,self.view.tag);
    [self.view addSubview:self.aView];
}

/// 2.1.b
- (void)test_addSubview_b {
    NSLog(@"%s: zero [%ld] addTo [%ld]",__func__,self.bView.tag,self.view.tag);
    [self.view addSubview:self.bView];
}

/// 2.2.b
- (void)test_addSubview_c {
    NSLog(@"%s: [%ld] addTo [%ld]",__func__,self.cView.tag,self.view.tag);
    [self.view addSubview:self.cView];
}

- (void)test_c_addSubview_tmp {
    //mark: setupUI中提前调用 [self test_addSubview_c];
    NSLog(@"%s: [%ld] addTo [%ld]",__func__,self.tmpView.tag,self.cView.tag);
    [self.cView addSubview:self.tmpView];
}

#pragma mark - 验证UIScrollView滚动会触发
- (void)testScrollView {
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(YLSCREEN_WIDTH, YLSCREEN_HEIGHT/2);
    [self.view addSubview:self.scrollView];
}
#pragma mark - 验证旋转Screen会触发父View的方法
- (void)testOrientation {
    NSLog(@"当前屏幕方向，%ld",(long)[UIDevice currentDevice].orientation);
}
#pragma mark - 验证修改frame会触发父View的方法
- (void)testFrame {
    NSLog(@"%s: [%ld] pre：%@",__func__,self.tmpView.tag,NSStringFromCGRect(self.tmpView.frame));
    self.tmpView.frame = CGRectMake(0, 0, 80, 80);
    NSLog(@"%s: [%ld] after：%@",__func__,self.tmpView.tag,NSStringFromCGRect(self.tmpView.frame));
}
#pragma mark - 验证调用layoutSubviews会触发
- (void)testLayoutSubviews {
    NSLog(@"%s: [%ld] ",__func__,self.cView.tag);
    [self.cView layoutSubviews];
}
#pragma mark - 验证调用setNeedsLayout会触发
- (void)testNeedsLayout {
    NSLog(@"%s: [%ld] ",__func__,self.cView.tag);
    [self.cView setNeedsLayout];
}

#pragma mark - 验证调用layoutIfNeeded会触发
- (void)testLayoutIfNeeded {
    NSLog(@"%s: [%ld] ",__func__,self.cView.tag);
    [self.cView layoutIfNeeded];
}

#pragma mark - layoutSubviews用法
- (void)testUsageForLayoutSubViews {
    YLPicBrowserViewController *picVC = [[YLPicBrowserViewController alloc] init];
    [self.navigationController pushViewController:picVC animated:YES];

//    YLPicScanViewController *picVC = [[YLPicScanViewController alloc] init];
//    [self.navigationController pushViewController:picVC animated:YES];
}

#pragma mark - delegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%s",__func__);
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    NSLog(@"%s",__func__);
//}

#pragma mark - lazy
- (YLView *)aView {
    if (!_aView) {
        _aView = [[YLView alloc] init];
        _aView.backgroundColor = [UIColor redColor];
        _aView.tag = 100;
    }
    return _aView;
}

- (YLView *)bView {
    if (!_bView) {
        _bView = [[YLView alloc] initWithFrame:CGRectZero];
        _bView.backgroundColor = [UIColor yellowColor];
        _bView.tag = 200;
    }
    return _bView;
}

- (YLView *)cView {
    if (!_cView) {
        _cView = [[YLView alloc] initWithFrame:CGRectMake(20, 120, YLSCREEN_WIDTH - 40, YLSCREEN_WIDTH - 40)];
        _cView.backgroundColor = [UIColor blueColor];
        _cView.tag = 300;
    }
    return _cView;
}
- (YLView *)tmpView {
    if (!_tmpView) {
        _tmpView = [[YLView alloc] initWithFrame:CGRectMake(20, 20, 50, 50)];
        _tmpView.backgroundColor = [UIColor systemPinkColor];
        _tmpView.tag = 999;
    }
    return _tmpView;
}

- (YLScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[YLScrollView alloc] initWithFrame:CGRectMake(0, 0, YLSCREEN_WIDTH, YLSCREEN_HEIGHT/2)];
        _scrollView.backgroundColor = [UIColor lightGrayColor];
        _scrollView.tag = 400;
    }
    return _scrollView;
}

@end
