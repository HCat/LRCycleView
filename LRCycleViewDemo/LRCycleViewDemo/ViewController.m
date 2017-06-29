//
//  ViewController.m
//  LRCycleViewDemo
//
//  Created by hcat on 2017/6/20.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "ViewController.h"
#import "LRCyCleScrollView.h"
#import "SDWebImageManager.h"

@interface ViewController ()

@property (nonatomic,strong) LRCyCleScrollView *cycleView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image_1 = [UIImage imageNamed:@"img_0.jpg"];
    UIImage *image_2 = [UIImage imageNamed:@"img_1.jpg"];
    UIImage *image_3 = [UIImage imageNamed:@"img_2.jpg"];

    NSArray *t_arr =[[NSArray alloc] initWithObjects:image_1,image_2,image_3, nil];
    
    self.cycleView = [[LRCyCleScrollView alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 250) withImages:t_arr];
    self.cycleView.isCanCycle = NO;
    self.cycleView.selectedBlock = ^(NSInteger selectedIndex) {
        NSLog(@"selectedIndex:%ld",selectedIndex);
    };
    [self.view addSubview:self.cycleView];
    
}

- (IBAction)hanldeBtnChangeAction:(id)sender {
    
    NSString *t_str1 = @"http://img1.juimg.com/170412/330779-1F4120KS149.jpg";
    NSString *t_str2 = @"http://img1.juimg.com/170412/330779-1F41214043694.jpg";
    NSString *t_str3 = @"http://img1.juimg.com/170412/330779-1F41210143657.jpg";
    NSString *t_str4 = @"http://img1.juimg.com/170412/330779-1F4120635118.jpg";
    NSString *t_str5 = @"http://img1.juimg.com/170412/330779-1F4120S0078.jpg";
    
    NSArray *t_arr2 =[[NSArray alloc] initWithObjects:t_str1,t_str2,t_str3,t_str4,t_str5,nil];
    self.cycleView.arr_sourceImages = t_arr2;
    self.cycleView.autoPlayTimeInterval = 3.0f;
    self.cycleView.isCanCycle = YES;
    
    [self.cycleView reloadData];

}

- (IBAction)hanldeBtnClearnCacheAction:(id)sender{

   [[[SDWebImageManager sharedManager] imageCache] clearDiskOnCompletion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
