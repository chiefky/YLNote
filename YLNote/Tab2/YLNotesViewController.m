//
//  YLNotesViewController.m
//  TestDemo
//
//  Created by tangh on 2020/7/11.
//  Copyright © 2020 tangh. All rights reserved.
//
#import "YLNotesViewController.h"
#import <objc/runtime.h>

#import "YLTestAutoReleaseController.h"
#import "YLKVOViewController.h"

#import "YLSon.h"
#import "YLFather.h"
#import "YLFather+Job.h"
#import "YLDefaultMacro.h"

static NSInteger static_globalInt = 10;// 静态全局变量
static NSMutableArray *static_globalArray; //静态全局数组

NSInteger globalInt = 10; // 全局变量
NSMutableArray *globalArray; //全局数组

@interface YLNotesViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)YLFather *father;
@property (nonatomic,strong)YLSon *son;

@property (nonatomic,copy)NSArray *testArray; // 测试copy属性

@property (nonatomic,weak)YLFather *wkFather; // 测试weak属性
@property (nonatomic,unsafe_unretained)YLFather *unFather; // 测试unsafe_unretained属性
@property (nonatomic,strong)YLFather *stFather; // 测试strong属性

@property (nonatomic,strong)UITableView *table;
@property (nonatomic,copy)NSArray *keywords;

@end

@implementation YLNotesViewController



- (void)setupUI {
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
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

#pragma mark - runtime

/// 测试子类(caregory)+load方法
- (void)testSonLoad {
    /**
     test 1: 子类实现load方法，父类不实现load
     打印：
     2020-07-18 15:19:44.620282+0800 TestDemo[52485:5573214] +[YLSon load]
     */
    
    /**
     test 2: 子类实现load方法，父类实现load 。
     结果打印:(先执行父类，后执行子类)
     2020-07-18 15:20:12.454908+0800 TestDemo[52502:5574051] +[YLFather load]
     2020-07-18 15:20:12.455673+0800 TestDemo[52502:5574051] +[YLSon load]
     */
    
    /**
     test 3: 子类不实现load方法，父类实现load
     打印：
     2020-07-18 15:20:54.070897+0800 TestDemo[52526:5575039] +[YLFather load]
     */
    
}

/**
 mathod 查找顺序：(分类的覆盖本类的，子类的覆盖父类的)
 1.查本类的方法列表 （包含 class_addMethod() + categoryMethodList + baseMethodList）
 2.查父类的方法列表
 
 */
/// 子类是否实现Initalize方法
- (void)testSonInitalize {
    /**
     test 1: 子类实现Initalize方法，父类不实现Initalize
     打印：
     2020-07-18 13:14:36.470353+0800 TestDemo[50448:5444966] +[YLSon initialize]
     */
    
    /**
     test 2: 子类实现Initalize方法，父类实现Initalize 。
     结果打印:(先执行父类，后执行子类)
     2020-07-18 13:10:23.949520+0800 TestDemo[50374:5440358] +[YLFather initialize]
     2020-07-18 13:10:23.949682+0800 TestDemo[50374:5440358] +[YLSon initialize]
     */
    
    /**
     test 3: 子类不实现Initalize方法，父类实现Initalize
     打印：(先执行父类，后执行子类（子类没有查到父类的实现）)
     2020-07-18 13:13:41.328426+0800 TestDemo[50424:5443668] +[YLFather initialize]
     2020-07-18 13:13:41.328591+0800 TestDemo[50424:5443668] +[YLFather initialize]
     */
    
    [YLSon new];
}

- (void)testSonOverwrite {
    /**
     test 1: 子类实现hairColor方法，父类不实现hairColor
     打印：
     2020-07-18 16:43:10.566676+0800 TestDemo[53825:5669885] -[YLSon hairColor]: red
     */
    
    /**
     test 2: 子类实现hairColor方法，父类实现hairColor 。
     结果打印:(子类中查到方法，不在查父类)
     2020-07-18 16:44:29.183475+0800 TestDemo[53859:5671411] -[YLSon hairColor]: red
     */
    
    /**
     test 3: 子类不实现hairColor方法，父类实现hairColor
     打印：(子类种找不到方法，去父类找）)
     2020-07-18 16:45:52.614581+0800 TestDemo[53882:5672936] -[YLFather hairColor]: red
     */
    [self.son hairColor];
}
/// 分类initalize方法
- (void)testCategoryInitalize {
    /**
     test 1: 分类YLFather+Job实现Initalize方法，本类不实现Initalize
     打印：
     2020-07-18 14:02:16.611136+0800 TestDemo[51231:5496229] +[YLFather(Job) initialize]
     */
    
    /**
     test 2: 分类实现Initalize方法，本类实现Initalize 。
     结果打印:
     2020-07-18 14:09:52.259161+0800 TestDemo[51337:5503903] +[YLFather(Job) initialize]
     */
    
    /**
     test 3: 分类不实现Initalize方法，本类实现Initalize
     2020-07-18 14:11:23.054112+0800 TestDemo[51387:5506117] +[YLFather initialize]
     打印：
     */
    [YLFather new];
}

/// 测试原类方法被覆盖（查找原理同Initialize，区别：实例方法从本类列表中查找，类方法从元类列表中查找）
- (void)testCategoryOverwrite {
    NSString *gender = [self.father gender];
    NSLog(@"性别：%@",gender);
}

/// 测试分类添加属性，是否会添加d实例变量
- (void)testCategory_associate_ivas {
    
    self.father.job = @"教师";
    //    [self.father setJob:@"中国"];
    unsigned int count = 0;
    /**
     *  通过传入一个类,获取这个类所有的实例变量
     *  第一个参数 : 传入一个类
     *  第二个参数 : 传入一个地址,返回一个 Int 型的值到这个地址
     *  返回一个包含所有实例变量的指针
     */
    Ivar *ivars = class_copyIvarList([self.father class], &count);
    for (unsigned int i = 0; i< count; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"实例变量： %s : %s,%td",ivar_getName(ivar), ivar_getTypeEncoding(ivar),ivar_getOffset(ivar));
    }
    
    NSLog(@"工作: %@",self.father.job);
}

