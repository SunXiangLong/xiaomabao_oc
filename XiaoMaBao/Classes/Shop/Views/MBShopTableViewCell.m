//
//  MBShopTableViewCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 15/12/29.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import "MBShopTableViewCell.h"
#import "RatingBar.h"
#import "PhotoCollectionViewCell.h"
@implementation MBShopTableViewCell



- (void)awakeFromNib {
    
    //self.userInteractionEnabled  = YES;
}
- (void)dict:(NSDictionary *)dic{

    RatingBar *bar = [[RatingBar alloc] initWithFrame:CGRectMake(0, 0, 100, self.evaluationView.ml_height)];
    [self.evaluationView addSubview:bar];
    bar.enable = NO;
    NSString *str = dic[@"comment_rank"];
    bar.starNumber = [str integerValue];
    self.name.text = [dic[@"author"]isEqualToString:@""]?@"匿名用户":dic[@"author"];
    self.evaluationText.text = dic[@"content"];
    
    
    NSArray *arr = dic[@"img_path"];
   
        if (arr.count>0) {
            self.photoArray = arr;
        }else{
            [self.evaluationPhoto removeFromSuperview];
        }
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//flowLayout.minimumInteritemSpacing =5;
    flowLayout.itemSize = CGSizeMake((UISCREEN_WIDTH-40)/5,(UISCREEN_WIDTH-40)/5);
    flowLayout.minimumInteritemSpacing =5;
    self.evaluationPhoto.collectionViewLayout = flowLayout;
    self.evaluationPhoto.dataSource = self;
    self.evaluationPhoto.delegate = self;
    [ self.evaluationPhoto registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCollectionViewCell"];
    
}
#pragma mark ---UICollectionViewDelegate
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    return insets;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell" forIndexPath:indexPath];
    id order = _photoArray[indexPath.item];
    [cell.image sd_setImageWithURL:order placeholderImage:[UIImage imageNamed:@"icon_nav03"]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = indexPath.item;
    photoBrowser.imageCount = self.photoArray.count;
    photoBrowser.sourceImagesContainerView = self.evaluationPhoto;
    
    [photoBrowser show];





}

#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageName = _photoArray[index];
    NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = [[UIImageView alloc] init];
    NSString *urlstring = _photoArray[index];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", urlstring]]
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                         
                        }];
    
    return imageView.image;
}

@end
