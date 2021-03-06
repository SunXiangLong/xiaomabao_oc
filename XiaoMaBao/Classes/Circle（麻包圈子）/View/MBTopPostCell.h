//
//  MBTopPostCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/9.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBTopPostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *user_image;
@property (weak, nonatomic) IBOutlet YYLabel *circle_name;
@property (weak, nonatomic) IBOutlet YYLabel *post_title;
@property (weak, nonatomic) IBOutlet YYLabel *post_content;
@property (weak, nonatomic) IBOutlet YYLabel *user_name;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *post_contentheight;
@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic,strong) NSArray *array;
@property(copy,nonatomic)NSDictionary *dataDic;
@end
