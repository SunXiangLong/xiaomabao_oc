//
//  YHPhotoBrowserViewController.h
//  YHPhotoKit
//
//  Created by deng on 16/11/26.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "YHSelectPhotoViewController.h"

@interface YHPhotoBrowserViewController : UIViewController

@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic, strong) PHCollection *photoCollection;
@property (nonatomic, strong) PHFetchResult *allFetchResult;
@property (nonatomic, strong) NSMutableArray *allPhotoArr;
@property (nonatomic, assign) NSIndexPath *currentIndex;
@property (nonatomic, strong) id<YHPhotoPickerViewControllerDelegate> photoDelegate;
@property (nonatomic, strong) YHSelectPhotoViewController *selectPhotoVCDelegate;
@property(nonatomic, assign) int maxPhotosCount;

@end