/// 测试分类添加属性，是否会添加proterty
- (void)testCategory_associate_protertys {
    unsigned int count = 0;
    objc_property_t * properties = class_copyPropertyList([self.father class], &count);
    for (unsigned int i = 0; i < count; i ++) {
        objc_property_t property = properties[i];
        //属性名
        const char * name = property_getName(property);
        //属性描述
        const char * propertyAttr = property_getAttributes(property);
        NSLog(@"属性- Attributes：【%s】，名称： %s ", propertyAttr, name);
        
        //属性的特性
        //           unsigned int attrCount = 0;
        //           objc_property_attribute_t * attrs = property_copyAttributeList(property, &attrCount);
        //           for (unsigned int j = 0; j < attrCount; j ++) {
        //               objc_property_attribute_t attr = attrs[j];
        //               const char * name = attr.name;
        //               const char * value = attr.value;
        //               NSLog(@"属性的描述：%s 值：%s", name, value);
        //           }
        //           free(attrs);
        NSLog(@"\n");
    }
    
    NSLog(@"properties地址: %p",properties);
    free(properties); // c代码需要手动管理内存，释放。否则会内存泄漏
}

// 获取所有实例方法
- (void)testCategory_associate_methds {
    unsigned int count = 0;
    Method *methodlist = class_copyMethodList([self.father class], &count);
    for (unsigned i = 0; i < count; i++) {
        Method method = methodlist[i];
        SEL name = method_getName(method);
        const char * type = method_getTypeEncoding(method);
        NSLog(@"方法名：%s 类型： %s ", sel_getName(name),type);
        
    }
    
    free(methodlist);
}

