//
//  main.m
//  TestDemo
//
//  Created by tangh on 2020/6/28.
//  Copyright © 2020 tangh. All rights reserved.
//

#import "AppDelegate.h"

typedef void (^YLBlock)(void);

int main(int argc, char * argv[]) {

    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
   
        int age =10;
        YLBlock block = ^{
            NSLog(@"age is %@",@(age));
        };
        block();
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
