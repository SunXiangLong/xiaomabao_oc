//
//  UIXNLeaveMsgViewController.m
//  CustomerServerSDK2
//
//  Created by NTalker on 15/5/1.
//  Copyright (c) 2015年 NTalker. All rights reserved.
//



#import "NTalkerLeaveMsgViewController.h"
#import "HPGrowingTextView.h"
#import "XNUserBasicInfo.h"
#import "XNHttpManager.h"
#import "XNFirstHttpService.h"
#import "XNUtilityHelper.h"
#import "XNGetflashserverDataModel.h"
#import "XNStatisticsHelper.h"

#define NOTIFICATION_XN_LEAVEMEAASGENOTIFICATION @"NOTIFICATION_XN_LEAVEMEAASGENOTIFICATION"

#define kFWFullScreenHeight     [UIScreen mainScreen].bounds.size.height
#define kFWFullScreenWidth      [UIScreen mainScreen].bounds.size.width

#define leaveMesageBackGroundColor             [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0]
#define leaveMesagerightItemButtonColor             [UIColor colorWithRed:13/255.0 green:94/255.0 blue:250/255.0 alpha:1.0]
#define NTalkSTR(str) str?:@""

@interface NTalkerLeaveMsgViewController ()<UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>{
    
    float autoSizeScaleX;
    float autoSizeScaleY;
    BOOL iphone6P;
    BOOL iphone6;
    UIButton *submitBtn;
    
}

@property (strong, nonatomic) UITextView *messageTextView;
@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UITextField *phoneNumTextField;
@property (strong, nonatomic) UITextField *emailTextField;

@end

@implementation NTalkerLeaveMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    autoSizeScaleX=kFWFullScreenHeight>480?kFWFullScreenWidth/320:1.0;
    autoSizeScaleY=kFWFullScreenHeight>736?kFWFullScreenHeight/736:1.0;
    iphone6P=CGSizeEqualToSize(CGSizeMake(414, 736), [[UIScreen mainScreen] bounds].size);
    iphone6=CGSizeEqualToSize(CGSizeMake(375, 667), [[UIScreen mainScreen] bounds].size);
    
    //    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view setBackgroundColor:leaveMesageBackGroundColor];
    
    [XNStatisticsHelper XNStatistics:@"22"
                      isOpenChatCtrl:NO
                           sessionId:nil
                           settingId:_settingId];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardWillAppearence:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardWillHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.title = @"留言";
    
    [self configureNavigate];
    [self configureTextView];
    
    UITextView *messageTV = (UITextView *)[self.view viewWithTag:2101];
    
    self.messageTextView = messageTV;
    
    UITextField *nameTF = nil;
    [self addtextField:&nameTF
                 frame:CGRectMake(10, CGRectGetMaxY(messageTV.frame) + 20*autoSizeScaleY, kFWFullScreenWidth - 20, 40 * autoSizeScaleY)
        andPlaceHolder:@" 姓名"
           andFontSize:14 * autoSizeScaleY
          andTextColor:[UIColor blackColor]
                inView:self.view];
    self.nameTextField = nameTF;
    
    UITextField *phoneTF = nil;
    [self addtextField:&phoneTF
                 frame:CGRectMake(10, CGRectGetMaxY(nameTF.frame) + 8 * autoSizeScaleY, kFWFullScreenWidth - 20, 40 * autoSizeScaleY)
        andPlaceHolder:@" 手机号"
           andFontSize:14 * autoSizeScaleY
          andTextColor:[UIColor blackColor]
                inView:self.view];
    self.phoneNumTextField = phoneTF;
    
    UITextField *emailTF = nil;
    [self addtextField:&emailTF
                 frame:CGRectMake(10, CGRectGetMaxY(phoneTF.frame) + 8 * autoSizeScaleY, kFWFullScreenWidth - 20, 40 * autoSizeScaleY)
        andPlaceHolder:@" 邮箱"
           andFontSize:14 * autoSizeScaleY
          andTextColor:[UIColor blackColor]
                inView:self.view];
    self.emailTextField = emailTF;
    
    [self configureSubmitButton:CGRectMake(10, CGRectGetMaxY(emailTF.frame) + 20 * autoSizeScaleY, kFWFullScreenWidth - 20, 40 * autoSizeScaleY)];
    
}

#pragma mark =====================configure=====================

