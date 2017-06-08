//
//  MBpreparePregnantSetViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/6/5.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBpreparePregnantSetViewController.h"
#import "IQUIView+Hierarchy.h"
#import "MBLogOperation.h"
@interface MBpreparePregnantSetViewController ()
@property (weak, nonatomic) IBOutlet UITextField *notLastPeriodOfTime;
@property (weak, nonatomic) IBOutlet UITextField *theMenstrualCycle;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation MBpreparePregnantSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    RACSignal *singing =   [RACSignal combineLatest:@[RACObserve(_notLastPeriodOfTime, text),RACObserve(_theMenstrualCycle, text)] reduce:^id(NSString *text1,NSString *text2){
        return  (text1.length > 0 &&text2.length >0)?@(1):@(0);
    }];
    
    RAC(self.saveButton, enabled) = singing;
     @weakify(self);
    [RACObserve(self.saveButton, enabled) subscribeNext:^(id x) {
        @strongify(self)
        if ([x  boolValue]) {
            self.saveButton.backgroundColor = UIcolor(@"f3535e");
        }else{
            self.saveButton.backgroundColor = [UIColor grayColor];
        }
    }];
   
     [[self.saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
         @strongify(self)
         [self seavePregnancyInformation];
     }];
}
-(void)setATime:(UITextField *)textField{
    
    
    if ([textField isEqual:_theMenstrualCycle]) {
        NSMutableArray *dateArr = [NSMutableArray array];
        
        for (NSInteger i =20; i<61; i++) {
            [dateArr addObject:s_Integer(i)];
        }
       
        [ActionSheetStringPicker showPickerWithTitle:@"请选择月经周期天数" rows:dateArr  initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            textField.text = dateArr[selectedIndex];
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            
        } origin:textField];
       
        
        
        return;
    }
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate  *date = [NSDate date];
    //实例化一个NSDateFormatter对象
   [ActionSheetDatePicker showPickerWithTitle:nil datePickerMode:UIDatePickerModeDate selectedDate:date minimumDate:[date  dateBySubtractingDays:60] maximumDate:date doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
       //实例化一个NSDateFormatter对象
       NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
       //设定时间格式,这里可以设置成自己需要的格式
       [dateFormatter setDateFormat:@"yyyy-MM-dd"];
       NSString *currentDateStr = [dateFormatter stringFromDate:selectedDate];
       textField.text = currentDateStr;
   } cancelBlock:nil origin:textField];
    
}

#pragma mark--设置宝宝信息
- (void)seavePregnancyInformation{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];

    [self show];
    NSDictionary *parameters = @{@"session":sessiondict,@"last_period_data":_notLastPeriodOfTime.text,@"period_circle":_theMenstrualCycle.text,@"type":@"2"};
    if (_baby_id) {
        parameters = @{@"session":sessiondict,@"last_period_data":_notLastPeriodOfTime.text,@"period_circle":_theMenstrualCycle.text,@"type":@"2",@"baby_id":_baby_id};
    }
    
    
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/athena/set_mengbao_info"];
    [MBNetworking   POSTOrigin:url parameters:parameters success:^(id responseObject) {
        
        MMLog(@"%@",responseObject);
        NSString *status =  s_str([responseObject valueForKeyPath:@"status"]);
        if ([status isEqualToString:@"1"]) {
            
            
            if (_baby_id) {
                self.afterTheDateSetForPregnantRefreshAgain();
            }
            [MBLogOperation loginAuthentication:nil success:^{
                [self dismiss];
                [self.navigationController popToRootViewControllerAnimated:true];
            } failure:^(NSString *error_desc, NSError *error) {
                if (error_desc) {
                    
                    [self show:error_desc time:1];
                    
                }else{
                    
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

-(NSString *)titleStr{
   return @"备孕设置";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
   

        if (textField.isAskingCanBecomeFirstResponder == NO) {
            NSLog(@"do another something...");
            
            [self setATime:textField];
        }
        return NO;
    
    
    
}
@end
