//
//  YLSDTableViewCell.m
//  TestDemo
//
//  Created by tangh on 2020/7/12.
//  Copyright © 2020 tangh. All rights reserved.
//

#import "YLSDTableViewCell.h"
#import <SDWebImage/SDWebImage.h>
#import <Masonry/Masonry.h>

@interface YLSDTableViewCell ()

@property (nonatomic,strong) UIImageView *urlImage;
@property (nonatomic,strong) UIImageView *fileImage;
@property (nonatomic,strong) UIImageView *gifImage;
@property (nonatomic,strong) UIProgressView *progressView;

@end

@implementation YLSDTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    self.fileImage = [UIImageView new];
    [self.contentView addSubview:self.fileImage];
    [self.fileImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.width.mas_equalTo(80);
        make.bottom.mas_equalTo(-10);
    }];
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.progressTintColor = [UIColor redColor];
    [self.fileImage addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.height.mas_equalTo(5);
        make.width.mas_equalTo(self.fileImage.mas_width);
    }];
//
//    self.gifImage = [UIImageView new];
//    [self.contentView addSubview:self.gifImage];
//    [self.gifImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(10);
//        make.left.mas_equalTo(self.fileImage.mas_right).offset(10);
//        make.width.mas_equalTo(100);
//        make.bottom.mas_equalTo(-10);
//    }];
//    
    
}

- (void)reloadData:(NSString *)url {
    [self.fileImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"netImagePlaceHolderImage"] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView.progress = (float)receivedSize / (float)expectedSize;
        });
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressView removeFromSuperview];
        });

    }];
}

@end