- (void)configureNavigate
{
    UIImage *backBtnImg=[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_back_btn.png"];
    UIBarButtonItem *backButtonItem=[[UIBarButtonItem alloc] initWithImage:backBtnImg style:0 target:self action:@selector(backButton)];
    [backButtonItem setTintColor:[UIColor colorWithPatternImage:backBtnImg]];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)configureTextView
{
    UITextView *placeholderTV = [[UITextView alloc] initWithFrame:CGRectMake(10, 64 + 30*autoSizeScaleY, kFWFullScreenWidth - 20, 140*autoSizeScaleY)];
    placeholderTV.backgroundColor = [UIColor whiteColor];
    placeholderTV.text = @"";
    placeholderTV.textColor = [self colorWithHexString:@"666666"];
    placeholderTV.font = [UIFont systemFontOfSize:16 * autoSizeScaleY];
    placeholderTV.delegate = self;
    placeholderTV.tag = 2100;
    [self.view addSubview:placeholderTV];
    
    UITextView *placeHolderTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 64 + 30*autoSizeScaleY, kFWFullScreenWidth - 20, 140*autoSizeScaleY)];
    placeHolderTextView.tag = 2102;
    placeHolderTextView.text = @" 留言...";
    placeHolderTextView.font = [UIFont systemFontOfSize:16 * autoSizeScaleY];
    placeHolderTextView.textColor = [self colorWithHexString:@"666666"];
    placeHolderTextView.delegate = self;
    [self.view addSubview:placeHolderTextView];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 64 + 30*autoSizeScaleY, kFWFullScreenWidth - 20, 140*autoSizeScaleY)];
    textView.backgroundColor = [UIColor clearColor];
    //设置边框
    textView.layer.borderWidth = 0.5f;
    textView.layer.borderColor = [[self colorWithHexString:@"dfdfdd"] CGColor];
    textView.delegate = self;
    textView.tag = 2101;
    textView.returnKeyType = UIReturnKeyDone;
    textView.textColor = [UIColor blackColor];
    textView.font = [UIFont systemFontOfSize:16 * autoSizeScaleY];
    
    [self.view addSubview:textView];
    
}

- (void)configureSubmitButton:(CGRect)frame
{
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = frame;
    [submitButton setBackgroundColor:[self colorWithHexString:@"32a8f5"]];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
}

#pragma mark ==================UITextViewDelegate==============

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView.tag != 2101) {
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView.tag == 2101)
    {
        for (UIView *view in [self.view subviews]) {
            if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]]) {
                view.layer.borderColor = [[self colorWithHexString:@"dfdfdd"] CGColor];
                
            }
        }
        textView.layer.borderColor = [[self colorWithHexString:@"32a8f5"] CGColor];
        
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag == 2101) {
        if (!textView.text.length) {
            UITextView *placeHolderTV = (UITextView *)[self.view viewWithTag:2102];
            placeHolderTV.text = @" 留言...";
        } else {
            UITextView *placeHolderTV = (UITextView *)[self.view viewWithTag:2102];
            placeHolderTV.text = @"";
        }
    } else {
        
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if ([textView isFirstResponder]) {
            [textView resignFirstResponder];
        }
    }
    return YES;
}

#pragma mark ==================UITextFieldDelegte=============

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    for (UIView *view in [self.view subviews]) {
        if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]]) {
            view.layer.borderColor = [[self colorWithHexString:@"dfdfdd"] CGColor];
            
        }
    }
    textField.layer.borderColor = [[self colorWithHexString:@"32a8f5"] CGColor];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark =====================点击事件======================

- (void)submit
{
    XNUserBasicInfo *basicInfo = [XNUserBasicInfo sharedInfo];
    
    if (![self check]) {
        return;
    };
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:NTalkSTR(_nameTextField.text) forKey:@"msg_name"];
    [dict setObject:NTalkSTR(_phoneNumTextField.text) forKey:@"msg_tel"];
    [dict setObject:NTalkSTR(_emailTextField.text) forKey:@"msg_email"];
    [dict setObject:NTalkSTR(_messageTextView.text) forKey:@"msg_content"];
    [dict setObject:@"UTF-8" forKey:@"charset"];
    [dict setObject:@"" forKey:@"parentpageurl"];
    [dict setObject:@"Index" forKey:@"m"];
    [dict setObject:@"queryService" forKey:@"a"];
    [dict setObject:@"leaveMsg" forKey:@"t"];
    [dict setObject:NTalkSTR(_siteId) forKey:@"siteid"];
    [dict setObject:NTalkSTR(basicInfo.uid) forKey:@"myuid"];
    [dict setObject:NTalkSTR(_responseKefu) forKey:@"destuid"];
    [dict setObject:@"" forKey:@"ntkf_t2d_sid"];
    [dict setObject:@"" forKey:@"source"];
    [dict setObject:NTalkSTR(_pageTitle) forKey:@"parentpagetitle"];
    [dict setObject:NTalkSTR(_pageURLString) forKey:@"parentpageurl"];
    
    
    NSString *URLString = [NSString stringWithFormat:@"%@queryservice.php",basicInfo.serverData.manageserver];
    URLString = [XNUtilityHelper URLStringByURLBody:URLString andParam:dict];
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[[XNHttpManager sharedManager] getFirstHttpService] postLeaveMessageWithURL:URLString andParam:nil withBlock:^(id response) {
        NSString *str = nil;
        if ([response isKindOfClass:[NSError class]]) {
            str = @"留言提交失败";
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        } else {
            str = @"提交成功";
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        [self hideActivityViewWithTag:10001 inView:self.view];
        self.view.userInteractionEnabled = YES;
    }];
    [self showActivityViewWithFrame:CGRectMake((kFWFullScreenWidth - 50)/2, (kFWFullScreenHeight - 50)/2, 50, 50) andTag:10001 inView:self.view];
    self.view.userInteractionEnabled = NO;
}

