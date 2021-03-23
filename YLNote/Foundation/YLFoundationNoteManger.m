//
//  YLFoundationNoteManger.m
//  YLNote
//
//  Created by tangh on 2021/1/6.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLFoundationNoteManger.h"
#import <YYModel/YYModel.h>
#import "YLArticalViewController.h"
#import "YLFileManager.h"
#import "YLWindowLoader.h"
#import "YLAlertManager.h"
#import "YLSafeMutableArray.h"
#import "YLPerson.h"
#import "YLLStudent.h"
#import "YLDinodsaul.h"
#import "YLNote-Swift.h"
#import "YLNoteData.h"

@interface YLFoundationNoteManger ()

@property (nonatomic,strong) NSMutableArray *array;

@end

@implementation YLFoundationNoteManger

+ (nonnull instancetype)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

+ (NSDictionary *)allNotes {
    return @{
        @"group":@"Foundation",
        @"questions":
            @[
                @{
                    @"description":@"iOS定义静态变量、静态常量、全局变量",
                    @"answer":@"testStaticValue",
                    @"class": NSStringFromClass(self),
                    @"type": @(0),
                },
                @{
                    @"description":@"nil、NIL、NSNULL区别",
                    @"answer":@"testNilAndNSNull",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                @{
                    @"description":@"实现一个线程安全的 NSMutableArray",
                    @"answer":@"testSafeArray",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                @{
                    @"description": @"atomic仅仅是对set线程安全并不保证对其数据的操作也安全",
                    @"answer":@"testAutomicProperty",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                @{
                    @"description":@"对nonatomic属性操作实现线程安全使用举例",
                    @"answer":@"testNonAutomicProperty",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                @{
                    @"description":@"isEqual 和 hash 有什么联系",
                    @"answer":@"testIsEqualAndHash",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                @{
                    @"description":@"如何重写自己的hash方法",
                    @"answer":@"testHashFunction",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },

                @{
                    @"description":@"id 和 instanceType 有什么区别",
                    @"answer":@"testIdAndInstancetype",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                @{
                    @"description":@"self和super的区别",
                    @"answer":@"testSelfAndSuper",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                @{
                    @"description":@"@synthesize和@dynamic分别有什么作用",
                    @"answer":@"testSynthesizeAndDyamic",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                @{
                    @"description":@"typeof() 和 __typeof__()，__typeof()区别",
                    @"answer":@"testTypeOf",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                @{
                    @"description":@"值类型(struct)和引用类型(class)",
                    @"answer":@"testStructAndClass",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                }
                
                
            ]
    };
}

+ (YLNoteGroup *)dataGroup {
    YLNoteGroup *group = [YLNoteGroup yy_modelWithDictionary:[self allNotes]];
    return group;
}

#pragma mark - nil、NILL、NSNULL区别
+ (void)testNilAndNSNull {
    NSString *msg = @"nil、NIL 可以说是等价的，都代表内存中一块空地址。\n NSNULL 代表一个指向 nil 的对象。";
    [YLAlertManager showAlertWithTitle:@"nil、NILL、NSNULL" message:msg actionTitle:@"OK" handler:nil];
}

#pragma mark - iOS定义静态变量、静态常量、全局变量
+ (void)testStaticValue {
    NSString *htmlUrl = @"https://www.jianshu.com/p/aec2e85b9e84";
    [self loadArticalPage:htmlUrl];
}

#pragma mark- 展示文章
+ (void)loadArticalPage:(NSString *)urlStr {
    UIViewController *currentVC = [YLWindowLoader getCurrentVC];
    YLArticalViewController *articalVC = [[YLArticalViewController alloc] init];
    articalVC.htmlUrl = urlStr;
    if (currentVC.navigationController) {
        NSLog(@"阅读文章");
        [currentVC.navigationController pushViewController:articalVC animated:YES];
    } else {
        NSLog(@"阅读文章-1");

        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:currentVC];
        [navi pushViewController:articalVC animated:YES];
    
    }

}

#pragma mark - id & instancetype
/**
 相同点:
instancetype 和 id 都是万能指针，指向对象。
不同点：
1.id 在编译的时候不能判断对象的真实类型，instancetype 在编译的时候可以判断对象的真实类型。
2.id 可以用来定义变量，可以作为返回值类型，可以作为形参类型；instancetype 只能作为返回值类型。
 */
+ (void)testIdAndInstancetype {
    NSString *msg = @" 相同点:instancetype 和 id 都是万能指针，指向对象。\n不同点： 1.id 在编译的时候不能判断对象的真实类型，instancetype 在编译的时候可以判断对象的真实类型。\n    2.id 可以用来定义变量，可以作为返回值类型，可以作为形参类型；instancetype 只能作为返回值类型";
    [YLAlertManager showAlertWithTitle:@"id & instancetype" message:msg actionTitle:@"OK" handler:nil];
}

#pragma mark - NSMutableArray Safe实现
#pragma mark - atomic & nonatomic

#pragma mark - hash & isEqual

#pragma mark - self & super
/// self和super的区别
+ (void)testSelfAndSuper_classFunc {
    NSDictionary *plumDict = [YLFileManager jsonParseWithLocalFileName:@"TRex"];
    YLDinodsaul *TRex = [YLDinodsaul yy_modelWithDictionary:plumDict];
    [TRex testClass];
}

#pragma mark - @synthesize和@dynamic

@end
