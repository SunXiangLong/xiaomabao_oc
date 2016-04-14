//
//  MBServiceShopsViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/31.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBServiceShopsViewController.h"
#import "MBServiceShopsHeadView.h"
#import "MBServiceShopsOneCell.h"
#import "MBServiceHomeCell.h"
#import "MBServiceShopsTableFootView.h"
#import "MBServiceShopsTableHeadView.h"
#import "MBUserEvaluationCell.h"
#import "MBServiceDetailsViewController.h"
#import "MBUserEvaluationController.h"
@interface MBServiceShopsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _iSmoreService;
    NSDictionary *_dataDic;
    NSArray *_dataArr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MBServiceShopsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setheadData];
       
    
}
- (UIView *)setTableHeadView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 183)];
    MBServiceShopsHeadView *tableHead = [MBServiceShopsHeadView instanceView];
    [tableHead.showImageView sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"shop_info"][@"shop_logo"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    tableHead.store_name.text = _dataDic[@"shop_info"][@"shop_name"];
    tableHead.adress.text = [NSString stringWithFormat:@"地址：%@",_dataDic[@"shop_info"][@"shop_nearby_subway"]];
    tableHead.photo.text = _dataDic[@"shop_info"][@"shop_phone"];
    tableHead.adress_detailed.text = _dataDic[@"shop_info"][@"shop_address"];
    tableHead.frame = view.bounds;
   
    [tableHead.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)]];

    [view addSubview:tableHead];
    return view;

}
- (void)callPhone:(id)sender {
    
    
    if (_dataDic) {
        NSString * telStr = [NSString stringWithFormat:@"telprompt://%@",_dataDic[@"shop_info"][@"shop_phone"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];

    }
    
}
- (void)setheadData{
    
    [self show];
    NSString *url =[NSString stringWithFormat:@"%@%@%@",BASE_URL_SHERVICE,@"service/shop_detail_info/",self.shop_id];
    [MBNetworking newGET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dismiss];
        
        
        if ([responseObject count]>0) {
            
           NSLog(@"%@",responseObject);
            _dataDic = responseObject;
              self.tableView.tableHeaderView = [self setTableHeadView];
            _dataArr = @[_dataDic[@"comment"],_dataDic[@"other_shop"],_dataDic[@"products"]];
            [self.tableView reloadData];
            // 拿到当前的上拉刷新控件，结束刷新状态
            [self.tableView .mj_footer endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self show:@"请求失败" time:1];
    }];
    
    
}
- (NSString *)titleStr{

    return self.title?:@"";
}
#pragma mark -- 更多服务
- (void)moreService{
    _iSmoreService = !_iSmoreService;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark -- 其它评价
- (void)otherEvaluation{
    MBUserEvaluationController *VC = [[MBUserEvaluationController alloc] init];
    VC.shop_id = _dataDic[@"comment"][0][@"comment_id"];
    [self pushViewController:VC Animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger num = 0 ;
    for (NSArray *arr in _dataArr ) {
        if (arr.count>0){
        
            num++;
        }
    }
    return num;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = _dataDic[@"products"];
    NSArray *arr2 = _dataDic[@"other_shop"];
    NSArray *arr3 = _dataDic[@"comment"];
        switch (section) {
            case 0:
            {
                if (arr.count>2) {
                    return _iSmoreService?arr.count:2;
                }else if(arr.count==0){
                    return 0;
                }
                 return arr.count;
            }
            case 1: return arr3.count;
            default: return arr2.count;
        }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0: return 85;
        case 1:{
           
            NSString *str = _dataDic[@"comment"][indexPath.row][@"comment_content"];
            NSArray *arr =  _dataDic[@"comment"][indexPath.row][@"comment_imgs"];
            CGFloat strHeight = [str sizeWithFont:[UIFont systemFontOfSize:14] withMaxSize:CGSizeMake(UISCREEN_WIDTH-62, MAXFLOAT)].height;
            CGFloat imageHeight = 0;
            if (arr.count != 0)  {
                if (arr.count>3) {
                    imageHeight =  (UISCREEN_WIDTH -32)/3*2+3*8;
                }else{
                    imageHeight =  (UISCREEN_WIDTH -32)/3+2*8;
                }
            }
            
            return 61+strHeight+imageHeight;
        }
        default:{
            NSDictionary    *dic = _dataDic[@"other_shop"][indexPath.row];
            NSString *str = dic[@"shop_desc"];
            CGFloat strHeight = [str sizeWithFont:[UIFont systemFontOfSize:14] withMaxSize:CGSizeMake(UISCREEN_WIDTH-62, MAXFLOAT)].height;
            
            return 80+strHeight;}
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    
    return 51;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    switch (section) {
        case 0:  {
            NSArray *arr = _dataDic[@"products"];
            NSInteger num = arr.count - 2;
            if (num>0) {
                return 41;
            }else{
                return 1;
            }
        }
        case 1:  return 41;
        default:  return 0;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
   
    if (section == 0) {
        
        NSArray *arr = _dataDic[@"products"];
        NSInteger num = arr.count - 2;
        
        if (num>0) {
            MBServiceShopsTableFootView *footView = [MBServiceShopsTableFootView instanceView];
            footView.frame = view.bounds;
            footView.name.text = [NSString stringWithFormat:@"查看其它%ld个服务",num];
            if (_iSmoreService) {
                footView.image.image = [UIImage imageNamed:@"dupward_image"];
            }else{
                footView.image.image = [UIImage imageNamed:@"down_image"];
            }
            [footView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreService)]];
              [view addSubview:footView];
            return view;
        }
        return nil;
    }else  if  (section == 1){
        MBServiceShopsTableFootView *footView = [MBServiceShopsTableFootView instanceView];
        footView.frame = view.bounds;
        [view addSubview:footView];
        footView.name.text = @"查看其它评价";
        footView.image.hidden = YES;
         [footView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otherEvaluation)]];
        return view;
    }
    
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    MBServiceShopsTableHeadView *headView = [MBServiceShopsTableHeadView instanceView];
    headView.frame = view.bounds;
    [view addSubview:headView];
    
    switch (section) {
        case 0: {
            NSArray *arr = _dataDic[@"products"];
            headView.number.text =  [NSString stringWithFormat:@"服务%lu",(unsigned long)arr.count];
                 headView.name.text = @"特色服务";} break;
        case 1:{headView.number.text = @"";
            headView.name.text = @"用户评价";}  break;
        default:{headView.number.text = @"";
            headView.name.text = @"更多商家";} break;
    }
    return view;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        MBServiceShopsOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBServiceShopsOneCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MBServiceShopsOneCell" owner:nil options:nil]firstObject];
        }
        cell.shop_name.text = _dataDic[@"products"][indexPath.row][@"product_name"];
        cell.price.text =  [NSString stringWithFormat:@"门市价：%@",_dataDic[@"products"][indexPath.row][@"product_market_price"]];
        cell.shop_price.text = [NSString stringWithFormat:@"¥ %@",_dataDic[@"products"][indexPath.row][@"product_shop_price"]];
        [cell.showImageViw sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"products"][indexPath.row][@"product_img"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
        cell .autoresizingMask = UIViewAutoresizingFlexibleHeight;
        cell .clipsToBounds  = YES;
        return cell;
    }else if(indexPath.section==1){
        MBUserEvaluationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBUserEvaluationCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MBUserEvaluationCell" owner:nil options:nil]firstObject];
        }
        cell.user_name.text = _dataDic[@"comment"][indexPath.row][@"user_name"];
        cell.user_time.text = _dataDic[@"comment"][indexPath.row][@"comment_date"];
        cell.user_center.text = _dataDic[@"comment"][indexPath.row][@"comment_content"];
        cell.comment_imgs = _dataDic[@"comment"][indexPath.row][@"comment_imgs"];
        cell.comment_thumb_imgs = _dataDic[@"comment"][indexPath.row][@"comment_thumb_imgs"];
        cell.user_id =  _dataDic[@"comment"][indexPath.row][@"user_id"];
        cell.imageUrl   = _dataDic[@"comment"][indexPath.row][@"header_img"];
        cell.VC = self;
        [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:cell.imageUrl ] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
        return cell;
        
    }
    NSDictionary    *dic = _dataDic[@"other_shop"][indexPath.row];
     MBServiceHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBServiceHomeCell"];
    if (!cell) {
       cell = [[[NSBundle mainBundle]loadNibNamed:@"MBServiceHomeCell" owner:nil options:nil]firstObject];
    }
    [cell.user_image sd_setImageWithURL:[NSURL URLWithString:dic[@"shop_logo"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    cell.name.text = dic[@"shop_name"];
    cell.neirong.text = dic[@"shop_desc"];
    cell.adress.text = dic[@"shop_nearby_subway"];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            MBServiceDetailsViewController *VC = [[MBServiceDetailsViewController alloc] init];
            VC.product_id = _dataDic[@"products"][indexPath.row][@"product_id"];
            [self pushViewController:VC Animated:YES];
        }break;
        case 1:{
            MBUserEvaluationController *VC = [[MBUserEvaluationController alloc] init];
            VC.shop_id = _dataDic[@"comment"][indexPath.row][@"comment_id"];
            [self pushViewController:VC Animated:YES];
        
        }break;
        default:{
        
            NSDictionary    *dic = _dataDic[@"other_shop"][indexPath.row];
            MBServiceShopsViewController *VC = [[MBServiceShopsViewController alloc] init];
            VC.shop_id = dic[@"shop_id"];
            [self pushViewController:VC Animated:YES];

        }break;
    }
}

@end
