//
//  MBcheshiCollectionViewCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBcheshiCollectionViewCell.h"
#import "JCCollectionViewWaterfallLayout.h"
#import "MBcheshiCollectionViewCell.h"
#import "MBCanulaCircleDetailsViewController.h"
#import "MBRecommendedCollectionViewCell.h"
@interface MBcheshiCollectionViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>
@end
@implementation MBcheshiCollectionViewCell

- (void)awakeFromNib {
     JCCollectionViewWaterfallLayout *layout = [[JCCollectionViewWaterfallLayout alloc] init];
    
    self.collectionView.backgroundColor =  [UIColor  colorR:236 colorG:237 colorB:241];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.collectionViewLayout = layout;
    [ self.collectionView registerNib:[UINib nibWithNibName:@"MBRecommendedCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MBRecommendedCollectionViewCell"];
    _dataArray = [NSMutableArray array];
    
}
-(void)setsss:(NSArray *)arr{
    [_dataArray addObjectsFromArray:arr];
    [_collectionView reloadData];
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = self.dataArray[indexPath.item][@"content"];
    
    
    NSInteger image_w =200;
    NSInteger image_h =500 ;
    if ([self.dataArray[indexPath.item][@"first_img"] isKindOfClass:[NSArray class]]) {
        
        image_w = 1;
        image_h = 0;
    }else{
        NSString *str1 = self.dataArray[indexPath.item][@"first_img"][@"origin_w"];
        NSString *str2 = self.dataArray[indexPath.item][@"first_img"][@"origin_h"];
        
        NSLog(@"----------------------%@ %@",str1,str2);
        image_w = [str1 integerValue];
        image_h = [str2 integerValue];
        
        
    }
    if (image_w ==0) {
        image_w = 1;
    }
    
    NSInteger width = (UISCREEN_WIDTH-15)/2-10;
    CGFloat heght = [str sizeWithFont:[UIFont systemFontOfSize:16] withMaxSize:CGSizeMake(width, MAXFLOAT)].height;
    
    return CGSizeMake(width, 60+heght+width*image_h/image_w);
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"------------------%@",self.dataArray);
    
    MBRecommendedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBRecommendedCollectionViewCell" forIndexPath:indexPath];
    NSString *str = self.dataArray[indexPath.item][@"content"];
    cell.neirongLable.text  = str;
    [cell.userImage sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.item][@"avatar"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    cell.userName.text = self.dataArray[indexPath.item][@"user_name"];
    cell.userTime.text = self.dataArray[indexPath.item][@"baby_age"];
    if (![self.dataArray[indexPath.item][@"first_img"] isKindOfClass:[NSArray class]]) {
        [cell.showImage sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.item][@"first_img"][@"origin"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    }
    
    
    return cell;
}

@end
