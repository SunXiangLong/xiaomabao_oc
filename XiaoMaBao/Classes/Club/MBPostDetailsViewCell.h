//
//  MBPostDetailsViewCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBPostDetailsViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (nonatomic, strong) RACSubject *myCircleViewSubject;
@property (nonatomic,strong) NSString *imageUrlStr;
@property (nonatomic, strong)NSIndexPath *indexPath;
@end
