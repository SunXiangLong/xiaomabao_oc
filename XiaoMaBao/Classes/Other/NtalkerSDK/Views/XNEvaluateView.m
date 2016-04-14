//
//  XNEvaluateView.m
//  TestEvaluateView
//
//  Created by Ntalker on 15/9/17.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//

#import "XNEvaluateView.h"

#define kColor(r,g,b,al) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:(al)]
#define kViewHeight CGRectGetHeight(self.frame)
#define kViewWidth CGRectGetWidth(self.frame)

#define kEvaluateRatio 0.8//
#define kEvaluateHeaderDistanceRatio 60.0/1666.0
#define kEvaluateHeaderRatio 52.0/1666.0            //标题字体大小比例
#define kEvaluateHeaderConDisRatio 80.0/1666.0      //标题,内容间距比例
#define kEvaluateContentViewRatio 70.0/1666.0       //评价内容view比例
#define kEvaluateContentDisRatio 60.0/1666.0        //评价选项间距比例
#define kEvaluateStatusButtonRatio 90.0/1666.0      //评价状态button高度比例
#define kSuggestTextHeightRatio 201.0/1666.0        //建议输入框高度比例
#define kPlaceHoderSizeRatio 45.0/1666.0            //输入框字体大小

@interface XNEvaluateView ()<UITextViewDelegate>

@property (nonatomic, strong) NSMutableArray *evaluateButtons;
@property (nonatomic, strong) NSMutableArray *evaluateStatus;
@property (nonatomic, assign) BOOL isKeyboardShow;
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, weak) id<XNEvaluateDelagate> delegate;


@end

@implementation XNEvaluateView

+ (XNEvaluateView *)addEvaluateViewWithFrame:(CGRect)frame delegate:(id<XNEvaluateDelagate>)delegate
{
    XNEvaluateView *evaluateView = [[XNEvaluateView alloc] initWithFrame:frame];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    evaluateView.bgView = [[UIView alloc] initWithFrame:keyWindow.bounds];
    evaluateView.bgView.backgroundColor = kColor(163.0, 163.0, 163.0, 0.7);
    evaluateView.delegate = delegate;
    [keyWindow addSubview:evaluateView.bgView];
    [evaluateView.bgView addSubview:evaluateView];
    
    return evaluateView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyBoardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHidden:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillChangeFrame:)
                                                     name:UIKeyboardWillChangeFrameNotification
                                                   object:nil];
        
        self.evaluateButtons = [[NSMutableArray alloc] init];
        self.evaluateStatus = [[NSMutableArray alloc] init];
        [self configureAnything];
    }
    return self;
}

