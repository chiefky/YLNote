//
//  YLThreadSync.m
//  Demo20200420
//
//  Created by tangh on 2020/6/21.
//  Copyright © 2020 tangh. All rights reserved.
//

#import "YLThreadSync.h"
#include <pthread.h>
#import <libkern/OSAtomic.h> // 引入自旋锁
#import <os/lock.h> // 引入不公平锁

/**
 要保证线程安全，就必须要线程同步，而在iOS中线程同步的方案有：

 原子操作
 信号量
 GCD串行队列
 锁
 */

@interface YLThreadSync ()

@property (nonatomic,assign) NSInteger testInt; // set方法加互斥锁
@property (strong, nonatomic) NSMutableArray *data;

@property (nonatomic,assign) NSInteger ticketsCount; // 剩余票数

@end

@implementation YLThreadSync


/// 初始化
- (instancetype)init {
    self = [super init];
    if (self) {
        _data = [NSMutableArray array];
        self.ticketsCount = 50;

    }
    return self;
}

#pragma mark - 信号量使用
+ (void)semaphoreCount {

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:100];
    // 创建为1的信号量
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    for (int i = 0; i < 10; i++) {
        dispatch_async(queue, ^{
            [arrayM addObject:[NSNumber numberWithInt:i]];
            NSLog(@"%@",[NSNumber numberWithInt:i]);
            // 发送信号量
            dispatch_semaphore_signal(sem);
        });
        
        // 等待信号量
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    }
    
}

#pragma mark - 用信号量机制使异步线程完成同步操作
/// 方法一： 串行队列 + 异步任务；缺点：CPU无法得到有效使用
+ (void)syncQueueTask {
    
    dispatch_queue_t queue = dispatch_queue_create("TEST", DISPATCH_QUEUE_SERIAL);
    
    for (NSInteger i = 0; i < 100; i++) {
        dispatch_sync(queue, ^{
            NSLog(@"任务%ld:%@",i,[NSThread currentThread]);
        });
    }
//    dispatch_async(queue, ^{
//        NSLog(@"任务1:%@",[NSThread currentThread]);
//    });
//    dispatch_async(queue, ^{
//        NSLog(@"任务2:%@",[NSThread currentThread]);
//    });
//    dispatch_async(queue, ^{
//        NSLog(@"任务3:%@",[NSThread currentThread]);
//    });
//
//    dispatch_async(queue, ^{
//        NSLog(@"任务11:%@",[NSThread currentThread]);
//    });
//    dispatch_async(queue, ^{
//        NSLog(@"任务22:%@",[NSThread currentThread]);
//    });
//    dispatch_async(queue, ^{
//        NSLog(@"任务33:%@",[NSThread currentThread]);
//    });

}

///方法二： 信号量控制多异步任务同步执行
+ (void)semaphoreSyncTask {
    dispatch_semaphore_t sem = dispatch_semaphore_create(0); // 0 表示创建信号但不发送信号；大于0 表示创建并发送信号
    // 代码执行顺序： 1，2，3，4，5，6
    dispatch_async(dispatch_get_global_queue(0, 0), ^{ // 1
        NSLog(@"任务1:%@",[NSThread currentThread]);
        dispatch_semaphore_signal(sem); // 3
    });
    
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER); // 2
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{ // 4
        NSLog(@"任务2:%@",[NSThread currentThread]);
        dispatch_semaphore_signal(sem);// 6
    });
    
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);// 5
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"任务3:%@",[NSThread currentThread]);
    });
    
    /**
     输出：
     任务1
     任务2
     任务3
     */
}

