//
//  MBDindingBabyCardController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBDindingBabyCardController.h"

@interface MBDindingBabyCardController ()<UITextFieldDelegate>
{

    UITextField *_recordTextFileld;
    NSString *_card_pass;
    
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
    
    @weakify(self);
    // 把监听到的通知转换信号
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        @strongify(self);
        
        //获取键盘的高度
        NSDictionary *userInfo = [x userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        CGFloat height = keyboardRect.size.height;
      
        self.bottom.constant = height+10;
     
        
        
    }];
    
    // 把监听到的通知转换信号
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidHideNotification object:nil] subscribeNext:^(id x) {
        
        @strongify(self);
        if (self.bottom.constant != 0  ) {
         
          self.bottom.constant =  10;
          
            
        }
        
    }];
}
- (IBAction)binding:(id)sender {
    
    if (_textfieldOne.text.length<4 ||_textfieldThree.text.length<4 || _textfieldTwo.text.length<4|| _textfieldFour.text.length<4) {
        [_textfieldOne becomeFirstResponder];
        _lable .hidden = NO;
        return;
    }
     _lable .hidden = YES;
    _card_pass = [NSString stringWithFormat:@"%@%@%@%@",_textfieldOne.text,_textfieldTwo.text,_textfieldThree.text,_textfieldFour.text];
    [self setData];
    
}
-(NSString *)titleStr{

return @"绑定新卡";
}

- (void)setData{
    
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *session = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
  
    
    
    [self show];
    
    [MBNetworking  POSTOrigin:string(BASE_URL_root, @"/mcard/madd") parameters:@{@"session":session,@"card_pass":_card_pass} success:^(id responseObject) {
        [self dismiss];

        
        NSLog(@"%@",responseObject);
        if ([[responseObject  valueForKey:@"status"] integerValue] ==1) {
            [self.myCircleViewSubject sendNext:@1];
            [self popViewControllerAnimated:YES];
        }else{
        
            [self show:[responseObject valueForKeyPath:@"info"] time:1];
       
           
        }
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"%@",error);
        [self show:@"请求失败" time:1];
        
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
   textField.text = [textField.text uppercaseString];
    string = [string uppercaseString];
    NSLog(@"%@",string);
    
 
    
        switch (textField.tag) {
            case 0:{
                if (range.location>3) {//限制只允许输入4位
                    _textfieldTwo.text = string;
                    [_textfieldTwo becomeFirstResponder];
                    return NO;
                    
                }
            
            } break;
            case 1: {
                if (range.location>3) {//限制只允许输入4位
                    _textfieldThree.text = string;
                    [_textfieldThree    becomeFirstResponder];
                    return NO;
                    
                }
            }break;
            case 2:{
                if (range.location>3) {//限制只允许输入4位
                    _textfieldFour.text = string;
                    [_textfieldFour    becomeFirstResponder];
                    return NO;
                    
                }
                
            }break;
            case 3:{
                
                if (range.location>3) {//限制只允许输入4位
                    [_textfieldFour    resignFirstResponder];
                    return NO;
                    
                }
            }break;
            default: return NO;
                
        }
    
    
    
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _recordTextFileld = textField;
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_recordTextFileld resignFirstResponder];
}
@end
