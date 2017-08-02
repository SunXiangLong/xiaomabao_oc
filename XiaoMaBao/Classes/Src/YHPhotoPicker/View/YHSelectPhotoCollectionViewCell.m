//
//  YHPhotoCollectionViewCell.m
//  YHPhotoKit
//
//  Created by deng on 16/11/27.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "YHSelectPhotoCollectionViewCell.h"
#import "YHSelectPhotoViewController.h"
#import <Photos/Photos.h>

@interface YHSelectPhotoCollectionViewCell()

@property (nonatomic, strong) UIImageView *thumbImage;
@property (nonatomic, strong) UIButton *seletStatusButton;
@property (nonatomic, weak) YHPhotoModel *thumbImageModel;
@property (nonatomic, weak) YHSelectPhotoViewController *selectPhotoVC;

@end

@implementation YHSelectPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.thumbImage];
        [self.contentView addSubview:self.seletStatusButton];
    }
    return self;
}

- (void)setDataWithModel:(YHPhotoModel *)model withDelegate:(id)delegate{
    self.selectPhotoVC = delegate;
    self.seletStatusButton.selected = model.isSelected;
    _thumbImageModel = model;
    PHAsset *asset = model.photoAsset;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize imageSize = CGSizeMake(self.frame.size.width * scale / 2, self.frame.size.width * scale / 2);
    [model.cachingManager requestImageForAsset:asset
                                    targetSize:imageSize
                                   contentMode:PHImageContentModeAspectFill 
                                       options:nil
                                 resultHandler:^(UIImage *result, NSDictionary *info) {
                                     if ([_thumbImageModel.photoAsset.localIdentifier isEqualToString:asset.localIdentifier]) {
                                         self.thumbImage.image = result;
                                     }
                                 }];
}

- (void)selectedStatusChange:(id)sender {
    UIButton *selectBtn = (UIButton *)sender;
    int maxCount = self.selectPhotoVC.maxPhotosCount == 0 ? 6 : self.selectPhotoVC.maxPhotosCount;
    if (self.selectPhotoVC.selectPhotosCount >= maxCount && !selectBtn.selected) {
        if (self.selectPhotoVC.pickerDelegate && [self.selectPhotoVC.pickerDelegate respondsToSelector:@selector(selectedPhotoBeyondLimit:currentView:)]) {
            [self.selectPhotoVC.pickerDelegate selectedPhotoBeyondLimit:maxCount currentView:self.selectPhotoVC.view];
        }
        return;
    }
    _thumbImageModel.isSelected = !_thumbImageModel.isSelected;
    selectBtn.selected = _thumbImageModel.isSelected;
    [self.selectPhotoVC didSelectStatusChange:_thumbImageModel];
}

#pragma mark setter
- (UIImageView *)thumbImage {
    if (!_thumbImage) {
        _thumbImage = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        _thumbImage.contentMode = UIViewContentModeScaleAspectFill;
        _thumbImage.clipsToBounds = YES;
    }
    return _thumbImage;
}

- (UIButton *)seletStatusButton {
    if (!_seletStatusButton) {
        _seletStatusButton = [[UIButton alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width - 33, 6, 27, 27)];
        [_seletStatusButton addTarget:self action:@selector(selectedStatusChange:) forControlEvents:UIControlEventTouchUpInside];
        [_seletStatusButton setBackgroundImage:[UIImage imageNamed:@"yh_image_no_picked"] forState:UIControlStateNormal];
        [_seletStatusButton setBackgroundImage:[UIImage imageNamed:@"yh_image_picked"] forState:UIControlStateSelected];
    }
    return _seletStatusButton;
}

@end