#pragma mark - 信号量+队列组： 多任务异步执行完回到主线程 （现实中比较常用）
/// 使用信号量实现（一组异步任务全部完成后回到指定线程）
+ (void)semaphoreGroup {
    // test: 不加信号量
    //    dispatch_group_t group = dispatch_group_create();
    //    dispatch_queue_t queue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
    //    dispatch_group_async(group, queue, ^{
    //        NSLog(@"异步任务组1");
    //        dispatch_async(queue, ^{
    //            NSLog(@"异步任务1");
    //        });
    //    });
    //
    //    dispatch_group_async(group, queue, ^{
    //        NSLog(@"异步任务组2");
    //        dispatch_async(queue, ^{
    //            NSLog(@"异步任务2");
    //        });
    //    });
    //
    //    dispatch_group_async(group, queue, ^{
    //        NSLog(@"异步任务组3");
    //        dispatch_async(queue, ^{
    //            NSLog(@"异步任务3");
    //        });
    //    });
    //
    //    dispatch_group_notify(group, queue, ^{
    //        NSLog(@"END");
    //    });
    
    
    // 信号量加持
    dispatch_group_t grp = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("concurrent.queue", DISPATCH_QUEUE_CONCURRENT);

    dispatch_group_async(grp, queue, ^{
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        NSLog(@"异步任务组1: %@",[NSThread currentThread]);
        dispatch_async(queue, ^{
            NSLog(@"异步任务1: %@",[NSThread currentThread]);
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    });

    dispatch_group_async(grp, queue, ^{
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        NSLog(@"异步任务组2: %@",[NSThread currentThread]);
        dispatch_async(queue, ^{
            NSLog(@"异步任务2: %@",[NSThread currentThread]);
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    });

    dispatch_group_async(grp, queue, ^{
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        NSLog(@"异步任务组3: %@",[NSThread currentThread]);
        dispatch_async(queue, ^{
            NSLog(@"异步任务3: %@",[NSThread currentThread]);
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    });

    dispatch_group_notify(grp, dispatch_get_main_queue(), ^{
        NSLog(@"END 回到主线程");
    });
    
}

/// 使用异步队列组 模拟 信号量（原理相似）
+ (void)semaphoreGroup_enter_leave {
    dispatch_group_t group =dispatch_group_create();
    dispatch_queue_t globalQueue=dispatch_get_global_queue(0, 0);
    
    dispatch_group_enter(group);
    dispatch_async(globalQueue, ^{
        NSLog(@"异步任务组1: %@",[NSThread currentThread]);
        dispatch_async(globalQueue, ^{
            NSLog(@"异步任务1: %@",[NSThread currentThread]);
            dispatch_group_leave(group);
        });
    });
    
    dispatch_group_enter(group);
    dispatch_async(globalQueue, ^{
        NSLog(@"异步任务组2: %@",[NSThread currentThread]);
        dispatch_async(globalQueue, ^{
            NSLog(@"异步任务2: %@",[NSThread currentThread]);
            dispatch_group_leave(group);
        });
    });
    
    dispatch_group_enter(group);
    dispatch_async(globalQueue, ^{
        NSLog(@"异步任务组3: %@",[NSThread currentThread]);
       dispatch_async(globalQueue, ^{
            NSLog(@"异步任务3: %@",[NSThread currentThread]);
            dispatch_group_leave(group);
        });
    });
    
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"END %@",[NSThread currentThread]);
    });
}

@end


// 定义block类型
typedef void(^YKBlock)(void);
// 定义获取全局队列方法
#define YK_GLOBAL_QUEUE(block) \
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{\
    while (1) {\
        block();\
    }\
})

static inline void pthread_mutex_init_recursive(pthread_mutex_t *mutex, bool recursive) {
#define YYMUTEX_ASSERT_ON_ERROR(x_) do { \
__unused volatile int res = (x_); \
assert(res == 0); \
} while (0)
    assert(mutex != NULL);
    if (!recursive) {
        // 普通锁
        YYMUTEX_ASSERT_ON_ERROR(pthread_mutex_init(mutex, NULL));
    } else {
        // 递归锁
        pthread_mutexattr_t attr;
        
        YYMUTEX_ASSERT_ON_ERROR(pthread_mutexattr_init (&attr));
        YYMUTEX_ASSERT_ON_ERROR(pthread_mutexattr_settype (&attr, PTHREAD_MUTEX_RECURSIVE));
        YYMUTEX_ASSERT_ON_ERROR(pthread_mutex_init (mutex, &attr));
        YYMUTEX_ASSERT_ON_ERROR(pthread_mutexattr_destroy (&attr));
    }
#undef YYMUTEX_ASSERT_ON_ERROR
}


@implementation YLThreadSync (Lock)
#pragma mark - 互斥锁
/// ① @synchronized
/// @param testInt 形参
- (void)setTestInt:(NSInteger)testInt {
    
    @synchronized (self) {
        _testInt = testInt;
    }
}

- (void)testSynchronized {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // 开了5个窗口(线程)，每个窗口10个售票任务，一直到售完50张票
    for (NSInteger i = 0; i < 5; i++) {
        dispatch_async(queue, ^{
            for (int j = 0; j < 10; j++) {
                @synchronized (self) {
                    NSInteger oldMoney = self.ticketsCount;
                    sleep(.2);
                    oldMoney -= 1;
                    self.ticketsCount = oldMoney;
                    NSLog(@"当前线程：%@ 剩余票数：%ld", [NSThread currentThread],oldMoney);
                }
            }
        });
    }

}

/// ② NSLock
- (void)testNSLock {
    NSLock *lock = [[NSLock alloc] init];
    YKBlock ykBlock = ^{
        [lock lock];
        NSLog(@"执行操作");
        sleep(1);
        [lock unlock];
    };
    
    YK_GLOBAL_QUEUE(ykBlock);
}

/// ③ Pthread 普通互斥锁 (正常使用不会造成死锁)
- (void)testPthread {
    __block pthread_mutex_t lock;
    pthread_mutex_init_recursive(&lock,false);

    YKBlock block0=^{
        NSLog(@"******************************");
        NSLog(@"0线程 %@：加锁",[NSThread currentThread]);
        pthread_mutex_lock(&lock); // -------------- 1 这三处加锁为什么没有引起死锁？
        NSLog(@"线程 0：睡眠 10 秒");
        sleep(10);
        pthread_mutex_unlock(&lock);
        NSLog(@"线程 0：解锁");
        NSLog(@"******************************\n");
        printf("\n");

    };
    YK_GLOBAL_QUEUE(block0);

    YKBlock block1=^{
        NSLog(@"1线程 %@：加锁",[NSThread currentThread]);
        pthread_mutex_lock(&lock);// -------------- 3
        NSLog(@"线程 1：睡眠 3 秒");
        sleep(2);
        pthread_mutex_unlock(&lock);
        NSLog(@"线程 1：解锁");
    };
    YK_GLOBAL_QUEUE(block1);

    
    YKBlock block2=^{
        NSLog(@"2线程 %@：加锁",[NSThread currentThread]);
        pthread_mutex_lock(&lock);// -------------- 3
        NSLog(@"线程 2：睡眠 3 秒");
        sleep(3);
        pthread_mutex_unlock(&lock);
        NSLog(@"线程 2：解锁");
    };
    YK_GLOBAL_QUEUE(block2);
}

// 普通互斥锁 重复加锁会造成死锁
- (void)testPthreadError {
    __block pthread_mutex_t lock;
    pthread_mutex_init_recursive(&lock,false);

    YKBlock block0=^{
        NSLog(@"******************************");
        NSLog(@"0线程 %@：加锁",[NSThread currentThread]);
        pthread_mutex_lock(&lock); // -------------- 1 这三处加锁为什么没有引起死锁？
        NSLog(@"线程 0：睡眠 10 秒");
        sleep(10);
        
        [self testPthreadKill:&lock]; // 未解锁前又加了锁
        
        pthread_mutex_unlock(&lock);
        NSLog(@"线程 0：解锁");
        NSLog(@"******************************\n");
        printf("\n");

    };
    YK_GLOBAL_QUEUE(block0);
}
- (void)testPthreadKill:(pthread_mutex_t *)mutex {
    NSLog(@"1线程 %@：加锁",[NSThread currentThread]);
    pthread_mutex_lock(mutex); // -------------- 2
    NSLog(@"线程 1：睡眠 2 秒");
    sleep(2);
    pthread_mutex_unlock(mutex);
    NSLog(@"线程 1：解锁");
    
}

#pragma mark - 递归锁（互斥锁的一种）；同一个线程可以多次加锁，不会造成死锁

/// 1️⃣ NSRecursiveLock
- (void)testNSRecursiveLock {
    NSRecursiveLock *lock = [[NSRecursiveLock alloc] init];
    YK_GLOBAL_QUEUE(^{
        static void (^RecursiveBlock)(int);
        RecursiveBlock = ^(int value) {
            NSLog(@"*************************");
            [lock lock];
            if (value > 0) {
                NSLog(@"加锁层数 %d", value);
                sleep(value);
                RecursiveBlock(--value);
            }
            [lock unlock];
            NSLog(@"解锁层数：%d",value);
            NSLog(@"*************************");
            printf("\n");

        };
        RecursiveBlock(3);
    });
}

/// 2️⃣ Pthread - recursive (没有跑通)
- (void)testPthread_recursive {
    
//    __block pthread_mutex_t lock;
//    // 初始化属性
//    pthread_mutexattr_t attr;
//    pthread_mutexattr_init(&attr);
//    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
//    // 初始化锁
//    pthread_mutex_init(&lock, &attr);
//    // 销毁属性
//    pthread_mutexattr_destroy(&attr);
//  
//    void (^RecursiveBlock)(int);
//    RecursiveBlock = ^(int value){
//        NSLog(@"*************************");
//        pthread_mutex_lock(&lock);
//        if (value > 0) {
//            NSLog(@"加锁层数 %d", value);
//            sleep(value);
//            RecursiveBlock(--value);
//        }
//        pthread_mutex_unlock(&lock);
//        NSLog(@"解锁层数：%d",value);
//        NSLog(@"*************************");
//        printf("\n");
//        
//    };
//    RecursiveBlock(3);

}
#pragma mark - 条件锁
/// 1️⃣ pthread_cond_wait & pthread_cond_signal 搭配使用
- (void)testPthread_cond {
    __block pthread_mutex_t lock;
    __block pthread_cond_t cond;
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_DEFAULT);
    pthread_mutex_init(&lock, &attr);
    pthread_mutexattr_destroy (&attr);
    
    pthread_cond_init(&cond, NULL);
    // 线程1 加条件锁
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        // 移除元素任务
        pthread_mutex_lock(&lock);
        if (self.data.count == 0) {
            pthread_cond_wait(&cond, &lock);
        }
        [self.data removeLastObject];
        NSLog(@"%@删除了数组最后一个元素",[NSThread currentThread]);
        pthread_mutex_unlock(&lock);
    });

    // 线程2 加条件锁
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        //添加元素任务
        pthread_mutex_lock(&lock);
        [self.data addObject:@"test"];
        NSLog(@"%@ 数组中添加了一个元素,发送激活条件信号",[NSThread currentThread]);
        pthread_cond_signal(&cond);

        pthread_mutex_unlock(&lock);
    });
    
}

