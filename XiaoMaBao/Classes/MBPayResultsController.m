//
//  MBPayResultsController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBPayResultsController.h"
#import "MBPayResultsCell.h"
#import "MBPayResultsHeadView.h"
#import "MBPayResultsFootView.h"
#import "MBServiceShopsViewController.h"
#import "MBServiceOrderController.h"
@interface MBPayResultsController ()
{
    NSDictionary *_dataDic;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MBPayResultsController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBPayResultsController"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBPayResultsController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setheadData];
    
    
    //覆盖侧滑手势
     UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [self.navigationController.view  addGestureRecognizer:pan];
   
}
-(void)back{

   
}
#pragma mark -- 请求数据
- (void)setheadData{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/service/view_ticket"];
    if (! sid) {
        return;
    }
    [MBNetworking POSTOrigin:url parameters:@{@"session":sessiondict,@"order_id":self.order_id} success:^(id responseObject) {
        
        if (responseObject) {
            _dataDic = responseObject;
            self.tableView.tableHeaderView = [self setTableHeadView];
            [self.tableView reloadData];
            self.tableView.tableFooterView = [self setTableFootView];
          
            
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败 " time:1];
        NSLog(@"%@",error);
    }];
    
    
    
    
    
}
- (UIView *)setTableHeadView{
    NSDictionary *dic = _dataDic[@"shop_info"];
    UIView *view  = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 50);
    MBPayResultsHeadView *headView = [MBPayResultsHeadView instanceView];
    headView.frame = view.frame;
    headView.shop_name.text = dic[@"shop_name"];
    [headView.shop_image sd_setImageWithURL:[NSURL URLWithString:dic[@"shop_logo"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    [view addSubview:headView];
    
    return view;
    
    
}
- (UIView *)setTableFootView{
    UIView *view  = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 60);
    MBPayResultsFootView *footView = [MBPayResultsFootView instanceView];
    footView.frame = view.frame;
    
    [footView.button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:footView];    
    return view;
    
}
-(NSString *)leftStr{
    return @"   ";
}
-(NSString *)titleStr{

return @"支付结果";
}
- (NSString *)rightStr{

return @"完成";
}
-(void)rightTitleClick{
    
    for (BkBaseViewController *VC in self.navigationController.viewControllers) {
        if ([VC isKindOfClass:[MBServiceShopsViewController class]]) {
            [self.navigationController popToViewController:VC animated:YES];
            
            NSNotification *notification =[NSNotification notificationWithName:@"HYTPopViewControllerNotification" object:nil userInfo:nil];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
        }
    }

}
- (void)button:(UIButton *)sender {
    MBServiceOrderController *VC = [[MBServiceOrderController alloc] init];
    VC.order_id = self.order_id;
    [self pushViewController:VC Animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSArray *arr = _dataDic[@"ticket_info"];
    return arr.count;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 47;
    
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _dataDic[@"ticket_info"][indexPath.section];
    
    MBPayResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBPayResultsCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBPayResultsCell" owner:self options:nil]firstObject];
    }
    cell.mabaoquan.text = dic[@"ticket_code"];
    
    return cell;
    
}


@end