- (void)configureAnything
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    [self addGestureRecognizer:tap];
    
    self.backgroundColor = kColor(250.0, 250.0, 250.0, 1.0);
    NSArray *arr = @[@"非常满意",@"满意",@"一般",@"不满意",@"非常不满意"];
    CGFloat width = CGRectGetWidth(self.frame);
    
    UIView *view = nil;
    [self addTitleView:&view withFrame:CGRectMake(0, CGRectGetWidth(self.frame) * kEvaluateHeaderDistanceRatio, CGRectGetWidth(self.frame), kViewHeight * kEvaluateHeaderRatio + 4) andTitle:@"感谢您的支持,请进行评价"];
    
    CGFloat evaluateTitleY = CGRectGetMaxY(view.frame);
    
    UIView *evaButtonView = nil;
    for (int i = 0; i < arr.count; i++) {
        
        BOOL seleted = NO;
        if (i == 0) {
            seleted = YES;
        }
        
        [self addView:&evaButtonView withFrame:CGRectMake((width - kEvaluateRatio*width)/2, evaluateTitleY + kViewHeight * kEvaluateHeaderConDisRatio +(i*(kEvaluateContentViewRatio + kEvaluateContentDisRatio) * kViewHeight), kEvaluateRatio*width, kEvaluateContentViewRatio * kViewHeight) andText:arr[i] selected:seleted inView:self];
    }
    
    CGFloat evaluateViewY = CGRectGetMaxY(evaButtonView.frame);
    
    UIView *evaStatusView = nil;
    [self addTitleView:&evaStatusView withFrame:CGRectMake(0, evaluateViewY + kViewHeight * kEvaluateHeaderConDisRatio, width, kViewHeight * kEvaluateHeaderRatio + 4) andTitle:@"问题解决状态"];
    
    NSArray *statusArr = @[@"已解决",@"跟进中",@"未解决"];
    UIView *evaStatusButton = nil;
    for (int i = 0; i < statusArr.count; i++) {
        [self addEvaStatusButton:&evaStatusButton withFrame:CGRectMake(40 + ((CGRectGetWidth(self.frame) - 73)/11) * 4 * i, CGRectGetMaxY(evaStatusView.frame) + kEvaluateContentDisRatio * kViewHeight, ((CGRectGetWidth(self.frame) - 73)/11) * 3, kViewHeight * kEvaluateStatusButtonRatio) andTitle:statusArr[i]];
        if (i == 0) {
            ((UIButton *)evaStatusButton).selected = YES;
        }
    }
    
    CGFloat evaluateStatusY = CGRectGetMaxY(evaStatusButton.frame);
    
    UIView *suggestTitleView = nil;
    [self addTitleView:&suggestTitleView withFrame:CGRectMake(0, evaluateStatusY + kEvaluateHeaderConDisRatio * kViewHeight, width, kViewHeight * kEvaluateHeaderRatio + 4) andTitle:@"建议与反馈"];
    
    UIView *suggestTextView = nil;
    
    [self addTextView:&suggestTextView withFrame:CGRectMake(117.0/3.0, kEvaluateHeaderDistanceRatio * kViewHeight + CGRectGetMaxY(suggestTitleView.frame), CGRectGetWidth(self.frame) - (117.0/3.0)*2, kSuggestTextHeightRatio * kViewHeight)];
    
    UIImageView *imageView = nil;
    [self addImageView:&imageView andFrame:CGRectMake(0, CGRectGetMaxY(suggestTextView.frame) + kViewHeight * kEvaluateHeaderDistanceRatio, kViewHeight, 0.5) andImageName:@"NTalkerUIKitResource.bundle/ntalker_line_horizon.png"];
    [self addImageView:nil andFrame:CGRectMake(CGRectGetWidth(self.frame)/2, CGRectGetMaxY(suggestTextView.frame) + kViewHeight * kEvaluateHeaderDistanceRatio, 0.5, kViewHeight - (CGRectGetMaxY(suggestTextView.frame) + kViewHeight * kEvaluateHeaderDistanceRatio)) andImageName:@"NTalkerUIKitResource.bundle/ntalker_line_vertical.png"];
    
    [self addButtonWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), CGRectGetWidth(self.frame)/2, kViewHeight - CGRectGetMaxY(imageView.frame)) andNormalTitle:@"取消" andNormalTitleColor:[self colorWithHexString:@"32a8f5"] andSel:@selector(cancel) inView:self];
    [self addButtonWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2, CGRectGetMaxY(imageView.frame), CGRectGetWidth(self.frame)/2, kViewHeight - CGRectGetMaxY(imageView.frame)) andNormalTitle:@"提交" andNormalTitleColor:[self colorWithHexString:@"32a8f5"] andSel:@selector(submit) inView:self];
    
}

#pragma mark =============公共方法=============

- (void)addLabelWithFrame:(CGRect)frame
                  andText:(NSString *)text
             andTextColor:(UIColor *)textColor
              andFontSize:(CGFloat)fontSize
                   andTag:(NSInteger)tag
                   inView:(UIView *)superView
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.backgroundColor = [UIColor clearColor];
    if (tag == 10001) {
        label.textAlignment = NSTextAlignmentLeft;
    } else {
        label.textAlignment = NSTextAlignmentCenter;
    }
    [superView addSubview:label];
}

