//
//  YHAlbumTableViewCell.m
//  YHPhotoKit
//
//  Created by deng on 16/11/27.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "YHAlbumTableViewCell.h"

#define kAlbumImageSize CGSizeMake(55, 54)

@implementation YHAlbumTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.albumImage];
        [self.contentView addSubview:self.albumTittle];
        [self addSubviewConstraint];
    }
    return self;
}

- (void)addSubviewConstraint {
    
    self.albumImage.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addConstraints:@[
                                       
                                       [NSLayoutConstraint constraintWithItem:self.albumImage
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0
                                                                     constant:5],
                                       
                                       [NSLayoutConstraint constraintWithItem:self.albumImage
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0
                                                                     constant:5],
                                       
                                       [NSLayoutConstraint constraintWithItem:self.albumImage
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0
                                                                     constant:-5],
                                       
                                       [NSLayoutConstraint constraintWithItem:self.albumImage
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeHeight
                                                                   multiplier:1.0
                                                                     constant:-10]
                                       ]];
    
    self.albumTittle.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addConstraints:@[
                                       
                                       [NSLayoutConstraint constraintWithItem:self.albumTittle
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.albumImage
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0
                                                                     constant:5],
                                       
                                       [NSLayoutConstraint constraintWithItem:self.albumTittle
                                                                    attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.albumImage
                                                                    attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0
                                                                     constant:0],
                                       
                                       [NSLayoutConstraint constraintWithItem:self.albumTittle
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.albumImage
                                                                    attribute:NSLayoutAttributeHeight
                                                                   multiplier:1.0
                                                                     constant:0],
                                       
                                       [NSLayoutConstraint constraintWithItem:self.albumTittle
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0
                                                                     constant:-5]
                                       ]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)bindDataWithAlbumModel:(YHAlbumModel *)model {
    PHCachingImageManager *imageManage = [[PHCachingImageManager alloc] init];
    if (model.albumCollection) {
        PHFetchResult *albumImagaAssert = [PHAsset fetchAssetsInAssetCollection:(PHAssetCollection *)model.albumCollection options:nil];
        if (albumImagaAssert.count > 0) {
            PHAsset *imageAsset = albumImagaAssert[albumImagaAssert.count - 1];
            [imageManage requestImageForAsset:imageAsset targetSize:kAlbumImageSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                _albumImage.image = result;
            }];
        }
    } else {
        if (model.albumFetchResult.count > 0) {
            PHAsset *imageAsset = model.albumFetchResult[model.albumFetchResult.count - 1];
            [imageManage requestImageForAsset:imageAsset
                                   targetSize:kAlbumImageSize
                                  contentMode:PHImageContentModeDefault
                                      options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                          _albumImage.image = result;
                                      }];
        }
    }
    _albumTittle.text = model.albumTittle;
}

#pragma mark setter
- (UIImageView *)albumImage {
    if (!_albumImage) {
        _albumImage = [[UIImageView alloc] init];
        _albumImage.contentMode = UIViewContentModeScaleAspectFill;
        _albumImage.layer.masksToBounds = YES;
    }
    return _albumImage;
}

- (UILabel *)albumTittle {
    if (!_albumTittle) {
        _albumTittle = [[UILabel alloc] init];
        _albumImage.contentMode = UIViewContentModeScaleAspectFill;
        _albumImage.layer.masksToBounds = YES;
    }
    return _albumTittle;
}

@end
