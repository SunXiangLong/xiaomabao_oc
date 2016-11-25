//
//  MBUserEvaluationCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBUserEvaluationCell.h"
#import "MBUserEvaluationListController.h"
#import "MBMBAffordablePlanetOneChildeOneCell.h"
@interface MBUserEvaluationCell ()<UICollectionViewDelegate,UICollectionViewDataSource,SDPhotoBrowserDelegate>

{
    
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *user_name;
@property (weak, nonatomic) IBOutlet UILabel *user_time;
@property (weak, nonatomic) IBOutlet UILabel *user_center;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewTop;
@property (nonatomic,strong) NSArray *comment_imgs;
@property (nonatomic,strong) NSArray *comment_thumb_imgs;
@property (nonatomic,strong) NSString *user_id;
@end
@implementation MBUserEvaluationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.showImageView .contentMode =  UIViewContentModeScaleAspectFill;
//    self.showImageView .autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    self.showImageView .clipsToBounds  = YES;
    self.showImageView.userInteractionEnabled = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"MBMBAffordablePlanetOneChildeOneCell" bundle:nil] forCellWithReuseIdentifier:@"MBMBAffordablePlanetOneChildeOneCell"];
    
    [self.showImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dianji:)]];
}
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    self.user_name.text = _dataDic[@"user_name"];
    self.user_time.text = _dataDic[@"comment_date"];
    [self.collectionView    reloadData];
    self.user_center.text = _dataDic[@"comment_content"];
    self.comment_imgs = _dataDic[@"comment_imgs"];
    self.comment_thumb_imgs = _dataDic[@"comment_thumb_imgs"];
    self.user_id =  _dataDic[@"user_id"];
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"header_img"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    
    
    if (self.comment_imgs.count > 0) {
        self.collectionViewTop.constant = 10;
        self.collectionViewHeight.constant = (UISCREEN_WIDTH -32)/3+2*8;
    }else{
        self.collectionViewTop.constant = 0;
        self.collectionViewHeight.constant = 0;
    }
    if (self.comment_imgs.count > 3){
        self.collectionViewHeight.constant = (UISCREEN_WIDTH -32)/3*2+3*8;
    }

}
- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    totalHeight += 50;
    totalHeight += [self.user_name sizeThatFits:size].height;
    totalHeight += [self.user_center sizeThatFits:size].height;
    totalHeight += self.collectionViewHeight.constant;
    totalHeight += self.collectionViewTop.constant;
    return CGSizeMake(size.width, totalHeight);
}
- (void)dianji:(UITapGestureRecognizer *)sender {
    MBUserEvaluationListController *VC = [[MBUserEvaluationListController alloc] init];
    VC.user_id = self.user_id;
    VC.user_name = self.user_name.text;
    VC.user_imageURl = _dataDic[@"header_img"];
    VC.title = string(self.user_name.text, @"的全部评价");
    [self.VC  pushViewController:VC Animated:YES ];
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
