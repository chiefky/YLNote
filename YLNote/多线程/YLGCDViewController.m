//
//  YLGCDViewController.m
//  TestDemo
//
//  Created by tangh on 2020/7/1.
//  Copyright © 2020 tangh. All rights reserved.
//

#import "YLGCDViewController.h"
#import "YLDefaultMacro.h"
#import "YLSDViewController.h"
#import "YLClass.h"

@interface YLGCDViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) UITableView *table;
@property (nonatomic,copy) NSArray *keywords;
@property (nonatomic,strong) dispatch_queue_t rw_queue;
@property (nonatomic,strong) NSMutableDictionary *cacheData;
//@property (atomic, copy) NSString *atomicStr;
@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, copy) NSString *atomicStr;
@property (nonatomic,strong)NSMutableDictionary *groupFoldStatus;
@property (nonatomic,strong)NSMutableDictionary *groupHeaderImages;

@end

@implementation YLGCDViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.cacheData = [@{@"name": @"中国"} mutableCopy];
    //实现一个简单的cache（使用读者写者锁）
    //dispatch_queue_create("com.gfzq.testQueue", DISPATCH_QUEUE_CONCURRENT);

    [self setupUI];
}

- (void)setupUI {
    self.table = [[UITableView alloc] initWithFrame:YLSCREEN_BOUNDS style:UITableViewStyleGrouped];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
    
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)logNum:(NSString *)numStr {
    NSLog(@"任务%@：---%@",numStr,[NSThread currentThread]);
}

#pragma mark - 点击分组信息
- (void)clickGroupAction:(UIButton *)button{
    NSLog(@"clicked %ld",button.tag);
    
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

#pragma mark - NSOperation
/// 主队列多任务
- (void)testOperation_main_queue {
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    queue.maxConcurrentOperationCount = 10;
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(logNum:) object:@"op1"];
    
    NSBlockOperation *op2 = [[NSBlockOperation alloc] init];
    [op2 addExecutionBlock:^{
        for (NSInteger i = 0; i < 2; i++) {
            NSString *str = [NSString stringWithFormat:@"op2.%ld",i+1];
            [self performSelector:@selector(logNum:) withObject:str afterDelay:3.0];
        }
    }];
    
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i < 2; i++) {
            NSString *str = [NSString stringWithFormat:@"op3.%ld",i+1];
            [self performSelector:@selector(logNum:) withObject:str afterDelay:3.0];
        }
    }];
    
    [queue addOperation:op1];
    [queue addOperation:op3];
    [queue addOperation:op2];
}

/// 自定义队列多任务
- (void)testOperation_custom_queue {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 2; // 用最大并发数控制串、并行队列。> 1时，并行队列。==1时，串行队列；
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(logNum:) object:@"op1"];
    
    NSBlockOperation *op2 = [[NSBlockOperation alloc] init];
    [op2 addExecutionBlock:^{
        for (NSInteger i = 0; i < 2; i++) {
            NSString *str = [NSString stringWithFormat:@"op2.%ld",i+1];
            NSRunLoop *loop = [NSRunLoop currentRunLoop];
            [self performSelector:@selector(logNum:) withObject:str afterDelay:2];
            [loop run];
            
        }
    }];
    
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i < 2; i++) {
            NSString *str = [NSString stringWithFormat:@"op3.%ld",i+1];
            NSRunLoop *loop = [NSRunLoop currentRunLoop];
            [self performSelector:@selector(logNum:) withObject:str afterDelay:2];
            [loop run];
            
        }
    }];
    
    [queue addOperation:op3];
    [queue addOperation:op2];
    [queue addOperation:op1];
}

- (void)testOperation_dependency {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 2; // 用最大并发数控制串、并行队列。> 1时，并行队列。==1时，串行队列；
    NSLog(@"-------start------");

    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(logNum:) object:@"op1"];
    
    NSBlockOperation *op2 = [[NSBlockOperation alloc] init];
    [op2 addExecutionBlock:^{
        for (NSInteger i = 0; i < 2; i++) {
            NSString *str = [NSString stringWithFormat:@"op2.%ld",i+1];
            NSRunLoop *loop = [NSRunLoop currentRunLoop];
            [self performSelector:@selector(logNum:) withObject:str afterDelay:2];
            [loop run];
            
        }
    }];
    
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i < 2; i++) {
            NSString *str = [NSString stringWithFormat:@"op3.%ld",i+1];
            NSRunLoop *loop = [NSRunLoop currentRunLoop];
            [self performSelector:@selector(logNum:) withObject:str afterDelay:2];
            [loop run];
            
        }
    }];
    
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i < 2; i++) {
            NSString *str = [NSString stringWithFormat:@"op4.%ld",i+1];
            NSRunLoop *loop = [NSRunLoop currentRunLoop];
            [self performSelector:@selector(logNum:) withObject:str afterDelay:2];
            [loop run];
            
        }
    }];
    
    [op3 addDependency:op2];
    
    [queue addOperation:op2];
    [queue addOperation:op3];
    [queue addOperation:op4];
    [queue addOperation:op1];
    NSLog(@"-------end------");

}

