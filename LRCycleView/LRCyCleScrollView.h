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
 
 */


#import <UIKit/UIKit.h>

typedef void(^LRCycleScrollBlock)(NSInteger selectedIndex);


@interface LRCyCleScrollView : UIView

/*是否可以循环,默认是YES, 如果图片只有一张的时候,设置isCanCycle无效,这时候是不能进行循环滚动的
  初始化后变换isCanCycle，需要手动调用reloadData来刷新轮播视图
 */
@property (nonatomic,assign) BOOL isCanCycle;

/*自动轮播时间,默认是为2秒,当设置autoPlayTimeInterval为0的时候,则不会自动轮播*/
@property (nonatomic,assign) NSTimeInterval autoPlayTimeInterval;

/*当初始化的图片数组为空的时候，需要显示的图片*/
@property (nonatomic,strong)UIImage *image_null;

/*加载图片时候的默认背景图*/
@property (nonatomic,strong)UIImage *image_placeHolder;

/* 图片数组 ，如果单独赋值给arr_images并不会触发reloadData, 需要手动调用reloadData来刷新轮播视图*/
@property (nonatomic,copy) NSArray *arr_sourceImages;

/* 选中之后的所做的操作 */
@property (nonatomic,copy) LRCycleScrollBlock selectedBlock;

/*初始化方式*/
- (instancetype)initWithFrame:(CGRect)frame withImages:(NSArray *)imagesArray;

/* 刷新数据 */
- (void)reloadData;

@end
