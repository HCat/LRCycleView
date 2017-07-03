# LRCycleView

## iOS图片轮播器

### 展示：


### 说明：
LRCycleView是图片轮播图控件文件,包含了两种实现轮播方式：

1. LRCycleScrollView:  
   是通过ScrollView来实现轮播方式,代码调用方式如下:  
   <pre>
   <code> LRCyCleScrollView * cycleScrollView = [[LRCyCleScrollView alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 200) withImages:t_arr];
     cycleScrollView.selectedBlock = ^(NSInteger selectedIndex) {
        NSLog(@"selectedIndex:%ld",selectedIndex);
   	 };
     [self.view addSubview:cycleScrollView];</code>
	</pre>
   
    
2. LRCycleCollectionView:  
	是通过collectionView来实现轮播方式,代码调用方式如下:  
   <pre>
   <code> LRCycleCollectionView * cycleCollectionView = [[LRCycleCollectionView alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 200) withImages:t_arr];
     cycleCollectionView = ^(NSInteger selectedIndex) {
        NSLog(@"selectedIndex:%ld",selectedIndex);
   	 };
     [self.view addSubview:cycleCollectionView];</code>
	</pre>
	
3. 更新数据源:  
	* LRCycleScrollView只需要调用方法reloadData即可完成数据更换操作:
   <pre> <code> cycleScrollView.arr_sourceImages = t_arr2;
      	  cycleScrollView.autoPlayTimeInterval = 3.0f;
          cycleScrollView.isCanCycle = YES;
          [cycleScrollView reloadData];</code>
	</pre>
	
	* LRCycleCollectionView只需要重新设置数据源就可以了:
   <pre> <code> cycleCollectionView.arr_sourceImages = t_arr;
          cycleCollectionView.autoPlayTimeInterval = 3.0f;
    	  cycleCollectionView.isCanCycle = YES;</code>
	</pre>


	
	
	
 
 
