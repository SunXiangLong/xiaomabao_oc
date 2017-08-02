//
//  YHSelectPhotoCollectionViewCell.m
//  YHPhotoKit
//
//  Created by deng on 16/11/29.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "YHPhotoBrowserCollectionViewCell.h"

@interface YHPhotoBrowserCollectionViewCell() <UIScrollViewDelegate>

@property (strong, nonatomic) YHPhotoModel *photoModel;
@property (strong, nonatomic) UIImageView *largeImage;
@property (strong, nonatomic) UIScrollView *imageContent;

@end

@implementation YHPhotoBrowserCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.userInteractionEnabled = YES;
        [self.contentView addSubview:self.imageContent];
        [self.imageContent addSubview:self.largeImage];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)tapPhotoAction:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:0.4 animations:^{
        self.largeImage.transform = CGAffineTransformIdentity;
        self.imageContent.contentSize = self.contentView.frame.size;
        self.imageContent.contentOffset = CGPointZero;
        self.imageContent.center = self.contentView.center;
        self.largeImage.frame = self.contentView.frame;
    }];
}

- (void)setDataWithModel:(YHPhotoModel *)model {
    self.photoModel = model;
    PHAsset *asset = model.photoAsset;
    self.imageContent.frame = self.bounds;
    self.imageContent.contentSize = self.frame.size;
    self.largeImage.transform = CGAffineTransformIdentity;
    self.largeImage.frame = self.contentView.frame;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize imageSize = CGSizeMake(self.frame.size.width * scale, self.frame.size.width * scale);
    [model.cachingManager requestImageForAsset:asset
                                    targetSize:imageSize
                                   contentMode:PHImageContentModeAspectFill
                                       options:nil
                                 resultHandler:^(UIImage *result, NSDictionary *info) {
                                     if ([self.photoModel.photoAsset.localIdentifier isEqualToString:asset.localIdentifier]) {
                                         self.largeImage.image = result;
                                     }
                                 }];
}

#pragma mark - scrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.largeImage;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.largeImage.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                     scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark - setter
- (UIScrollView *)imageContent {
    if (!_imageContent) {
        _imageContent = [[UIScrollView alloc] initWithFrame:self.contentView.frame];
        _imageContent.userInteractionEnabled = YES;
        _imageContent.delegate = self;
        _imageContent.contentMode = UIViewContentModeScaleAspectFill;
        _imageContent.maximumZoomScale = 2.0;
        _imageContent.minimumZoomScale = 1;
        _imageContent.decelerationRate = UIScrollViewDecelerationRateFast;
        _imageContent.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageContent.scrollEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhotoAction:)];
        tap.numberOfTapsRequired = 2;
        [_imageContent addGestureRecognizer:tap];
    }
    return _imageContent;
}

- (UIImageView *)largeImage {
    if (!_largeImage) {
        _largeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.width)];
        _largeImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _largeImage.contentMode = UIViewContentModeScaleAspectFit;
        _largeImage.userInteractionEnabled = YES;
    }
    return _largeImage;
}

@end
