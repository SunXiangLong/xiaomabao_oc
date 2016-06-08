//
//  MBBabyDueDateController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBabyDueDateController.h"

@interface MBBabyDueDateController ()
{
    /**
     * 点击预产期计算器为Yes， 点击保存为NO
     */
    BOOL _isCalculation;
}
@property (weak, nonatomic) IBOutlet UITextField *dueDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastPeriodTextField;
@property (weak, nonatomic) IBOutlet UITextField *menstrualCycleTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view_height;
@property (weak, nonatomic) IBOutlet UIView *top_view;

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view_top;
@end

@implementation MBBabyDueDateController

- (void)viewDidLoad {
    [super viewDidLoad];
//  self.top_view.hidden = YES;
   
   self.top_view.transform = CGAffineTransformMakeScale(0, 0);
    
   
}
- (IBAction)shezhi:(id)sender {
    if (_isCalculation) {
        return;
    }
    _isCalculation   = !_isCalculation;
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
- (IBAction)save:(id)sender {
    if (!_isCalculation) {
        
        
        return;
    }
    _isCalculation   = !_isCalculation;

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
    NSLog(@"开始了");
}
//动画结束时
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    //方法中的flag参数表明了动画是自然结束还是被打断,比如调用了removeAnimationForKey:方法或removeAnimationForKey方法，flag为NO，如果是正常结束，flag为YES。
    NSLog(@"结束了");
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
