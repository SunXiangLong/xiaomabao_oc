//
//  MBGuidePage.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/28.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBGuidePage.h"
#import "LZXCollectionViewCell.h"
@interface MBGuidePage()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    // 创建页码控制器
    UIPageControl *_pageControl;
    //
    UIButton *_btnStart;
}
@end
@implementation MBGuidePage
-(instancetype)init{
  self =  [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setUI];
    }
    return self;
}
- (void)setUI{
    
    [self addCollectionView];
    
    UIButton* btnStart = [[UIButton alloc] init];
 
    btnStart.frame = CGRectMake((UISCREEN_WIDTH-160)/2, UISCREEN_HEIGHT - 65 - 36, 160, 65);
    btnStart.hidden = YES ;
    [btnStart addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [btnStart setImage:[UIImage imageNamed:@"lanch5"] forState:UIControlStateNormal];
    _btnStart = btnStart ;
    [self addSubview: btnStart];
    

    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btnStart.frame)+2, 0, 30)];

    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
   _pageControl.numberOfPages = 4;
 [ self addSubview: _pageControl];
}
- (void)addCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    // 设置cell 大小
    layout.itemSize = CGSizeMake(UISCREEN_WIDTH, UISCREEN_HEIGHT);
    
    // 设置滑动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 设置间距
    layout.minimumLineSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor   whiteColor];
    collectionView.delegate = self;
    
    collectionView.dataSource = self;
    // 隐藏滚动条
    collectionView.showsHorizontalScrollIndicator = NO;
    
    // 设置分页效果
    collectionView.pagingEnabled = YES;
    
    // 设置弹簧效果
    collectionView.bounces =  YES;
    
    [self addSubview:collectionView];
    
    [collectionView registerClass:[LZXCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LZXCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.imageviewbg.image = [UIImage imageNamed:self.dataArray[indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

  
 NSInteger num =  scrollView.contentOffset.x/UISCREEN_WIDTH;
    _pageControl.currentPage = num;
    if (num == 3 ) {
        _btnStart.hidden = NO;
    }else{
        _btnStart.hidden = YES;
    }
}

-(void)start{
    [UIView animateWithDuration:1 animations:^{
        self.alpha = 0 ;
    } completion:^(BOOL finished) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults]  synchronize];
        [self removeFromSuperview];
       
        
    }];
}
@end
