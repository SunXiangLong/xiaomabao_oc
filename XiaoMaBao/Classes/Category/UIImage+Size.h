//
//  UIImage+Size.h
//  WNXHuntForCity
//
//  Created by MacBook on 15/7/13.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Size)
+ (instancetype)saImageWithSingleColor:(UIColor *)color;
//修改image的大小

- (UIImage *)imageByScalingToSize:(CGSize)targetSize;

// 控件截屏
+ (UIImage *)imageWithCaputureView:(UIView *)view;
/*
 *
 *  压缩图片至目标尺寸
 *
 *  @param sourceImage 源图片
 *  @param maxValue 图片长宽最大值
 *
 *  @return 返回按照源图片的宽、高比例压缩至目标宽、高的UIImage图片
 */
- (UIImage *)resizeImage:(UIImage *)sourceImage toMaxWidthAndHeight:(CGFloat)maxValue ;


/**
 *  调整图片尺寸和大小
 *
 *  @param sourceImage  原始图片
 *  @param maxImageSize 新图片最大尺寸
 *  @param maxSize      新图片最大存储大小
 *
 *  @return 新图片imageData
 */

+ (NSData *)reSizeImageData:(UIImage *)sourceImage maxImageSize:(CGFloat)maxImageSize maxSizeWithKB:(CGFloat) maxSize;
@end
