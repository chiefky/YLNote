//
//  YLBlockViewController.m
//  YLNote
//
//  Created by tangh on 2020/7/21.
//  Copyright © 2020 tangh. All rights reserved.
//

#import "YLBlockViewController.h"
#import "YLBlockUsageViewController.h"
#import "YLDefaultMacro.h"
static NSInteger static_globalInt = 10;// 静态全局变量
static NSMutableArray *static_globalArray; //静态全局数组

NSInteger globalInt = 10; // 全局变量
NSMutableArray *globalArray; //全局数组

@interface YLBlockViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *table;
@property (nonatomic,copy)NSArray *keywords;

@end

@implementation YLBlockViewController

void swap(int *a, int *b){
    int temp = *a;
    *a = *b;
    *b = temp;
};

- (void)setupUI {
    int a = 2;
    int b = 4;
    swap(&a, &b);

    NSLog(@"%d--%d",a,b);
    
    self.table = [[UITableView alloc] initWithFrame:YLSCREEN_BOUNDS style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
    
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
#pragma mark - block 类型
/// 三种形式的block
/**
 1、不使用外部变量的 block 是全局 block
 2、使用外部变量并且未进行 copy 操作的 block 是栈 block
 3、对栈 block 进行 copy 操作，就是堆 block，而对全局 block 进行 copy，仍是全局 block
 */

/// 全局block
- (void)testBlockType_Global {
    static NSInteger static_local_num = 100;
    
    // __NSGlobalBlock__：不使用外部变量
    NSLog(@"1. 不使用外部变量 %@",[^{
        printf("1-block内部");
    } class]);
    
    // __NSGlobalBlock__：使用静态局部变量
    NSLog(@"2. 使用静态局部变量 %@",[^{
        printf("2-block内部: %ld",static_local_num);
    } class]);
    
    // __NSGlobalBlock__：使用全局变量
    NSLog(@"3. 使用全局变量 %@",[^{
        printf("3-block内部: %ld",globalInt);
    } class]);
    
    // __NSGlobalBlock__：使用全局静态变量
    NSLog(@"4. 使用全局静态变量 %@",[^{
        printf("4-block内部: %ld",static_globalInt);
    } class]);

   
}

/// 堆区block
- (void)testBlockType_Malloc {
    //__NSMallocBlock__: 未使用局部变量，ARC下编译器自动对block进行了copy (引用计数+1)
       void(^block1)(void) = ^{
           NSLog(@"1-block内部");
       };
       NSLog(@"1. 未使用局部变量,ARC下编译器自动对block进行了copy: %@",[block1 class]);


    // 使用全局变量，并对block进行copy(引用计数+1)
    void(^block2)(void) = ^{
        NSLog(@"2-block内部: %ld",globalInt);
        
    };
    NSLog(@"2. 使用全局变量，ARC下编译器自动对block进行了copy: %@",[block2 class]);
    
    //__NSMallocBlock__： 使用局部变量，ARC下编译器自动对block进行了copy
    NSInteger num = 3;
    __block NSInteger blockNum = 8;
    NSMutableArray *arra = [NSMutableArray array];

    void(^block3)(void) = ^{
           NSLog(@"3-block内部 start");
           NSLog(@"num:（%p, %ld)",&num,num);
           NSLog(@"blockNum:（%p, %ld)",&blockNum,blockNum);
           NSLog(@"array:（%p, %@)",&arra,arra);
           NSLog(@"修改blockNum,arry的值");
           blockNum = 333;
           [arra addObjectsFromArray:@[@"11",@"22",@"53"]];
           NSLog(@"3-block内部 end:（num:%p, %ld)(blockNum:%p, %ld）",&num,num,&blockNum,blockNum);
           
       };
    NSLog(@"3. 使用局部变量，ARC下编译器自动对block进行了copy: %@",[block3 class]);
    NSLog(@"3.1 start:（num:%p, %ld),(blockNum:%p, %ld）,array:（%p, %@)",&num,num,&blockNum,blockNum,&arra,arra);
    NSLog(@"3.2 : 修改arry的值");
    arra = [@[@"strig"] mutableCopy];
    NSLog(@"3.3 :（num:%p, %ld),(blockNum:%p, %ld）,array:（%p, %@)",&num,num,&blockNum,blockNum,&arra,arra);

    NSLog(@"3.4 : 修改blockNum,arry的值");
    blockNum = 11;
    [arra addObjectsFromArray:@[@"1",@"2",@"3"]];
    NSLog(@"3.5 :（num:%p, %ld),(blockNum:%p, %ld）,array:（%p, %@)",&num,num,&blockNum,blockNum,&arra,arra);

    
    NSLog(@"3.4 : 执行block");
    block3();
    NSLog(@"3.5 end:（num:%p, %ld),(blockNum:%p, %ld）,array:（%p, %@)",&num,num,&blockNum,blockNum,&arra,arra);
}

/// 栈区block
- (void)testBlockType_Stack {
    NSInteger num = 3;
    NSMutableArray *arra = [NSMutableArray array];

    // __NSStackBlock__：使用局部变量，且未对block进行copy
      NSLog(@"1. 使用局部变量,且未对block进行copy: %@",[^{
          printf("1-block内部 局部（auto）变量: %ld",num);
      } class]);
    
  

    __block NSInteger x = 8;// 将局部变量转换为一个struct
    __weak void (^block3)(void) = ^{
        x = 7; // block 内捕获的是struct的引用
        NSLog(@"2-block内：(num:%p,x:%p,array:%p)",&num,&x,arra);
    };
    NSLog(@"2. 使用局部变量,且对block声明为弱引用 class:%@",[block3 class]);
    NSLog(@"******block执行前*******");
    NSLog(@"2.1: (num:%p,x:%p,array:%p)",&num,&x,arra);

    block3();
    NSLog(@"2.2: (num:%p,x:%p,array:%p)",&num,&x,arra);
    NSLog(@"2.3: x=%@",@(x));
    NSLog(@"2.4: block:%@",block3);
    NSLog(@"2.5: copy:%@",[block3 copy]);
    
    NSLog(@"3. 空block： %@",^{
        
    });
 
}


#pragma mark - block 局部变量，不管是否是静态的都会被block捕获（区别：局部变量被编译成值形式，而静态局部变量被编成指针形式）
// block内部引用局部变量（值捕获,外部变化不影响内部,相当于深vcopy）
- (void)testLocalVarBlock {
    
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"1",@"2", nil];
    void(^block)(void) = ^() {
        NSLog(@"before: %@",arr);
        [arr addObject:@"m"];
        NSLog(@"after: %@",arr);
    };
    [arr addObject:@"3"];
    arr = nil;
    
    block();
    
    NSLog(@"类型：%@",[block class]);
}

// block内部引用局部静态变量（指针捕获，内外互相影响,相当于浅copy）
- (void)testStatic_LocalVarBlock {
    
    static NSInteger num = 3;
    static NSMutableArray *arr;
    NSLog(@"init %ld,[%@]",(long)num,arr);

    void(^block)(void) = ^() {
        NSLog(@"a %ld,%p:[%@]",(long)num,arr,arr);

        num = 7;
        [arr addObject:@"9"];

        NSLog(@"b %ld,%p:[%@]",(long)num,arr,arr);

        arr = [NSMutableArray arrayWithObjects:@"hello",@"world", nil];
        NSLog(@"b %ld,%p:[%@]",(long)num,arr,arr);

    };
    num = 5;
    arr = [NSMutableArray arrayWithObjects:@"1",@"2", nil];
    block();
    
    NSLog(@"d %ld,%p:[%@]",(long)num,arr,arr);

}

#pragma mark -block 全局变量，不管是否是静态的,全局变量都放在静态区已经被初始化了，可以直接从静态区取值
/// block内部引用全局变量
- (void)testGlobalVarBlock {
    globalArray = [NSMutableArray arrayWithObjects:@"global",@"你好", nil];

    void(^block)(void) = ^() {
        NSLog(@"before: %p %@ -- %ld",globalArray,globalArray,globalInt);
        [globalArray addObject:@"9"];
        globalInt = 999;
        NSLog(@"after: %p %@-- %ld",globalArray,globalArray,globalInt);
    };
    globalInt = 888;
    [globalArray addObject:@"3"];
    
    block();
    NSLog(@"类型：%@",[block class]);
}

/// block内部引用静态全局变量
- (void)testStatic_globalVarBlock {
    static_globalArray = [NSMutableArray arrayWithObjects:@"世界",@"你好", nil];
       void(^block)(void) = ^() {
           NSLog(@"before: %p %@ -- %ld",static_globalArray,static_globalArray,static_globalInt);
           [static_globalArray addObject:@"9"];
           static_globalInt = 1111;
           NSLog(@"after: %p %@-- %ld",static_globalArray,static_globalArray,static_globalInt);
       };
       static_globalInt = 666;
       [static_globalArray addObject:@"3"];
       
       block();
       NSLog(@"类型：%@",[block class]);
}




- (void)testBlock__block {
    /**
     一般情况下，如果我们要对 block 截获的局部变量进行赋值操作需添加__block 修饰符，而对全局变量，静态变量是不需要添加 修饰符的。 另外，block 里访问 self 或成员变量都会去截获   。
     */
    /**
     __Block_byref_a_0 成员含义如下：

     __isa: 指向所属类的指针，被初始化为 (void*)0
     __forwarding: 指向对象在堆中的拷贝
     __flags: 标志变量，在实现block的内部操作时会用到
     __size: 对象的内存大小
     a: 原始类型的变量
     */
    __block NSInteger num = 1;//被__block修饰的变量被封装成了一个对象，类型为__Block_byref_a_0，然后把&a作为参数传给了block。
    NSLog(@"block前：(num:%p)",&num);

    // 使用局部变量，并对block进行copy
    void(^block)(void) = ^{
        num += 2;
        NSLog(@"block内：(num:%p)",&num);

    };
    num = 5;
    block();
    NSLog(@"block后：(num:%p)",&num);

    /**
     
     另外，__block 变量在copy 时，由于__forwarding 的存在，栈上的 __forwarding指针会指向堆上的 __forwarding 变量，而堆上的__forwarding 指针指向其自身，所以，如果对__block 的变量修改，实际上是在修改堆上的    __block 变量。
     即__forwarding 指针存在的意义就是，无论在任何内存位置，都可以顺利地访问同一个__block 变量。
     
     另外由于block捕获的 __block修饰的变量会去持有变量，那么如果用__block修饰self，且self持有
     block，并且 block 内部使用到__block修饰的 self 时，就会造成多循环引用，即 self 持有 block，block 持有__block 变量，而__block 变量持有self，造成内存泄漏。
     */
    
}

- (void)testBlock__usage {
    YLBlockUsageViewController *usageVC = [[YLBlockUsageViewController alloc] init];
    usageVC.title = @"block的用法";
    [self.navigationController pushViewController:usageVC animated:YES];
}

#pragma mark - delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell) {
        NSString *titleValue = self.keywords[indexPath.row];
        NSArray *titleValues = [titleValue componentsSeparatedByString:@":"];
        
        NSDictionary *attrMethod = @{ NSForegroundColorAttributeName : [UIColor redColor] ,
                                      NSFontAttributeName: [UIFont systemFontOfSize:12]
        };
        NSDictionary *attrTitle = @{ NSForegroundColorAttributeName : [UIColor blackColor] ,
                                     NSFontAttributeName: [UIFont systemFontOfSize:12]
        };
        NSString * methodTitle = titleValues.firstObject;
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:titleValue];
        [attrStr addAttributes:attrMethod range:NSMakeRange(0, methodTitle.length + 1)];
        [attrStr addAttributes:attrTitle range:NSMakeRange(methodTitle.length + 1, titleValue.length - methodTitle.length - 1)];
        
        cell.textLabel.attributedText = attrStr;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.keywords.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *value = self.keywords[indexPath.row];
    NSArray *selectorTitle = [value componentsSeparatedByString:@":"];
    NSString *selectorStr = selectorTitle.firstObject;
    SEL selector = NSSelectorFromString(selectorStr);
    
    //检查是否有"myMethod"这个名称的方法
    if ([self respondsToSelector:selector]) {
        //           [self performSelector:sel];
        if (!self) { return; }
        IMP imp = [self methodForSelector:selector];
        void (*func)(id, SEL) = (void *)imp;
        func(self, selector);
    }
}


#pragma mark - lazy
- (NSArray *)keywords {
    return @[
        @"testBlockType_Global:全局block",
        @"testBlockType_Malloc:堆区block",
        @"testBlockType_Stack:栈区block",
        @"testLocalVarBlock:引用局部变量[值捕获]",
    @"testStatic_LocalVarBlock:引用(静态)局部变量[指针捕获]",
    @"testGlobalVarBlock:引用全局变量[直接使用]",
    @"testStatic_globalVarBlock:引用(静态)全局变量[直接使用]",
    @"testBlock__block:使用__block修改局部变量值",
    @"testBlock__usage:Block基本用法(传值/作为参数/作为返回值等)"];
}


@end
