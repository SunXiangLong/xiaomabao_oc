//
//  MBMBSMCategoryTwoVC.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/6/28.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class catListsModel;
@interface MBSMCategoryTwoVC : UIViewController
@property(copy,nonatomic)NSArray<catListsModel *> *catListsArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,copy)  void (^backCatID)(NSString *catID);
@end
