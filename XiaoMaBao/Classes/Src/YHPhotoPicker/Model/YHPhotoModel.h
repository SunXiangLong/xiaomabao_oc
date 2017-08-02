//
//  YHPhotoModel.h
//  YHPhotoKit
//
//  Created by deng on 16/11/26.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface YHPhotoModel : NSObject

@property(assign, nonatomic) NSInteger index;
@property(assign, nonatomic) BOOL isSelected;
@property(assign, nonatomic) BOOL isOriginPhoto;
@property(strong, nonatomic) PHCachingImageManager *cachingManager;
@property(strong, nonatomic) PHAsset *photoAsset;
@property(strong, nonatomic) UIImage *largeImage;
@property(assign, nonatomic) CGSize largeImageSize;

- (void)setDataWithPhotoAsset:(PHAsset *)asset imageManager:(PHCachingImageManager *)imageManager;

@end
