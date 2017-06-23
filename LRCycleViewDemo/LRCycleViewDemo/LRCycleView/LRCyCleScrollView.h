//
//  LRCyCleScrollView.h
//  LRCycleViewDemo
//
//  Created by hcat on 2017/6/20.
//  Copyright © 2017年 Hcat. All rights reserved.
//

/* 备注：LRCyCleScrollView
 
   这个轮播控件主要用于图片轮播数量比较少的情况， 当然轮播图片数组的数目相对较大的时候
   不建议使用LRCyCleScrollView，因为它一口气往UIScrollView添加了全部的数组图片的UIImageView.
   这样造成了大量的cpu消耗和内存消耗，虽然还是可以运用，但是不建议
   还有另外一种实现方式，运用3个UIImageView来对数组中的图片进行轮播，相对逻辑处理比较复杂，需要考虑
   图片为1张或者2张情况下的特殊出来，而且需要考虑当然是否循环轮播的处理，处理起来逻辑不清楚，理解起来
   也不好理解，所以不提倡运用3个UIImageView来进行图片的轮播
   
   代码主要原理参照：KDCycleBannerView. 感谢作者提供的想法.
 */


#import <UIKit/UIKit.h>

typedef void(^LRCyCleScrollBlock)(NSInteger selectedIndex);



@interface LRCyCleScrollView : UIView

/*是否可以循环,默认是YES, 如果图片只有一张的时候,设置isCanCycle无效,这时候是不能进行循环滚动的*/
@property (nonatomic,assign) BOOL isCanCycle;

/*自动轮播时间，默认是为1秒*/
@property (nonatomic,assign) NSTimeInterval autoPlayTimeInterval;

/*当初始化的图片数组为空的时候，需要显示的图片*/
@property (nonatomic,strong)UIImage *image_null;

/*加载图片时候的默认背景图*/
@property (nonatomic,strong)UIImage *image_placeHolder;

/* 图片数组 */
@property (nonatomic,copy) NSArray *arr_images; 

/* 选中之后的所做的操作 */
@property (nonatomic,copy) LRCyCleScrollBlock selectedBlock;

/*初始化方式*/
- (instancetype)initWithFrame:(CGRect)frame withImages:(NSArray *)imagesArray;

//设置当前显示在第几页
- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated;

/* 刷新数据 */
- (void)reloadData;

@end
