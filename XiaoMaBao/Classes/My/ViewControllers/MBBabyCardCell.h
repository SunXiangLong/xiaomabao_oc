//
//  MBBabyCardCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBBabyCardCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *babyCard;
@property (weak, nonatomic) IBOutlet UILabel *babyCardPrice;
@property (weak, nonatomic) IBOutlet UILabel *babyCardDate;
@property(copy,nonatomic)NSDictionary *dataDic;
@property (weak, nonatomic) IBOutlet UIButton *seleButton;
@property (nonatomic, strong) RACSubject *myCircleViewSubject;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@end
