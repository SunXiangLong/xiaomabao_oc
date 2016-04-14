//
//  MBUserEvaluationListCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBUserEvaluationListCell.h"
#import "MBServiceShopsViewController.h"
#import "MBMBAffordablePlanetOneChildeOneCell.h"
@interface MBUserEvaluationListCell ()<UICollectionViewDelegate,UICollectionViewDataSource,SDPhotoBrowserDelegate>

{
    
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end
@implementation MBUserEvaluationListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.showImageView .contentMode =  UIViewContentModeScaleAspectFill;
    self.showImageView .autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.showImageView .clipsToBounds  = YES;
    self.showImageView.userInteractionEnabled = YES;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"MBMBAffordablePlanetOneChildeOneCell" bundle:nil] forCellWithReuseIdentifier:@"MBMBAffordablePlanetOneChildeOneCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
}

- (IBAction)touxiangdianji:(id)sender {
    MBServiceShopsViewController *VC = [[MBServiceShopsViewController alloc] init];
    VC.shop_id = self.shop_id;
    [self.VC pushViewController:VC Animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
#pragma mark --UICollectionViewdelegate

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 8;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(8, 8, 8, 8);
    
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _comment_imgs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MBMBAffordablePlanetOneChildeOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBMBAffordablePlanetOneChildeOneCell" forIndexPath:indexPath];
    [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:  _comment_imgs[indexPath.item]] placeholderImage:[UIImage imageNamed:@"placeholder_num3"]];
    return cell;
    
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SDPhotoBrowser *photoBrowser = [[SDPhotoBrowser alloc] init];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = indexPath.item;
    photoBrowser.imageCount =_comment_imgs.count;
    photoBrowser.sourceImagesContainerView = self.collectionView;
    [photoBrowser show];
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((UISCREEN_WIDTH-32)/3,(UISCREEN_WIDTH-32)/3);
    
}
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageName = _comment_thumb_imgs[index];
    NSString *urlStr = [imageName stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return [NSURL URLWithString:urlStr];
    
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    //    UIImageView *imageView = [[UIImageView alloc] init];
    //    NSString *urlstring = _comment_imgs[index];
    //    [imageView sd_setImageWithURL:[NSURL URLWithString:urlstring] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    //    return imageView.image;
    
    // 不建议用此种方式获取小图，这里只是为了简单实现展示而已
    MBMBAffordablePlanetOneChildeOneCell *cell = (MBMBAffordablePlanetOneChildeOneCell *)[self collectionView:self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    
    return cell.showImageView.image;
}
@end
