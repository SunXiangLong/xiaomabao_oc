//
//  MBFreeStoreViewOneCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBFreeStoreViewOneCell.h"
#import "MBFreeStoreViewOnechildCell.h"
#import "MBShopingViewController.h"
@interface MBFreeStoreViewOneCell()<UICollectionViewDelegate,UICollectionViewDataSource>
{
}

@property (weak, nonatomic) IBOutlet UICollectionView *collerctionView;

@end
@implementation MBFreeStoreViewOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UICollectionViewFlowLayout *flowLayout =  [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset =  UIEdgeInsetsMake(7, 8, 7, 8);
    flowLayout.itemSize =  CGSizeMake(114,147);
    _collerctionView.collectionViewLayout = flowLayout;
    _collerctionView.showsHorizontalScrollIndicator = NO;
    _collerctionView.dataSource = self;
    _collerctionView.delegate = self;
    [_collerctionView registerNib:[UINib nibWithNibName:@"MBFreeStoreViewOnechildCell" bundle:nil] forCellWithReuseIdentifier:@"MBFreeStoreViewOnechildCell"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
#pragma mark --UICollectionViewdelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MBFreeStoreViewOnechildCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBFreeStoreViewOnechildCell" forIndexPath:indexPath];
    [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:_dataArray[indexPath.item][@"goods_thumb"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    NSString *str = _dataArray[indexPath.item][@"goods_name"];
    if (str.length>10) {
        cell.shopName.text = [str substringToIndex:10];
    }else{
        cell.shopName.text = str;
    }

    
    cell.shopprice.text = [NSString stringWithFormat:@"¥ %@",_dataArray[indexPath.item][@"goods_price"]];
    return cell;
    
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MBShopingViewController *shopDetailVc = [[MBShopingViewController alloc] init];
    shopDetailVc.GoodsId = _dataArray[indexPath.item][@"goods_id"];
    [self.VC pushViewController:shopDetailVc Animated:YES];
    
}

@end