// 2️⃣ NSCondition (可以对每个线程分别加锁)
/**
 NSCondition 的对象实际上作为一个锁和一个线程检查器：锁主要为了当检测条件时保护数据源，执行条件引发的任务；线程检查器主要是根据条件决定是否继续运行线程，即线程是否被阻塞。
 
 同时，NSCondition提供更高级的用法。wait和signal，和条件信号量类似。比如我们要监听imageNames数组的个数，当imageNames的个数大于0的时候就执行清空操作。思路是这样的，当imageNames个数大于0时执行清空操作，否则，wait等待执行清空操作。当imageNames个数增加的时候发生signal信号，让等待的线程唤醒继续执行。
 
 NSCondition和NSLock、@synchronized等是不同的是，NSCondition可以给每个线程分别加锁，加锁后不影响其他线程进入临界区。这是非常强大。但是正是因为这种分别加锁的方式，NSCondition使用wait并使用加锁后并不能真正的解决资源的竞争。比如我们有个需求：不能让m<0。假设当前m=0,线程A要判断到m>0为假,执行等待；线程B执行了m=1操作，并唤醒线程A执行m-1操作的同时线程C判断到m>0，因为他们在不同的线程锁里面，同样判断为真也执行了m-1，这个时候线程A和线程C都会执行m-1,但是m=1，结果就会造成m=-1.
 
 当我用数组做删除试验时，做增删操作并不是每次都会出现，大概3-4次后会出现。单纯的使用lock、unlock是没有问题的。
 */
