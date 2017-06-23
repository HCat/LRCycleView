//
//  ViewController.m
//  LRCycleViewDemo
//
//  Created by hcat on 2017/6/20.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "ViewController.h"
#import "LRCyCleScrollView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image_1 = [UIImage imageNamed:@"img_0.jpg"];
    UIImage *image_2 = [UIImage imageNamed:@"img_1.jpg"];
//    UIImage *image_3 = [UIImage imageNamed:@"img_2.jpg"];
//    UIImage *image_4 = [UIImage imageNamed:@"img_3.jpg"];
//    UIImage *image_5 = [UIImage imageNamed:@"img_4.jpg"];
    NSArray *t_arr =[[NSArray alloc] initWithObjects:image_1,image_2, nil];
    
    LRCyCleScrollView *t_cycle = [[LRCyCleScrollView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 250) withImages:t_arr];
    t_cycle.isCanCycle = YES;
    
    
    [self.view addSubview:t_cycle];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
