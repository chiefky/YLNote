//
//  YLDemoHashEqualViewController.m
//  YLNote
//
//  Created by tangh on 2021/3/23.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLDemoHashEqualViewController.h"
#import "YLPerson.h"
@interface YLDemoHashEqualViewController ()

@end

@implementation YLDemoHashEqualViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

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
- (void)testIsEqualAndHash {
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
    [dictionaryKey1 setObject:@"YLPerson" forKey:per1];
    NSMutableDictionary *dictionaryKey2 = [NSMutableDictionary dictionary];
    [dictionaryKey2 setObject:@"YLPerson" forKey:per2];
    NSLog(@"🦖 key end ---------");
}

/// 如何重写自己的hash方法?
- (void)testHashFunction {
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