- (void)testNSCondition {
    NSCondition* condition_lock = [[NSCondition alloc] init];

    // 线程1 加条件锁
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        // 移除元素任务
        [condition_lock lock];
        if (self.data.count == 0) {
            [condition_lock wait];
        }
        [self.data removeLastObject];
        NSLog(@"%@删除了数组最后一个元素",[NSThread currentThread]);
        [condition_lock unlock];
    });

    // 线程2 加条件锁
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        //添加元素任务
        [condition_lock lock];
        [self.data addObject:@"test"];
        NSLog(@"%@ 数组中添加了一个元素,发送激活条件信号",[NSThread currentThread]);
        [condition_lock signal];
        [condition_lock unlock];
    });


}

// 3️⃣ NSCoditionLock
/**
 lock不分条件，如果锁没被申请，直接执行代码

 unlock不会清空条件，之后满足条件的锁还会执行

 unlockWithCondition:我的理解就是设置解锁条件(同一时刻只有一个条件，如果已经设置条件，相当于修改条件)

 lockWhenCondition:满足特定条件,执行相应代码

 NSConditionLock同样实现了NSLocking协议，试验过程中发现性能很低。

 NSConditionLock也可以像NSCondition一样做多线程之间的任务等待调用，而且是线程安全的。
 */
