//
//  YLSwiftViewController.m
//  TestDemo
//
//  Created by tangh on 2020/7/19.
//  Copyright © 2020 tangh. All rights reserved.
//

#import "YLOCSwiftViewController.h"
#import "YLDefaultMacro.h"
#import "YLNote-Swift.h"
@interface YLOCSwiftViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *table;
@property (nonatomic,copy)NSArray *keywords;
@property (nonatomic,strong)NSMutableDictionary *foldStatus;
@property (nonatomic,strong)NSMutableDictionary *headImageViews;


@end

@implementation YLOCSwiftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

- (void)setupUI {
    self.table = [[UITableView alloc] initWithFrame:YLSCREEN_BOUNDS style:UITableViewStyleGrouped];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
    
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - tests
- (void)testAlgorithm {
//    YLAlgorithmViewController *testVC = [[YLAlgorithmViewController alloc] init];
//    [self.navigationController pushViewController:testVC animated:YES];
}

#pragma mark - 点击分组信息
- (void)clickGroupAction:(UIButton *)button{
    NSLog(@"clicked %ld",button.tag);
    
    int groupIndex = (int)button.tag;
    int flag = 0;//用来控制重新实例化按钮
    
    if([self.foldStatus[@(groupIndex)] intValue]==0){
        [self.foldStatus setObject:@(1) forKey:@(groupIndex)];
        flag = 0;
    }else{
        [self.foldStatus setObject:@(0) forKey:@(groupIndex)];
        flag = 1;

    }

 
    //刷新当前的分组
    NSIndexSet * set=[[NSIndexSet alloc] initWithIndex:groupIndex];
    [self.table reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
    
    UIImageView * imageView = self.headImageViews[@(groupIndex)];
    
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
#pragma mark - delegate & datadource

#pragma mark - 设置分组的个数
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return self.keywords.count;
}
#pragma mark - 设置分组的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}
#pragma mark - 自定义分组头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSDictionary *dic = self.keywords[section];
    NSString * title = dic[@"group"];

//    //1 自定义头部
    UIView * view = [[UIView alloc] init];
    view.backgroundColor=[UIColor grayColor];
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor whiteColor].CGColor;
//
    // 2 增加按钮
    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    button.frame = CGRectMake(0, 0, YLSCREEN_WIDTH, 40);
    button.tag = section;
    [button addTarget:self action:@selector(clickGroupAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];

    //3 添加左边的箭头
    UIImageView * imageView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 40/2.0-20/2.0, 20, 20)];
    imageView.image=[UIImage imageNamed:@"swift.png"];
    imageView.tag=101;
    [button addSubview:imageView];
    [self.headImageViews setObject:imageView forKey:@(section)];

    return view;

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * view=[[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    return view;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int flag = [self.foldStatus[@(section)] intValue];
    NSDictionary *sectionDict = self.keywords[section];
    NSArray * sectionArry = sectionDict[@"question"];
    if(flag) {
        return sectionArry.count;
    } else {
        return 0;
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *sectionDict = self.keywords[section];
    
    return sectionDict.allKeys.lastObject;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell) {
               NSDictionary *sectionDict = self.keywords[indexPath.section];
              NSArray *sectionArry = sectionDict[@"question"];

//                      NSArray *sectionArry = sectionDict.allValues.lastObject;
//                      NSString *titleValue = sectionArry[indexPath.row];
//                      NSArray *titleValues = [titleValue componentsSeparatedByString:@":"];
//
//                      NSDictionary *attrMethod = @{ NSForegroundColorAttributeName : [UIColor redColor] ,
//                                                    NSFontAttributeName: [UIFont systemFontOfSize:12]
//                      };
//                      NSDictionary *attrTitle = @{ NSForegroundColorAttributeName : [UIColor blackColor] ,
//                                                   NSFontAttributeName: [UIFont systemFontOfSize:12]
//                      };
//                      NSString * methodTitle = titleValues.firstObject;
//                      NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:titleValue];
//                      [attrStr addAttributes:attrMethod range:NSMakeRange(0, methodTitle.length + 1)];
//                      [attrStr addAttributes:attrTitle range:NSMakeRange(methodTitle.length + 1, titleValue.length - methodTitle.length - 1)];
//
//                      cell.textLabel.attributedText = attrStr;
        
        cell.textLabel.text = sectionArry[indexPath.row];

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *sectionDict = self.keywords[indexPath.section];
    NSArray *sectionArry = sectionDict[@"question"];
    NSString *method = sectionArry[indexPath.row];
    NSArray *selectorTitles = [method componentsSeparatedByString:@":"];
    NSString *title = selectorTitles.firstObject;
    NSString *selectorStr = selectorTitles.lastObject;

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
    if (!_keywords) {
        _keywords = [NSArray array];
    }
    return @[
        @{
            @"group":@"数字交换",
            @"questions":@[
                    @"使用临时变量:swapNumbersWithTemp",
                    @"使用四则运算:swapNumbersWithArithmetic",
                    @"使用异或运算:swapNumbersWithXOR"]
        },
        @{
            @"group":@"求二叉树深度",
            @"questions":@[
                    @"1",
                    @"2"]
        },
        @{
            @"group":@"二叉树遍历",
            @"questions":@[
                    @"1",
                    @"2"]
        }
    ];
}

- (NSMutableDictionary *)foldStatus {
    if (!_foldStatus) {
        _foldStatus = [NSMutableDictionary dictionary];
    }
    return _foldStatus;
}

- (NSMutableDictionary *)headImageViews {
    if (!_headImageViews) {
        _headImageViews = [NSMutableDictionary dictionary];
    }
    return _headImageViews;
}

@end
