//
//  MBElectronicCardOrderInfoVC.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/3/22.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBElectronicCardOrderInfoVC.h"
#import "MBCardHelpCenterTitleCell.h"
#import "MBElectronicCardOrderModel.h"
#import "MBWelfareCardCollectionViewCell.h"
#import <ShareSDKConnector/ShareSDKConnector.h>
@interface MBElectronicCardOrderInfoVC ()
@property (weak, nonatomic) IBOutlet UILabel *order_time;
@property (weak, nonatomic) IBOutlet UILabel *order_sn;
@property (weak, nonatomic) IBOutlet UILabel *order_money;
@property (weak, nonatomic) IBOutlet UILabel *mabao_card_amount;
@property (weak, nonatomic) IBOutlet UILabel *order_be_paid;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) MBElectronicCardOrderInfoModels *model;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *shipping_fee;

@end

@implementation MBElectronicCardOrderInfoVC
-(void)setModel:(MBElectronicCardOrderInfoModels *)model{
    _model = model;
    _order_sn.text = _model.order_sn;
    _order_time.text = _model.add_time;
    _order_money.text = _model.card_amount;
    _mabao_card_amount.text = _model.mabao_card_amount;
    _order_be_paid.text = _model.order_amount;
    _shipping_fee.text = _model.shipping_fee;
    _topView.hidden = false;
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadData];
    // Do any additional setup after loading the view.
}
-(void)reloadData
{
    [self show];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    [MBNetworking   POSTOrigin:string(BASE_URL_root, @"/order/gift_order_detail/") parameters:@{@"session":sessiondict,@"order_sn":self.orderSn} success:^(id responseObject) {
        [self dismiss];
        
        self.model = [MBElectronicCardOrderInfoModels yy_modelWithDictionary:responseObject[@"data"]];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败！" time:1];
    }];
    
}
-(NSString *)titleStr{
    return @"订单详情";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_model) {
        
        if (_model.virtualArray.count >0) {
            return 2;
        }
        
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return _model.orderCardsListArray.count;
    }
    return _model.virtualArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 99;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 40);
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, UISCREEN_WIDTH, 35)];
    centerView.backgroundColor = [UIColor whiteColor];
    [view addSubview:centerView];
    UILabel *order_time = [[UILabel alloc] init];
    order_time.textColor = UIcolor(@"555555");
    if (section == 0) {
        order_time.text = @"购物清单";
    }else{
        order_time.text = @"卡号&卡密";
    }
    
    order_time.font = YC_YAHEI_FONT(14);
    [centerView addSubview:order_time];
    [order_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
        
    }];
    
    
    
    
    return view;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        MBElectronicSubOrderCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBElectronicSubOrderCardCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MBElectronicSubOrderCardCell" owner:nil options:nil]firstObject];
        }
        cell.model = _model.orderCardsListArray[indexPath.row];
        return cell;
    }
    MBElectronicCardInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBElectronicCardInfoCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBElectronicCardInfoCell" owner:nil options:nil]firstObject];
    }
    cell.model = _model.virtualArray[indexPath.row];
    return cell;
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        virtualModel  *model = _model.virtualArray[indexPath.row];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        
        
        UIAlertController *alerCV = [UIAlertController alertControllerWithTitle:@"卡号拷贝" message:@"选择要拷贝的内容" preferredStyle:UIAlertControllerStyleActionSheet];
        [alerCV addAction:[UIAlertAction actionWithTitle:@"复制卡号" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [pasteboard setString:model.card_no];
            [self show:@"复制成功" time:.5];
        }]];
        [alerCV addAction:[UIAlertAction actionWithTitle:@"复制密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [pasteboard setString:model.card_pass];
              [self show:@"复制成功" time:.5];
        }]];
        [alerCV addAction:[UIAlertAction actionWithTitle:@"复制卡号和密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [pasteboard setString:[NSString stringWithFormat:@"%@\n%@",model.card_no,model.card_pass]];
              [self show:@"复制成功" time:.5];
            
        }]];
        [alerCV addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
         [self presentViewController:alerCV animated:true completion:nil];
        
    }
    
    
}

@end