- (void)backButton {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark =====================other========================

- (void)addtextField:(UITextField **)tField frame:(CGRect)frame andPlaceHolder:(NSString *)placeholder andFontSize:(CGFloat)fontSize andTextColor:(UIColor *)textColor inView:(UIView *)superView
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.layer.borderWidth = 0.5;
    textField.delegate = self;
    textField.placeholder = placeholder;
    textField.font = [UIFont systemFontOfSize:fontSize];
    textField.textColor = textColor;
    textField.returnKeyType = UIReturnKeyDone;
    textField.backgroundColor = [UIColor whiteColor];
    [superView addSubview:textField];
    textField.layer.borderColor = [[self colorWithHexString:@"dfdfdd"] CGColor];
    
    if (tField) {
        *tField = textField;
    }
}

- (BOOL)check
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9]|7[0])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    //用于检测手机号的 NSPredicate
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    //用于校验邮箱的正则表达式
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    //用于校验邮箱的 NSPredicate
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    NSString *promtString = nil;
    if (!_messageTextView.text.length)
    {
        promtString = @"请输入留言内容";
    }
    else if (!_nameTextField.text.length)
    {
        promtString = @"请输入姓名";
    } else if (![regextestmobile evaluateWithObject:_phoneNumTextField.text] &&
               ![regextestcm evaluateWithObject:_phoneNumTextField.text] &&
               ![regextestct evaluateWithObject:_phoneNumTextField.text] &&
               ![regextestcu evaluateWithObject:_phoneNumTextField.text] &&
               ![emailTest evaluateWithObject:_emailTextField.text])
    {
        promtString = @"请输入格式正确的电话号码 或 邮箱地址";
    }
    
    if (promtString.length) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:promtString
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    return YES;
}

#pragma mark ====================keyBoard==================

- (void)keyBoardWillAppearence:(NSNotification *)sender
{
    for (UIView *view in [self.view subviews]) {
        if ([view isFirstResponder]) {
            CGFloat keyBoardOrigin = [[sender.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
            
            CGFloat respondsMaxY = 0;
            if (self.view.frame.origin.y != 0) {
                respondsMaxY = CGRectGetMaxY(view.frame) + self.view.frame.origin.y;
            } else {
                respondsMaxY = CGRectGetMaxY(view.frame);
            }
            
            if (keyBoardOrigin < respondsMaxY) {
                CGRect frame = self.view.frame;
                frame.origin.y = frame.origin.y + keyBoardOrigin - respondsMaxY;
                self.view.frame = frame;
            }
        }
    }
}

- (void)keyBoardWillHidden:(NSNotification *)sender
{
    if (self.view.frame.origin.y != 0) {
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    }
}

#pragma mark =====================UIAlertViewDelegate===================

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark ==========================other===========================

- (UIColor *)colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    //if ([cString length] < 6) return DEFAULT_VOID_COLOR;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    //if ([cString length] != 6) return DEFAULT_VOID_COLOR;
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:(1.0)];
}

- (void)showActivityViewWithFrame:(CGRect)rect andTag:(NSInteger)tag inView:(UIView *)superView
{
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithFrame:rect];
    activityView.center = CGPointMake((superView.frame.size.width - 25)/2, (superView.frame.size.height - 25)/2);
    
    [activityView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.75f]];
    
    [activityView.layer setCornerRadius:5.0f];
    [activityView.layer setMasksToBounds:YES];
    [activityView setAlpha:1.0f];
    
    activityView.tag = tag;
    activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [activityView startAnimating];
    [superView addSubview:activityView];
}

- (void)hideActivityViewWithTag:(NSInteger)tag inView:(UIView *)superView
{
    UIActivityIndicatorView *view = (UIActivityIndicatorView *)[superView viewWithTag:tag];
    [view stopAnimating];
    [view removeFromSuperview];
}

-(void)dealloc{
    //    DLog(@"UIXNLeaveMsgViewController dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