- (void)testNSConditionLock {
    NSConditionLock* conditionLock = [[NSConditionLock alloc] initWithCondition:1]; // 初始条件为1

    // 线程1 任务
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [conditionLock lock];
        NSLog(@"条件1 加锁，%@",[NSThread currentThread]);
        sleep(1);
        [conditionLock unlockWithCondition:2];
    });

    // 线程2 任务
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        [conditionLock lockWhenCondition:2];
        NSLog(@"条件2 加锁，%@",[NSThread currentThread]);
        sleep(1);
        [conditionLock unlockWithCondition:3];
    });

}


#pragma mark - 分布式锁

#pragma mark - 读写锁
/**
 读写锁实际是一种特殊的自旋锁，它把对共享资源的访问者划分成读者和写者，读者只对共享资源进行读访问，写者则需要对共享资源进行写操作。这种锁相对于自旋锁而言，能提高并发性，因为在多处理器系统中，它允许同时有多个读者来访问共享资源，最大可能的读者数为实际的逻辑CPU数。写者是排他性的，一个读写锁同时只能有一个写者或多个读者（与CPU数相关），但不能同时既有读者又有写者。
 
 iOS中的读写安全方案需要注意一下场景
 1、同一时间，只能有1个线程进行写的操作
 2、同一时间，允许有多个线程进行读的操作
 3、同一时间，不允许既有写的操作，又有读的操作

 */


// 1️⃣ dispatch_barrier_async
/**
 `dispatch_barrier_async`这个函数传入的并发队列必须是自己通过dispatch_queue_cretate创建的 如果传入的是一个串行或是一个全局的并发队列，那这个函数便等同于dispatch_async函数的效果
 */
