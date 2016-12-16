/*
 https://github.com/waynezxcv/Gallop
 
 Copyright (c) 2016 waynezxcv <liuweiself@126.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */



#import "UIView+DisplayAddtions.h"
#import <objc/runtime.h>
#import "LWImageStorage.h"
#import "CALayer+WebCache.h"
#import "LWTransaction.h"
#import "CALayer+LWTransaction.h"
#import "UIImage+Gallop.h"



static const void* reuseIdentifierKey;
static const void* URLKey;

static CGSize _sizeFillWithAspectRatio(CGFloat sizeToScaleAspectRatio, CGSize destinationSize);

static CGSize _sizeFitWithAspectRatio(CGFloat aspectRatio, CGSize constraints);

static void _croppedImageBackingSizeAndDrawRectInBounds(CGSize sourceImageSize,
                                                        CGSize boundsSize,
                                                        UIViewContentMode contentMode,
                                                        CGRect cropRect,
                                                        BOOL forceUpscaling,
                                                        CGSize *outBackingSize,
                                                        CGRect *outDrawRect);




@implementation UIView (DisplayAddtions)

- (NSString *)identifier {
    return objc_getAssociatedObject(self, &reuseIdentifierKey);
}

- (void)setIdentifier:(NSString *)identifier {
    objc_setAssociatedObject(self, &reuseIdentifierKey, identifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSURL *)URL {
    return objc_getAssociatedObject(self, &URLKey);
}

- (void)setURL:(NSURL *)URL {
    objc_setAssociatedObject(self, &URLKey, URL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)setContentWithImageStorage:(LWImageStorage *)imageStorage
            displaysAsynchronously:(BOOL)displaysAsynchronously
                       resizeBlock:(void(^)(LWImageStorage*imageStorage, CGFloat delta))resizeBlock {
    
    self.backgroundColor = imageStorage.backgroundColor;
    self.clipsToBounds = imageStorage.clipsToBounds;
    self.contentMode = imageStorage.contentMode;
    
    if ([imageStorage.contents isKindOfClass:[UIImage class]]) {
        
        switch (imageStorage.localImageType) {
            case LWLocalImageDrawInLWAsyncDisplayView: {
                return;
            }
                
            case LWLocalImageTypeDrawInSubView: {
                
                UIImage* image = (UIImage *)imageStorage.contents;
                [self _drawImageInSubViewWithImage:image
                                      imageStorage:imageStorage
                            displaysAsynchronously:displaysAsynchronously
                                       resizeBlock:resizeBlock];
                return;
            }
        }
    }
    
    
    if ([imageStorage.contents isKindOfClass:[NSString class]]) {
        imageStorage.contents = [NSURL URLWithString:imageStorage.contents];
    }
    
    if ([[(NSURL *)imageStorage.contents absoluteString] isEqualToString:self.URL.absoluteString]) {
        return;
    }
    
    self.URL = imageStorage.contents;
    
    if (!imageStorage.needResize) {
        [self _processNotNeedResizeWithImageStorage:imageStorage
                             displaysAsynchronously:displaysAsynchronously];
    }
    
    __weak typeof(self) weakSelf = self;
    [self.layer lw_setImageWithURL:(NSURL *)imageStorage.contents
                  placeholderImage:imageStorage.placeholder
                      cornerRadius:imageStorage.cornerRadius
             cornerBackgroundColor:imageStorage.cornerBackgroundColor
                       borderColor:imageStorage.cornerBorderColor
                       borderWidth:imageStorage.cornerBorderWidth
                              size:imageStorage.frame.size
                       contentMode:imageStorage.contentMode
                            isBlur:imageStorage.isBlur
                           options:SDWebImageAvoidAutoSetImage
                          progress:nil
                         completed:^(UIImage *image,
                                     NSError *error,
                                     SDImageCacheType cacheType,
                                     NSURL *imageURL) {
                             if (!image) {
                                 return ;
                             }
                             __strong typeof(weakSelf) sself = weakSelf;
                             
                             if (imageStorage.needResize) {
                                 [sself _processNeedResizeWithImage:image
                                                       imageStorage:imageStorage
                                             displaysAsynchronously:displaysAsynchronously
                                                        resizeBlock:resizeBlock];
                             }
                             
                             [sself _setContentsImage:image
                                         imageStorage:imageStorage
                               displaysAsynchronously:displaysAsynchronously
                                           completion:^{
                                               if (imageStorage.fadeShow) {
                                                   [weakSelf fadeShowAnimation];
                                               }
                                           }];
                         }];
}


- (void)_drawImageInSubViewWithImage:(UIImage *)image
                        imageStorage:(LWImageStorage *)imageStorage
              displaysAsynchronously:(BOOL)displaysAsynchronously
                         resizeBlock:(void(^)(LWImageStorage*imageStorage, CGFloat delta))resizeBlock {
    
    if (!imageStorage.needResize) {
        [self _processNotNeedResizeWithImageStorage:imageStorage
                             displaysAsynchronously:displaysAsynchronously];
    } else {
        [self _processNeedResizeWithImage:image
                             imageStorage:imageStorage
                   displaysAsynchronously:displaysAsynchronously
                              resizeBlock:resizeBlock];
    }
    __weak typeof(self)weakSelf = self;
    [self _setContentsImage:image
               imageStorage:imageStorage
     displaysAsynchronously:displaysAsynchronously
                 completion:^{
                     __strong typeof(weakSelf) sself = weakSelf;
                     if (imageStorage.fadeShow) {
                         [sself fadeShowAnimation];
                     }
                 }];
    
}


- (void)_processNeedResizeWithImage:(UIImage *)image
                       imageStorage:(LWImageStorage *)imageStorage
             displaysAsynchronously:(BOOL)displaysAsynchronously
                        resizeBlock:(void(^)(LWImageStorage*imageStorage, CGFloat delta))resizeBlock {
    if (displaysAsynchronously) {
        CGFloat delta = [self _resizeImageStorage:imageStorage image:image];
        [self.layer.lw_asyncTransaction addAsyncOperationWithTarget:self
                                                           selector:@selector(layoutWithStorage:)
                                                             object:imageStorage
                                                         completion:^(BOOL canceled) {
                                                             resizeBlock(imageStorage,delta);
                                                         }];
    } else {
        CGFloat delta = [self _resizeImageStorage:imageStorage image:image];
        [self layoutWithStorage:imageStorage];
        resizeBlock(imageStorage,delta);
    }
}


- (void)_processNotNeedResizeWithImageStorage:(LWImageStorage *)imageStorage
                       displaysAsynchronously:(BOOL)displaysAsynchronously {
    
    if (displaysAsynchronously) {
        [self.layer.lw_asyncTransaction addAsyncOperationWithTarget:self
                                                           selector:@selector(layoutWithStorage:)
                                                             object:imageStorage
                                                         completion:^(BOOL canceled) {}];
    } else {
        [self layoutWithStorage:imageStorage];
    }
}

- (CGFloat)_resizeImageStorage:(LWImageStorage *)imageStorage
                         image:(UIImage *)image {
    
    CGSize imageSize = image.size;
    CGFloat imageScale = imageSize.height/imageSize.width;
    CGSize reSize = CGSizeMake(imageStorage.bounds.size.width,
                               imageStorage.bounds.size.width * imageScale);
    
    CGFloat delta = reSize.height - imageStorage.frame.size.height;
    imageStorage.frame = CGRectMake(imageStorage.frame.origin.x,
                                    imageStorage.frame.origin.y,
                                    imageStorage.frame.size.width,
                                    imageStorage.frame.size.height + delta);
    return delta;
}


- (void)_setContentsImage:(UIImage *)image
             imageStorage:(LWImageStorage *)imageStorage
   displaysAsynchronously:(BOOL)displaysAsynchronously
               completion:(void(^)())completion {
    if (!image || !imageStorage) {
        return;
    }
    
    if (imageStorage.isBlur && [imageStorage.contents isKindOfClass:[UIImage class]]) {
        if (displaysAsynchronously) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UIImage* blurImage = [image lw_applyBlurWithRadius:20
                                                         tintColor:RGBA(0, 0, 0, 0.15f)
                                             saturationDeltaFactor:1.4
                                                         maskImage:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self _addSetImageTransactionWithImage:blurImage
                                    displaysAsynchronously:displaysAsynchronously
                                                completion:completion];
                });
            });
        } else {
            UIImage* blurImage = [image lw_applyBlurWithRadius:20
                                                     tintColor:RGBA(0, 0, 0, 0.15f)
                                         saturationDeltaFactor:1.4
                                                     maskImage:nil];
            [self _addSetImageTransactionWithImage:blurImage
                            displaysAsynchronously:displaysAsynchronously
                                        completion:completion];
        }
    } else {
        [self _addSetImageTransactionWithImage:image
                        displaysAsynchronously:displaysAsynchronously
                                    completion:completion];
    }
}


