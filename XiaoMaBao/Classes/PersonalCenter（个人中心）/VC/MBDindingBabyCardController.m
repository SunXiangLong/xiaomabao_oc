//
//  MBDindingBabyCardController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBDindingBabyCardController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "IQKeyboardReturnKeyHandler.h"
@interface MBDindingBabyCardController ()<UITextFieldDelegate>
{

    UITextField *_recordTextFileld;
    NSString *_card_pass;
    IQKeyboardReturnKeyHandler *returnKeyHandler;
    
}
@property (weak, nonatomic) IBOutlet UITextField *textfieldOne;
@property (weak, nonatomic) IBOutlet UITextField *textfieldTwo;
@property (weak, nonatomic) IBOutlet UITextField *textfieldThree;
@property (weak, nonatomic) IBOutlet UITextField *textfieldFour;
@property (weak, nonatomic) IBOutlet UILabel *lable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (copy, nonatomic) NSMutableString *appStr;
@end

@implementation MBDindingBabyCardController
- (RACSubject *)myCircleViewSubject {
    
    if (!_myCircleViewSubject) {
        
        _myCircleViewSubject = [RACSubject subject];
    }
    
    return _myCircleViewSubject;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [_textfieldOne becomeFirstResponder];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
     [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
   
    @weakify(self);
    // 把监听到的通知转换信号
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        @strongify(self);
        
        //获取键盘的高度
        NSDictionary *userInfo = [x userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        NSValue *amValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration;
        [amValue getValue:&animationDuration];
        CGRect keyboardRect = [aValue CGRectValue];
        CGFloat height = keyboardRect.size.height;
        self.bottom.constant = height+10;
        [UIView animateWithDuration:animationDuration animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
        
     
        
        
    }];
    
    // 把监听到的通知转换信号
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(id x) {
        
        @strongify(self);
        if (self.bottom.constant != 0  ) {
            self.bottom.constant = 10;
             NSDictionary *userInfo = [x userInfo];
            NSValue *amValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
            NSTimeInterval animationDuration;
            [amValue getValue:&animationDuration];
            [UIView animateWithDuration:animationDuration animations:^{
                
                [self.view layoutIfNeeded];
            } completion:nil];
          
            
        }
        
    }];
    
    
}
- (IBAction)binding:(id)sender {
    
    _card_pass = [NSString stringWithFormat:@"%@%@%@%@",_textfieldOne.text,_textfieldTwo.text,_textfieldThree.text,_textfieldFour.text];
     _lable .hidden = YES;
    
    [self setData];
    
}
-(NSString *)titleStr{

   return @"绑定新卡";
}

- (void)setData{
    
    [_recordTextFileld resignFirstResponder];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *session = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
  
    
    
    [self show];
    
    [MBNetworking  POSTOrigin:string(BASE_URL_root, @"/mcard/madd") parameters:@{@"session":session,@"card_pass":[_card_pass uppercaseString]} success:^(id responseObject) {
        [self dismiss];

        
        MMLog(@"%@",responseObject);
        if ([[responseObject  valueForKey:@"status"] integerValue] ==1) {
            [self.myCircleViewSubject sendNext:@1];
            [self popViewControllerAnimated:YES];
        }else{
            _lable.hidden = NO;
            [self show:[responseObject valueForKeyPath:@"info"] time:1];
       
           
        }
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败" time:1];
        
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    MMLog(@"2222");
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
 MMLog(@"444");
    if (textField.text.length > 4) {
        textField.text = [textField.text substringToIndex:4];
        MMLog(@"%@",[textField.text substringFromIndex:4]);
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
      MMLog(@"333");
    switch (textField.tag) {
            case 0:{
                if (range.location>3) {//限制只允许输入4位
                    [_textfieldTwo becomeFirstResponder];
                    return NO;
                    
                }
            
            } break;
            case 1: {
                if (range.location>3) {//限制只允许输入4位
                    [_textfieldThree    becomeFirstResponder];
                    return NO;
                    
                }
            }break;
            case 2:{
                if (range.location>3) {//限制只允许输入4位
                   
                    [_textfieldFour    becomeFirstResponder];
                    return NO;
                    
                }
                
            }break;
            case 3:{
                
                if (range.location>3) {//限制只允许输入4位
                    
                    return NO;
                    
                }
            }break;
            default: return NO;
                
        }
    
    
    
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.secureTextEntry = false;
    return YES;
}


@end
