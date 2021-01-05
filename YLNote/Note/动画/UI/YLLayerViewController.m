//
//  YLLayerViewController.m
//  TestDemo
//
//  Created by tangh on 2020/7/7.
//  Copyright © 2020 tangh. All rights reserved.
//

#import "YLLayerViewController.h"
#import "YLDefaultMacro.h"

@interface YLLayerViewController ()
@property (nonatomic, strong) UIView *layerView;
@property (nonatomic, strong) CALayer *colorLayer;
@property (nonatomic, strong) UIButton *actionButton;

@property (nonatomic,strong)CALayer *MamiLayer2;
@end

@implementation YLLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self setupLayers];
//    [self testUIViewLayerAnimation];
}

- (void)setupUI {
    CALayer *MamiLayer = [CALayer layer];
    MamiLayer.backgroundColor = [UIColor redColor].CGColor;
    MamiLayer.bounds = CGRectMake(0, 0, 100, 100);
    MamiLayer.position = CGPointMake(50, 50);
    
    [self.view.layer addSublayer:MamiLayer];
    
   self.MamiLayer2 = [CALayer layer];
    self.MamiLayer2.backgroundColor = [UIColor greenColor].CGColor;
    self.MamiLayer2.bounds = CGRectMake(0, 0, 50, 10);
    self.MamiLayer2.position = CGPointMake(50, 50);
    [self.view.layer addSublayer:MamiLayer];
    
    [self.view.layer addSublayer:self.MamiLayer2];
    NSLog(@"MamiLayer2---%@ -- %@",NSStringFromCGRect(self.MamiLayer2.frame),NSStringFromCGPoint(self.MamiLayer2.position));

    UIButton *testButn = [UIButton buttonWithType:UIButtonTypeSystem];
    testButn.backgroundColor = [UIColor purpleColor];
    testButn.layer.position = CGPointMake(YLSCREEN_WIDTH/2, YLSCREEN_HEIGHT/2);
    testButn.bounds = CGRectMake(0, 0, 100, 100);
    [self.view addSubview:testButn];
    [testButn addTarget:self action:@selector(changeAnchor) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupLayers {
    self.layerView = [UIView new];
    self.layerView.backgroundColor = [UIColor lightGrayColor];
//    self.layerView.bounds = CGRectMake(0, 0, 200, 200);
    self.layerView.frame = CGRectMake(50, 50, 100, 100);

//    self.layerView.layer.position = CGPointMake(YLSCREEN_WIDTH/2, YLSCREEN_HEIGHT/2);
    [self.view addSubview:self.layerView];
    
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(0, 0, 80.0f, 80.0f);
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
//    self.colorLayer.position = CGPointMake(100, 100);
    self.colorLayer.cornerRadius = 3;

    //add a custom action
//    CATransition *transition = [CATransition animation];
//    transition.type = kCATransitionFade;
//    transition.subtype = kCATransitionFromLeft;
//    self.colorLayer.actions = @{@"backgroundColor": transition};
    
    [self.layerView.layer addSublayer:self.colorLayer];
    
    self.actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.actionButton.backgroundColor = [UIColor whiteColor];
    self.actionButton.frame = CGRectMake(100, 200, 100, 30);
//    self.actionButton.layer.position = CGPointMake(100,175);
//    self.actionButton.bounds = CGRectMake(0, 0, 100, 30);
    [self.actionButton setTitle:@"change color" forState:UIControlStateNormal];
    [self.view addSubview:self.actionButton];
    [self.actionButton addTarget:self action:@selector(changeColor) forControlEvents:UIControlEventTouchUpInside];

}

- (void)testUIViewLayerAnimation {
    //test layer action when outside of animation block
       NSLog(@"Outside: %@", [self.layerView actionForLayer:self.layerView.layer forKey:@"backgroundColor"]);
       //begin animation block
       [UIView beginAnimations:nil context:nil];
       //test layer action when inside of animation block
       NSLog(@"Inside: %@", [self.layerView actionForLayer:self.layerView.layer forKey:@"backgroundColor"]);
       //end animation block
       [UIView commitAnimations];
}

- (void)changeColor
{
    //randomize the layer background color
//    CGFloat red = arc4random() / (CGFloat)INT_MAX;
//    CGFloat green = arc4random() / (CGFloat)INT_MAX;
//    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
//    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    
//    //begin a new transaction
//       [CATransaction begin];
//       //set the animation duration to 1 second
//       [CATransaction setAnimationDuration:5.0];
//       //randomize the layer background color
//       CGFloat red = arc4random() / (CGFloat)INT_MAX;
//       CGFloat green = arc4random() / (CGFloat)INT_MAX;
//       CGFloat blue = arc4random() / (CGFloat)INT_MAX;
//       self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
//    [CATransaction commit];
    
    
//    [CATransaction begin];
//    //set the animation duration to 1 second
//    [CATransaction setAnimationDuration:1.0];
//    //randomize the layer background color
//    CGFloat red = arc4random() / (CGFloat)INT_MAX;
//    CGFloat green = arc4random() / (CGFloat)INT_MAX;
//    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
//    self.layerView.layer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
//    //commit the transaction
//    [CATransaction commit];
    
//    self.colorLayer.cornerRadius = 3;
//    self.layerView.frame = CGRectMake(0, 0, 100, 100);

    [UIView animateWithDuration:10 animations:^{
        self.colorLayer.cornerRadius = 20;
        self.layerView.frame = CGRectMake(100, 100, 100, 100);
    }];
    
    CGFloat duration = 10;

    [CATransaction begin];
    [CATransaction setAnimationDuration:duration];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut] ];
    self.colorLayer.cornerRadius = 20;
    [CATransaction commit];

    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationCurveEaseInOut animations:^{
        self.layerView.frame = CGRectMake(100, 100, 100, 100);
    } completion:^(BOOL finished) { }];
    
//    CGAffineTransform
    
}

#pragma mark - 修改锚点
- (void)changeAnchor {
    [CATransaction begin];
    //设置事务有没有动画
    [CATransaction setDisableActions:NO];
    //设置事务动画的执行时长.
    [CATransaction setAnimationDuration:2];
    
    self.MamiLayer2.anchorPoint = CGPointMake(1, 0);
    
    [CATransaction commit];
    NSLog(@"MamiLayer2---%@ -- %@",NSStringFromCGRect(self.MamiLayer2.frame),NSStringFromCGPoint(self.MamiLayer2.position));

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