#pragma mark - GCD
/// 主队列多异步任务
- (void)testGCD_main_queue {
    dispatch_queue_t queue = dispatch_get_main_queue();
    NSLog(@"-------start------");
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSString *str = [NSString stringWithFormat:@"1.%ld",i+1];
            [self performSelector:@selector(logNum:) withObject:str afterDelay:3.0];
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSString *str = [NSString stringWithFormat:@"2.%ld",i+1];
            
            [self performSelector:@selector(logNum:) withObject:str afterDelay:3.0];
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSString *str = [NSString stringWithFormat:@"3.%ld",i+1];
            
            [self performSelector:@selector(logNum:) withObject:str afterDelay:3.0];
        }
    });
    NSLog(@"-------end------");
}

/// 串行队列异步任务
- (void)testGCD_serial_queue {
    dispatch_queue_t queue = dispatch_queue_create("queue.ios.serial", DISPATCH_QUEUE_SERIAL);
    NSLog(@"-------start------");
    
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSString *str = [NSString stringWithFormat:@"1.%ld",i+1];
            NSRunLoop *loop = [NSRunLoop currentRunLoop];
            [self performSelector:@selector(logNum:) withObject:str afterDelay:2];
            [loop run];
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSString *str = [NSString stringWithFormat:@"2.%ld",i+1];
            NSRunLoop *loop = [NSRunLoop currentRunLoop];
            [self performSelector:@selector(logNum:) withObject:str afterDelay:1];
            [loop run];
        }
    });
    
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSString *str = [NSString stringWithFormat:@"3.%ld",i+1];
            NSRunLoop *loop = [NSRunLoop currentRunLoop];
            [self performSelector:@selector(logNum:) withObject:str afterDelay:1.0];
            [loop run];
        }
    });
    NSLog(@"-------end------");
}

/// 全局队列（并发队列异步任务）
- (void)testGCD_global_queue {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSLog(@"-------start------");
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSString *str = [NSString stringWithFormat:@"1.%ld",i+1];
            [self performSelector:@selector(logNum:) withObject:str afterDelay:2];
            [[NSRunLoop currentRunLoop] run];
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            
            [[NSRunLoop currentRunLoop] run];
            NSString *str = [NSString stringWithFormat:@"2.%ld",i+1];
            [self performSelector:@selector(logNum:) withObject:str afterDelay:2];
        }
    });
    
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSString *str = [NSString stringWithFormat:@"3.%ld",i+1];
            NSRunLoop *loop = [NSRunLoop currentRunLoop];
            [self performSelector:@selector(logNum:) withObject:str afterDelay:1.0];
            [loop run];
        }
    });
    NSLog(@"-------end------");
}

/// 并发队列异步任务
- (void)testGCD_concurrent_queue {
    dispatch_queue_t queue = dispatch_queue_create("queue.ios.CONCURRENT", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"-------start------");
    for (NSInteger i = 0; i < 100; i++) {
        dispatch_async(queue, ^{
            NSString *str = [NSString stringWithFormat:@"%ld",i+1];
            NSRunLoop *loop = [NSRunLoop currentRunLoop];
            [self performSelector:@selector(logNum:) withObject:str afterDelay:2];
            [loop run];
        });
    }
    NSLog(@"-------end------");
}

