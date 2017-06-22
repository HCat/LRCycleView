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

@interface LRCyCleScrollView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) UIPageControl * pageControl;
@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,assign) BOOL scrollViewBounces;

@property (nonatomic,assign) NSUInteger layoutCount;    //layout调用次数,用于调试用的

@property (nonatomic,assign) NSUInteger currentIndex;   //当前索引页

@end


@implementation LRCyCleScrollView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame withImages:(NSArray *)imagesArray{

    self = [super initWithFrame:frame];
    
    if (self) {
        self.arr_images = imagesArray;
        self.scrollViewBounces = YES;
        self.isCanCycle = YES;
        self.currentIndex = 0;
        
        self.layoutCount = 0;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollViewBounces = YES;
        self.isCanCycle = YES;
        self.currentIndex = 0;
        
        self.layoutCount = 0;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.scrollViewBounces = YES;
        self.isCanCycle = YES;
        self.currentIndex = 0;
        
        self.layoutCount = 0;
    }
    return self;
}

#pragma mark -

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layoutCount += 1;
    NSLog(@"layoutCount:%ld",_layoutCount);
    
    NSArray *subViews = self.subviews;
    [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self initialize];
    
}

#pragma mark - 初始化内部视图

- (void)initialize{

    [self createScrollView];
    [self createPageControl];
    
    [self loadData];
    
    if (_autoPlayTimeInterval > 0) {
        
        //这里有两种条件来开始自动轮播，一种是循环播放，图片数量要大于3张；另外是不循环播放，图片数量大于2张
        
        if ((_isCanCycle && _arr_images.count > 3) || (!_isCanCycle && _arr_images.count > 2)) {
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


}

#pragma mark - loadData

- (void)loadData{

    NSAssert(_arr_images != nil, @"arr_images must not nil");
    
    if (_arr_images.count == 0) {
        
        //如果数组为空的话，则显示无数据页面
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = _image_null;
        [_scrollView addSubview:imageView];
        
        return;
    }
    
    if (_isCanCycle) {

        NSMutableArray *cycleDatasource = [_arr_images mutableCopy];
        [cycleDatasource insertObject:[_arr_images lastObject] atIndex:0];
        [cycleDatasource addObject:[_arr_images objectAtIndex:0]];
        self.arr_images = cycleDatasource;
        
    }
    
    CGFloat contentWidth = CGRectGetWidth(_scrollView.frame);
    CGFloat contentHeight = CGRectGetHeight(_scrollView.frame);
    
    _scrollView.contentSize = CGSizeMake(contentWidth * _arr_images.count, contentHeight);
    
    for (NSUInteger i = 0 ; i < _arr_images.count; i++) {
        
        //添加UIImageView子视图
        UIImageView * t_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i *contentWidth, 0, contentWidth, contentHeight)];
        t_imageView.backgroundColor = [UIColor clearColor];
        
        [self setImage:_arr_images[i] InImageView:t_imageView];
        [_scrollView addSubview:t_imageView];
        
    }
    

    if (_isCanCycle && _arr_images.count > 1) {
        _scrollView.contentOffset = CGPointMake(contentWidth, 0);
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
//4、已经结束拖拽，手指刚离开view的那一刻
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if ((self.isCanCycle && _arr_images.count > 3) || (!self.isCanCycle &&_arr_images.count > 2)) {
        [self createTimer];
    }

}



#pragma mark - UITapGestureRecognizerSelector

- (void)singleTapGestureRecognizer:(UITapGestureRecognizer *)tapGesture {
    
    NSInteger page = (NSInteger)(_scrollView.contentOffset.x / CGRectGetWidth(_scrollView.frame));
    
   
}


@end
