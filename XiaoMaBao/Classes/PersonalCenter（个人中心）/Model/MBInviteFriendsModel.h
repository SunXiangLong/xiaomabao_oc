//
//  MBInviteFriendsModel.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/3/30.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MBShareModel: NSObject
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) NSURL *url;
@end
@interface MBCounponModel: NSObject
@property (nonatomic,strong) NSString *user_name;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSURL *header_img;
@property (nonatomic,strong) NSString *coupon_type;
@end
@interface MBInviteFriendsModel : NSObject
@property (nonatomic,strong) MBShareModel *share;
@property (nonatomic,strong) NSMutableArray<MBCounponModel *>*counponArray;
@end
