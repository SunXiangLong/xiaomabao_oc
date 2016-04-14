//
//  MBServiceHomeViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/31.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBServiceHomeViewController.h"
#import "MBServiceHomeCell.h"
#import "MBServiceShopsViewController.h"



@interface MBServiceHomeViewController ()
{
    NSInteger _page;
    NSMutableArray *_storeData;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MBServiceHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _storeData = [NSMutableArray array];
    _page = 1;
    [self setheadData];
    [self setRefresh];
    
}
- (void)setRefresh{
    
    
    
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(setheadData)];
    //    footer.triggerAutomaticallyRefreshPercent = 0.5;
    
    footer.refreshingTitleHidden = YES;
    self.tableView.mj_footer = footer;
    
    
}
#pragma mark -- 上拉加载数据
- (void)setheadData{
    
    [self show];
    
    
    //    NSString *page = [NSString stringWithFormat:@"%ld",_page];
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_SHERVICE,@"service/shop_list"];
    [MBNetworking newGET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dismiss];
        
        NSArray *arr = [responseObject valueForKeyPath:@"data"];
        NSLog(@"%@",arr);
        if ([arr count]>0) {
            
            [_storeData addObjectsFromArray:arr];
            _page++;
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
-(NSString *)titleStr{
    return @"麻包服务";
}
- (void)rightTitleClick{
    
    
  
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _storeData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary    *dic = _storeData[indexPath.row];
    NSString *str = dic[@"shop_desc"];
    CGFloat strHeight = [str sizeWithFont:[UIFont systemFontOfSize:14] withMaxSize:CGSizeMake(UISCREEN_WIDTH-62, MAXFLOAT)].height;
    return 80+strHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary    *dic = _storeData[indexPath.row];
    MBServiceHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBServiceHomeCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBServiceHomeCell" owner:nil options:nil]firstObject];
    }
    [cell.user_image sd_setImageWithURL:[NSURL URLWithString:dic[@"shop_logo"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    cell.name.text = dic[@"shop_name"];
    cell.neirong.text = dic[@"shop_desc"];
    cell.adress.text = dic[@"shop_nearby_subway"];
    cell.user_city.text  = dic[@"shop_city"];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary    *dic = _storeData[indexPath.row];
    MBServiceShopsViewController *VC = [[MBServiceShopsViewController alloc] init];
    VC.shop_id = dic[@"shop_id"];
    VC.title = dic[@"shop_name"];
    [self pushViewController:VC Animated:YES];
}


@end