- (void)test_rwLock_barrier {
    dispatch_queue_t queue = dispatch_queue_create("rw_queue", DISPATCH_QUEUE_CONCURRENT);

    for (NSInteger i = 0; i < 10; i++) {
        dispatch_async(queue, ^{
            NSLog(@"执行读操作 %ld",i);
        });
    }
    dispatch_barrier_async(queue, ^{
        NSLog(@"执行写操作");
    });
  
}

// 2️⃣ pthread_rwlock_t
- (void)testPthread_rwlock {
    __block pthread_rwlock_t lock;
    pthread_rwlock_init(&lock, NULL);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 10; i++) {
        dispatch_async(queue, ^{
            pthread_rwlock_rdlock(&lock);
            sleep(1);
            NSLog(@"正在执行读操作 %d，%@",i,[NSThread currentThread]);
            pthread_rwlock_unlock(&lock);
        });
        
        dispatch_async(queue, ^{
            pthread_rwlock_wrlock(&lock);
            sleep(1);
            NSLog(@"正在执行写操作 %d，%@",i,[NSThread currentThread]);
            pthread_rwlock_unlock(&lock);
        });
        
    }
}

#pragma mark - 自旋锁
/**
 自旋锁和互斥锁
 自旋锁(Spin lock)
 自旋锁与互斥锁有点类似，只是自旋锁不会引起调用者睡眠，如果自旋锁已经被别的执行单元保持，调用者就一直循环在那里看是 否该自旋锁的保持者已经释放了锁，"自旋"一词就是因此而得名。其作用是为了解决某项资源的互斥使用。因为自旋锁不会引起调用者睡眠，所以自旋锁的效率远 高于互斥锁。虽然它的效率比互斥锁高，但是它也有些不足之处：
     1、自旋锁一直占用CPU，他在未获得锁的情况下，一直运行－－自旋，所以占用着CPU，如果不能在很短的时 间内获得锁，这无疑会使CPU效率降低。
     2、在用自旋锁时有可能造成死锁，当递归调用时有可能造成死锁，调用有些其他函数也可能造成死锁，如 copy_to_user()、copy_from_user()、kmalloc()等。
     因此我们要慎重使用自旋锁，自旋锁只有在内核可抢占式或SMP的情况下才真正需要，在单CPU且不可抢占式的内核下，自旋锁的操作为空操作。自旋锁适用于锁使用者保持锁时间比较短的情况下。
 互斥锁
 互斥锁属于sleep-waiting类型的锁。例如在一个双核的机器上有两个线程(线程A和线程B)，它们分别运行在Core0和 Core1上。假设线程A想要通过pthread_mutex_lock操作去得到一个临界区的锁，而此时这个锁正被线程B所持有，那么线程A就会被阻塞 (blocking)，Core0 会在此时进行上下文切换(Context Switch)将线程A置于等待队列中，此时Core0就可以运行其他的任务(例如另一个线程C)而不必进行忙等待。而自旋锁则不然，它属于busy-waiting类型的锁，如果线程A是使用pthread_spin_lock操作去请求锁，那么线程A就会一直在 Core0上进行忙等待并不停的进行锁请求，直到得到这个锁为止。
 两种锁的加锁原理
 互斥锁：线程会从sleep（加锁）——>running（解锁），过程中有上下文的切换，cpu的抢占，信号的发送等开销。
 自旋锁：线程一直是running(加锁——>解锁)，死循环检测锁的标志位，机制不复杂。
 对比
 互斥锁的起始原始开销要高于自旋锁，但是基本是一劳永逸，临界区持锁时间的大小并不会对互斥锁的开销造成影响，而自旋锁是死循环检测，加锁全程消耗cpu，起始开销虽然低于互斥锁，但是随着持锁时间，加锁的开销是线性增长。
 两种锁的应用
 互斥锁用于临界区持锁时间比较长的操作，比如下面这些情况都可以考虑

 1 临界区有IO操作
 2 临界区代码复杂或者循环量大
 3 临界区竞争非常激烈
 4 单核处理器

 至于自旋锁就主要用在临界区持锁时间非常短且CPU资源不紧张的情况下，自旋锁一般用于多核的服务器。

*/
// 1️⃣ OSSpinLock 不安全（iOS10 已废弃）
- (void)testOSSpinLock {
    //初始化
    __block OSSpinLock lock = OS_SPINLOCK_INIT;
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);

    for (NSInteger i = 0; i < 5; i++) {
        dispatch_async(queue, ^{
            for (int i = 0; i < 10; i++) {
                //加锁
                OSSpinLockLock(&lock);
                
                NSInteger oldMoney = self.ticketsCount;
                sleep(.2);
                oldMoney -= 1;
                self.ticketsCount = oldMoney;
                
                NSLog(@"当前剩余票数-> %ld", oldMoney);
                //解锁
                OSSpinLockUnlock(&lock);
            }
        });
    }
}