- (void)_addSetImageTransactionWithImage:(UIImage *)image
                  displaysAsynchronously:(BOOL)displaysAsynchronously
                              completion:(void(^)())completion {
    if (displaysAsynchronously) {
        [self.layer.lw_asyncTransaction addAsyncOperationWithTarget:self.layer
                                                           selector:@selector(setContents:)
                                                             object:(__bridge id _Nullable)image.CGImage
                                                         completion:^(BOOL canceled) {
                                                             completion();
                                                         }];
    } else {
        [self.layer setContents:(__bridge id _Nullable)image.CGImage];
        completion();
    }
}


- (void)layoutWithStorage:(LWImageStorage *)imageStorage {
    if (!CGRectEqualToRect(self.frame, imageStorage.frame)) {
        self.frame = imageStorage.frame;
    }
    self.hidden = NO;
}

- (void)cleanup {
    CGImageRef imageRef = (__bridge_retained CGImageRef)(self.layer.contents);
    id contents = self.layer.contents;
    NSURL* URL = self.URL;
    self.layer.contents = nil;
    self.URL = nil;
    if (imageRef) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [contents class];
            [URL class];
            CFRelease(imageRef);
        });
    }
    self.hidden = YES;
}


- (void)fadeShowAnimation {
    [self.layer removeAnimationForKey:@"fadeshowAnimation"];
    CATransition* transition = [CATransition animation];
    transition.duration = 0.15;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionFade;
    [self.layer addAnimation:transition forKey:@"fadeshowAnimation"];
    
}

