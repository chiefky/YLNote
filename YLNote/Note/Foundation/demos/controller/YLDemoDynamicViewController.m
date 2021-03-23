//
//  YLDemoDynamicViewController.m
//  YLNote
//
//  Created by tangh on 2021/3/23.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLDemoDynamicViewController.h"
#import "YLLStudent.h"

@interface YLDemoDynamicViewController ()

@end

@implementation YLDemoDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self testSynthesizeAndDyamic];
}

/**
 property = ivar + setter、getter;
 @property有两个对应的词，一个是 @synthesize，一个是 @dynamic。如果 @synthesize和 @dynamic都没写，那么默认的就是@syntheszie var = _var;

 @synthesize 的语义是如果你没有手动实现 setter 方法和 getter 方法，那么编译器会自动为你加上这两个方法。

 @dynamic 告诉编译器：属性的 setter 与 getter 方法由用户自己实现，不自动生成。（当然对于 readonly 的属性只需提供 getter 即可）。假如一个属性被声明为 @dynamic var，然后你没有提供 @setter方法和 @getter 方法，编译的时候没问题，但是当程序运行到 instance.var = someVar，由于缺 setter 方法会导致程序崩溃；或者当运行到 someVar = var 时，由于缺 getter 方法同样会导致崩溃。编译时没问题，运行时才执行相应的方法，这就是所谓的动态绑定;
 
 补充：{
 1. 既不使用@dynamic也不使用@synthesize的情况下手动重写setter、getter方法会报错[Use of undeclared identifier '_color'],原因是如果全部自己重写编译器不在自动合成实例变量,解决方法可以手动添加一个实例变量。
 如果只重写一个setter或getter方法或者都不重写，ok，编译器仍然会自动添加下划线实例变量和缺少的方法。
 2. 使用@synthesize 如果没有修改实例变量名称，默认是添加同名实例变量(不带下划线)。如果修改实例变量名称,编译器会以修改后名称添加实例变量。
 3. 使用@dynamic,编译器既不会自动添加setter、getter也不会自动添加实例变量,必须自己手动添加实例变量，实例变量名随意;
 }
 */
// @synthesize和@dynamic分别有什么作用？
- (void)testSynthesizeAndDyamic {
    YLLStudent *st = [[YLLStudent alloc] init];
    // synthesize 属性(修改内部实例变量)
    st.studentId = @"北京大学";
    NSLog(@"studentId 1%@",st.studentId);
    
    [st setStudentId:@"shanghai"];
    NSLog(@"studentId 2--%@",[st studentId]);
  
    // dynamic 属性
    NSLog(@"studentTel --%@",st.studentTel); // crash: -[YLLStudent studentTel]: unrecognized
}


@end
