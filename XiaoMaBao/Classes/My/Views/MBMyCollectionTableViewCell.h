//
//  MBMyCollectionTableViewCell.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/8.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBMyCollectionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *showimageview;
@property (weak, nonatomic) IBOutlet UILabel *decribe;
@property (weak, nonatomic) IBOutlet UILabel *goods_price;

- (IBAction)saveToCart:(id)sender;
@property(copy,nonatomic)NSString *goods_id;
@property(copy,nonatomic)NSString *goodsNum;

@end
