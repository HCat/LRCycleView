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

@property (nonatomic,copy) NSArray *arr_images;         //初始化的图片数组
@property (nonatomic,assign) NSUInteger layoutCount;    //layout调用次数,用于调试用的

/* 只创建3个视图来进行轮播 */
@property (nonatomic,strong) UIImageView *imgV_left;       //左边视图
@property (nonatomic,strong) UIImageView *imgV_middle;     //中间视图
@property (nonatomic,strong) UIImageView *imgV_right;      //右边视图




@end


@implementation LRCyCleScrollView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame withImages:(NSArray *)imagesArray{

    self = [super initWithFrame:frame];
    
    if (self) {
        self.arr_images = imagesArray;
        self.scrollViewBounces = YES;
        self.isCanCycle = YES;
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
        self.layoutCount = 0;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.scrollViewBounces = YES;
        self.isCanCycle = YES;
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
    
//    [self initialize];
//    
//    if (self.completeBlock) {
//        self.completeBlock();
//    }
}

#pragma mark - 初始化内部视图

- (void)initialize{

    [self createScrollView];
    [self createPageControl];
    
    
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
    
    //对源图片数据进行数据拷贝，并且在收尾各添加数组收尾数据
    if (_isCanCycle) {
        
        NSMutableArray *cycleDatasource = [_arr_images mutableCopy];
        [cycleDatasource insertObject:[_arr_images lastObject] atIndex:0];
        [cycleDatasource addObject:[_arr_images objectAtIndex:0]];
        self.arr_images = cycleDatasource;
        
    }
    
    CGFloat contentWidth = CGRectGetWidth(_scrollView.frame);
    CGFloat contentHeight = CGRectGetHeight(_scrollView.frame);
    
    
    self.imgV_left = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, contentWidth, contentHeight)];
    _imgV_left.contentMode = UIViewContentModeScaleAspectFill;
    _imgV_left.backgroundColor = [UIColor clearColor];
    
    self.imgV_middle = [[UIImageView alloc] initWithFrame:CGRectMake(contentWidth, 0, contentWidth, contentHeight)];
    _imgV_middle.contentMode = UIViewContentModeScaleAspectFill;
    _imgV_middle.backgroundColor = [UIColor clearColor];
    
    self.imgV_right = [[UIImageView alloc] initWithFrame:CGRectMake(contentWidth * 2, 0, contentWidth, contentHeight)];
    _imgV_right.contentMode = UIViewContentModeScaleAspectFill;
    _imgV_right.backgroundColor = [UIColor clearColor];
    
    [self setImage:_arr_images[0] InImageView:_imgV_left];
    [self setImage:_arr_images[1] InImageView:_imgV_middle];
    [self setImage:_arr_images[2] InImageView:_imgV_right];
    
    [_scrollView addSubview:_imgV_left];
    [_scrollView addSubview:_imgV_middle];
    [_scrollView addSubview:_imgV_middle];
    
    _scrollView.contentOffset = CGPointMake(contentWidth, 0);
    
    
    //添加点击事件
    
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    [tapGestureRecognize setDelegate:(id<UIGestureRecognizerDelegate> _Nullable)self];
    tapGestureRecognize.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:tapGestureRecognize];
    
}

- (void)setImage:(id)imageSource InImageView:(UIImageView *)imageView{

    if ([imageSource isKindOfClass:[UIImage class]]) {
        
        imageView.image = imageSource;
        
    }else if ([imageSource isKindOfClass:[NSString class]] || [imageSource isKindOfClass:[NSURL class]]) {
      
        [imageView sd_setImageWithURL:[imageSource isKindOfClass:[NSString class]] ? [NSURL URLWithString:imageSource] : imageSource placeholderImage:_image_placeHolder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            
            
        }];
        
    }


}


#pragma mark - UITapGestureRecognizerSelector

- (void)singleTapGestureRecognizer:(UITapGestureRecognizer *)tapGesture {
    
    NSInteger page = (NSInteger)(_scrollView.contentOffset.x / CGRectGetWidth(_scrollView.frame));
    
   
}


@end
