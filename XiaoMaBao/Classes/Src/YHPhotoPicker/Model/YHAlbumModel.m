//
//  YHAlbumModel.m
//  YHPhotoKit
//
//  Created by deng on 16/11/26.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "YHAlbumModel.h"

@implementation YHAlbumModel

- (void)setDataWithAlbumCollection:(PHCollection *)albumCollection {
    _albumCollection = albumCollection;
    _albumTittle = albumCollection.localizedTitle;
}

- (void)setDataWithAlbumResult:(PHFetchResult *)albumFetchResult {
    _albumFetchResult = albumFetchResult;
    _albumTittle = @"相机胶卷";
}

@end
