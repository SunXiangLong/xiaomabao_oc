//
//  ValidationView.h
//  XiaoMaBao
//
//  Created by liulianqi on 15/12/16.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ValidationView : UIView
@property (weak, nonatomic) IBOutlet UIButton *cancel;

@property (weak, nonatomic) IBOutlet UITextField *photo;

@property (weak, nonatomic) IBOutlet UIButton *code;
@property (weak, nonatomic) IBOutlet UITextField *verifcation;

@property (weak, nonatomic) IBOutlet UIButton *submit;
+ (instancetype)instanceXibView;
@end
