//
//  YLNotesViewController.m
//  TestDemo
//
//  Created by tangh on 2020/7/11.
//  Copyright © 2020 tangh. All rights reserved.
//
#import "YLNotesViewController.h"
#import "YLNote-Swift.h"

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



@interface YLNotesViewController ()<UITableViewDelegate,UITableViewDataSource,YLGroupDataSource>
@property (nonatomic,strong)YLFather *father;
@property (nonatomic,strong)YLSon *son1;
@property (nonatomic,strong)YLSon *son2;

@property (nonatomic,copy)NSArray *testArray; // 测试copy属性

@property (nonatomic,weak)YLFather *wkFather; // 测试weak属性
@property (nonatomic,unsafe_unretained)YLFather *unFather; // 测试unsafe_unretained属性
@property (nonatomic,strong)YLFather *stFather; // 测试strong属性

@property (nonatomic,strong)UITableView *table;
@property (nonatomic,copy)NSArray<YLNoteGroup *> *keywords;
@property (nonatomic,strong)NSMutableDictionary *groupFoldStatus;
@property (nonatomic,strong)NSMutableDictionary *groupHeaderImages;

@property (nonatomic,weak) NSObject<YLGroupDataSource> *datasource;
@property (nonatomic,weak) NSObject<YLGroupDataDelegate> *delegate;

@property (nonatomic,strong) YLNoteGroupDataManager *dataManager;


@end

@implementation YLNotesViewController



- (void)setupUI {
    self.table = [[UITableView alloc] initWithFrame:YLSCREEN_BOUNDS style:UITableViewStyleGrouped];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
    
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.dataManager = [[YLNoteGroupDataManager alloc] init];
    self.datasource = self.dataManager;
    self.delegate = self.dataManager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
#pragma mark - 点击分组信息
- (void)clickGroupAction:(UIButton *)button{    
    int groupIndex = (int)button.tag;
    int flag = 0;//用来控制重新实例化按钮
    
    if([self.groupFoldStatus[@(groupIndex)] intValue]==0){
        [self.groupFoldStatus setObject:@(1) forKey:@(groupIndex)];
        flag = 0;
    }else{
        [self.groupFoldStatus setObject:@(0) forKey:@(groupIndex)];
        flag = 1;
    }
    
    //刷新当前的分组
    NSIndexSet * set=[[NSIndexSet alloc] initWithIndex:groupIndex];
    [self.table reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
    
    UIImageView * imageView = self.groupHeaderImages[@(groupIndex)];
    
    //模拟动画，每次都重新刷新了因此仿射变化恢复到原始状态了
    if(flag){
        imageView.transform=CGAffineTransformRotate(imageView.transform, M_PI_2);
    }
    //
    [UIView animateWithDuration:0.3 animations:^{
        
        if(flag==0){
            imageView.transform=CGAffineTransformMakeRotation( M_PI_2);
        }else{
            imageView.transform=CGAffineTransformMakeRotation(0);
            
        }
    }];
    
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

#pragma mark - delegate & datadource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.keywords.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    YLNoteGroup *group = self.keywords[section];
    NSString * title = group.groupName;
    
    //    //1 自定义头部
    UIView * view = [[UIView alloc] init];
    view.backgroundColor=[UIColor whiteColor];
    //    view.layer.borderWidth = 1;
    //    view.layer.borderColor = [UIColor whiteColor].CGColor;
    //
    // 2 增加按钮
    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    button.frame = CGRectMake(0, 0, YLSCREEN_WIDTH, 40);
    button.tag = section;
    [button addTarget:self action:@selector(clickGroupAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    //3 添加左边的箭头
    UIImageView * imageView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 20.0-15.0/2, 15, 15)];
    imageView.image=[UIImage imageNamed:@"arrow"];
    imageView.tag=101;
    [button addSubview:imageView];
    [self.groupHeaderImages setObject:imageView forKey:@(section)];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * view=[[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell) {
        YLNoteGroup *group = self.keywords[indexPath.section];
        YLNoteItem *question = group.questions[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@",indexPath.row + 1,question
                               .itemDesc];;
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int flag = [self.groupFoldStatus[@(section)] intValue];
    YLNoteGroup *group = self.keywords[section];
    if(flag) {
        return group.questions.count;
    } else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YLNoteGroup *group = self.keywords[indexPath.section];
    YLNoteItem *question = group.questions[indexPath.row];
    [self.delegate didSelectRowWith:question];
    return;
    
//    NSString *method = question.functionName; //selectorTitle.firstObject;
//    SEL selector = NSSelectorFromString(method);
//    Class cls = NSClassFromString(question.className);
//    //检查是否有"myMethod"这个名称的方法
//    if ([cls respondsToSelector:selector]) {
//        //           [self performSelector:sel];
//        if (!cls) { return; }
//        IMP imp = [cls methodForSelector:selector];
//        void (*func)(id, SEL) = (void *)imp;
//        func(cls, selector);
//    }
}

#pragma mark - lazy
- (NSMutableDictionary *)groupHeaderImages {
    if (!_groupHeaderImages) {
        _groupHeaderImages = [NSMutableDictionary dictionary];
    }
    return _groupHeaderImages;
}

- (NSMutableDictionary *)groupFoldStatus {
    if (!_groupFoldStatus) {
        _groupFoldStatus = [NSMutableDictionary dictionary];
    }
    return _groupFoldStatus;
}

- (NSArray<YLNoteGroup *> *)keywords {
    // 判断代理对象是否实现这个方法，没有实现会导致崩溃
    if ([self.datasource respondsToSelector:@selector(dataGroup)]) {
        return [self.datasource dataGroup];
    } else {
        return 0;
    }
    
}

//- (NSArray *)keywords {
//    return @[
//        [YLUIKitNoteManger allNotes],
//        [YLWebNoteManager allNotes],
//        [YLRuntimeNoteManager allNotes],
//
//        //------- 1.7 to do -----
//        [YLAutoReleaseNoteManager allNotes],
//        [YLGCDNoteManager allNotes],
//        [YLKVONoteManager allNotes],
//
////        @{
////            @"group":@"NSNotificationCenter",
////            @"questions":@[
////                    @"testNotification:手动实现NSNotificationCenter",
////                    @"testNotification_block:使用block接口"]},
//
//        //------- 1.8 to do -----
//        [YLMessageNoteManager allNotes],
//        [YLRunLoopNoteManager allNotes],
//        [YLAnimationNoteManager allNotes],
//        [YLThirdLibNoteManager allNotes],
//    ];
//}

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

@end
