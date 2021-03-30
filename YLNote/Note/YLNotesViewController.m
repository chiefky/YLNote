//
//  YLNotesViewController.m
//  TestDemo
//
//  Created by tangh on 2020/7/11.
//  Copyright © 2020 tangh. All rights reserved.
//
#import "YLNotesViewController.h"
#import "YLNote-Swift.h"
#import <YYModel/YYModel.h>
#import <objc/runtime.h>

#import "YLFoundationNoteManger.h"
#import "YLWebNoteManager.h"
#import "YLRuntimeNoteManager.h"
#import "YLRunLoopNoteManager.h"
#import "YLAutoReleaseNoteManager.h"
#import "YLKVONoteManager.h"
#import "YLGCDNoteManager.h"
#import "YLThirdLibNoteManager.h"
#import "YLAnimationNoteManager.h"
#import "YLMessageNoteManager.h"

#import "YLTestAutoReleaseController.h"
#import "YLKVOViewController.h"
#import "YLBlockViewController.h"
#import "YLNotifiTestViewController.h"
#import "YLTestViewController.h"

#import "YLSon.h"
#import "YLFather.h"
#import "YLFather+Job.h"
#import "YLDefaultMacro.h"
#import "YLNoteData.h"
#import "NSObject+Test.h"



@interface YLNotesViewController ()<YLQuestionDataProtocol>
@property (nonatomic,strong)YLFather *father;
@property (nonatomic,strong)YLSon *son1;
@property (nonatomic,strong)YLSon *son2;

@property (nonatomic,copy)NSArray *testArray; // 测试copy属性

@property (nonatomic,weak)YLFather *wkFather; // 测试weak属性
@property (nonatomic,unsafe_unretained)YLFather *unFather; // 测试unsafe_unretained属性
@property (nonatomic,strong)YLFather *stFather; // 测试strong属性

@property (nonatomic,strong)UITableView *table;

@property (nonatomic,strong) YLQuestionDataManager *dataManager;
@property (nonatomic,copy) NSArray<YLNoteSectionData *> *sectionDatas;

@end

@implementation YLNotesViewController

- (void)setupUI {
    self.table = [[UITableView alloc] initWithFrame:YLSCREEN_BOUNDS style:UITableViewStyleGrouped];
    [self.view addSubview:self.table];
    [self.table registerClass:[YLGroupHeaderView class] forHeaderFooterViewReuseIdentifier:[self headerIdentifier]];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"YLQuestionTableViewCell" ofType:@"nib"];
    if (path) {
        [self.table registerNib:[UINib nibWithNibName:@"YLQuestionTableViewCell" bundle:nil] forCellReuseIdentifier:[self cellIdentifier]];
    } else {
        [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:[self cellIdentifier]];
    }
    self.dataManager.dataSource = self;
    self.sectionDatas = self.dataManager.allDatas;
    self.table.delegate = self.dataManager;
    self.table.dataSource = self.dataManager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
