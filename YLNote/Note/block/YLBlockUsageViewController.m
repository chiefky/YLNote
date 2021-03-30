//
//  YLBlockUsageViewController.m
//  YLNote
//
//  Created by tangh on 2021/1/18.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLBlockUsageViewController.h"
#import <YYModel/YYModel.h>
#import "YLFileManager.h"
#import "YLNoteData.h"
#import "YLIterator.h"
#import "YLNetworkBaseAPI.h"
#import "YLAlertManager.h"
#import "YLNetErrorCode.h"
#import "YLDefaultMacro.h"

// block别名
typedef NSString *(^BlockName_child)(NSInteger gender); // gender 可写可不写，0：男，1：女；

@interface YLBlockUsageViewController ()<UITableViewDelegate,UITableViewDataSource>
/// block声明方式一
@property (nonatomic,copy) BlockName_child name_child;// 起名

/// block声明方式二
@property (nonatomic,copy) NSString*(^myBlock)(NSInteger gender); // 起名

@property (nonatomic,strong)UITableView *table;
@property (nonatomic,strong) NSMutableArray<YLQuestion*> *dataArray;
@property (nonatomic,assign) NSInteger page; // 页码

@end

@implementation YLBlockUsageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
}
#pragma mark - UI
- (void)setupUI {
    self.table = [[UITableView alloc] initWithFrame:YLSCREEN_BOUNDS style:UITableViewStylePlain];
    [self.view addSubview:self.table];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"kYLTableViewControllerCell"];
}

#pragma mark -rewrite
- (void)requestData {
    [self requestDataWithParam:@{} page:1];
}

#pragma mark - data
- (void)requestDataWithParam:(id)param page:(NSInteger)page {
    NSDictionary *block_usageDict = [YLFileManager jsonParseWithLocalFileName:@"blockusage"]; // 后台返回json
     YLNetworkAPIResponse *response = [[YLNetworkAPIResponse alloc] initWithDictionary:block_usageDict];
    if (!response || ![response.data isKindOfClass:[NSDictionary class]]) {
        [YLAlertManager showToastWithMessage:YLNetworkDataformatErrorDesc senconds:3];
        return;
    }
    
    NSDictionary *dataDict = response.data;
    if (dataDict && [dataDict[@"list"] isKindOfClass:[NSArray class]]) {
        NSArray *tmpArray = [NSArray yy_modelArrayWithClass:[YLQuestion class] json:dataDict[@"list"]];
        if ([dataDict[@"page"] integerValue] > 1) {
            [self.dataArray addObjectsFromArray:tmpArray];
        } else {
            self.dataArray = [tmpArray mutableCopy];
        }
        [self.table reloadData];
    }
}

#pragma mark - test functions
// - block有哪些类型
- (void)testBlockTypes {
    /**
         1.没有返回值,没有参数的block
     */
    void(^blockSimple)(void) = ^() {
        NSLog(@"这是一个没有返回值,没有参数的block;");
    };
    blockSimple();
    
    /**
        2.没有返回值，有两个参数；必须要写参数,而且必须要有参数变量名。
     */
    void(^blockWithParameter)(int, NSString *) = ^(int a, NSString* b){
        NSLog(@"这是一个没有返回值，两个参数的block;参数a:%d,参数b:%@",a,b);
    };
    blockWithParameter(2 ,@"Hello");// 调用
    
    /**
         3.带有返回值与参数 返回值int 参数为int
     */
    NSInteger(^blockWithParameterAndReturn)(NSInteger,NSInteger) = ^(NSInteger a,NSInteger b){
        NSInteger result = a-b;
        NSLog(@"这是一个带有返回值与参数的block;参数a:%ld,参数b:%ld,返回值：%ld",a,b,result);
        return result;
    };
    blockWithParameterAndReturn(6,2);
    
    /**
         4.带有返回值,不带参数 略
     */
}

// - block作为属性，声明及使用
- (void)testPropertyBlock {
    self.name_child = ^NSString *(NSInteger gender) {
        if (gender) {
            return @"唐雪仙";
        }
        return @"唐冰圣";
    };
    NSLog(@"女儿起名:%@",self.name_child(1));
    
    self.myBlock = ^NSString *(NSInteger gender) {
      if (gender) {
            return @"唐雪仙";
        }
        return @"唐冰圣";
    };
    NSLog(@"儿子起名:%@",self.myBlock(0));
}

// - block作为函数参数使用
- (void)testParameterBlock {
    [self parameterBlockSimple:^{
        NSLog(@"block作为参数:无返回值 无参数");
    }];
    
    [self parameterBlockWithParameter:^(NSString *parameter) {
        NSLog(@"block作为参数:无返回值 输入参数:%@",parameter);
    }];
    
    [self parameterBlockWithParameterAndReturn:^NSString *(NSInteger parameter) {
        NSLog(@"block作为参数:有返回值 输入参数:%ld",parameter);
        if (parameter) {
            return @"女孩";
        }
        return @"男孩";
    }];
}


/// block作为参数 无返回值 无参数(事件完成后调用block块里的方法)
/// @param blockname block名称
- (void)parameterBlockSimple:(void(^)(void))blockname {
    if (blockname) {
        blockname();
    }
}

/// block作为参数 无返回值 NSSTring参数(形参parameter可写可不写)
/// @param blockname block名称
- (void)parameterBlockWithParameter:(void(^)(NSString* parameter))blockname {
    if (blockname) {
        blockname(@"Hello World");
    }
}

/// block作为参数 有返回值 NSInteger参数(形参parameter可写可不写)
/// @param blockname block名称
- (void)parameterBlockWithParameterAndReturn:(NSString*(^)(NSInteger parameter))blockname {
    if (blockname) {
       NSString *result = blockname(0);
        NSString *s = [result stringByAppendingString:@"😄"];
        NSLog(@"结果是:%@",s);
    }
}

// - block作为函数返回值使用
- (void)testReturnBlock {
    // 链式变成  block做参数 做返回值
    NSString *values = [NSObject iteratorResult:^(YLIterator * _Nonnull iterator) {
        iterator.add(@"😤😤").add(@"猪腚").add(@"喜欢吃🥜味儿的💩");
    }];
    NSLog(@"values = %@",values);

}

#pragma mark - delegate & datadource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kYLTableViewControllerCell" forIndexPath:indexPath];
    if (cell) {
        YLQuestion *question = self.dataArray[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@",indexPath.row + 1,question.title];;
        cell.textLabel.textColor = [UIColor orangeColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YLQuestion *question = self.dataArray[indexPath.row];
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



#pragma mark -lazy
- (NSMutableArray<YLQuestion *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
