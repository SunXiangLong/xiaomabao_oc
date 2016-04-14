//
//  MBLevelDisplayImagesView.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBLevelDisplayImagesView : UIView
/**
 *  图片长
 */
@property (nonatomic,assign) NSInteger height;
/**
 *  图片宽
 */
@property (nonatomic,assign) NSInteger width;
/**
 *  俩个图片之间的间距
 */
@property (nonatomic,assign) NSInteger minimumLineSpacing;
/**
 *  本地图片数组
 */
@property (nonatomic,strong) NSArray *imageArray;
/**
 *  网络图片数组
 */
@property (nonatomic,strong) NSArray *urlImageArray;

@end
