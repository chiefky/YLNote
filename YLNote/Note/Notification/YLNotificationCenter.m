//
//  YLNotificationCenter.m
//  YLNote
//
//  Created by tangh on 2020/7/27.
//  Copyright © 2020 tangh. All rights reserved.
//

#import "YLNotificationCenter.h"
#import "YLNotification.h"
#import "YLNotificationInfoModel.h"

typedef void(^YLNotificationBlock)(YLNotification *);

@interface YLNotificationInfoModel ()
@property (nonatomic, copy) NSString *name;
@property (nonatomic,unsafe_unretained) id observer;
@property (nonatomic,unsafe_unretained) id object;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (readwrite, nonatomic, assign) SEL selector;
@property (readwrite, nonatomic, copy) YLNotificationBlock block;

- (instancetype)initWithName:(nonnull NSString *)name observer:(nonnull id)obs object:(nullable id)obj  queue:(nullable NSOperationQueue *)queue;

@end

@implementation YLNotificationInfoModel
- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}

- (instancetype)initWithName:(nonnull NSString *)name observer:(nonnull id)obs object:(nullable id)obj  queue:(nullable NSOperationQueue *)queue {
    self = [super init];
    if (self) {
        self.name = name;
        self.queue = queue ?: [NSOperationQueue currentQueue];
        self.object = obj;
        self.observer = obs;
    }
    return self;
}

@end

@interface YLNotificationCenter ()

@property (readwrite, nonatomic, strong) NSMutableDictionary *observerMap;

@end

static YLNotificationCenter *center;
static NSString *key_observersDic_noContent = @"key_observersDic_noContent";

@implementation YLNotificationCenter

+ (instancetype)defaultCenter {
    if (!center) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            center = [[YLNotificationCenter alloc] init];
        });
    }
    
    return center;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (!center) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            center = [super allocWithZone:zone];
        });
    }
    return center;
}
#pragma mark - methods
- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject {
    if (!aSelector || !observer) {
        return;
    }
    YLNotificationInfoModel *infoModel = [[YLNotificationInfoModel alloc] initWithName:aName observer:observer object:anObject queue:nil];
    infoModel.selector = aSelector;
    [self addObserverModel:infoModel];
}

- (id<NSObject>)addObserverForName:(NSString *)name object:(id)obj queue:(NSOperationQueue *)queue usingBlock:(void (^)(YLNotification * _Nonnull))block {
    if (!block) {
        return nil;
    }
    NSObject *observer = [NSObject new];
    YLNotificationInfoModel *infoModel = [[YLNotificationInfoModel alloc] initWithName:name observer:observer object:obj queue:queue];
    infoModel.block = block;
    [self addObserverModel:infoModel];
    return observer;
}

- (void)addObserverModel:(YLNotificationInfoModel *)model {
    NSString *key = model.name && [model.name isKindOfClass:NSString.class] ? model.name : key_observersDic_noContent;
    NSMutableDictionary *obsDict = self.observerMap;
    @synchronized (obsDict) {
        if ([obsDict objectForKey:key]) {
            NSMutableArray *tmpArr = [obsDict objectForKey:key];
            [tmpArr addObject:model];
        } else {
            NSMutableArray *tmpArr = [NSMutableArray array];
            [tmpArr addObject:model];
            [obsDict setObject:tmpArr forKey:key];
        }
    }
}

- (void)postNotificationName:(NSNotificationName)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo {
    YLNotification *noti = [[YLNotification alloc] initWithName:aName object:anObject prama:aUserInfo];
    [self postNotification:noti];
}

- (void)postNotification:(YLNotification *)notification {
    if (!notification) {
        return;
    }
    NSMutableDictionary *dict = self.observerMap;
    @synchronized (dict) {
        NSMutableArray *tmpArry = [dict objectForKey:notification.keyName];
        [tmpArry.copy enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[YLNotificationInfoModel class]]) {
                YLNotificationInfoModel *model = obj;
                if (model.observer) {
                    if (model.selector ) {
                        if ([model.observer respondsToSelector:model.selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                            
                            [model.observer performSelector:model.selector withObject:notification];
#pragma clang diagnostic pop
                            
                        }
                    } else if(model.block) {
                        NSBlockOperation *opera = [NSBlockOperation blockOperationWithBlock:^{
                            model.block(notification);
                        }];
                        [model.queue addOperation:opera];
                    }
                } else {
                    [tmpArry removeObject:model];
                }
            }
        }];
    }
}

- (void)removeObserver:(id)observer name:(NSString *)aName object:(id)anObject {
    if (!observer) {
        return;
    }
    NSMutableDictionary *obsDict = self.observerMap;
    NSString *key = aName && [aName isKindOfClass: NSString.class] ? aName : key_observersDic_noContent;
    NSMutableArray *tmpArr = [obsDict objectForKey:key];
    if (tmpArr) {
      [tmpArr.copy enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
          if ([obj isKindOfClass:[YLNotificationInfoModel class]]) {
              YLNotificationInfoModel *model = obj;
              if ([model.observer isEqual:observer] && (!anObject || anObject == model.object)) {
                  [tmpArr removeObject:model];
              }
          }
      }];
  }
}

- (void)removeObserver:(id)observer {
    if (!observer) {
        return;
    }
    [self removeObserver:observer name:nil object:nil];
}

#pragma mark - lazy
- (NSDictionary *)observerMap {
    if (!_observerMap) {
        _observerMap = [NSMutableDictionary dictionary];
    }
    return _observerMap;
}

@end
