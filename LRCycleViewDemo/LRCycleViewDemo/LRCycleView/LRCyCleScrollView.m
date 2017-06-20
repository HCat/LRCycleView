//
//  LRCyCleScrollView.m
//  LRCycleViewDemo
//
//  Created by hcat on 2017/6/20.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "LRCyCleScrollView.h"

@interface LRCyCleScrollView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,assign) BOOL scrollViewBounces;

@property (nonatomic,copy) NSArray *arr_images;


@end


@implementation LRCyCleScrollView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame withImages:(NSArray *)imagesArray{

    self = [super initWithFrame:frame];
    
    if (self) {
        self.arr_images = imagesArray;
        self.scrollViewBounces = YES;
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollViewBounces = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.scrollViewBounces = YES;
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSArray *subViews = self.subviews;
    [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
//    [self initialize];
//    
//    if (self.completeBlock) {
//        self.completeBlock();
//    }
}



@end
