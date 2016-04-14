//
//  ProblemTableViewCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 15/11/26.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProblemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *ProblemDescriptionTextView;

@property (weak, nonatomic) IBOutlet UICollectionView *conllectionView;

@property (weak, nonatomic) IBOutlet UITextField *consigneeTectField;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *detailedAddressTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDistance;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHight;
@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UITextField *problem;

@end
