//
//  YLKVOViewController.m
//  TestDemo
//
//  Created by tangh on 2020/7/15.
//  Copyright © 2020 tangh. All rights reserved.
//

#import "YLKVOViewController.h"
#import <objc/runtime.h>
#import <Masonry/Masonry.h>
#import "YLDefaultMacro.h"
#import "YLStudent.h"
#import "YLHitTestViewController.h"

static  NSString *const kTableViewCell = @"kTableViewCell";

NSString *yl_firstName(id self, SEL selector)
{
    return @"MeiMei";
}

NSString *yl_lastName(id self, SEL selector)
{
    return @"Apple";
}



@interface YLKVOViewController ()<UITableViewDelegate,UITableViewDataSource>
//@property (nonatomic,strong) UIScrollView *contentView;

@property (nonatomic,strong) UITableView *table;
@property (nonatomic,copy) NSArray *keyWords;

@end

@implementation YLKVOViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.table];
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewCell];


}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
 
//    // 动态添加类之后，任何时机任何位置都可以使用
//    Class cls = NSClassFromString(@"Subclass_YLPerson");
//     YLStudent *son = [[cls alloc] init];
//     son.firstName = @"youli";
//     NSLog(@"son full name: %@ %@",son.firstName,son.lastName);
    return;
    
}


#pragma mark - test

/// 改 fist name
- (void)testMethodSwigzzing {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        YLStudent *st = [YLStudent new];
          st.firstName = @"Tom";
          st.lastName = @"Google";
          NSLog(@"person full name: %@ %@", st.firstName, st.lastName);
          
          SEL sel = @selector(firstName);
          Method or_method = class_getInstanceMethod([st class], sel);
          
          SEL yl_sel = NSSelectorFromString(@"yl_firstName");
          BOOL isAdded = class_addMethod([st class], sel, (IMP)yl_firstName, method_getTypeEncoding(or_method));
          if (isAdded) {
              // 添加成功,说明之前没有对应IMP(原因：声明后没有实现，或者没有声明)，将被交换方法的实现替换到这个并不存在的实现
              class_replaceMethod([st class], sel, (IMP)yl_firstName, method_getTypeEncoding(or_method));

          } else {
              //添加不成功,说明老方法有对应实现，把新方法添加上，直接交换两个方法的实现
              class_addMethod([st class], yl_sel, (IMP)yl_firstName, method_getTypeEncoding(or_method));
              Method yl_method = class_getInstanceMethod([st class], yl_sel);
              method_exchangeImplementations(yl_method, or_method);
          }
          
          NSLog(@"person full name: %@ %@", st.firstName, st.lastName);
    });
  

}

/// 改 lastName
- (void)testIsaSwigzzing {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
            YLStudent *person = [[YLStudent alloc] init];
            person.firstName = @"Tom";
            person.lastName = @"Google";
            NSLog(@"person full name: %@ %@", person.firstName, person.lastName);
            
            // 1.创建一个子类
            NSString *oldName = NSStringFromClass([person class]);
            NSString *newName = [NSString stringWithFormat:@"Subclass_%@", oldName];
            Class customClass = objc_allocateClassPair([person class], newName.UTF8String, 0);
            objc_registerClassPair(customClass);
            // 2.重写get方法
            SEL sel = @selector(lastName);
            Method method = class_getInstanceMethod([person class], sel);
            const char *type = method_getTypeEncoding(method);
            class_addMethod(customClass, sel, (IMP)yl_lastName, type);
            // 3.修改修改isa指针(isa swizzling)
            object_setClass(person, customClass);
            
            NSLog(@"person full name: %@ %@", person.firstName, person.lastName);
            
           
            YLStudent *person2 = [[YLStudent alloc] init];
            person2.firstName = @"Jerry";
            person2.lastName = @"Google";
            NSLog(@"person2 full name: %@ %@", person2.firstName, person2.lastName);
    });
}

- (void)testIsaSwigzzing_responser {
    YLHitTestViewController *hitVC = [[YLHitTestViewController alloc] init];
    [self.navigationController pushViewController:hitVC animated:YES];
}

#pragma mark - delegate & datadource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCell forIndexPath:indexPath];
    if (cell) {
            NSString *titleValue = self.keyWords[indexPath.row];
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
        cell.textLabel.numberOfLines = 0;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.keyWords.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *titleValue = self.keyWords[indexPath.row];
    NSArray *selectorTitle = [titleValue componentsSeparatedByString:@":"];
    NSString *selectorStr = selectorTitle.firstObject;
    SEL selector = NSSelectorFromString(selectorStr);
    //检查是否有"myMethod"这个名称的方法
    if ([self respondsToSelector:selector]) {
        //           [self performSelector:sel];
        if (!self) { return; }
        IMP imp = [self methodForSelector:selector];
        void (*func)(id, SEL,NSInteger) = (void *)imp;
        func(self, selector,indexPath.row);
    }
}

#pragma mark - lazy
- (NSArray *)keyWords {
    return @[@"testMethodSwigzzing: 面试题1\n 现有一个继承于NSObject的实例对象，需要在不直接修改方法实现的情况下，改变一个方法的行为，你会怎么做？\n   不直接修改方法实现，指的是不直接修改.m文件中方法的内部实现.\n   这一道题比较简单，其实问的就是 Runtime 的 Method Swizzling 。可能答出来之后，还会问几个 Method Swizzling 相关的深入问题。下面难度升级。",
             @"testIsaSwigzzing: 面试题2\n   问题1，如果使用 Method Swizzling 技术，相当于修改了类对象中方法选择器和IMP实现的对应关系。这将导致继承自这个类的所有子类和实例对象都影响，如何控制受影响的范围，或者说如何让方法的行为改变只对这个实例对象生效？\n   这个题难度上升了，但是不是有一种脱离生产的感觉，为了面试你而出的一道题？\n   我们对这个问题包装一下，让它看起来更接地气，同时问题也再升级一点。\n  ",
             @"testIsaSwigzzing_responser: 面试题3\n    现有一个视图，我们需要扩大一下它的响应范围。如果使用 Method Swizzling 技术，受影响的范围会比较大。当然，也可以选择继承一个子类来实现。但如果现在实例已经创建了，还是同样的需求，你会如何实现？"
    ];
}


- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:YLSCREEN_BOUNDS style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        _table.rowHeight = 200;
    }
    return _table;
}
@end

