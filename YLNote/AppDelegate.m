//
//  AppDelegate.m
//  TestDemo
//
//  Created by tangh on 2020/6/28.
//  Copyright © 2020 tangh. All rights reserved.
//

#import "AppDelegate.h"
#import <JSPatch/JPEngine.h>
#import "YLDefaultMacro.h"
#import "YLNotesViewController.h"
#import "YLGCDViewController.h"
#import "YLOCSwiftViewController.h"
#import "YLFlutterViewController.h"
#import "YLUserViewController.h"

#import "YLNote-Swift.h"


/**
 * 设置图片
 */
NSString *kTabBarItemKeyImageName             = @"kTabBarItemKeyImageName";
/**
 * 设置选中图片
 */
NSString *kTabBarItemKeySelectedImageName     = @"kTabBarItemKeySelectedImageName";
/**
 * 设置文字颜色
 */
NSString *kTabBarItemKeyColorName             = @"kTabBarItemKeyColorName";
/**
 * 设置选中文字颜色
 */
NSString *kTabBarItemKeySelectedColorName     = @"kTabBarItemKeySelectedColorName";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[YLSkinMananger defaultManager] checkAndUpdateSkinSettingWithCompleteBlock:^(NSDictionary * _Nonnull dict) {
        NSLog(@"******+++= %@",dict);
    }];

    [self appearanceSetting];

//    NSLog(@"%s",__func__);
    self.window = [[UIWindow alloc] initWithFrame: YLSCREEN_BOUNDS];
    
    YLNotesViewController *noteVC = [[YLNotesViewController alloc] init];
    noteVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"笔记" image:[UIImage imageNamed:@"note"] tag:1];
    noteVC.title = @"笔记";
    [noteVC.tabBarItem addSkinObserver];
    noteVC.tabBarItem.skinMap = @{
                                       kTabBarItemKeyColorName:[UIColor redColor],
                                       kTabBarItemKeySelectedColorName: @"EF5931" };
    UINavigationController *naviNote = [[UINavigationController alloc] initWithRootViewController:noteVC];
    naviNote.navigationBar.translucent = NO;
    
//    YLGCDViewController *gcdVC = [[YLGCDViewController alloc] init];
//    gcdVC.title = @"多线程";
//    gcdVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"多线程" image:[UIImage imageNamed:@"GCD"] tag:3];
//
//    UINavigationController *naviGCD = [[UINavigationController alloc] initWithRootViewController:gcdVC];
    YLAlgorithmViewController *algoriVC = [[YLAlgorithmViewController alloc] init];
    algoriVC.title = @"算法";
    algoriVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"算法" image:[UIImage imageNamed:@"GCD"] tag:2];
    UINavigationController *naviAlgori = [[UINavigationController alloc] initWithRootViewController:algoriVC];

    
    YLSwiftViewController *swiftVC = [[YLSwiftViewController alloc] init];
    swiftVC.title = @"Swift";
    swiftVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Swift" image:[UIImage imageNamed:@"swift"] tag:3];
    UINavigationController *naviSwift = [[UINavigationController alloc] initWithRootViewController:swiftVC];

    YLFlutterViewController *flutterVC = [[YLFlutterViewController alloc] init];
     flutterVC.title = @"Flutter";
    flutterVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Flutter" image:[UIImage imageNamed:@"flutter"] tag:4];
    UINavigationController *naviFlutter = [[UINavigationController alloc] initWithRootViewController:flutterVC];

//    YLUserViewController *userVC = [[YLUserViewController alloc] init];
//     userVC.title = @"User";
//    userVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"User" image:[UIImage imageNamed:@"user"] tag:5];
    
    YLMemoryViewController *memVC = [[YLMemoryViewController alloc] init];
    
    memVC.title = @"性能";
    memVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"性能" image:[UIImage imageNamed:@"user"] tag:5];

    UINavigationController *naviUser = [[UINavigationController alloc] initWithRootViewController:memVC];

     UITabBarController *tab = [[UITabBarController alloc] init];
    tab.tabBar.translucent = NO;
     tab.viewControllers = @[naviNote,naviAlgori,naviSwift,naviFlutter,naviUser];
    self.window.rootViewController = tab;
     [self.window makeKeyAndVisible];
     
    return YES;
}

/// <#Description#>
- (void)appearanceSetting {
//    [UITabBar appearance].barTintColor = [YLTheme main].tabTintColor;
//    [UITabBar appearance].tintColor = [YLTheme main].themeColor;
    [UINavigationBar appearance].barTintColor = [YLTheme main].themeColor ;
    [UINavigationBar appearance].tintColor = [YLTheme main].naviTintColor;
    [UINavigationBar appearance].titleTextAttributes = @{NSFontAttributeName:[YLTheme main].mainFont,NSForegroundColorAttributeName:[YLTheme main].backColor};
    // 抹去navigationbar 返回按钮title (推荐)
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-200, 0) forBarMetrics:UIBarMetricsDefault];

}

- (void)checkOrWritePlist:(void(^)(NSDictionary *))completeBlock {
    NSString * path = [[NSBundle mainBundle] pathForResource:@"Skin" ofType:@"plist"];
    NSMutableDictionary * mutDic = [NSMutableDictionary dictionary];

    if (path == nil) {
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] ;
        NSString *infoFilePath = [cachesPath stringByAppendingPathComponent:@"Skin.plist"];
        
        [mutDic setValue:@{@"color":@"DC143C"} forKey:@"red"];
        [mutDic setValue:@{@"color":@"FF00F0"} forKey:@"blue"];
        [mutDic setValue:@{@"color":@"fd9c2e"} forKey:@"yellow"];
        [mutDic setValue:@"blue" forKey:@"selectColor"];
        [mutDic setValue:@"yellow" forKey:@"tintColor"];

        [mutDic writeToFile:infoFilePath atomically:YES];
    }
    if (completeBlock) {
        completeBlock([mutDic copy]);
    }
}

@end
