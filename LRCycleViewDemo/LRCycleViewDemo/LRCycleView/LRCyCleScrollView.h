//
//  LRCyCleScrollView.h
//  LRCycleViewDemo
//
//  Created by hcat on 2017/6/20.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LRCyCleScrollView : UIView

/*是否可以循环，默认是YES*/
@property (nonatomic,assign) BOOL isCanCycle;

/*自动轮播时间，默认是为1秒*/
@property (nonatomic,assign) NSTimeInterval autoPlayTimeInterval;

/*当初始化的图片数组为空的时候，需要显示的图片*/
@property (nonatomic,strong)UIImage *image_null;

/*加载图片时候的默认背景图*/
@property (nonatomic,strong)UIImage *image_placeHolder;

/*初始化方式*/
- (instancetype)initWithFrame:(CGRect)frame withImages:(NSArray *)imagesArray;


@end
