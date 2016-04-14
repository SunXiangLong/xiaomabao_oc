//
//  XBCollectionViewController.h
//  XBScrollPageControllerDemo
//
//  Created by Scarecrow on 15/9/8.
//  Copyright (c) 2015年 xiu8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BkBaseViewController.h"
@interface XBCollectionViewController : UICollectionViewController
//XBScrollPageController 传参
@property (nonatomic,copy) NSString *cat_id;

@property (nonatomic,strong) BkBaseViewController *VC;
@property (nonatomic,strong)  NSArray *dataArray;
@property (nonatomic,assign)  CGFloat offsetY;


@end
