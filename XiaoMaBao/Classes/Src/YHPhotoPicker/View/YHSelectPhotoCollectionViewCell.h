//
//  YHPhotoCollectionViewCell.h
//  YHPhotoKit
//
//  Created by deng on 16/11/27.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHPhotoModel.h"

@interface YHSelectPhotoCollectionViewCell : UICollectionViewCell

- (void)setDataWithModel:(YHPhotoModel *)model withDelegate:(id)delegate;

@end
