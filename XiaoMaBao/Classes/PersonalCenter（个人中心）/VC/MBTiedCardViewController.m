//
//  MBTiedCardViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/12/19.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBTiedCardViewController.h"

@interface MBTiedCardViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *province;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *area;
@property (weak, nonatomic) IBOutlet UITextField *openBank;
@property (weak, nonatomic) IBOutlet UITextField *cardID;
@property (weak, nonatomic) IBOutlet UITextField *iphone;

@end

@implementation MBTiedCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}
-(NSString *)titleStr{
  return @"绑定银行卡";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSArray *banK = @[@"邮政银行",@"招商银行",@"农业银行",@"建设银行",@"交通银行",@"中国银行",@"兴业银行"];
    [ActionSheetStringPicker showPickerWithTitle:@"选择绑定银行" rows:banK initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        textField.text = banK[selectedIndex];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:textField];
//    [ActionSheetStringPicker showPickerWithTitle:@"请选择性别"
//                                            rows:genders
//                                initialSelection:0
//                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
//                                          
//                                     cancelBlock:^(ActionSheetStringPicker *picker) {
//                                         MMLog(@"Block Picker Canceled");
//                                     }origin:textField];
    return NO;
}

@end
