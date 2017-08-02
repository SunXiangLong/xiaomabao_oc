//
//  YHSelectPhotoViewController.h
//  YHPhotoKit
//
//  Created by deng on 16/11/26.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@class YHPhotoModel;
@class YHSelectPhotoViewController;

@protocol YHPhotoPickerViewControllerDelegate <NSObject>

- (void)YHPhotoPickerViewController:(YHSelectPhotoViewController *)PhotoPickerViewController selectedPhotos:(NSArray *)photos;

- (void)selectedPhotoBeyondLimit:(int)count currentView:(UIView *)view;

@end

@interface YHSelectPhotoViewController : UIViewController

@property(weak, nonatomic) id<YHPhotoPickerViewControllerDelegate> pickerDelegate;
@property(strong,nonatomic) PHFetchResult *allFetchResult;
@property(strong, nonatomic) PHCollection *photoCollection;
@property(assign, nonatomic) int selectPhotosCount;
@property(nonatomic, assign) int maxPhotosCount;

- (void)didSelectStatusChange:(YHPhotoModel *)model;
- (void)finshToSelectPhoto:(YHPhotoModel *)model;

@end

