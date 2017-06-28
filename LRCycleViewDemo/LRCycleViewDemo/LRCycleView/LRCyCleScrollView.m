//
//  LRCyCleScrollView.m
//  LRCycleViewDemo
//
//  Created by hcat on 2017/6/20.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "LRCyCleScrollView.h"
#import "NSTimer+UnRetain.h"
#import "UIImageView+WebCache.h"

#define DEFINEAUTOPLAYTIME 3.0f


@interface LRCyCleScrollView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) UIPageControl * pageControl;
@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,assign) BOOL scrollViewBounces;

@property (nonatomic,assign) NSUInteger layoutCount;    //layout调用次数,用于调试用的

@property (nonatomic,assign) NSInteger currentIndex;   //当前索引页
@property (nonatomic,assign) NSInteger count;          //图片数据的数目

@property (nonatomic,copy) NSArray *arr_images;

@end


@implementation LRCyCleScrollView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame withImages:(NSArray *)imagesArray{

    self = [super initWithFrame:frame];
    
    if (self) {
        self.arr_sourceImages = imagesArray;
        self.isCanCycle = YES;
        self.autoPlayTimeInterval = DEFINEAUTOPLAYTIME;
        
        
        self.layoutCount = 0;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.isCanCycle = YES;
        self.autoPlayTimeInterval = DEFINEAUTOPLAYTIME;
       
        self.layoutCount = 0;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.isCanCycle = YES;
        self.autoPlayTimeInterval = DEFINEAUTOPLAYTIME;
    
        self.layoutCount = 0;
    }
    return self;
}

#pragma mark - public Methods

- (void)reloadData{
    [self setNeedsLayout];
}

- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated{



}




#pragma mark - set && get 

- (void)setIsCanCycle:(BOOL)isCanCycle{

    _isCanCycle = isCanCycle;
    if (_isCanCycle) {
        self.scrollViewBounces = YES;
    }else{
        self.scrollViewBounces = NO;
    }

}

#pragma mark -

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSArray *subViews = self.subviews;
    [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self invalidateTimer];
    self.arr_images = _arr_sourceImages;
    
    [self initialize];
    
}

#pragma mark - 初始化内部视图

- (void)initialize{

    [self createScrollView];
    [self createPageControl];
    
    [self loadData];
    
    if (_autoPlayTimeInterval > 0) {
        
        //这里有两种条件来开始自动轮播，一种是循环播放，图片数量要大于3张；另外是不循环播放，图片数量大于2张
        
        if ((_isCanCycle && _arr_images.count > 3) || (!_isCanCycle && _arr_images.count >= 2)) {
            [self createTimer];
        }
        
    }

}

#pragma mark - 初始化ScrollView


- (void)createScrollView{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = _scrollViewBounces;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = self.autoresizingMask;
    [self addSubview:_scrollView];

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

#pragma mark - 定时器相关

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

    [_timer invalidate];
    self.timer = nil;

}

- (void)timerAction{

    CGFloat item_width = CGRectGetWidth(_scrollView.frame);
    
    if (!_isCanCycle) {
        if (_currentIndex == _arr_images.count - 1) {
            _currentIndex = 0;
            [_scrollView setContentOffset:CGPointMake(item_width * _currentIndex, 0) animated:NO];
            return;
        }
    }
    
    _currentIndex ++;
    [_scrollView setContentOffset:CGPointMake(item_width * _currentIndex, 0) animated:YES];
    
}

#pragma mark - loadData

