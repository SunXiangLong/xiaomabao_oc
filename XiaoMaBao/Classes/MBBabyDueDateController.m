//
//  MBBabyDueDateController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBabyDueDateController.h"

@interface MBBabyDueDateController ()
@property (weak, nonatomic) IBOutlet UITextField *dueDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastPeriodTextField;
@property (weak, nonatomic) IBOutlet UITextField *menstrualCycleTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view_height;
@property (weak, nonatomic) IBOutlet UIView *top_view;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view_top;
@end

@implementation MBBabyDueDateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.top_view.hidden = YES;
   
    self.top_view.transform = CGAffineTransformMakeScale(0, 0);
   
}
- (IBAction)shezhi:(id)sender {

    
    
    [UIView animateWithDuration:.5f animations:^{
        self.view_height.constant = 90;
        self.view_top.constant = 10;
        self.top_view.hidden = NO;
        self.top_view.transform = CGAffineTransformMakeScale(1, 1);
        
    } completion:^(BOOL finished) {
     
      
    }];
    
}
- (IBAction)save:(id)sender {
   

    [UIView animateWithDuration:.5f animations:^{
        self.view_height.constant = 0;
        self.view_top.constant = 0;
        self.top_view.hidden = YES;
        self.top_view.transform = CGAffineTransformMakeScale(0, 0);
    
    } completion:^(BOOL finished) {
       
    }];
    
}
#pragma mark --- 选择日期
-(void)selectBirthday:(UITextField *)textField{
    
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
                                         
                                         textField.text = currentDateStr;
                                     } cancelBlock:^(ActionSheetDatePicker *picker) {
                                         
                                     } origin:textField];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [self selectBirthday:textField];
    return NO;
}


@end
