//
//  YLDemoDrawrectViewController.m
//  YLNote
//
//  Created by tangh on 2021/1/22.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLDemoDrawrectViewController.h"
#import "YLSetting.h"
#import <Masonry/Masonry.h>
#import "YLCircleView.h"
@interface YLDemoDrawrectViewController ()

@property (nonatomic,strong)UIStepper *steper;
@property (nonatomic,strong)YLCircleView *circleView;
@property (nonatomic,strong)YLTouchView *touchView;

@end

@implementation YLDemoDrawrectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self setupUI];
}

#pragma mark - ui
- (void)setupUI {
    CGFloat topValue = self.navigationController.navigationBar.bounds.size.height + [YLSetting defaultSettingCenter].statusBarHeight;
    self.steper = [[UIStepper alloc]init];
    self.steper.value = 80;
    self.steper.stepValue = 20;
    [self.view addSubview:self.steper];
    [self.steper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(89);
        make.height.mas_equalTo(40);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"change color" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(changeColorFromStepper) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.steper.mas_bottom).offset(20);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(40);
    }];
    
    self.circleView = [[YLCircleView alloc] init];
    [self.view addSubview:self.circleView];
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(button.mas_bottom).offset(20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];
    
    [self.view addSubview:self.touchView];
    self.touchView.backgroundColor = [UIColor blueColor];
    [self.touchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topValue+20);
        make.width.height.mas_equalTo(300);
        make.centerX.mas_equalTo(0);
    }];
    
}

#pragma mark - actions
- (void)changeColorFromStepper {
    CGFloat valueFloat = self.steper.value;
    NSLog(@"self.steper.value:%@",@(valueFloat));
    UIColor *color = [UIColor colorWithRed:valueFloat/255.0 green:125/255.0 blue:255/255.0 alpha:1];
    self.circleView.color = color;
}

#pragma mark -
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s",__FUNCTION__);
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s",__FUNCTION__);
}
#pragma mark -lazy
- (YLTouchView *)touchView {
    if (!_touchView) {
        _touchView = [[YLTouchView alloc] init];
    }
    return _touchView;
}

@end
