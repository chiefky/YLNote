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
#import "YLSwiftViewController.h"
#import "YLFlutterViewController.h"
#import "YLUserViewController.h"

#import "YLNote-Swift.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

//    NSLog(@"%s",__func__);
    self.window = [[UIWindow alloc] initWithFrame: YLSCREEN_BOUNDS];
    
    YLNotesViewController *noteVC = [[YLNotesViewController alloc] init];
    noteVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"笔记" image:[UIImage imageNamed:@"note"] tag:3];
    noteVC.title = @"笔记";
    UINavigationController *naviNote = [[UINavigationController alloc] initWithRootViewController:noteVC];
    
    YLGCDViewController *gcdVC = [[YLGCDViewController alloc] init];
    gcdVC.title = @"多线程";
    gcdVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"多线程" image:[UIImage imageNamed:@"GCD"] tag:3];

    UINavigationController *naviGCD = [[UINavigationController alloc] initWithRootViewController:gcdVC];
    
    YLAlgorithmViewController *swiftVC = [[YLAlgorithmViewController alloc] init];
    swiftVC.title = @"Swift";
    swiftVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Swift" image:[UIImage imageNamed:@"swift"] tag:3];
    UINavigationController *naviSwift = [[UINavigationController alloc] initWithRootViewController:swiftVC];

    YLFlutterViewController *flutterVC = [[YLFlutterViewController alloc] init];
     flutterVC.title = @"Flutter";
    flutterVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Flutter" image:[UIImage imageNamed:@"flutter"] tag:3];
    UINavigationController *naviFlutter = [[UINavigationController alloc] initWithRootViewController:flutterVC];

    YLUserViewController *userVC = [[YLUserViewController alloc] init];
     userVC.title = @"User";
    userVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"User" image:[UIImage imageNamed:@"user"] tag:5];
    UINavigationController *naviUser = [[UINavigationController alloc] initWithRootViewController:userVC];

     UITabBarController *tab = [[UITabBarController alloc] init];
     tab.viewControllers = @[naviNote,naviGCD,naviSwift,naviFlutter,naviUser];
    self.window.rootViewController = tab;
     [self.window makeKeyAndVisible];
     
    [self appearanceSetting];
    return YES;
}

- (void)appearanceSetting {
    [UITabBar appearance].barTintColor = [UIColor whiteColor];
    [UITabBar appearance].tintColor = [UIColor orangeColor];
    [UINavigationBar appearance].barTintColor = [UIColor orangeColor];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]};

}

@end
