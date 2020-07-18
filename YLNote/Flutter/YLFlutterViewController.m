//
//  YLFlutterViewController.m
//  TestDemo
//
//  Created by tangh on 2020/7/19.
//  Copyright © 2020 tangh. All rights reserved.
//

#import "YLFlutterViewController.h"
#import "YLDefaultMacro.h"

@interface YLFlutterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *table;
@property (nonatomic,copy)NSArray *keywords;

@end

@implementation YLFlutterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

- (void)setupUI {
    self.table = [[UITableView alloc] initWithFrame:YLSCREEN_BOUNDS style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
    
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - tests


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
            @"NSOperation":@[
                    @"testSonOverwrite:子类方法重写",
                    @"testCategory_associate_ivas:获取所有实例变量",
                    @"testCategory_associate_protertys:获取所有属性",
                    @"testCategory_associate_methds:获取所有实例方法",
                    @"testCategory_associate_class_methds:获取所有类方法"]},
        @{
            @"GCD":@[
                    @"testCopy:copy关键字",
                    @"testStrong:strong关键字",
                    @"testWeak:weak关键字",
                    @"test_unsafe_unretained:unsafe_unretained关键字",
                    @"testMemory:内存泄漏",
                    @"testAutorelease:Autorelease"]},
        @{
            @"锁":@[
                    @"testIsa_swizzing:isa指针换"]},
    ];
}


@end
