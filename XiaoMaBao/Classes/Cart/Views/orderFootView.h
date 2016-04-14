//
//  orderFootView.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/2/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface orderFootView : UIView
+ (instancetype)instanceView;

@property (weak, nonatomic) IBOutlet UILabel *priceLabletext;
@property (weak, nonatomic) IBOutlet UILabel *shuifeiLabletext;
@property (weak, nonatomic) IBOutlet UILabel *zongjiaLabeltext;

@end
