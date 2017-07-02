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
#import "LRCycleCollectionCell.h"

#define DEFINEAUTOPLAYTIME 2.0f
#define kCollectionViewCellID @"kCollectionViewCellID"


@interface LRCycleCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
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
    
    [_collectionView reloadData];
    
}


- (void)setAutoPlayTimeInterval:(NSTimeInterval)autoPlayTimeInterval{

    _autoPlayTimeInterval = autoPlayTimeInterval;
    
    [self invalidateTimer];
    
    if(_autoPlayTimeInterval > 0){
        
        [self createTimer];
        
    }

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
    
    [self setAutoPlayTimeInterval:_autoPlayTimeInterval];
    
}

#pragma mark - 初始化collectionView

- (void)createCollectionView{
    
    CGFloat contentWight = CGRectGetWidth(self.frame);
    CGFloat contentheight = CGRectGetHeight(self.frame);
    
    _flowLayout = [UICollectionViewFlowLayout new];
    _flowLayout.itemSize = CGSizeMake(contentWight, contentheight);
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout.minimumLineSpacing = 0;
    _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) collectionViewLayout:_flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[LRCycleCollectionCell class] forCellWithReuseIdentifier:kCollectionViewCellID];
    [self addSubview:_collectionView];
    
}

#pragma mark - 初始化PageControl

- (void)createPageControl{
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 13 *_arr_images.count, 25)];
    _pageControl.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetMaxY(self.frame) - CGRectGetHeight(_pageControl.frame)/2);
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


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
 
    if (_arr_images) {
        return _arr_images.count;
    }else{
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LRCycleCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellID forIndexPath:indexPath];
    
    if (self.arr_images && self.arr_images.count > 0) {
        
        id t_image = self.arr_images[indexPath.row];
        cell.image = t_image;
        
    }else{
         cell.image = _image_null;
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isCanCycle && _arr_images.count > 3) {
        
        if (self.selectedBlock) {
           self.selectedBlock(indexPath.row - 1);
        }
        
    }else{
        
        if (self.selectedBlock) {
            self.selectedBlock(indexPath.row);
        }
        
    }
}


#pragma mark - UIScrollViewDelegate


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self invalidateTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ((_isCanCycle && _arr_images.count > 3) || (!_isCanCycle &&_arr_images.count >= 2)) {
        [self createTimer];
    }
}




@end