- (void)addView:(UIView **)evaView withFrame:(CGRect)frame andText:(NSString *)text selected:(BOOL)selected inView:(UIView *)superView
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
//    view.backgroundColor = [UIColor blackColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, (2.0/1666.0) * kViewHeight, CGRectGetHeight(view.frame), CGRectGetHeight(view.frame));
    [button setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_circle_noselect.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_circle_select.png"] forState:UIControlStateSelected];
    button.adjustsImageWhenHighlighted = NO;
//    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.userInteractionEnabled = NO;
    [self.evaluateButtons addObject:button];
    [view addSubview:button];
    
    if (selected) {
        button.selected = YES;
    }
    
    [self addLabelWithFrame:CGRectMake(CGRectGetMaxX(button.frame) + 14, (2.0/1666.0)*kViewHeight, text.length * (kEvaluateHeaderRatio * kViewHeight + 2), CGRectGetHeight(view.frame))
                    andText:text
               andTextColor:[self colorWithHexString:@"666666"]
                andFontSize:kEvaluateHeaderRatio * kViewHeight
                     andTag:10001
                     inView:view];
    
    [superView addSubview:view];
    
    *evaView = view;
    
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(satisfactionLevel:)];
    [view addGestureRecognizer:tap];
}

- (void)addTitleView:(UIView **)view withFrame:(CGRect)frame andTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.textColor = [self colorWithHexString:@"333333"];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:kViewHeight * kEvaluateHeaderRatio];
    [label sizeToFit];
    
    CGRect rect = label.frame;
    rect.size.height = kViewHeight * kEvaluateHeaderRatio + 2.0;
    
    CGPoint point = CGPointMake((kViewWidth - rect.size.width)/2, rect.origin.y);
    rect.origin = point;
    
    label.frame = rect;
    
    [self addSubview:label];
    *view = label;
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMinY(label.frame) + CGRectGetHeight(label.frame)/2, CGRectGetMinX(label.frame) - 13, 2)];
    leftImageView.image = [UIImage imageNamed:@"NTalkerUIKitResource.bundle/evaluate_left.png"];
    
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + 3, CGRectGetMinY(leftImageView.frame), CGRectGetWidth(leftImageView.frame), 2)];
    rightImageView.image = [UIImage imageNamed:@"NTalkerUIKitResource.bundle/evaluate_right.png"];
    
    [self addSubview:leftImageView];
    [self addSubview:rightImageView];
}

- (void)addImageView:(UIImageView **)anImageView andFrame:(CGRect)frame andImageName:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:imageName];
    [self addSubview:imageView];
    
    if (anImageView) {
        *anImageView = imageView;
    }
}

- (void)addEvaStatusButton:(UIView **)view withFrame:(CGRect)frame andTitle:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_status_noselect.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_status_select.png"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(statusSelected:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[self colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:kEvaluateHeaderRatio * kViewHeight];
    button.adjustsImageWhenHighlighted = NO;
    [self.evaluateStatus addObject:button];
    [self addSubview:button];
    
    *view = button;
}

- (void)addTextView:(UIView **)view withFrame:(CGRect)frame
{
    UITextView *placeHolderTextView = [[UITextView alloc] initWithFrame:frame];
    placeHolderTextView.layer.masksToBounds = YES;
    placeHolderTextView.layer.borderWidth = 0.5;
    placeHolderTextView.layer.cornerRadius = 5;
    placeHolderTextView.layer.borderColor = [[self colorWithHexString:@"666666"] CGColor];
    placeHolderTextView.tag = 1000;
    placeHolderTextView.text = @"此刻的想法";
    placeHolderTextView.font = [UIFont systemFontOfSize:kPlaceHoderSizeRatio * kViewHeight];
    placeHolderTextView.textColor = [self colorWithHexString:@"666666"];
    placeHolderTextView.delegate = self;
    [self addSubview:placeHolderTextView];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:frame];
    textView.backgroundColor = [UIColor clearColor];
    textView.delegate = self;
    textView.tag = 1001;
    textView.font = [UIFont systemFontOfSize:kPlaceHoderSizeRatio * kViewHeight];
    [self addSubview:textView];
    
    *view = textView;
}

