//
//  YLSDViewController.m
//  TestDemo
//
//  Created by tangh on 2020/7/12.
//  Copyright © 2020 tangh. All rights reserved.
//

#import "YLSDViewController.h"
#import <SDWebImage/SDWebImage.h>
#import "YLDefaultMacro.h"
#import "YLSDTableViewCell.h"

@interface YLSDViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *table;
@property (nonatomic,copy)NSArray *images;

@end

@implementation YLSDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.table = [[UITableView alloc] initWithFrame:YLSCREEN_BOUNDS style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.rowHeight = 100;
    [self.view addSubview:self.table];
    [self.table registerClass:[YLSDTableViewCell class] forCellReuseIdentifier:@"kYLSDTableViewCell"];
}

#pragma mark - table delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YLSDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kYLSDTableViewCell" forIndexPath:indexPath];
    if (cell) {
        [cell reloadData:self.images[indexPath.row]];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.images.count;
}

#pragma mark - lazy
- (NSArray *)images {
    return @[@"https://comic.sinaimg.cn/2012/0617/U8297P1157DT20120617173831.jpg",
    @"https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQsGam9wrxRLNK-dGHyyT0hWhvezvsUJpGInQ&usqp=CAU",
    @"https://n.sinaimg.cn/sinacn10109/330/w640h490/20190105/37b6-hrfcctm5042721.jpg",
    @"https://img1.how01.com/imgs/af/f7/f/102200067705a7251e79.jpg",
             @"https://inews.gtimg.com/newsapp_bt/0/9265460989/641",
    @"https://hbimg.huabanimg.com/7cc06dda4998e2b64114287b0be7a366bab9ee959eff6-cMP0j4_fw658"];
}
@end
