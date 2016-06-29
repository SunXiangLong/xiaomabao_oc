//
//  MBBabyDueDateController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBabyDueDateController.h"
#import "ActionSheetStringPicker.h"
#import "MBNewWebViewController.h"
#import "SFHFKeychainUtils.h"
#import "MBLogOperation.h"
@interface MBBabyDueDateController ()
{
    /**
     * 点击预产期计算器为Yes， 点击保存为NO
     */
    BOOL _isCalculation;
    
    NSDate *_lastPeriodDate;
}
@property (weak, nonatomic) IBOutlet UITextField *dueDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastPeriodTextField;
@property (weak, nonatomic) IBOutlet UITextField *menstrualCycleTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view_top;
@property (weak, nonatomic) IBOutlet UIView *top_view;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation MBBabyDueDateController


- (void)viewDidLoad {
    [super viewDidLoad];
   self.top_view.transform = CGAffineTransformMakeScale(0, 0);
    
   
}
#pragma mark--设置宝宝信息
- (void)setData{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    if (_lastPeriodTextField.text.length == 0 ) {
        
    _lastPeriodTextField.text = @"";
    }
    
    if ( _menstrualCycleTextField.text.length==0) {
       _menstrualCycleTextField.text = @"";
    }
    [self show];
    
    
    NSDictionary *parameters = @{@"session":sessiondict,@"overdue_date":_dueDateTextField.text,@"last_period_data":_lastPeriodTextField.text,@"period_circle":_menstrualCycleTextField.text};
    
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/athena/set_mengbao_info"];
    [MBNetworking   POSTOrigin:url parameters:parameters success:^(id responseObject) {
 
        NSLog(@"%@",responseObject);
        NSString *status =  s_str([responseObject valueForKeyPath:@"status"]);
        if ([status isEqualToString:@"1"]) {
            
            
    
            [MBLogOperation loginAuthentication:nil success:^{
                [self dismiss];
                [self popViewControllerAnimated:YES];
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
        NSLog(@"%@",error);
    }];
    
    
}
- (IBAction)shezhi:(id)sender {
   _top_view.hidden = NO;
    _isCalculation   = YES;
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(UISCREEN_WIDTH/2, 288)];
    anim.duration = .5f;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    // 必须设置代理
    anim.delegate = self;
    [self.button.layer addAnimation:anim forKey:@"position"];
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1];
    scaleAnimation.duration = .5f;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = NO;
        scaleAnimation.delegate = self;
   [self.top_view.layer addAnimation:scaleAnimation forKey:@"transform.scale"];
   

  
    

    
}

- (IBAction)jishuan:(id)sender {
    MBNewWebViewController *VC = [[MBNewWebViewController alloc] init];
    
    [self pushViewController:VC Animated:YES];
}

- (IBAction)save:(id)sender {
   
  
    
    if (_dueDateTextField.text.length ==0  ) {
       if (_isCalculation) {
            
            if (_lastPeriodTextField.text.length == 0 ) {
                
                [self show:@"选择末次月经时间" time:1];
                
                return;
            }
            
            if ( _menstrualCycleTextField.text.length==0) {
                
                [self show:@"选择月经周期天数" time:1];
                
                return;
            }
           
          NSInteger time =  28 - ( [_menstrualCycleTextField.text integerValue] - 45)+279;
          NSDate *dueDate = [_lastPeriodDate dateByAddingDays:time];
          NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
           //设定时间格式,这里可以设置成自己需要的格式
           [dateFormatter setDateFormat:@"yyyy-MM-dd"];
           //用[NSDate date]可以获取系统当前时间
           NSString *currentDateStr = [dateFormatter stringFromDate:dueDate];
           _dueDateTextField.text = currentDateStr;
           
           [self setAnimation];
           
       }else{
           
           [self show:@"请设置你的预产期(可点击预产期计算器帮助计算)" time:1];
           return;
       }
     
        
    }
      [self setData];
    
    _isCalculation   = NO;
}
/**
 *  隐藏预产期计算器
 */
- (void)setAnimation{
     _top_view.hidden = YES;
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    scaleAnimation.toValue = [NSNumber numberWithFloat:0];
    scaleAnimation.duration = .5f;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.delegate = self;
    [self.top_view.layer addAnimation:scaleAnimation forKey:@"transform.scale"];
    
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
    
    
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(UISCREEN_WIDTH/2, 188)];
    anim.duration = .5f;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    // 必须设置代理
    anim.delegate = self;
    [self.button.layer addAnimation:anim forKey:@"position"];

}
//动画开始时
- (void)animationDidStart:(CAAnimation *)anim{
//    NSLog(@"开始了");
}
//动画结束时
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    //方法中的flag参数表明了动画是自然结束还是被打断,比如调用了removeAnimationForKey:方法或removeAnimationForKey方法，flag为NO，如果是正常结束，flag为YES。
//    NSLog(@"结束了");
    if (_isCalculation) {
        self.top_view.transform = CGAffineTransformMakeScale(1 ,1);
        self.view_height.constant = 90;
        self.view_top.constant = 10;
       
    }else{
        self.top_view.transform = CGAffineTransformMakeScale(0 ,0);
        self.view_height.constant = 0;
        self.view_top.constant = 0;
    
    }
  

}
#pragma mark --- 选择日期
-(void)selectBirthday:(UITextField *)textField{
    NSMutableArray *dateArr = [NSMutableArray array];
    
    for (NSInteger i =20; i<46; i++) {
        [dateArr addObject:s_Integer(i)];
    }
    if ([_menstrualCycleTextField isEqual:textField]) {
  

        [ActionSheetStringPicker showPickerWithTitle:@"请选择月经周期天数" rows:dateArr  initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            textField.text = dateArr[selectedIndex];
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            
        } origin:textField];
        return;
    }
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
                                         if ([_lastPeriodTextField isEqual:textField]) {
                                             if ([selectedDate isEarlierThan:date] ) {
                                              _lastPeriodDate = selectedDate;
                                             textField.text = currentDateStr;
                                             }else{
                                              [self show:@"请选择正确的末次月经时间" time:1];
                                             }
                                             
                                         }else{
                                             if ([selectedDate isLaterThan:date] ) {
                                                 textField.text = currentDateStr;

                                             }else{
                                                 [self show:@"请选择正确的预产期时间" time:1];
                                             }
                                         
                                         }
                                         
                                    
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
