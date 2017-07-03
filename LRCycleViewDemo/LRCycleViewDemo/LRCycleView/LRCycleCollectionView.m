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
        _isCanCycle = YES;
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

    if (_arr_sourceImages.count == 1 || !_arr_sourceImages) {
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
    
    /* 设置pageControl显示 */
    _pageControl.numberOfPages = _arr_sourceImages.count;
    _pageControl.currentPage = 0;
    self.currentIndex = 0;
    
    if (_isCanCycle) {
        self.collectionView.bounces = YES;
        self.currentIndex = 1;
    }else{
        self.collectionView.bounces = NO;
        
    }
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    [self setAutoPlayTimeInterval:_autoPlayTimeInterval];
    
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

    [self initialize];
    
}

#pragma mark - 初始化内部视图

- (void)initialize{
    
    [self createCollectionView];
    [self createPageControl];
    
    [self setArr_sourceImages:_arr_sourceImages];
    
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
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.pagingEnabled = YES;
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
    _pageControl.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame) - CGRectGetHeight(_pageControl.frame)/2);
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
    
    if (!_isCanCycle) {
        if (_currentIndex == _arr_images.count - 1) {
            _currentIndex = 0;
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            return;
        }
    }
    
    _currentIndex ++;
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
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


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat target_x = scrollView.contentOffset.x;
    CGFloat item_width = CGRectGetWidth(scrollView.frame);
    
    
    /* 当滑动到页面的一半的时候视为下一张图片, 这里以当前滑动位置是否超过图片一半来判断当前页 */
    _currentIndex = (target_x + item_width/2) / item_width;
    
    /* 循环滚动时候的边缘判断 */
    if (_isCanCycle && _arr_images.count > 3) {

        if (target_x >= item_width * (_arr_images.count - 1)) {
            
            /* 当可以循环滚动时候，滑动到数组最后一张的时候，让scrollView置换到数组第1张位置 */
           
            _currentIndex = 1;
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            
        }else if (target_x <= 0){
            
            /* 当循环滚动的时候，滚动到数组第0张的时候，让scrollView设置到数组倒数第2张的位置 */
            _currentIndex = _arr_images.count - 2;
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            
        }
    }
    
    
    if (_pageControl) {
        
        if (_isCanCycle && _arr_images.count > 3) {
            
            _pageControl.currentPage = _currentIndex - 1;
            
        }else{
            
            _pageControl.currentPage = _currentIndex;
            
        }
        
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self invalidateTimer];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if ((_isCanCycle && _arr_images.count > 3) || (!_isCanCycle &&_arr_images.count >= 2)) {
        [self createTimer];
    }
    
}

- (void)dealloc{
    
    NSLog(@"LRCycleCollectionView dealloc");
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
}

@end
