//
//  MBFocusOneCollectionViewCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BkBaseViewController.h"
@interface MBFocusOneCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *centenView;
@property (weak, nonatomic) IBOutlet UIButton *dianzanButton;
@property (weak, nonatomic) IBOutlet UIView *bootomView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageview;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userweizhi;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *userTime;
@property (weak, nonatomic) IBOutlet UILabel *userCenter;
@property (weak, nonatomic) IBOutlet UILabel *userZhan;
@property (weak, nonatomic) IBOutlet UILabel *userDay;
@property (weak, nonatomic) IBOutlet UILabel *userPinglun;
@property (nonatomic,strong) NSString *talk_id;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) NSString *is_praise;
@property (nonatomic,strong) NSString *user_id;
@property (nonatomic,strong) BkBaseViewController *VC;
-(void)setprase:(NSArray *)prase  image:(NSArray *)imagaeArr;
@end