#pragma mark - os_unfair_lock
- (void)test_unfair_lock {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);

    if (@available(iOS 10.0, *)) {
        __block os_unfair_lock lock = OS_UNFAIR_LOCK_INIT;
        

        for (NSInteger i = 0; i < 5; i++) {
            dispatch_async(queue, ^{
                for (int i = 0; i < 10; i++) {
                    //加锁
                    os_unfair_lock_lock(&lock);
                    
                    NSInteger oldMoney = self.ticketsCount;
                    sleep(.2);
                    oldMoney -= 1;
                    self.ticketsCount = oldMoney;
                    
                    NSLog(@"当前剩余票数-> %ld", oldMoney);
                    //解锁
                    os_unfair_lock_unlock(&lock);
                }

            });
        }

    } else {
        // Fallback on earlier versions
    }

}

#pragma mark - 原子性
/**
 atomic的实现机制
 使用atomic 修饰属性，编译器会设置默认读写方法为原子读写，并使用互斥锁添加保护。
 static inline void reallySetProperty(id self, SEL _cmd,
     id newValue, ptrdiff_t offset, bool atomic, bool copy, bool mutableCopy) {
     //偏移为0说明改的是isa
     if (offset == 0) {
         object_setClass(self, newValue);
         return;
     }

     id oldValue;
     id *slot = (id*) ((char*)self + offset);//获取原值
     //根据特性拷贝
     if (copy) {
         newValue = [newValue copyWithZone:nil];
     } else if (mutableCopy) {
         newValue = [newValue mutableCopyWithZone:nil];
     } else {
         if (*slot == newValue) return;
         newValue = objc_retain(newValue);
     }
     //判断原子性
     if (!atomic) {
         //非原子直接赋值
         oldValue = *slot;
         *slot = newValue;
     } else {
         //原子操作使用自旋锁
         spinlock_t& slotlock = PropertyLocks[slot];
         slotlock.lock();
         oldValue = *slot;
         *slot = newValue;
         slotlock.unlock();
     }

     objc_release(oldValue);
 }

 id objc_getProperty(id self, SEL _cmd, ptrdiff_t offset, BOOL atomic) {
     // 取isa
     if (offset == 0) {
         return object_getClass(self);
     }

     // 非原子操作直接返回
     id *slot = (id*) ((char*)self + offset);
     if (!atomic) return *slot;
         
     // 原子操作自旋锁
     spinlock_t& slotlock = PropertyLocks[slot];
     slotlock.lock();
     id value = objc_retain(*slot);
     slotlock.unlock();
     
     // 出于性能考虑，在锁之外autorelease
     return objc_autoreleaseReturnValue(value);
 }

 
 ---------------------------------------------------------------------------
 为什么不能保证绝对的线程安全？
 单独的原子操作绝对是线程安全的，但是组合一起的操作就不能保证。

 */
#pragma mark - ONCE

@end
