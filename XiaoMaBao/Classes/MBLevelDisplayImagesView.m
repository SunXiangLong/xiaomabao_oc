//
//  MBLevelDisplayImagesView.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBLevelDisplayImagesView.h"
#import "MBToolCollectionViewCell.h"
@interface MBLevelDisplayImagesView ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UIButton *_lastButton;
    UIView *_topView;
    UIView *_headView;
    BOOL _isHeadView;
    UIButton *_labtButton;
    
}
@property(nonatomic,strong) UICollectionView *controller;
@end

@implementation MBLevelDisplayImagesView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.width  =  self.ml_height;
        self.height =  self.ml_height;
        self.minimumLineSpacing = 5;
        [self setCollectionView];
    }
    return self;
}
- (void)setCollectionView{
    

        
    
        UICollectionViewFlowLayout *flowLayout = ({
            UICollectionViewFlowLayout *flowLayout =  [[UICollectionViewFlowLayout alloc] init];
            flowLayout.itemSize = CGSizeMake(self.width,self.height);
            flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            flowLayout.minimumLineSpacing = self.minimumLineSpacing;
            flowLayout;
        });
        
        UICollectionView *collectionView = ({
            UICollectionView *collectionView   = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:flowLayout];
            collectionView.backgroundColor = [UIColor whiteColor];
            collectionView.showsHorizontalScrollIndicator = NO;
            collectionView.dataSource = self;
            collectionView.delegate = self;
            [collectionView registerNib:[UINib nibWithNibName:@"MBToolCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MBToolCollectionViewCell"];
            
          
            
            collectionView;
            
            
        });
        
        [self addSubview:collectionView];
        
    
    
}
#pragma mark <UICollectionViewDataSource>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake(self.width, self.height);
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.imageArray) {
        return self.imageArray.count;
    }else{
    
      return self.urlImageArray.count;
    }
  
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MBToolCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBToolCollectionViewCell" forIndexPath:indexPath];
    [cell.showImage sd_setImageWithURL:[NSURL URLWithString:self.urlImageArray[indexPath.item]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    
   
    cell.showImage .contentMode =  UIViewContentModeScaleAspectFill;
    cell.showImage .autoresizingMask = UIViewAutoresizingFlexibleHeight;
    cell.showImage .clipsToBounds  = YES;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
   
}

@end
