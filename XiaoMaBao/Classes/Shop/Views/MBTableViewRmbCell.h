//
//  MBTableViewRmbCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBTableViewRmbCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) NSString *image_height;

- (void)setImageUrl:(NSString *)str;
@end
