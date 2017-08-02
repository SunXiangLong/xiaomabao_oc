//
//  YHPhotoPickerViewController.m
//  YHPhotoKit
//
//  Created by deng on 16/11/26.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "YHPhotoPickerViewController.h"
#import "YHAlbumViewController.h"

@interface YHPhotoPickerViewController ()

@end

@implementation YHPhotoPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    YHAlbumViewController *albumViewController = [[YHAlbumViewController alloc] init];
    albumViewController.pickerDelegate = self.pickerDelegate;
    albumViewController.maxPhotosCount = self.maxPhotosCount;
    [self pushViewController:albumViewController animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
