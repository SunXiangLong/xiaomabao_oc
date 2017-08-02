//
//  YHPhotoPickerViewController.h
//  YHPhotoKit
//
//  Created by deng on 16/11/26.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHSelectPhotoViewController.h"

@interface YHPhotoPickerViewController : UINavigationController

@property(nullable, weak, nonatomic) id<YHPhotoPickerViewControllerDelegate> pickerDelegate;
@property(nonatomic, assign) int maxPhotosCount;

@end
