//
//  LRCyCleScrollView.h
//  LRCycleViewDemo
//
//  Created by hcat on 2017/6/20.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LRCyCleScrollView : UIView


@property (nonatomic,assign) BOOL isCanCycle; //是否可以循环，默认是YES

@property (nonatomic,assign) NSUInteger autoPlayTimeInterval; //自动轮播时间，默认是为1秒


- (instancetype)initWithFrame:(CGRect)frame withImages:(NSArray *)imagesArray;


@end