/// 获取所有类方法
- (void)testCategory_associate_class_methds {
    unsigned int count = 0;
    Method *methodlist = class_copyMethodList(object_getClass([self.father class]), &count);
    for (unsigned i = 0; i < count; i++) {
        Method method = methodlist[i];
        SEL name = method_getName(method);
        const char * type = method_getTypeEncoding(method);
        NSLog(@"方法名：%s 类型： %s ", sel_getName(name),type);
        
    }
    
    free(methodlist);
}
#pragma mark - 内存泄漏
/// 内存泄漏（A、B互相持有，无法打破循环引用）
- (void)testMemory {
    {
        YLFather *test0 = [[YLFather alloc] init]; //A对象
        YLFather *test1 = [[YLFather alloc] init];//B对象
        
        //此时B对象的持有者为test1 和 A对象的成员变量obj，B对象被两条强指针指向
        [test0 setPropertyObj1:test1];
        
        //此时A对象的持有者为test0 和 B对象的成员变量obj，A对象被两条强指针指向
        [test1 setPropertyObj1:test0];
    }
    /*
     test0 超出其作用域 ，所以其强引用失效，自动释放对象A;
     test1 超出其作用域 ，所以其强引用失效，自定释放对象B;
     
     此时持有象A的强引用的变量为B对象的成员变量obj；
     此时持有对象B的强引用的变量为A对象的成员变量obj;
     
     因为都还被一条强指针指向，所以内存泄漏！
     */
}


#pragma mark - 关键字
/// 测试copy关键字
- (void)testCopy {
    
    NSArray *t1 = [NSArray arrayWithObjects:@"hello",@"world", nil];
    self.testArray = t1; // testArray设置器里的copy执行的是浅copy (入参是不可变类型)
    
    t1 = @[@"ldldlld"];
    NSLog(@"1: %p--%p",t1,self.testArray);
    
    NSMutableArray *mT1 = [NSMutableArray array];
    self.testArray = mT1; // testArray设置器里的copy执行的是深copy (入参是可变类型)
    NSLog(@"2: %p--%p",mT1,self.testArray);
}

/// weak
- (void)testWeak {
    {
        self.wkFather = [[YLFather alloc] init];
        NSLog(@"局部即将退出: %@",self.wkFather);
    }
    NSLog(@"局部已退出: %@",self.wkFather);
}

- (void)test_unsafe_unretained {
    {
        self.unFather = [[YLFather alloc] init];
        NSLog(@"局部即将退出: %@",self.unFather);
    }
    NSLog(@"局部已退出: %@",self.unFather);
}

- (void)testStrong {
    {
        self.stFather = [[YLFather alloc] init];
        NSLog(@"局部即将退出: %@",self.stFather);
    }
    NSLog(@"局部已退出: %@",self.stFather);
}

/// 测试__weak、__strong、__unsafe_unretained 关键字
- (void)testWeak_strong__unsafe_unretained {
    // 告知编译器忽略未使用变量警告⚠️
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    __strong YLFather *strongZYClass;
    __weak YLFather *weakZYClass;
    __unsafe_unretained YLFather *unsafeZYClass;
#pragma clang diagnostic pop
    
    NSLog(@"test begin");
    
    {
        YLFather *zyClass = [[YLFather alloc] init];
        //        strongZYClass = zyClass;
        weakZYClass = zyClass;
        //        unsafeZYClass = zyClass;
        NSLog(@"局部退出%@--%@",zyClass,weakZYClass);
    }
    
    NSLog(@"test over%@",weakZYClass);
}


- (void)testAutorelease {
    YLTestAutoReleaseController *autoVC = [[YLTestAutoReleaseController alloc] init];
    [self.navigationController pushViewController:autoVC animated:YES];
}

