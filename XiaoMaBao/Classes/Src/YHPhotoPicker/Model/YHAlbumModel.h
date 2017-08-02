//
//  YHAlbumModel.h
//  YHPhotoKit
//
//  Created by deng on 16/11/26.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface YHAlbumModel : NSObject

@property(strong, nonatomic)NSString *albumTittle;
@property(assign, nonatomic)NSInteger albumCount;
@property(strong, nonatomic)PHCollection *albumCollection;
@property(strong, nonatomic)PHFetchResult *albumFetchResult;

- (void)setDataWithAlbumCollection:(PHCollection *)albumCollection;

- (void)setDataWithAlbumResult:(PHFetchResult *)albumFetchResult;

@end
