//
//  MBBabyChestController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/3.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBabyChestController.h"
#import "MBBabyChestCell.h"
@interface MBBabyChestController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MBBabyChestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ self.collectionView registerNib:[UINib nibWithNibName:@"MBBabyChestCell" bundle:nil] forCellWithReuseIdentifier:@"MBBabyChestCell"];
}
-(NSString *)titleStr{
    
     return @"百宝箱";
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---UICollectionViewDelegate
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(25, 9, 25, 9);
}
   

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
        return CGSizeMake((UISCREEN_WIDTH-40)/3,(UISCREEN_WIDTH-40)/3);
    
    
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MBBabyChestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBBabyChestCell" forIndexPath:indexPath];
    
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}


@end