- (void)addButtonWithFrame:(CGRect)frame andNormalTitle:(NSString *)normalTitle andNormalTitleColor:(UIColor *)normalTitleColor andSel:(SEL)sel inView:(UIView *)superView
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:normalTitle forState:UIControlStateNormal];
    [button setTitleColor:normalTitleColor forState:UIControlStateNormal];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:kViewHeight * kEvaluateHeaderRatio];
    [superView addSubview:button];
}

#pragma mark ==========UITextViewDelegate=======

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    UITextView *placeHolderTextView = (UITextView *)[self viewWithTag:1000];
    placeHolderTextView.text = @"";
}

#pragma mark ============点击事件响应=============

- (void)statusSelected:(UIButton *)sender
{
    for (UIButton *button in _evaluateStatus) {
        if ([button isKindOfClass:[UIButton class]]) {
            button.selected = NO;
        }
    }
    sender.selected = !sender.selected;
}

- (void)cancel
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancel:)]) {
        [self.delegate cancel:self];
    }
}

- (void)submit
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(submitMessage:evaluateView:)]) {
        
        __block NSString *evaluateContent = nil;
        __block NSUInteger value = 0;
        [_evaluateButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
            if ([button isKindOfClass:[UIButton class]]) {
                if (button.selected == YES) {
                    UILabel *label = (UILabel *)[button.superview subviews][1];
                    evaluateContent = label.text;
                    value = idx;
                    *stop = YES;
                }
            }
        }];
        
        NSString *evalueateSatus = nil;
        for (UIButton *button in _evaluateStatus) {
            if ([button isKindOfClass:[UIButton class]]) {
                if (button.selected == YES) {
                    evalueateSatus = button.currentTitle;
                    break;
                }
            }
        }
        
        UITextView *textView = (UITextView *)[self viewWithTag:1001];
        NSString *suggestText = textView.text;
        
        NSDictionary *dict = @{EVALUATECONTENT:evaluateContent,
                               EVALUATEVALUE:@(5 - value),
                               EVALUATESTATUS:evalueateSatus,
                               EVALUATESUGGEST:suggestText?:@""};
        [self.delegate submitMessage:dict evaluateView:self];
    }
}

- (void)tapView
{
    UITextView *textView = (UITextView *)[self viewWithTag:1001];
    if ([textView isFirstResponder]) {
        [textView resignFirstResponder];
    }
}

- (void)satisfactionLevel:(UITapGestureRecognizer *)sender
{
    for (UIButton *button in _evaluateButtons) {
        if ([button isKindOfClass:[UIButton class]]) {
            button.selected = NO;
            UILabel *label = (UILabel *)[button.superview subviews][1];
            label.textColor = [self colorWithHexString:@"666666"];
        }
    }
    
    for (UIView *view in [sender.view subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            button.selected = !button.selected;
            UILabel *label = (UILabel *)[button.superview subviews][1];
            label.textColor = [self colorWithHexString:@"32a8f5"];
        }
    }
}

#pragma mark =============键盘监听================

- (void)keyBoardWillShow:(NSNotification *)sender
{
    if (!sender.userInfo) return;
    if (_isKeyboardShow) return;
    
    CGFloat screenHeight = [UIScreen mainScreen].applicationFrame.size.height;
    _isKeyboardShow = YES;
    CGFloat keyboardHeight = [[sender.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    keyboardHeight = keyboardHeight?:(282.0/667.0) * screenHeight;
    CGRect frame = self.frame;
    frame.origin.y = frame.origin.y - keyboardHeight;
    _keyboardHeight = keyboardHeight;
    self.frame = frame;
}

- (void)keyboardWillHidden:(NSNotification *)sender
{
    if (!sender.userInfo) return;
    
    _isKeyboardShow = NO;

    CGRect frame = self.frame;
    frame.origin.y = frame.origin.y + _keyboardHeight;
    self.frame = frame;
}

- (void)keyboardWillChangeFrame:(NSNotification *)sender
{
    
}

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
    
    return kColor(((float) r),((float) g),((float) b), 1);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.bgView removeFromSuperview];
}

@end
