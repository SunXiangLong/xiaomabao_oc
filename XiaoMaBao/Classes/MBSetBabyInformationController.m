//
//  MBSetBabyInformationController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/3.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBSetBabyInformationController.h"
#import "SFHFKeychainUtils.h"
#import "MBLogOperation.h"
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
    
    [self setData];
    

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
                                         if ([selectedDate isEarlierThan:date] ) {
                                             NSString *currentDateStr = [dateFormatter stringFromDate:selectedDate];
                                             
                                             _baby_birthday.text = currentDateStr;
                                         }else{
                                             [self show:@"请选择正确的宝宝生日" time:1];
                                         
                                         }
                                   
                                     } cancelBlock:^(ActionSheetDatePicker *picker) {
                                         
                                     } origin:_baby_birthday];
    
}
- (NSString *)titleStr{
    return @"设置宝宝信息";
}

#pragma mark--设置宝宝信息
- (void)setData{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [self show];


   NSDictionary *parameters = @{@"session":sessiondict,@"nickname":_baby_name.text,@"birthday":_baby_birthday.text,@"gender":_babyGender};
   
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/athena/set_mengbao_info"];
    [MBNetworking   POSTOrigin:url parameters:parameters success:^(id responseObject) {
        
        MMLog(@"%@",responseObject);
        NSString *status =  s_str([responseObject valueForKeyPath:@"status"]);
        if ([status isEqualToString:@"1"]) {
            [MBLogOperation loginAuthentication:nil success:^{
                [self dismiss];
                [self.navigationController popToRootViewControllerAnimated:true];
            } failure:^(NSString *error_desc, NSError *error) {
                if (error_desc) {
        
                    [self show:error_desc time:1];
                    
                }else{
                    
                    MMLog(@"%@",error);
                    
                    [self show:@"请求失败" time:1];
                }
            }];
            
        }else{
        
            [self show:@"保存失败" time:1];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败 " time:1];
        MMLog(@"%@",error);
    }];
    
    
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
