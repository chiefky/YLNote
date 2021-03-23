//
//  YLDinodsaul.m
//  YLNote
//
//  Created by tangh on 2021/1/11.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLDinodsaul.h"

@implementation YLDinodsaul

- (id)copyWithZone:(NSZone *)zone {
    YLDinodsaul *dino = [[YLDinodsaul alloc] init];
    dino.name = self.name;
    dino.organismId = self.organismId;
    dino.levSpecices = self.levSpecices;
    return dino;
}

- (BOOL)isEqual:(id)object {
    if (self == object) { // 判断是否是同一个对象
        return YES;
    }
    if (![object isKindOfClass:[YLDinodsaul class]]) { // 判断是否是同一类型, 这样不仅可以提高判等的效率, 还可以避免隐式类型转换带来的潜在风险
        return NO;
    }
    
    return [self isEqualToDinosaur:object];
}

- (BOOL)isEqualToDinosaur:(YLDinodsaul *)dinosaur {
    if (!dinosaur) {
        return NO;
    }
    
    BOOL equalName = (!self.name && !dinosaur.name) || [self.name isEqualToString:dinosaur.name];
    BOOL equalOrganismId = (!self.organismId && !dinosaur.organismId) || [self.organismId isEqualToString:dinosaur.organismId];
    
    return equalName && equalOrganismId ;
}

- (NSUInteger)hash {
    NSUInteger hash = [super hash];
    NSLog(@"hash = %ld", hash);
    return hash;
}

/**
 A.[self class] 和 [super class] 输出是一样的
 B.self和super底层实现原理

     1.当使用 self 调用方法时，会从当前类的方法列表中开始找，如果没有，就从父类中再找；
     而当使用 super 时，则从父类的方法列表中开始找，然后调用父类的这个方法
     2.当使用 self 调用时，会使用 objc_msgSend 函数：
         id objc_msgSend(id theReceiver, SEL theSelector, ...)
         第一个参数是消息接收者，第二个参数是调用的具体类方法的 selector，后面是 selector 方法的可变参数。以 [self setName:] 为例，编译器会替换成调用 objc_msgSend 的函数调用，其中 theReceiver 是 self，theSelector 是 @selector(setName:)，这个 selector 是从当前 self 的 class 的方法列表开始找的 setName，当找到后把对应的 selector 传递过去。

     3.当使用 super 调用时，会使用 objc_msgSendSuper 函数：

         id objc_msgSendSuper(struct objc_super *super, SEL op, ...)
         第一个参数是个objc_super的结构体，第二个参数还是类似上面的类方法的selector

         struct objc_super {
             id receiver;
             Class superClass;
         };
 */
- (void)testClass {
    NSLog(@"%@ - %@",[self class],[super class]);
}

@end
