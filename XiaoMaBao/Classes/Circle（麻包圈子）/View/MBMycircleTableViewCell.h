//
//  MBMycircleTableViewCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/28.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^cellButtonClick)(NSIndexPath *indexPath);
@interface MBMycircleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet YYLabel *user_name;
@property (weak, nonatomic) IBOutlet UIImageView *user_image;
@property (weak, nonatomic) IBOutlet YYLabel *user_center;
@property (weak, nonatomic) IBOutlet UIButton *user_button;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property(copy,nonatomic)NSDictionary *dataDic;
@property (copy,nonatomic) cellButtonClick buttonClick;
@end