- (void)_rerenderingImage:(UIImage *)image
             imageStorage:(LWImageStorage *)imageStorage
               completion:(void(^)())compeltion {
    
    if (!image || !imageStorage) {
        return;
    }
    
    @autoreleasepool {
        BOOL forceUpscaling = NO;
        BOOL cropEnabled = YES;
        BOOL isOpaque = imageStorage.opaque;
        UIColor* backgroundColor = imageStorage.backgroundColor;
        UIViewContentMode contentMode = imageStorage.contentMode;
        CGFloat contentsScale = imageStorage.contentsScale;
        CGRect cropDisplayBounds = CGRectZero;
        CGRect cropRect = CGRectMake(0.5, 0.5, 0, 0);
        BOOL hasValidCropBounds = cropEnabled && !CGRectIsNull(cropDisplayBounds) && !CGRectIsEmpty(cropDisplayBounds);
        CGRect bounds = (hasValidCropBounds ? cropDisplayBounds : imageStorage.bounds);
        CGSize imageSize = image.size;
        CGSize imageSizeInPixels = CGSizeMake(imageSize.width * image.scale, imageSize.height * image.scale);
        CGSize boundsSizeInPixels = CGSizeMake(floorf(bounds.size.width * contentsScale), floorf(bounds.size.height * contentsScale));
        BOOL contentModeSupported = contentMode == UIViewContentModeScaleAspectFill ||
        contentMode == UIViewContentModeScaleAspectFit ||
        contentMode == UIViewContentModeCenter;
        CGSize backingSize   = CGSizeZero;
        CGRect imageDrawRect = CGRectZero;
        CGFloat cornerRadius = imageStorage.cornerRadius;
        UIColor* cornerBackgroundColor = imageStorage.cornerBackgroundColor;
        UIColor* cornerBorderColor = imageStorage.cornerBorderColor;
        CGFloat cornerBorderWidth = imageStorage.cornerBorderWidth;
        
        if (boundsSizeInPixels.width * contentsScale < 1.0f || boundsSizeInPixels.height * contentsScale < 1.0f ||
            imageSizeInPixels.width < 1.0f                  || imageSizeInPixels.height < 1.0f) {
            return;
        }
        
        if (!cropEnabled || !contentModeSupported) {
            backingSize = imageSizeInPixels;
            imageDrawRect = (CGRect){.size = backingSize};
            
        } else {
            _croppedImageBackingSizeAndDrawRectInBounds(imageSizeInPixels,
                                                        boundsSizeInPixels,
                                                        contentMode,
                                                        cropRect,
                                                        forceUpscaling,
                                                        &backingSize,
                                                        &imageDrawRect);
        }
        if (backingSize.width <= 0.0f || backingSize.height <= 0.0f ||
            imageDrawRect.size.width <= 0.0f || imageDrawRect.size.height <= 0.0f) {
            return;
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIGraphicsBeginImageContextWithOptions(backingSize,isOpaque,contentsScale);
            if (nil == UIGraphicsGetCurrentContext()) {
                return;
            }
            if (isOpaque && backgroundColor) {
                [backgroundColor setFill];
                UIRectFill(CGRectMake(0, 0, backingSize.width, backingSize.height));
            }
            
            UIBezierPath* cornerPath = [UIBezierPath bezierPathWithRoundedRect:imageDrawRect
                                                                  cornerRadius:cornerRadius * contentsScale];
            
            UIBezierPath* backgroundRect = [UIBezierPath bezierPathWithRect:imageDrawRect];
            if (cornerBackgroundColor) {
                [cornerBackgroundColor setFill];
            }
            [backgroundRect fill];
            [cornerPath addClip];
            [image drawInRect:imageDrawRect];
            if (cornerBorderColor) {
                [cornerBorderColor setStroke];
            }
            [cornerPath stroke];
            [cornerPath setLineWidth:cornerBorderWidth];
            
            CGImageRef processedImageRef = (UIGraphicsGetImageFromCurrentImageContext().CGImage);
            UIGraphicsEndImageContext();
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.layer.lw_asyncTransaction addAsyncOperationWithTarget:self.layer
                                                                   selector:@selector(setContents:)
                                                                     object:(__bridge id _Nullable)processedImageRef
                                                                 completion:^(BOOL canceled) {
                                                                     compeltion();
                                                                 }];
            });
        });
    }
}

