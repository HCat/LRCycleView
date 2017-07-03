//
//  ViewController.m
//  LRCycleViewDemo
//
//  Created by hcat on 2017/6/20.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "ViewController.h"
#import "LRCyCleScrollView.h"
#import "LRCycleCollectionView.h"
#import "SDWebImageManager.h"

@interface ViewController ()

@property (nonatomic,strong) LRCyCleScrollView *cycleScrollView;
@property (nonatomic,strong) LRCycleCollectionView *cycleCollectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image_1 = [UIImage imageNamed:@"img_0.jpg"];
    UIImage *image_2 = [UIImage imageNamed:@"img_1.jpg"];
    UIImage *image_3 = [UIImage imageNamed:@"img_2.jpg"];
    
    NSArray *t_arr =[[NSArray alloc] initWithObjects:image_1,image_2,image_3,nil];
    
    self.cycleScrollView = [[LRCyCleScrollView alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 200) withImages:t_arr];
    self.cycleScrollView.isCanCycle = NO;
    self.cycleScrollView.selectedBlock = ^(NSInteger selectedIndex) {
        NSLog(@"selectedIndex:%ld",selectedIndex);
    };
    [self.view addSubview:self.cycleScrollView];
    
    
    self.cycleCollectionView = [[LRCycleCollectionView alloc] initWithFrame:CGRectMake(0, 300, [UIScreen mainScreen].bounds.size.width, 200) withImages:t_arr];
    self.cycleCollectionView.isCanCycle = NO;
    self.cycleCollectionView.selectedBlock = ^(NSInteger selectedIndex) {
        NSLog(@"selectedIndex:%ld",selectedIndex);
    };
    [self.view addSubview:self.cycleCollectionView];
    
    
}

- (IBAction)hanldeBtnChangeAction:(id)sender {
    
    NSString *t_str1 = @"http://img1.juimg.com/170412/330779-1F4120KS149.jpg";
    NSString *t_str2 = @"http://img1.juimg.com/170412/330779-1F41214043694.jpg";
    NSString *t_str3 = @"http://img1.juimg.com/170412/330779-1F41210143657.jpg";
    NSString *t_str4 = @"http://img1.juimg.com/170412/330779-1F4120635118.jpg";
    NSString *t_str5 = @"http://img1.juimg.com/170412/330779-1F4120S0078.jpg";
    
    NSArray *t_arr2 =[[NSArray alloc] initWithObjects:t_str1,t_str2,t_str3,t_str4,t_str5,nil];
    self.cycleScrollView.arr_sourceImages = t_arr2;
    self.cycleScrollView.autoPlayTimeInterval = 3.0f;
    self.cycleScrollView.isCanCycle = YES;
    [self.cycleScrollView reloadData];
    
  

    NSMutableArray *t_arr = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        int y = (arc4random() % 5) + 0;
        NSString *t_str = [NSString stringWithFormat:@"img_%d.jpg",y];
        UIImage *image = [UIImage imageNamed:t_str];
        [t_arr addObject:image];
    }

    self.cycleCollectionView.arr_sourceImages = t_arr;
    self.cycleCollectionView.autoPlayTimeInterval = 3.0f;
    self.cycleCollectionView.isCanCycle = YES;

}

- (IBAction)hanldeBtnClearnCacheAction:(id)sender{

   [[[SDWebImageManager sharedManager] imageCache] clearDiskOnCompletion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
