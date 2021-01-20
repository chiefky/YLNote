//
//  YLTableViewController.m
//  YLNote
//
//  Created by tangh on 2021/1/18.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLTableViewController.h"
#import "YLDefaultMacro.h"
#import "YLQuestion.h"

@interface YLTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *table;
@property (nonatomic,strong)NSMutableArray<YLQuestion *>*questions;
@end

@implementation YLTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getAllQuestions];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark- UI
- (void)setupUI {
    self.table = [[UITableView alloc] initWithFrame:YLSCREEN_BOUNDS style:UITableViewStyleGrouped];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
    
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"kYLTableViewControllerCell"];
}

#pragma mark - Data
- (void)getAllQuestions {
    
}

#pragma mark - delegate & datadource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell) {
        YLQuestion *question = self.questions[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@",indexPath.row + 1,question.title];;
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {    return self.questions.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YLQuestion *question = self.questions[indexPath.row];
    NSString *function = question.function; //selectorTitle.firstObject;
    SEL selector = NSSelectorFromString(function);
    //检查是否有"myMethod"这个名称的方法
    if ([self respondsToSelector:selector]) {
        if (!self) { return; }
        IMP imp = [self methodForSelector:selector];
        void (*func)(id, SEL) = (void *)imp;
        func(self, selector);
    }
}

#pragma mark - lazy

- (NSMutableArray *)questions {
    if (!_questions) {
        _questions = [NSMutableArray array];
    }
    return _questions;
}


@end
