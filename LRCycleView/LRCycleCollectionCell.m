//
//  LRCycleCollectionCell.m
//  LRCycleViewDemo
//
//  Created by hcat on 2017/6/30.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "LRCycleCollectionCell.h"
#import "UIImageView+WebCache.h"


@interface LRCycleCollectionCell ()

@property (nonatomic,strong) UIImageView *imageView;


@end

@implementation LRCycleCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        [self imageView];
        
        
    }
    
    return self;
}

- (UIImageView *)imageView{

    if (!_imageView) {
        _imageView = [UIImageView new];
        [self.contentView addSubview:_imageView];
    }
    
    return _imageView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.frame = self.bounds;
}


- (void)setImage:(id)image{

    _image = image;
    
    if ([_image isKindOfClass:[UIImage class]]) {
        
        _imageView.image = _image;
        
    }else if ([_image isKindOfClass:[NSString class]] || [_image isKindOfClass:[NSURL class]]) {
        
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activity startAnimating];
        activity.center = CGPointMake(CGRectGetWidth(_imageView.frame) * 0.5, CGRectGetHeight(_imageView.frame) * 0.5);
        [activity setHidesWhenStopped:true];
        [_imageView addSubview:activity];
        
        NSURL *url_image = [_image isKindOfClass:[NSString class]] ? [NSURL URLWithString:_image] : _image;
        
        __weak typeof(self) weakSelf = self;
        [_imageView sd_setImageWithURL:url_image placeholderImage:_image_placeHolder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [activity stopAnimating];
            [weakSelf.imageView setImage:image];
        }];
        
    }
    
}

@end
