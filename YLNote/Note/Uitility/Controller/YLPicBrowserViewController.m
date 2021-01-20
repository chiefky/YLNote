//
//  YLPicBrowserViewController.m
//  YLNote
//
//  Created by tangh on 2021/1/18.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLPicBrowserViewController.h"
#import <YBImageBrowser/YBImageBrowser.h>
#import "YLAlertManager.h"
#import "YLCustomTools.h"

@interface YLPicBrowserViewController ()<YBImageBrowserDataSource> {
    NSArray *imageArray;
    NSMutableArray *imageViewArray;
    NSInteger currentIndex;
    
}

@property (nonatomic,strong)YBImageBrowser *browser;
@property (nonatomic,strong)NSMutableArray<YBIBDataProtocol> *dataSourceArray;

@end

@implementation YLPicBrowserViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getAuthonForPhotoLibrary];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    
}

- (void)setupUI {    
    self.browser = [YBImageBrowser new];
    //只支持竖屏
    self.browser.supportedOrientations = UIInterfaceOrientationMaskPortrait;
    //设置数据源，也可以用dataSourceArray
    self.browser.dataSource = self;
    //当前页
    self.browser.currentPage = self.selectedIndex;
    //设置转场动画为空
    self.browser.defaultAnimatedTransition.showType = YBIBTransitionTypeNone;
    self.browser.defaultAnimatedTransition.hideType = YBIBTransitionTypeNone;
    //展示图片主视图
    [self.browser showToView:self.view containerSize:self.view.bounds.size];
    //解决右滑返回和图片浏览器滑动冲突
    [self.browser.collectionView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

#pragma mark - YBImageBrowserDataSource
- (NSInteger)yb_numberOfCellsInImageBrowser:(YBImageBrowser *)imageBrowser {
    return self.imageAssets.count;
}

- (id<YBIBDataProtocol>)yb_imageBrowser:(YBImageBrowser *)imageBrowser dataForCellAtIndex:(NSInteger)index {
    PHAsset *asset = self.imageAssets[index];
    YBIBImageData *data = [[YBIBImageData alloc] init];
    data.imagePHAsset = asset;
    data.interactionProfile.disable = YES;
    //单击手势闭包回调
    data.singleTouchBlock = ^(YBIBImageData * _Nonnull imageData) {
        //        [self.toolViewHandler hideTopView];
    };
    return data;
}

#pragma mark - 相册授权
- (void)getAuthonForPhotoLibrary {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        //没有授权
        if(status== PHAuthorizationStatusRestricted) {
            NSLog(@"没有授权");
        }
        else if (status==PHAuthorizationStatusDenied) {
            NSLog(@"没有授权-2");
        }
        else {//已经授权
            __weak typeof(self) weakSelf = self;
            [self askPhotoHandler:^(NSMutableArray *assets) {
                weakSelf.imageAssets = assets;
                [weakSelf.browser reloadData];
            }];
        }
    }];
}

/// 授权失败提示
- (void)showAlert {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *appName  = [info objectForKey:@"CFBundleDisplayName"];
    appName            = appName ? appName : [info objectForKey:@"CFBundleName"];
    NSString *message  = [NSString stringWithFormat:@"请在系统设置中允许“%@”访问照片!", appName];
    [YLAlertManager showAlertWithTitle:@"无法访问" message:message actionTitle:@"OK" handler:^(UIAlertAction * _Nonnull action) {
        
    }];
}

- (void)askPhotoHandler:(void(^)(NSMutableArray *assets)) complate {
    NSMutableArray<PHAsset *> *assets = [NSMutableArray array];
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //ascending 为YES时，按照照片的创建时间升序排列;为NO时，则降序排列
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHAssetMediaType type = PHAssetMediaTypeImage;
    
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:type options:option];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            PHAsset *asset = (PHAsset *)obj;
            NSInteger type = asset.mediaType;
            //照片
            if(type == 1){
                [assets addObject:asset];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            complate(assets);
        });
    });
}
#pragma mark - lazy
//- (NSMutableArray<YBIBDataProtocol> *)dataSourceArray {
//    if (!_dataSourceArray) {
//        _dataSourceArray = [NSMutableArray arrayWithArray:imageArray];
//    }
//    return _dataSourceArray;
//}
- (NSMutableArray<PHAsset *> *)imageAssets {
    if (!_imageAssets) {
        _imageAssets = [NSMutableArray array];
    }
    return _imageAssets;
}
@end
