//
//  YLFoundationNoteManger.m
//  YLNote
//
//  Created by tangh on 2021/1/6.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLFoundationNoteManger.h"
#import "YLArticalViewController.h"
#import "YLWindowLoader.h"
#import "YLAlertManager.h"
#import "YLSafeMutableArray.h"
#import "YLDinosaur.h"
#import "YLPerson.h"

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
                    @"answer":@"",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                @{
                    @"description":@"@synthesize和@dynamic分别有什么作用",
                    @"answer":@"",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                @{
                    @"description":@"typeof 和 __typeof，typeof区别",
                    @"answer":@"",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                @{
                    @"description":@"struct和class的区别,值类型和引用类型",
                    @"answer":@"",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                }
                
                
            ]
    };
}
#pragma mark - nil、NILL、NSNULL区别
+ (void)testNilAndNSNull {
    NSString *msg = @"nil、NIL 可以说是等价的，都代表内存中一块空地址。\n NSNULL 代表一个指向 nil 的对象。";
    [YLAlertManager showAlertWithTitle:nil message:msg actionTitle:@"OK" handler:nil];
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
    [YLAlertManager showAlertWithTitle:nil message:msg actionTitle:@"OK" handler:nil];
}

#pragma mark - NSMutableArray Safe实现
/// 实现一个线程安全的数组
/**
 NSMutableArray是线程不安全的，当有多个线程同时对数组进行操作的时候可能导致崩溃或数据错误
 
 线程锁：使用线程锁对数组读写时进行加锁
 
 派发队列：在《Effective Objective-C 2.0..》书中第41条：多用派发队列，少用同步锁中指出：使用“串行同步队列”（serial synchronization queue），将读取操作及写入操作都安排在同一个队列里，即可保证数据同步。而通过并发队列，结合GCD的栅栏块（barrier）来不仅实现数据同步线程安全，还比串行同步队列方式更高效。
 */
+ (void)testSafeArray {
    YLSafeMutableArray *safeArr = [[YLSafeMutableArray alloc] init];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (NSUInteger i = 0; i < 5; i++) {
        dispatch_async(queue, ^{
            NSLog(@"添加第%ld个",i);
            [safeArr addObject:[NSString stringWithFormat:@"我是%ld",i]];
        });
        dispatch_async(queue, ^{
            NSLog(@"删除第%ld个",i);
            [safeArr removeObjectAtIndex:i];
        });
    }
}

#pragma mark - atomic & nonatomic
/// atomic 修饰的属性是绝对安全的吗
/**
 不是，所谓的安全只是局限于 Setter、Getter 的访问器方法而言的，你对它做 Release 的操作是不会受影响的。这个时候就容易崩溃了。
 
 看一下打印结果：
 2021-01-08 17:00:13.908449+0800 YLNote[25990:15006808] 🌹<NSThread: 0x600000889a80>{number = 7, name = (null)} ageAuto : 1432
 2021-01-08 17:00:13.908452+0800 YLNote[25990:15005841] 🍑<NSThread: 0x600000844140>{number = 6, name = (null)} ageAuto : 1164
 最终的结果和我们预期的完全是不一样的，这是为什么呢？
 
 错误的分析是：因为ageAuto是atomic修饰的，所以是线程安全的，在+1的时候，只会有一个线程去操作，所以最终的打印结果必定有一个是2000。
 
 正确的分析是：其实atomic是原子的是没问题的，这个只是表示set方法是原子的，效果是类似于下面的效果
 //atomic表示的是对set方法加锁,表示在设置值的时候，只会有一个线程执行set方法
 - (void)setAgeAuto:(NSInteger)ageAuto{
 [self.lock lock];
 _ageAuto = ageAuto;
 [self.lock unlock];
 }
 */
+ (void)testAutomicProperty {
    YLPerson *person = [[YLPerson alloc] init];
    //开启一个线程对intA的值+1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0;i < 1000;i ++){
            person.ageAuto = person.ageAuto + 1;
        }
        NSLog(@"🍑%@ ageAuto : %ld",[NSThread currentThread],(long)person.ageAuto);
    });
    
    //开启一个线程对intA的值+1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0;i < 1000;i ++){
            person.ageAuto = person.ageAuto + 1;
        }
        NSLog(@"🌹%@ ageAuto : %ld",[NSThread currentThread],(long)person.ageAuto);
    });
    
}

+ (void)testNonAutomicProperty {
    YLPerson *person = [[YLPerson alloc] init];
    
    NSLock *lock = [[NSLock alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0;i < 1000;i ++){
            [lock lock];
            person.ageNonAuto = person.ageNonAuto + 1;
            [lock unlock];
        }
        NSLog(@"🍑%@ ageNonAuto : %ld",[NSThread currentThread],(long)person.ageNonAuto);
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0;i < 1000;i ++){
            [lock lock];
            person.ageNonAuto = person.ageNonAuto + 1;
            [lock unlock];
        }
        NSLog(@"🌹%@ ageNonAuto : %ld",[NSThread currentThread],(long)person.ageNonAuto);
    });
}

