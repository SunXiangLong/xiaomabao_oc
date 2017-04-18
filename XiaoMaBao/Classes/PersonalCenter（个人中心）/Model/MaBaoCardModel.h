//
//  MaBaoCardModel.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/4/18.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaBaoCardModel : NSObject
@property (nonatomic,strong) NSString *use_end_time;
@property (nonatomic,strong) NSString *card_money;
@property (nonatomic,strong) NSString *card_surplus_money;
@property (nonatomic,strong) NSString *card_no;
@property (nonatomic,assign) BOOL over_date;
@property (nonatomic,assign) BOOL isSelected;
@end
