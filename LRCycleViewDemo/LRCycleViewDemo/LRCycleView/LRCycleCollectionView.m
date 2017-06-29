//
//  LRCycleCollectionView.m
//  LRCycleViewDemo
//
//  Created by hcat on 2017/6/29.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "LRCycleCollectionView.h"
#import "NSTimer+UnRetain.h"
#import "UIImageView+WebCache.h"

#define DEFINEAUTOPLAYTIME 2.0f


@interface LRCycleCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic,strong) UIPageControl * pageControl;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,copy) NSArray *arr_images;

@property (nonatomic,assign) NSInteger currentIndex;

@end

@implementation LRCycleCollectionView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame withImages:(NSArray *)imagesArray{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        _arr_sourceImages = [imagesArray copy];
        self.isCanCycle = YES;
        _autoPlayTimeInterval = DEFINEAUTOPLAYTIME;
        
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _isCanCycle = YES;
        _autoPlayTimeInterval = DEFINEAUTOPLAYTIME;
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _isCanCycle = YES;
        _autoPlayTimeInterval = DEFINEAUTOPLAYTIME;
        
    }
    return self;
}


#pragma mark - set && get

- (void)setIsCanCycle:(BOOL)isCanCycle{
    
    NSAssert(_arr_sourceImages != nil, @"arr_images must not nil");

    if (_arr_sourceImages.count == 1) {
        _isCanCycle = NO;
    }else{
        _isCanCycle = isCanCycle;
    }
    
    self.arr_sourceImages = _arr_sourceImages;

}

- (void)setArr_sourceImages:(NSArray *)arr_sourceImages{

    _arr_sourceImages = [arr_sourceImages copy];
    
    if (_arr_sourceImages && _arr_sourceImages.count > 0) {
    
        if (_isCanCycle) {
            
            NSMutableArray *cycleDatasource = [_arr_sourceImages mutableCopy];
            [cycleDatasource insertObject:[_arr_sourceImages lastObject] atIndex:0];
            [cycleDatasource addObject:[_arr_sourceImages objectAtIndex:0]];
            self.arr_images = cycleDatasource;
        
        }else{
            
            self.arr_images = _arr_sourceImages;
            
        }
    
    }else{
        self.arr_images = _arr_sourceImages;
    }
    
}


- (void)setAutoPlayTimeInterval:(NSTimeInterval)autoPlayTimeInterval{

    _autoPlayTimeInterval = autoPlayTimeInterval;
    
    if




}

#pragma mark - layoutSubviews

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor lightGrayColor];
    NSArray *subViews = self.subviews;
    [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self invalidateTimer];
    
    [self initialize];
    
}

#pragma mark - 初始化内部视图

- (void)initialize{
    
    [self createCollectionView];
    [self createPageControl];
    
}

#pragma mark - 初始化collectionView


- (void)createCollectionView{
    
    
    
    
    
    
}

#pragma mark - 初始化PageControl

- (void)createPageControl{
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 13 *_arr_images.count, 25)];
    _pageControl.center = CGPointMake(CGRectGetWidth(_scrollView.frame)/2, CGRectGetMaxY(_scrollView.frame) - CGRectGetHeight(_pageControl.frame)/2);
    _pageControl.userInteractionEnabled = NO;
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    
    [self addSubview:_pageControl];
    
}



#pragma mark - NSTimer定时器相关

//初始化定时器

- (void)createTimer{
    
    __weak typeof(self) weakSelf = self;
    
    //这里用timer的block方法， 主要是防止timer引起的循环引用
    self.timer = [NSTimer lr_scheduledTimerWithTimeInterval:_autoPlayTimeInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf timerAction];
    }];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
}

//释放定时器

- (void)invalidateTimer{
    
    if (_timer) {
        [_timer invalidate];
        self.timer = nil;
        
    }
    
}

- (void)timerAction{
    
   
    
   
    
}



@end
