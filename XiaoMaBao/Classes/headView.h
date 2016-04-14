//
//  headView.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface headView : UIView
+ (instancetype)instanceView;
@property (weak, nonatomic) IBOutlet UILabel *tishiLable;
@property (weak, nonatomic) IBOutlet UILabel *numLable;
@end