#pragma mark - hash & isEqual

static NSString * const kKey1 = @"kYLPerson1";
static NSString * const kKey2 = @"kYLPerson2";

/// hash方法与判等的关系?
//hash方法主要是用于在Hash Table查询成员用的, 那么和我们要讨论的isEqual()有什么关系呢?
//为了优化判等的效率, 基于hash的NSSet和NSDictionary在判断成员是否相等时, 会这样做
//Step 1: 集成成员的hash值是否和目标hash值相等, 如果相同进入Step 2, 如果不等, 直接判断不相等
//Step 2: hash值相同(即Step 1)的情况下, 再进行对象判等, 作为判等的结果
//简单地说就是
//hash值是对象判等的必要非充分条件
/**
 从打印结果可以看到:
 "hash方法只在对象被添加至NSSet和设置为NSDictionary的key时会调用"
 NSSet添加新成员时, 需要根据hash值来快速查找成员, 以保证集合中是否已经存在该成员
 NSDictionary在查找key时, 也利用了key的hash值来提高查找的效率
 */
+ (void)testIsEqualAndHash {
    //    YLDinosaur *dino1 = [YLDinosaur dinosaurWithName:@"霸王龙" superorder:@"蜥臀目" suborder:@"兽脚亚目" subsuborder:@"坚尾龙类"];
    //    YLDinosaur *dino2 = [YLDinosaur dinosaurWithName:@"霸王龙" superorder:@"蜥臀目" suborder:@"兽脚亚目" subsuborder:@"坚尾龙类"];
    NSDate *currDate = [NSDate date];
    YLPerson *per1 = [YLPerson personWithName:kKey1 birthday:currDate];
    YLPerson *per2 = [YLPerson personWithName:kKey2 birthday:currDate];
    
    NSLog(@"✨ ------- isEqual start ------");
    NSLog(@"per1 == per2 : %@",per1 == per2 ? @"YES":@"NO"); // “==”判断哈希值相等
    NSLog(@"[per1 isEqual:per2] : %@",[per1 isEqual:per2] ? @"YES":@"NO"); //”isEqual“ 判断两个对象的属性值是否相等
    NSLog(@"✨ ------- isEqual end -------");
    
    NSLog(@"🐱 ------- array start -------");
    NSMutableArray *array1 = [NSMutableArray array];
    [array1 addObject:per1];
    NSMutableArray *array2 = [NSMutableArray array];
    [array2 addObject:per2];
    NSLog(@"🐱 ------- array end ----------");
    
    NSLog(@"🐒 ------- set start --------");
    NSMutableSet *set1 = [NSMutableSet set];
    [set1 addObject:per1];
    NSMutableSet *set2 = [NSMutableSet set];
    [set2 addObject:per2];
    NSLog(@"🐒 ------- set end -------");
    
    NSLog(@"🐹 ------- dictionary value start -------");
    NSMutableDictionary *dictionaryValue1 = [NSMutableDictionary dictionary];
    [dictionaryValue1 setObject:per1 forKey:kKey1];
    NSMutableDictionary *dictionaryValue2 = [NSMutableDictionary dictionary];
    [dictionaryValue2 setObject:per2 forKey:kKey2];
    NSLog(@"🐹 ------- dictionary value end ----------");
    
    NSLog(@"🦖 ------- dictionary key start ---------");
    NSMutableDictionary *dictionaryKey1 = [NSMutableDictionary dictionary];
    [dictionaryKey1 setObject:@"YLDinosaur" forKey:per1];
    NSMutableDictionary *dictionaryKey2 = [NSMutableDictionary dictionary];
    [dictionaryKey2 setObject:@"YLDinosaur" forKey:per2];
    NSLog(@"🦖 key end ---------");
}

/// 如何重写自己的hash方法?
+ (void)testHashFunction {
    NSDate *currDate = [NSDate date];
    YLPerson *person1 = [YLPerson personWithName:kKey1 birthday:currDate];
    YLPerson *person2 = [YLPerson personWithName:kKey1 birthday:currDate];
    
    NSLog(@"[person1 isEqual:person2] = %@", [person1 isEqual:person2] ? @"YES" : @"NO");

    NSMutableSet *set = [NSMutableSet set];
    [set addObject:person1];
    [set addObject:person2];
#warning 文章中说是2
    NSLog(@"set count = %ld", set.count); // 2 ???
    


}

@end
