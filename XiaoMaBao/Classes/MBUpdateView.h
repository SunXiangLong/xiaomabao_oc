//
//  MBUpdateView.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/10/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBUpdateView : UIView
@property (weak, nonatomic) IBOutlet UILabel *version;
@property (weak, nonatomic) IBOutlet UILabel *ver_description;
@property (weak, nonatomic) IBOutlet UILabel *size;
+ (instancetype)instanceView;
@property(copy,nonatomic)NSDictionary *dataDic;
@end
