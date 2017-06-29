//
//  LRCycleCollectionView.h
//  LRCycleViewDemo
//
//  Created by hcat on 2017/6/29.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LRCycleCollectionBlock)(NSInteger selectedIndex);

@interface LRCycleCollectionView : UIView

/** 是否无限循环,默认Yes */
@property (nonatomic,assign) BOOL isCanCycle;

/*自动轮播时间,默认是为2秒,当设置autoPlayTimeInterval为0的时候,则不会自动轮播*/
@property (nonatomic,assign) NSTimeInterval autoPlayTimeInterval;

/* 图片数据源 */
@property (nonatomic,copy) NSArray *arr_sourceImages;

/* 当初始化的图片数组为空的时候，需要显示的图片 */
@property (nonatomic,strong)UIImage *image_null;

/* 加载图片时候的默认背景图 */
@property (nonatomic,strong)UIImage *image_placeHolder;

/* 选中之后的所做的操作 */
@property (nonatomic,copy) LRCycleCollectionBlock selectedBlock;

/*初始化方式*/
- (instancetype)initWithFrame:(CGRect)frame withImages:(NSArray *)imagesArray;

@end