/// 使用barrier实现多任务，同步
- (void)testGCD_barrier {
    dispatch_queue_t queue = dispatch_queue_create("queue.ios.CONCURRENT", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"-------start------");
      dispatch_async(queue, ^{
          // 此时任务一中嵌套异步任务，仅使用barrier无法达到1，2，3先执行，4后执行，需借助信号量实现
          for (NSInteger i = 0; i < 2; i++) {
              dispatch_after(2.0, queue, ^{
                  NSString *str = [NSString stringWithFormat:@"1.%ld",i+1];
                  [self logNum:str];
              });
          }
          NSLog(@"任务1结束了");
      });
      dispatch_async(queue, ^{
          for (NSInteger i = 0; i < 2; i++) {
              NSString *str = [NSString stringWithFormat:@"2.%ld",i+1];
              NSRunLoop *loop = [NSRunLoop currentRunLoop];
              [self performSelector:@selector(logNum:) withObject:str afterDelay:1];
              [loop run];
          }
      });
      
      dispatch_async(queue, ^{
          for (NSInteger i = 0; i < 2; i++) {
              NSString *str = [NSString stringWithFormat:@"3.%ld",i+1];
              NSRunLoop *loop = [NSRunLoop currentRunLoop];
              [self performSelector:@selector(logNum:) withObject:str afterDelay:1.0];
              [loop run];
          }
      });
    dispatch_barrier_async(queue, ^{
        NSLog(@"-------barrier------");
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSString *str = [NSString stringWithFormat:@"4.%ld",i+1];
            NSRunLoop *loop = [NSRunLoop currentRunLoop];
            [self performSelector:@selector(logNum:) withObject:str afterDelay:1.0];
            [loop run];
        }
    });
    NSLog(@"-------end------");
}

/// 使用group实现多任务，同步
- (void)testGCD_group {
    dispatch_queue_t queue = dispatch_queue_create("queue.ios.CONCURRENT", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"-------start------");
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue,^{
        for (NSInteger i = 0; i < 2; i++) {
            NSString *str = [NSString stringWithFormat:@"1.%ld",i+1];
            NSRunLoop *loop = [NSRunLoop currentRunLoop];
            [self performSelector:@selector(logNum:) withObject:str afterDelay:1];
            [loop run];
        }
        NSLog(@"任务1结束了");
    });
    
    
    dispatch_group_async(group, queue, ^{
        // 此时任务一中嵌套异步任务，仅使用group无法达到1，2，3先执行，4后执行，需借助信号量实现
        for (NSInteger i = 0; i < 2; i++) {
            dispatch_async(queue, ^{
                [NSThread sleepForTimeInterval:10];
                NSString *str = [NSString stringWithFormat:@"2.%ld",i+1];
                [self logNum:str];
            });
            // TODO: 不知道为什么这里`dispatch_after`不起作用
            //                   dispatch_after(10.0, queue, ^{
            //                       NSString *str = [NSString stringWithFormat:@"2.%ld",i+1];
            //                       [self logNum:str];
            //                   });
        }
        NSLog(@"任务2结束了");
    });
    
      dispatch_group_async(group, queue,^{
          for (NSInteger i = 0; i < 2; i++) {
              NSString *str = [NSString stringWithFormat:@"3.%ld",i+1];
              NSRunLoop *loop = [NSRunLoop currentRunLoop];
              [self performSelector:@selector(logNum:) withObject:str afterDelay:1.0];
              [loop run];
          }
          NSLog(@"任务3结束了");
      });

    dispatch_group_notify(group, queue, ^{
        NSLog(@"-------notify------");

        for (NSInteger i = 0; i < 2; i++) {
            NSString *str = [NSString stringWithFormat:@"4.%ld",i+1];
            NSRunLoop *loop = [NSRunLoop currentRunLoop];
            [self performSelector:@selector(logNum:) withObject:str afterDelay:1.0];
            [loop run];
        }
    });
    
    NSLog(@"-------end------");
}

/// 使用group + semaphore实现多任务，同步
- (void)testGCD_group_semaphore {
    dispatch_queue_t queue = dispatch_queue_create("queue.ios.CONCURRENT", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"-------start------");
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue,^{
        for (NSInteger i = 0; i < 2; i++) {
            NSString *str = [NSString stringWithFormat:@"1.%ld",i+1];
            NSRunLoop *loop = [NSRunLoop currentRunLoop];
            [self performSelector:@selector(logNum:) withObject:str afterDelay:1];
            [loop run];
        }
        NSLog(@"任务1结束了");
    });
    
    dispatch_group_async(group, queue, ^{
        // 创建信号量,目的将异步任务转换为同步任务
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        dispatch_async(queue, ^{
            [NSThread sleepForTimeInterval:10];
            NSString *str = [NSString stringWithFormat:@"2.1"];
            [self logNum:str];
            dispatch_semaphore_signal(semaphore);
        });
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"任务2结束了");
    });
