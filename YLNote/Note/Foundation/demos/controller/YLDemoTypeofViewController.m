//
//  YLDemoTypeofViewController.m
//  YLNote
//
//  Created by tangh on 2021/3/23.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLDemoTypeofViewController.h"
#import "YLLStudent.h"

@interface YLDemoTypeofViewController ()

@end

@implementation YLDemoTypeofViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - typeof 和 __typeof，typeof 的区别?
/**
 __typeof__() 和 __typeof() 是 C语言 的编译器特定扩展，因为标准 C 不包含这样的运算符。 标准 C 要求编译器用双下划线前缀语言扩展（这也是为什么你不应该为自己的函数，变量等做这些）

 typeof() 与前两者完全相同的，只不过去掉了下划线，同时现代的编译器也可以理解。

 所以这三个意思是相同的，但没有一个是标准C，不同的编译器会按需选择符合标准的写法。

 #
 */
- (void)testTypeOf {
    YLLStudent *st = [[YLLStudent alloc] init];
    st.studentId = @"1000209";
    st.name = @"张⑨";
    CGFloat teamCoefficient = 0.98;
    
// 1   __weak __typeof(self) weakSelf = self;
// 2   __weak typeof (self) weakSelf = self;
 
    __weak __typeof__(self) weakSelf = self;
    st.bomusBlock = ^NSString * _Nullable(NSUInteger attendanceDays, double performance, double salary) {
        CGFloat result = (attendanceDays / 30 * 0.3 + performance * 0.7) * teamCoefficient * salary;
        [weakSelf hello];
        
        return [NSString stringWithFormat:@"%f",result];
    };
     NSLog(@"%@ 的奖金为：%@",st.name,st.bonus);
    
}

- (void)hello {
    NSLog(@"say hello");
}

@end
