//
//  MBInvoiceViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/11/22.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBInvoiceViewController.h"

@interface MBInvoiceViewController (){
    UIButton *_lastInvoiceTypeButton;
     UIButton *_lastTokenButton;
    NSArray *_invoiceText;
    NSArray *_invoiceTypeArray;
}
@property (strong, nonatomic) IBOutlet UIView *instructionsView;
@property (weak, nonatomic) IBOutlet UIButton *InvoiceTypeBt;
@property (weak, nonatomic) IBOutlet UIButton *individualInvoice;
@property (weak, nonatomic) IBOutlet UIButton *invoiceUnit;
@property (weak, nonatomic) IBOutlet UITextField *unitNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *centerText;
@property (weak, nonatomic) IBOutlet UITextField *taxIdentification;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *taxHeight;

@end

@implementation MBInvoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _centerText.text = @"1.目前只支持纸质发票，暂不支持电子发票，增值税发票 \n\n2.发票金额为订单的实际支付金额、不含红包、优惠券抵扣金额、麻豆抵扣金额、麻包卡&共享卡抵扣金额";
    
    _instructionsView.frame = CGRectMake(0, -UISCREEN_HEIGHT, UISCREEN_WIDTH, UISCREEN_HEIGHT);
    
    [[UIApplication sharedApplication].keyWindow addSubview:_instructionsView];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    _invoiceText = @[@"服装",@"化妆品",@"电子产品",@"文具用品",@"商品明细"];
    _invoiceTypeArray = @[@"个人",@"单位"];
    _invoiceUnit.layer.borderWidth  = PX_ONE;
    _individualInvoice.layer.borderWidth  = PX_ONE;
    _InvoiceTypeBt.layer.borderWidth  = PX_ONE;
    
    _lastTokenButton = _individualInvoice;
    _individualInvoice.layer.borderColor = [UIColor colorWithHexString:@"fb5151"].CGColor;
    [_individualInvoice   setTitleColor:UIcolor(@"fb5151") forState:UIControlStateNormal];
    
    
    _unitNameTextField.placeholder = @"请输入个人姓名";
    _viewHeight.constant = 130;
    _taxHeight.constant = 0;
}
-(NSString *)titleStr{
   return @"发票信息";

}
- (NSString *)rightStr{
  return @"须知";
}
-(void)rightTitleClick{
    [UIView animateWithDuration:.3f animations:^{
        _instructionsView.mj_y = 0;
    }];

}
- (IBAction)cancel:(id)sender {
    
    [UIView animateWithDuration:0.3f animations:^{
        _instructionsView.mj_y = UISCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        if (finished) {
            _instructionsView.mj_y = - UISCREEN_HEIGHT;
        }
    }];
}

- (IBAction)invoiceToken:(UIButton *)sender {
    if (![_lastTokenButton isEqual:sender]) {
        
        sender.layer.borderColor = [UIColor colorWithHexString:@"fb5151"].CGColor;
        [sender   setTitleColor:UIcolor(@"fb5151") forState:UIControlStateNormal];
       
        if (_lastTokenButton) {
            _lastTokenButton.layer.borderColor = [UIColor colorWithHexString:@"555555"].CGColor;
            [_lastTokenButton   setTitleColor:UIcolor(@"555555") forState:UIControlStateNormal];
        }
        
        _lastTokenButton = sender;
        
        if ([_lastTokenButton isEqual:_invoiceUnit]) {
            _unitNameTextField.placeholder = @"请输入单位名称";
            _viewHeight.constant = 160;
            _taxHeight.constant = 30;
        }else{
            _unitNameTextField.placeholder = @"请输入个人姓名";
             _viewHeight.constant = 130;
            _taxHeight.constant = 0;
        }
      
    }
    
    
    
}

- (IBAction)InvoiceType:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (![_lastInvoiceTypeButton isEqual:sender]) {
        _lastInvoiceTypeButton.selected = !_lastInvoiceTypeButton.selected;
        _lastInvoiceTypeButton = sender;

    }else{
        if (!_lastInvoiceTypeButton.selected) {
            _lastInvoiceTypeButton = nil;
        }
    }
    
}
- (IBAction)determine:(UIButton *)sender {

    
    if ([_lastTokenButton isEqual:_invoiceUnit]) {
        if (_unitNameTextField.text.length < 1) {
           [self show:@"请输入公司名称" time:1];
            [_unitNameTextField becomeFirstResponder];
            return;
        }
        
        if (_taxIdentification.text.length < 1) {
            [self show:@"请输入公司纳税识别号" time:1];
            [_taxIdentification becomeFirstResponder];
            return;
        }
        
    }else{
        if (_unitNameTextField.text.length < 1) {
            [self show:@"请输入个人姓名" time:1];
            [_unitNameTextField becomeFirstResponder];
            return;
        }
    }

    if (!_lastInvoiceTypeButton) {
        [self show:@"请选择发票类型" time:1];
        return;
    }
    
    NSString *inv_payee = _invoiceTypeArray[_lastTokenButton.tag];
    NSString *inv_type = _invoiceText[_lastInvoiceTypeButton.tag];
    NSString *inv_content = _unitNameTextField.text;
    self.block(inv_payee,inv_type,inv_content,_taxIdentification.text?:@"");
    [self popViewControllerAnimated:YES];
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [_unitNameTextField resignFirstResponder];
}

@end