//
      dispatch_group_async(group, queue,^{
          for (NSInteger i = 0; i < 2; i++) {
              NSString *str = [NSString stringWithFormat:@"3.%ld",i+1];
              NSRunLoop *loop = [NSRunLoop currentRunLoop];
              [self performSelector:@selector(logNum:) withObject:str afterDelay:1.0];
              [loop run];
          }
          NSLog(@"任务3结束了");
      });

    dispatch_group_notify(group, queue, ^{
        NSLog(@"-------notify------");

        for (NSInteger i = 0; i < 2; i++) {
            NSString *str = [NSString stringWithFormat:@"4.%ld",i+1];
            NSRunLoop *loop = [NSRunLoop currentRunLoop];
            [self performSelector:@selector(logNum:) withObject:str afterDelay:1.0];
            [loop run];
        }
    });
    
    NSLog(@"-------end------");
}

- (void)testGCD_max {
    dispatch_queue_t workConcurrentQueue = dispatch_queue_create("cccccccc", DISPATCH_QUEUE_CONCURRENT);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(3);
    for (NSInteger i = 0; i < 10; i++) {
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_async(workConcurrentQueue, ^{
            
            NSLog(@"任务开始%ld:%@",i,[NSThread currentThread]);
            
            sleep(1);
            
            NSLog(@"任务结束%ld:%@",i,[NSThread currentThread]);

            dispatch_semaphore_signal(semaphore);});
    }
    NSLog(@"主线程...!");

}
/// 使用GCD实现读写锁
- (void)testGCD_lock_rw {
    dispatch_queue_t que = dispatch_queue_create("hello", DISPATCH_QUEUE_CONCURRENT);
    for (NSInteger i = 1; i < 50; i++) {
        dispatch_async(que, ^{
            [self setCache:@"heel" forKey:[NSString stringWithFormat:@"%@",@(i)]];
        });
      dispatch_async(que, ^{
                      [self objWithKey:[NSString stringWithFormat:@"%@",@(i-1)]];
      });

            
    }
}

- (void)setCache:(id)cacheObject forKey:(NSString *)key {
    if (key.length == 0) {
        return;
    }
    dispatch_barrier_async(self.rw_queue, ^{
        [self.cacheData setValue:cacheObject forKey:key];
        NSLog(@"写:%@-%@",key,cacheObject);
    });
}
#pragma mark - tes
- (void)testAtomic {
    [_lock lock];
    //thread A
    self.atomicStr = @"am on thread A";
    NSLog(@"%@", self.atomicStr);
    [_lock unlock];

    //thread B
    [_lock lock];
    self.atomicStr = @"am on thread B";
    NSLog(@"%@", self.atomicStr);
    [_lock unlock];

}

- (id)objWithKey: (NSString *)key {
    if (key.length == 0) {
        return nil;
    }
    __block id cacheObject = nil;
    dispatch_sync(self.rw_queue, ^{
        cacheObject = self.cacheData[key];
        NSLog(@"读:%@-%@",key,cacheObject);
    });
    return cacheObject;
}

#pragma mark - delegate & datadource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.keywords.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSDictionary *dic = self.keywords[section];
    NSString * title = dic.allKeys.lastObject;
    
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
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
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
     int flag = [self.groupFoldStatus[@(section)] intValue];
       NSDictionary *sectionDict = self.keywords[section];
       NSArray * sectionArry =  sectionDict.allValues.lastObject;
       if(flag) {
           return sectionArry.count;
       } else {
           return 0;
       }
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

- (NSArray *)keywords {
    return @[
        @{
            @"NSOperation":@[
                    @"testOperation_main_queue:主队列",
                    @"testOperation_custom_queue:自定义队列,最大并发数",
                    @"testOperation_dependency:3，2，1添加进队列，3依赖2",
                    @"testCategory_associate_methds:获取所有实例方法",
                    @"testCategory_associate_class_methds:获取所有类方法"]},
        @{
            @"GCD":@[@"testAtomic: mmm",
                    @"testGCD_main_queue:主队列异步任务",
                    @"testGCD_serial_queue:串行队列异步任务",
                    @"testGCD_global_queue:全局队列异步任务",
                    @"testGCD_concurrent_queue:并行队列异步任务",
                    @"testGCD_barrier:任先执行1、2、3,后执行4",
                    @"testGCD_group:先执行1、2、3,后执行4",
                    @"testGCD_group_semaphore:先执行1、2、3,后执行4",
                    @"testGCD_max: 控制最大并发数",
                    @"testGCD_lock_rw:使用GCD实现读写锁"]},
        @{
            @"锁":@[
                    @"testIsa_swizzing:isa指针换"]},
    ];
}

- (dispatch_queue_t)rw_queue {
    if (!_rw_queue) {
        _rw_queue = dispatch_queue_create("com.gfzq.testQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return _rw_queue;
}

@end