@end


static void _croppedImageBackingSizeAndDrawRectInBounds(CGSize sourceImageSize,
                                                        CGSize boundsSize,
                                                        UIViewContentMode contentMode,
                                                        CGRect cropRect,
                                                        BOOL forceUpscaling,
                                                        CGSize* outBackingSize,
                                                        CGRect* outDrawRect) {
    size_t destinationWidth = boundsSize.width;
    size_t destinationHeight = boundsSize.height;
    CGFloat boundsAspectRatio = (float)destinationWidth / (float)destinationHeight;
    
    CGSize scaledSizeForImage = sourceImageSize;
    BOOL cropToRectDimensions = !CGRectIsEmpty(cropRect);
    
    if (cropToRectDimensions) {
        scaledSizeForImage = CGSizeMake(boundsSize.width / cropRect.size.width, boundsSize.height / cropRect.size.height);
    } else {
        if (contentMode == UIViewContentModeScaleAspectFill)
            scaledSizeForImage = _sizeFillWithAspectRatio(boundsAspectRatio, sourceImageSize);
        else if (contentMode == UIViewContentModeScaleAspectFit)
            scaledSizeForImage = _sizeFitWithAspectRatio(boundsAspectRatio, sourceImageSize);
    }
    if (forceUpscaling == NO && (scaledSizeForImage.width * scaledSizeForImage.height) < (destinationWidth * destinationHeight)) {
        destinationWidth = (size_t)roundf(scaledSizeForImage.width);
        destinationHeight = (size_t)roundf(scaledSizeForImage.height);
        if (destinationWidth == 0 || destinationHeight == 0) {
            *outBackingSize = CGSizeZero;
            *outDrawRect = CGRectZero;
            return;
        }
    }
    
    CGFloat sourceImageAspectRatio = sourceImageSize.width / sourceImageSize.height;
    CGSize scaledSizeForDestination = CGSizeMake(destinationWidth, destinationHeight);
    if (cropToRectDimensions) {
        scaledSizeForDestination = CGSizeMake(boundsSize.width / cropRect.size.width, boundsSize.height / cropRect.size.height);
    } else {
        if (contentMode == UIViewContentModeScaleAspectFill)
            scaledSizeForDestination = _sizeFillWithAspectRatio(sourceImageAspectRatio, scaledSizeForDestination);
        else if (contentMode == UIViewContentModeScaleAspectFit)
            scaledSizeForDestination = _sizeFitWithAspectRatio(sourceImageAspectRatio, scaledSizeForDestination);
    }
    
    CGRect drawRect = CGRectZero;
    if (cropToRectDimensions) {
        drawRect = CGRectMake(-cropRect.origin.x * scaledSizeForDestination.width,
                              -cropRect.origin.y * scaledSizeForDestination.height,
                              scaledSizeForDestination.width,
                              scaledSizeForDestination.height);
    } else {
        if (contentMode == UIViewContentModeScaleAspectFill) {
            drawRect = CGRectMake(((destinationWidth - scaledSizeForDestination.width) * cropRect.origin.x),
                                  ((destinationHeight - scaledSizeForDestination.height) * cropRect.origin.y),
                                  scaledSizeForDestination.width,
                                  scaledSizeForDestination.height);
            
        } else {
            drawRect = CGRectMake(((destinationWidth - scaledSizeForDestination.width) / 2.0),
                                  ((destinationHeight - scaledSizeForDestination.height) / 2.0),
                                  scaledSizeForDestination.width,
                                  scaledSizeForDestination.height);
        }
    }
    *outDrawRect = drawRect;
    *outBackingSize = CGSizeMake(destinationWidth, destinationHeight);
}

static CGSize _sizeFillWithAspectRatio(CGFloat sizeToScaleAspectRatio, CGSize destinationSize) {
    CGFloat destinationAspectRatio = destinationSize.width / destinationSize.height;
    if (sizeToScaleAspectRatio > destinationAspectRatio) {
        return CGSizeMake(destinationSize.height * sizeToScaleAspectRatio, destinationSize.height);
    } else {
        return CGSizeMake(destinationSize.width, floorf(destinationSize.width / sizeToScaleAspectRatio));
    }
}

static CGSize _sizeFitWithAspectRatio(CGFloat aspectRatio, CGSize constraints) {
    CGFloat constraintAspectRatio = constraints.width / constraints.height;
    if (aspectRatio > constraintAspectRatio) {
        return CGSizeMake(constraints.width, constraints.width / aspectRatio);
    } else {
        return CGSizeMake(constraints.height * aspectRatio, constraints.height);
    }
}