#pragma mark - KVO
- (void)testIsa_swizzing {
    YLKVOViewController *kvoVC = [[YLKVOViewController alloc] init];
    [self.navigationController pushViewController:kvoVC animated:YES];
    
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


/// 三种形式的block
/**
 1、不使用外部变量的 block 是全局 block
 2、使用外部变量并且未进行 copy 操作的 block 是栈 block
 3、对栈 block 进行 copy 操作，就是堆 block，而对全局 block 进行 copy，仍是全局 block
 */
- (void)testBlockType {
    NSInteger num = 1;
    static NSInteger static_local_num = 100;

    // __NSGlobalBlock__：不使用外部变量、使用全局变量、全局静态变量、静态局部变量
    NSLog(@"block1 %@",[^{
        printf("__NSGlobalBlock__: %ld",static_local_num);
    } class]);

    // __NSStackBlock__：使用局部变量，且未对block进行copy
    NSLog(@"block2 %@",[^{
        printf("__NSStackBlock__: %ld",num);
    } class]);
  
    
    //__NSMallocBlock__: 未使用局部变量，且，对block进行了copy (引用计数+1)
    void(^block3)(void) = ^{
        NSLog(@"__NSGlobalBlock__");
    };
    NSLog(@"block4: %@",[block3 class]);

    //__NSMallocBlock__： 使用局部变量，且，对block进行copy
    void(^block4)(void) = ^{
        NSLog(@"__NSMallocBlock__: %ld",num);
        
    };
    NSLog(@"block5: %@",[block4 class]);
  
    // 使用全局变量，并对block进行copy(引用计数+1)
    void(^block5)(void) = ^{
        NSLog(@"__NSGlobalBlock__: %ld",globalInt);
        
    };
    NSLog(@"block6: %@",[block5 class]);
}

- (void)testBlock__block {
    /**
     一般情况下，如果我们要对 block 截获的局部变量进行赋值操作需添加__block 修饰符，而对全局变量，静态变量是不需要添加 修饰符的。 另外，block 里访问 self 或成员变量都会去截获   。
     */
    __block NSInteger num = 1;
    // 使用局部变量，并对block进行copy
    void(^block)(void) = ^{
        num += 2;
        NSLog(@"num: %ld",num);
        
    };
    block();
    
    /**
     
     另外，__block 变量在copy 时，由于__forwarding 的存在，栈上的 __forwarding指针会指向堆上的 __forwarding 变量，而堆上的__forwarding 指针指向其自身，所以，如果对__block 的变量修改，实际上是在修改堆上的    __block 变量。
     即__forwarding 指针存在的意义就是，无论在任何内存位置，都可以顺利地访问同一个__block 变量。
     
     另外由于block捕获的 __block修饰的变量会去持有变量，那么如果用__block修饰self，且self持有
     block，并且 block 内部使用到__block修饰的 self 时，就会造成多循环引用，即 self 持有 block，block 持有__block 变量，而__block 变量持有self，造成内存泄漏。
     */
    
}

#pragma mark - delegate & datadource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.keywords.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *sectionDict = self.keywords[section];
    
    return sectionDict.allKeys.lastObject;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell) {
        NSDictionary *sectionDict = self.keywords[indexPath.section];
        NSArray *sectionArry = sectionDict.allValues.lastObject;
        NSString *titleValue = sectionArry[indexPath.row];
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
    NSDictionary *sectionDict = self.keywords[section];
    NSArray *sectionArry = sectionDict.allValues.lastObject;
    return sectionArry.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *sectionDict = self.keywords[indexPath.section];
    NSArray *sectionArry = sectionDict.allValues.lastObject;
    NSString *value = sectionArry[indexPath.row];
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
        @{
            @"runtime":@[
                    @"testSonInitalize:子类的'+initialize'",
                    @"testCategoryInitalize:分类的'+initialize'",
                    @"testSonOverwrite:子类方法重写",
                    @"testCategoryOverwrite:分类方法重写（原理同Initalize）",
                    @"testCategory_associate_ivas:获取所有实例变量",
                    @"testCategory_associate_protertys:获取所有属性",
                    @"testCategory_associate_methds:获取所有实例方法",
                    @"testCategory_associate_class_methds:获取所有类方法"]},
        @{
            @"keywords":@[
                    @"testCopy:copy关键字",
                    @"testStrong:strong关键字",
                    @"testWeak:weak关键字",
                    @"test_unsafe_unretained:unsafe_unretained关键字",
                    @"testMemory:内存泄漏",
                    @"testAutorelease:Autorelease"]},
        @{
            @"KVO":@[
                    @"testIsa_swizzing:isa指针换"]},
        @{
            @"block":@[@"testLocalVarBlock:引用局部变量[值捕获]",
                       @"testStatic_LocalVarBlock:引用(静态)局部变量[指针捕获]",
                       @"testGlobalVarBlock:引用全局变量[直接使用]",
                       @"testStatic_globalVarBlock:引用(静态)全局变量[直接使用]",
                       @"testBlockType:栈block、堆block、Global block",
                       @"testBlock__block:使用__block修改局部变量值"]},
        @{
                   @"Runloop":@[
                           @"testRunloop_timrt:isa指针换"]},
    ];
}

- (YLFather *)father {
    if (!_father) {
        _father = [[YLFather alloc] init];
    }
    return _father;
}

- (YLSon *)son {
    if (!_son) {
        _son = [YLSon new];
    }
    return _son;
}

@end
