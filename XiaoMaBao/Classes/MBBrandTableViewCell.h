//
//  MBBrandTableViewCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/12.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBBrandTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;

- (void)loadData:(id)data indexPath:(NSIndexPath*)indexPath;
@end
