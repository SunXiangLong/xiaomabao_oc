//
//  MBShopTableViewCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 15/12/29.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBShopTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,SDPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIView *evaluationView;
@property (weak, nonatomic) IBOutlet UILabel *evaluationText;
@property (weak, nonatomic) IBOutlet UICollectionView *evaluationPhoto;
@property (copy, nonatomic) NSArray *photoArray;
@property(copy,nonatomic)NSDictionary *dic;

@end
