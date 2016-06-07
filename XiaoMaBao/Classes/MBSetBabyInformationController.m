//
//  MBSetBabyInformationController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/3.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBSetBabyInformationController.h"

@interface MBSetBabyInformationController ()
@property (weak, nonatomic) IBOutlet UITextField *baby_name;
@property (weak, nonatomic) IBOutlet UITextField *baby_birthday;

@end

@implementation MBSetBabyInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)submit:(id)sender {
    if (_baby_name.text.length < 1) {
        [self show:@"给宝宝起个可爱的名字吧！" time:1];
        [_baby_name becomeFirstResponder];
        return;
    }
      [_baby_name resignFirstResponder];
    if (_baby_birthday.text.length < 1) {
        [self show:@"请选择宝宝的生日！" time:1];
        [self selectBirthday];
        return;
    }
    
}
#pragma mark --- 宝宝生日
-(void)selectBirthday{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate  *date = [NSDate date];
    [ActionSheetDatePicker showPickerWithTitle:nil datePickerMode:UIDatePickerModeDate selectedDate:date
                                     doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                                         //实例化一个NSDateFormatter对象
                                         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                         //设定时间格式,这里可以设置成自己需要的格式
                                         [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                                         //用[NSDate date]可以获取系统当前时间
                                         NSString *currentDateStr = [dateFormatter stringFromDate:selectedDate];
                                         
                                         _baby_birthday.text = currentDateStr;
                                     } cancelBlock:^(ActionSheetDatePicker *picker) {
                                         
                                     } origin:_baby_birthday];
    
}
- (NSString *)titleStr{
    return @"设置宝宝信息";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [_baby_name resignFirstResponder];
    [self selectBirthday];
    return NO;
}

@end
