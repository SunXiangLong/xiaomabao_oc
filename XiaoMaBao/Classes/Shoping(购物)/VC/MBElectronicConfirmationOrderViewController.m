//
//  MBElectronicConfirmationOrderViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/3/21.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBElectronicConfirmationOrderViewController.h"
#import "MBDiscountCell.h"
#import "MBWelfareCardCollectionViewCell.h"
#import "MBInvoiceViewController.h"
#import "MBBabyCardController.h"
#import "MBPaymentViewController.h"
#import "MaBaoCardModel.h"
@interface MBElectronicConfirmationOrderViewController ()
{
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *card_amount;
@property (copy,nonatomic) NSMutableString *cards;
@property (strong,nonatomic) NSMutableArray<NSMutableDictionary *> *discountArray;
@end

@implementation MBElectronicConfirmationOrderViewController
-(NSMutableString *)cards{
    if (!_cards) {
        _cards = [NSMutableString string];
    }
    return _cards;
}
-(NSMutableArray *)discountArray{
    
    if (!_discountArray) {
        
        _discountArray = [@[
                            [@{@"商品合计":_orderModel.total.card_amount} mutableCopy],
                            [@{@"发票信息":@""} mutableCopy],
                            [@{@"使用麻包卡":@""} mutableCopy],
                            [@{@"备注：":@""} mutableCopy]
                            ] mutableCopy];
    }
    return _discountArray;
}
-(void)setOrderModel:(MBElectronicCardOrderModel *)orderModel{
    _orderModel = orderModel;
    self.discountArray[2][@"使用麻包卡"] = orderModel.total.mabao_card_amount;
    _card_amount.text = orderModel.total.be_paid;
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _card_amount.text = _orderModel.total.be_paid;
    [_tableView registerNib:[UINib nibWithNibName:@"MBFireOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"MBFireOrderTableViewCell"];
    // Do any additional setup after loading the view.
}
- (IBAction)submitOrders:(id)sender {
    [self submissionOrderData];
}
-(void)refreshData
{
    [self show];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking POST:string(BASE_URL_root, @"/giftflow/checkout") parameters:@{@"session":sessiondict,@"mabao_card":self.cards,@"inv_type":_orderModel.inv.inv_type,@"inv_payee":_orderModel.inv.inv_payee,@"inv_content":_orderModel.inv.inv_content} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [self.orderModel.cardsArrray enumerateObjectsUsingBlock:^(MBElectronicCardModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *str = [NSString stringWithFormat:@"%@|%@|%ld",obj.card_id,obj.card_money,(long)obj.card_cnt];
            [formData appendPartWithFormData:[str dataUsingEncoding:NSUTF8StringEncoding] name:[NSString stringWithFormat:@"card[%ld]",idx]];
            
        }];
        
    } progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [self dismiss];
        MMLog(@"%@",responseObject);
        self.orderModel = [MBElectronicCardOrderModel yy_modelWithDictionary:responseObject];
        
//        [self performSegueWithIdentifier:@"MBElectronicConfirmationOrderViewController" sender:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败！" time:1];
    }];
    
    
    
}
- (NSString *)titleStr{

return @"订单详情";
}
- (void)submissionOrderData{
    [self show];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking POST:string(BASE_URL_root, @"/giftflow/done") parameters:@{@"session":sessiondict,@"mabao_card":self.cards,@"inv_type":_orderModel.inv.inv_type,@"inv_payee":_orderModel.inv.inv_payee,@"inv_content":_orderModel.inv.inv_content,@"remarks":_discountArray.lastObject[@"备注："]} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [self.orderModel.cardsArrray enumerateObjectsUsingBlock:^(MBElectronicCardModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *str = [NSString stringWithFormat:@"%@|%@|%ld",obj.card_id,obj.card_money,(long)obj.card_cnt];
            [formData appendPartWithFormData:[str dataUsingEncoding:NSUTF8StringEncoding] name:[NSString stringWithFormat:@"card[%ld]",idx]];
            
        }];
        
    } progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [self dismiss];
        MMLog(@"%@",responseObject);
       
        if ([responseObject[@"status"] isKindOfClass:[NSDictionary class]]&&[responseObject[@"status"][@"succeed"] integerValue] == 1) {
            
            MBPaymentViewController *payVc = [[MBPaymentViewController alloc] init];
            
            payVc.orderInfo = @{@"order_sn":responseObject[@"data"][@"order_sn"],
                                @"order_amount":responseObject[@"data"][@"order_amount"],
                                @"pay_status":responseObject[@"data"][@"pay_status"],
                                @"subject":@"北京小麻包信息技术有限公司",
                                @"desc":@"购买电子卡业务"
                                };
            payVc.type = MBAnECardOrders;
            [self.navigationController pushViewController:payVc animated:YES];
            
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:responseObject[@"status"][@"error_desc"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败！" time:1];
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0: return self.orderModel.cardsArrray.count;
            
        default:
            return self.discountArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0: return 75;
            
        default:
            return 40;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    switch (section) {
        case 0: return 35;
            
        default:
            return 0.001;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0: return 25;
            
        default:
            return 0.001;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0: {
            UIView *headerView = [[UIView alloc] init];
            headerView.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 25);
            headerView.backgroundColor = [UIColor whiteColor];
            UILabel *lable = [[UILabel alloc] init];
            lable.textColor = UIcolor(@"434343");
            lable.font = SYSTEMFONT(15);
            lable.text = @"小麻包自营";
            [headerView addSubview:lable];
            [lable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(headerView.mas_centerY);
                make.left.mas_equalTo(10);
            }];
            //    [self addBottomLineView:headerView left:15];
            return headerView;
        }
            
        default:
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 5)];
            view.backgroundColor = UIcolor(@"f3f3f3");
            
            return view;
        }
    }
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
        {
            UIView *footerView = [[UIView alloc] init];
            UIView *footer = [[UIView alloc] init];
            footer.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 30);
            footer.backgroundColor = [UIColor whiteColor];
            [footerView addSubview:footer];
            
            
            UILabel *fee = [[UILabel alloc] init];
            fee.font = SYSTEMFONT(12);
            fee.textColor = UIcolor(@"878787");
            fee.text = [NSString stringWithFormat:@"共%@件商品",_orderModel.total.card_numbers];
            [footer addSubview:fee];
            [fee mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(footer.mas_centerY);
                make.left.mas_equalTo(10);
            }];
            
            UILabel *total_money = [[UILabel alloc] init];
            total_money.font = SYSTEMFONT(12);
            total_money.textColor = UIcolor(@"e8455d");
            total_money.text =  _orderModel.total.card_amount;
            [footer addSubview:total_money];
            [total_money mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(footer.mas_centerY);
                make.right.mas_equalTo(-10);
            }];
            UILabel *lable = [[UILabel alloc] init];
            lable.font = SYSTEMFONT(12);
            lable.textColor = UIcolor(@"373737");
            lable.text =  @"小计：";
            [footer addSubview:lable];
            [lable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(footer.mas_centerY);
                make.right.equalTo(total_money.mas_left);
            }];
            
            return footerView;
        }
        default:
        {
            
            return [[UIView alloc] init];
            
        }
    }
    
    
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    switch (indexPath.section) {
        case 0:{
        
            
            MBElectronicSubOrderCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBElectronicSubOrderCardCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"MBElectronicSubOrderCardCell" owner:nil options:nil]firstObject];
            }
            cell.model = self.orderModel.cardsArrray[indexPath.row];
            return cell;
        }
            
        default:
        {
            static NSString *identifier = @"MBDiscountCell";
            MBDiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            BOOL isnext = YES;
            if (indexPath.row < 1 || indexPath.row > 2 ) {
                isnext = NO;
            }
            if (!cell) {
                cell = [[MBDiscountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            
            if (indexPath.row == (self.discountArray.count - 1)) {
                cell.isnote =true;
            }else{
                cell.isnote =false;
            }
            NSMutableDictionary *dic = _discountArray[indexPath.row];
            cell.price = _discountArray[indexPath.row][dic.allKeys.firstObject];
            
            cell.name = dic.allKeys.firstObject;
            cell.isnext = isnext;
            
            @weakify(self)
            [[cell.textField rac_textSignal] subscribeNext:^(id x) {
                @strongify(self);
                NSMutableDictionary *dic = self.discountArray.lastObject;
                dic[@"备注："] = x;
                
            }];
            return cell;
        
        }
    }
    

    
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 1:{
                
                MBInvoiceViewController *VC = [[UIStoryboard storyboardWithName:@"Shopping" bundle:nil] instantiateViewControllerWithIdentifier:@"MBInvoiceViewController"];
                WS(weakSelf)
                VC.block = ^(NSString *inv_payee,NSString *inv_type,NSString *inv_content,NSString *inv_identification){
                    
                    weakSelf.discountArray[1][@"发票信息"] = inv_content;
                    weakSelf.orderModel.inv.inv_payee = inv_payee;
                    weakSelf.orderModel.inv.inv_type = inv_type;
                    weakSelf.orderModel.inv.inv_content = inv_content;
                    weakSelf.orderModel.inv.inv_identification = inv_identification;
                    [weakSelf.tableView reloadData];
                    
                };
                [self pushViewController:VC Animated:YES];
            }break;
            case 2:
            {
                _cards = nil;
              MBBabyCardController *VC =  [[UIStoryboard storyboardWithName:@"PersonalCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"MBBabyCardController"];
                @weakify(self);
                
                [[VC.myCircleViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSArray *arr) {
                    @strongify(self);
                    for ( MaBaoCardModel*model in arr) {
                        if ([model isEqual:arr.firstObject]) {
                            if (model.card_no) {
                                [self.cards appendString:model.card_no];
                            }
                        }else{
                            
                            if (model.card_no) {
                                [self.cards appendString:@"|"];
                                [self.cards appendString:model.card_no];
                            }
                            
                            
                        }
                    }
                    
                   
                    [self refreshData];
                    
                    
                }];
                [self pushViewController:VC Animated:YES];
            }
                
                break;
            default:
                break;
        }
        
    }
    
}

#pragma mark --要开始移动scrollView时调用（移除键盘）
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;{
    [self.view endEditing:NO];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return YES;
}
@end
