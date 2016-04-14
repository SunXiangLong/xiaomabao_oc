//
//  MBcheshiCollectionViewCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBcheshiCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,copy)  NSMutableArray *dataArray;
-(void)setsss:(NSArray *)arr;
@end
