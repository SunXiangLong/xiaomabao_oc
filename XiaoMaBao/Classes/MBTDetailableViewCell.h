//
//  MBTDetailableViewCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBTDetailableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *xiqiLable;
@property (weak, nonatomic) IBOutlet UILabel *miaoshuLable;

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *dataLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (weak, nonatomic) IBOutlet UIImageView *showsImage;
@property (weak, nonatomic) IBOutlet UIImageView *dingweiImageView;

@property (weak, nonatomic) IBOutlet UILabel *didianLabletext;
@end