- (void)loadData{

    NSAssert(_arr_images != nil, @"arr_images must not nil");
    
    if (_arr_images.count == 0) {
        
        /*如果数组为空的话，则显示无数据页面*/
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = _image_null;
        [_scrollView addSubview:imageView];
        
        return;
    }
    
    /* 设置pageControl显示 */
    _pageControl.numberOfPages = _arr_images.count;
    _pageControl.currentPage = 0;
    self.currentIndex = 0;
   
    /* 当数组只有一个元素的时候设置不进行循环滚动了 */
    if (_arr_images.count == 1) {
        self.isCanCycle = NO;
    }
    
    /* 如果需要循环轮播, 则在图片数组首尾两边各自添加首尾元素 */
    if (_isCanCycle) {

        NSMutableArray *cycleDatasource = [_arr_images mutableCopy];
        [cycleDatasource insertObject:[_arr_images lastObject] atIndex:0];
        [cycleDatasource addObject:[_arr_images objectAtIndex:0]];
        self.arr_images = cycleDatasource;
    
    }
    
    CGFloat contentWidth = CGRectGetWidth(_scrollView.frame);
    CGFloat contentHeight = CGRectGetHeight(_scrollView.frame);
    
    _scrollView.contentSize = CGSizeMake(contentWidth * _arr_images.count, contentHeight);
    
    /* 添加UIImageView子视图 */
    for (NSUInteger i = 0 ; i < _arr_images.count; i++) {
    
        UIImageView * t_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i *contentWidth, 0, contentWidth, contentHeight)];
        t_imageView.backgroundColor = [UIColor clearColor];
        
        [self setImage:_arr_images[i] InImageView:t_imageView];
        [_scrollView addSubview:t_imageView];
        
    }
    
    /* 如果循环轮播,则scrollView设置显示在第二张图上面 */
    if (_isCanCycle) {
        _scrollView.contentOffset = CGPointMake(contentWidth, 0);
        self.currentIndex = 1;
    }
    
    //添加点击事件
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    [tapGestureRecognize setDelegate:(id<UIGestureRecognizerDelegate> _Nullable)self];
    tapGestureRecognize.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:tapGestureRecognize];
    
}

#pragma mark - 设置图片给子视图UIImageView

- (void)setImage:(id)imageSource InImageView:(UIImageView *)imageView{

    if ([imageSource isKindOfClass:[UIImage class]]) {
        
        imageView.image = imageSource;
        
    }else if ([imageSource isKindOfClass:[NSString class]] || [imageSource isKindOfClass:[NSURL class]]) {
      
        NSURL *url_image = [imageSource isKindOfClass:[NSString class]] ? [NSURL URLWithString:imageSource] : imageSource;
        
        [imageView sd_setImageWithURL:url_image placeholderImage:_image_placeHolder];
        
    }


}

#pragma mark - UIScrollViewDelegate

/* 即将要开始拖拽的时候，停止计时器 */
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (_timer) {
         [self invalidateTimer];
    }
}

/* 当结束拖拽的时候，开始计时器 */
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if ((_isCanCycle && _arr_images.count > 3) || (!_isCanCycle &&_arr_images.count >= 2)) {
        
        [self createTimer];
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat target_x = scrollView.contentOffset.x;
    CGFloat item_width = CGRectGetWidth(scrollView.frame);
    
    
    /* 当滑动到页面的一半的时候视为下一张图片, 这里以当前滑动位置是否超过图片一半来判断当前页 */
    _currentIndex = (target_x + item_width/2) / item_width;
   
   
    /* 循环滚动时候的边缘判断 */
    if (_isCanCycle && _arr_images.count > 3) {
        
        
        if (target_x >= item_width * (_arr_images.count - 1)) {
            
            /* 当可以循环滚动时候，滑动到数组最后一张的时候，让scrollView置换到数组第1张位置 */
            target_x = item_width;
            _scrollView.contentOffset = CGPointMake(target_x, 0);
            _currentIndex = 1;
            
        }else if (target_x <= 0){
            
            /* 当循环滚动的时候，滚动到数组第0张的时候，让scrollView设置到数组倒数第2张的位置 */
            target_x = item_width * (_arr_images.count -2);
            _scrollView.contentOffset = CGPointMake(target_x, 0);
            _currentIndex = _arr_images.count - 2;
        
        }
    }
    
    // NSLog(@"_currentIndex:%ld",_currentIndex);
   
    if (_pageControl) {
        
        if (_isCanCycle && _arr_images.count > 3) {
            
            _pageControl.currentPage = _currentIndex - 1;
            
        }else{
            
            _pageControl.currentPage = _currentIndex;
            
        }
        
    }
    
}


#pragma mark - UITapGestureRecognizerSelector

- (void)singleTapGestureRecognizer:(UITapGestureRecognizer *)tapGesture {
    
        if (_isCanCycle && _arr_images.count > 3) {
            
            if (self.selectedBlock) {
                if (_currentIndex - 1 >=  _arr_sourceImages.count ) {
                    self.selectedBlock(_arr_sourceImages.count - 1);
                }else{
                    self.selectedBlock(_currentIndex - 1);
                }
            }
            
        }else{
            
            if (self.selectedBlock) {
                self.selectedBlock(_currentIndex);
            }
            
        }
        
    
   
}


@end
