//
//  YHAlbumTableViewCell.h
//  YHPhotoKit
//
//  Created by deng on 16/11/27.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "YHAlbumModel.h"

@interface YHAlbumTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *albumImage;
@property (nonatomic, strong) UILabel *albumTittle;
@property (nonatomic, strong) PHCollection *albumCollection;

- (void)bindDataWithAlbumModel:(YHAlbumModel *)model;

@end
