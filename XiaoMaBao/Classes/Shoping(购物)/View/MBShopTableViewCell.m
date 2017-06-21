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

-(void)setModel:(MBGoodCommentListModel *)model {
    _model = model;
    RatingBar *bar = [[RatingBar alloc] initWithFrame:CGRectMake(0, 0, 100, self.evaluationView.ml_height)];
    [self.evaluationView addSubview:bar];
    bar.enable = NO;
    NSString *str = _model.comment_rank;
    bar.starNumber = [str integerValue];
    self.name.text = [_model.author isEqualToString:@""]?@"匿名用户":_model.author;
    self.evaluationText.text = _model.content;
    
    
    if (_model.img_path.count <= 0) {
        [self.evaluationPhoto removeFromSuperview];
    }
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((UISCREEN_WIDTH-40)/5,(UISCREEN_WIDTH-40)/5);
    flowLayout.minimumInteritemSpacing =5;
    self.evaluationPhoto.collectionViewLayout = flowLayout;
    self.evaluationPhoto.dataSource = self;
    self.evaluationPhoto.delegate = self;
    [ self.evaluationPhoto registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCollectionViewCell"];

}
-(void)setDic:(NSDictionary *)dic{
    _dic =dic;
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
   
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (_model.img_path.count > 0) {
        return 1;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _model.img_path.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell" forIndexPath:indexPath];
    cell.urlImg = _photoArray[indexPath.item];;
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
- (CGSize)sizeThatFits:(CGSize)size {
   
    NSInteger height = [_model.content sizeWithFont:[UIFont systemFontOfSize:12] withMaxSize:CGSizeMake(UISCREEN_WIDTH-20, MAXFLOAT)].height;
    
   
    
    if (_model.img_path.count>0) {
        return  CGSizeMake(size.width, 50+height+(UISCREEN_WIDTH-40)/5+20);
    }
    return  CGSizeMake(size.width, 50+height);
}
@end
