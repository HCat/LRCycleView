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

@property (nonatomic,strong) LRCyCleScrollView *cycleView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image_1 = [UIImage imageNamed:@"img_0.jpg"];
    UIImage *image_2 = [UIImage imageNamed:@"img_1.jpg"];
    UIImage *image_3 = [UIImage imageNamed:@"img_2.jpg"];

    NSArray *t_arr =[[NSArray alloc] initWithObjects:image_1,image_2,image_3, nil];
    
    self.cycleView = [[LRCyCleScrollView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 250) withImages:t_arr];
    self.cycleView.isCanCycle = NO;
    self.cycleView.autoPlayTimeInterval = 2.0f;
    self.cycleView.selectedBlock = ^(NSInteger selectedIndex) {
        NSLog(@"selectedIndex:%ld",selectedIndex);
    };
    [self.view addSubview:self.cycleView];
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)hanldeBtnChangeAction:(id)sender {
    
    UIImage *image_1 = [UIImage imageNamed:@"img_0.jpg"];
    UIImage *image_2 = [UIImage imageNamed:@"img_1.jpg"];
    UIImage *image_3 = [UIImage imageNamed:@"img_2.jpg"];
    UIImage *image_4 = [UIImage imageNamed:@"img_3.jpg"];
    UIImage *image_5 = [UIImage imageNamed:@"img_4.jpg"];
    self.cycleView.arr_sourceImages =[[NSArray alloc] initWithObjects:image_1,image_2,image_3,image_4,image_5, nil];
    self.cycleView.isCanCycle = YES;
    
    [self.cycleView reloadData];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
