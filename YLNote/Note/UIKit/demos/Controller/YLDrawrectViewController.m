//
//  YLDrawrectViewController.m
//  YLNote
//
//  Created by tangh on 2021/1/22.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLDrawrectViewController.h"
#import <Masonry/Masonry.h>
#import "YLCircleView.h"
@interface YLDrawrectViewController ()

@property (nonatomic,strong)UIStepper *steper;
@property (nonatomic,strong)YLCircleView *circleView;

@end

@implementation YLDrawrectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self setupUI];
}

#pragma mark - ui
- (void)setupUI {
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
    
//    [self changeColorFromStepper];
}
#pragma mark - actions
- (void)changeColorFromStepper {
    CGFloat valueFloat = self.steper.value;
    NSLog(@"self.steper.value:%@",@(valueFloat));
    UIColor *color = [UIColor colorWithRed:valueFloat/255.0 green:20/255.0 blue:valueFloat/255.0 alpha:1];
    self.circleView.color = color;
    [self.circleView setNeedsDisplay];
}

@end