#pragma mark - 点击分组信息
- (void)clickGroupAction:(UIButton *)sender {
    YLNoteSectionData *sectionData = self.sectionDatas[sender.tag - 1000];
    BOOL groupStatus = sectionData.unfoldStatus;
    if(!groupStatus){
        sectionData.unfoldStatus = YES;
    } else {
        sectionData.unfoldStatus = NO;
    }
    //刷新当前的分组
    NSIndexSet * set=[[NSIndexSet alloc] initWithIndex:sender.tag - 1000];
    [self.table reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
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
    [self.son1 hairColor];
    [self.son2 hairColor];
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

- (void)testClassMethod {
    [YLFather performSelector:@selector(testTest)];
}

- (void)testMsg_resolve {
    [self.son1 eat];
}

- (void)testMsg_forwarding {
    [self.son1 eat];
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if (self = [self init]) {
        //(1)获取类的属性及属性对应的类型
        NSMutableArray * keys = [NSMutableArray array];
        NSMutableArray * attributes = [NSMutableArray array];
        /*
         * 例子
         * name = value3 attribute = T@"NSString",C,N,V_value3
         * name = value4 attribute = T^i,N,V_value4
         */
        unsigned int outCount;
        objc_property_t * properties = class_copyPropertyList([self class], &outCount);
        for (int i = 0; i < outCount; i ++) {
            objc_property_t property = properties[i];
            //通过property_getName函数获得属性的名字
            NSString * propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            [keys addObject:propertyName];
            //通过property_getAttributes函数可以获得属性的名字和@encode编码
            NSString * propertyAttribute = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
            [attributes addObject:propertyAttribute];
        }
        //立即释放properties指向的内存
        free(properties);
        
        //(2)根据类型给属性赋值
        for (NSString * key in keys) {
            if ([dict valueForKey:key] == nil) continue;
            [self setValue:[dict valueForKey:key] forKey:key];
        }
    }
    return self;
    
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

#pragma mark - YLNotifiTestViewController

- (void)testNotification {
    YLNotifiTestViewController *vc = [[YLNotifiTestViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)testNotification_block {
    YLTestViewController *vc = [[YLTestViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - Foundation
// nil、NILL、NSNULL区别
- (void)test_nilAndNSNull {
    NSString *msg = @"nil、NIL 可以说是等价的，都代表内存中一块空地址。\n NSNULL 代表一个指向 nil 的对象。";
    [YLAlertManager showAlertWithTitle:@"nil、NILL、NSNULL" message:msg actionTitle:@"OK" handler:nil];
}

/**
 相同点:
instancetype 和 id 都是万能指针，指向对象。
不同点：
1.id 在编译的时候不能判断对象的真实类型，instancetype 在编译的时候可以判断对象的真实类型。
2.id 可以用来定义变量，可以作为返回值类型，可以作为形参类型；instancetype 只能作为返回值类型。
 */
- (void)test_idAndInstancetype {
    NSString *msg = @" 相同点:instancetype 和 id 都是万能指针，指向对象。\n不同点： 1.id 在编译的时候不能判断对象的真实类型，instancetype 在编译的时候可以判断对象的真实类型。\n    2.id 可以用来定义变量，可以作为返回值类型，可以作为形参类型；instancetype 只能作为返回值类型";
    [YLAlertManager showAlertWithTitle:@"id & instancetype" message:msg actionTitle:@"OK" handler:nil];
}

/// self和super的区别
- (void)test_selfAndSuper {
    NSDictionary *plumDict = [YLFileManager jsonParseWithLocalFileName:@"TRex"];
    YLDinodsaul *TRex = [YLDinodsaul yy_modelWithDictionary:plumDict];
    [TRex testClass];
}
/**
 类： 引用类型（位于栈上面的指针（引用）和位于堆上的实体对象）
 结构体：值类型（实例直接位于栈中）
 */
// struct和class的区别
- (void)test_structAndClass {
    NSString *msg = @"类： 引用类型（位于栈上面的指针（引用）和位于堆上的实体对象）\n结构体：值类型（实例直接位于栈中）";
    [YLAlertManager showAlertWithTitle:@"值类型&引用类型" message:msg actionTitle:@"OK" handler:nil];
}

#pragma mark - UIkit
/**
 因为UIView依赖于CALayer提供的内容，而CALayer又依赖于UIView提供的容器来显示绘制的内容，所以UIView的显示可以说是CALayer要显示绘制的图形。当要显示时，CALayer会准备好一个CGContextRef(图形上下文)，然后调用它的delegate(这里就是UIView)的drawLayer:inContext:方法，并且传入已经准备好的CGContextRef对象，在drawLayer:inContext:方法中UIView又会调用自己的drawRect:方法。
     我们可以把UIView的显示比作“在电脑上使用播放器播放U盘上得电影”，播放器相当于UIView，视频解码器相当于CALayer，U盘相当于CGContextRef，电影相当于绘制的图形信息。不同的图形上下文可以想象成不同接口的U盘

 注意：当我们需要绘图到根层上时，一般在drawRect:方法中绘制，不建议在drawLayer:inContext:方法中绘图

 */
- (void)test_displayUIView {
    [YLAlertManager showAlertWithTitle:@"" message:@" 因为UIView依赖于CALayer提供的内容，而CALayer又依赖于UIView提供的容器来显示绘制的内容，所以UIView的显示可以说是CALayer要显示绘制的图形。当要显示时，CALayer会准备好一个CGContextRef(图形上下文)，然后调用它的delegate(这里就是UIView)的drawLayer:inContext:方法，并且传入已经准备好的CGContextRef对象，在drawLayer:inContext:方法中UIView又会调用自己的drawRect:方法。" actionTitle:@"ok" handler:nil];
}

#pragma mark - datasource Protocol
- (NSString *)jsonFileName {
    return @"Note";
}

- (NSString *)cellIdentifier {
    return @"cell";
}

- (NSString *)headerIdentifier {
    return @"kYLGroupHeaderView";
}

- (void)doFunctionWith:(NSString *)name parameter:(id)parameter {
    NSString *funcName = [NSString stringWithFormat:@"test_%@",name];
    SEL selector = NSSelectorFromString(funcName);
    
    //检查是否有"myMethod"这个名称的方法
    if ([self respondsToSelector:selector]) {
        if (!self) { return; }
        if ([name containsString:@":"]) {
            IMP imp = [self methodForSelector:selector];
            CGRect (*func)(id, SEL, id, id) = (void *)imp;
            CGRect result = self ?
            func(self, selector, @"2", @"3") : CGRectZero;
            NSLog(@"result:: %@",NSStringFromCGRect(result));
        } else {
            IMP imp = [self methodForSelector:selector];
            void (*func)(id, SEL) = (void *)imp;
            func(self, selector);
        }
    }
    
    
}

#pragma mark - lazy

- (YLFather *)father {
    if (!_father) {
        _father = [[YLFather alloc] init];
    }
    return _father;
}

- (YLSon *)son1 {
    if (!_son1) {
        _son1 = [YLSon new];
    }
    return _son1;
}

- (YLSon *)son2 {
    if (!_son2) {
        _son2 = [YLSon new];
    }
    return _son2;
}

- (YLQuestionDataManager *)dataManager {
    if (!_dataManager) {
        _dataManager = [[YLQuestionDataManager alloc] init];
    }
    return _dataManager;
}

@end
