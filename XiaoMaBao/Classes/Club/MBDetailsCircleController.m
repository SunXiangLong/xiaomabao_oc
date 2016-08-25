//
//  MBDetailsCircleController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/9.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBDetailsCircleController.h"
#import "MBDetailsCircleTbaleViewCell.h"
#import "MBDetailsCircleTableHeadView.h"
#import "MBReleaseTopicViewController.h"
#import "MBLoginViewController.h"
#import "MBPostDetailsViewController.h"
#import "MBDetailsCircleCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
@interface MBDetailsCircleController ()<UITableViewDelegate,UITableViewDataSource>
{
    /**
     *  页数
     */
    NSInteger _page;
    /**
     *  是否从下一个界面返回
     */
    BOOL _isDimiss;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *   帖子数据源
 */
@property (copy, nonatomic) NSMutableArray *dataArray;

@end

@implementation MBDetailsCircleController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    if (_isDimiss) {
        _page = 1;
        [self.dataArray removeAllObjects];
        [self setData];
    
        _isDimiss   = !_isDimiss;
    }
}
/**
 *   帖子数据源懒加载
 *
 *  @return 初始化后的数组
 */
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
   [self setData];

    [self.tableView registerNib:    [UINib nibWithNibName:@"MBDetailsCircleCell" bundle:nil] forCellReuseIdentifier:@"MBDetailsCircleCell"];
 
    

  
}
/**
 *  请求帖子数据
 */
- (void)setData{

    [self show];
    
    NSString *page = s_Integer(_page);
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/circle/get_circle_info"];
    [MBNetworking   POSTOrigin:url parameters:@{@"circle_id":self.circle_id,@"page":page} success:^(id responseObject) {
        
//      NSLog(@"%@",responseObject);
        [self dismiss];
        
        if (responseObject) {
            if ([[responseObject valueForKeyPath:@"data"] count]>0) {
                [self.dataArray addObjectsFromArray:[responseObject valueForKeyPath:@"data"]];
                
                if (_page ==1) {
                       _tableView.tableHeaderView = [self setTableHeadView];
                    [self pullOnLoading];
                    _tableView.delegate = self;
                    _tableView.dataSource = self;
                                    }
                _page++;
                [_tableView reloadData];
                [self.tableView .mj_footer endRefreshing];
                
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                return ;
            }
            
        }else{
            [self show:@"没有相关数据" time:1];
        }

        
        
    }failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败 " time:1];
        NSLog(@"%@",error);
    }];
    

}
-(void)pullOnLoading{

    
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(setData)];
    footer.refreshingTitleHidden = YES;
    self.tableView.mj_footer = footer;

}
#pragma mark--加入圈子或取消加入圈子
- (void)setJoin_circle:(BOOL)isRightButton{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    if (!sid) {
        [self loginClicksss];
        return;
    }
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/UserCircle/join_circle"];
    
    [self show];
    
    [MBNetworking   POSTOrigin:url parameters:@{@"session":sessiondict,@"circle_id":self.circle_id} success:^(id responseObject) {
        [self dismiss];
        [self show:@"加入圈子成功" time:1];
        if ([[responseObject  valueForKeyPath:@"status"]isEqualToNumber:@1]) {
        self.is_join = @"1";
        _tableView.tableHeaderView = [self setTableHeadView];
            if (isRightButton) {
                _isDimiss = YES;
                MBReleaseTopicViewController *VC = [[MBReleaseTopicViewController    alloc] init];
                VC.circle_id = self.circle_id;
                [self pushViewController:VC Animated:YES];
            }
     
     
            
            

        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败 " time:1];
        NSLog(@"%@",error);
    }];
    
    
}
/**
 *  tableViewheadView
 *
 *
 */
-(UIView *)setTableHeadView{
  
        UIView *tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 70)];
        MBDetailsCircleTableHeadView *view = [MBDetailsCircleTableHeadView instanceView];
        [tableHeadView addSubview:view];
    @weakify(self);
    [[view.myCircleViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *num) {
        @strongify(self);
        
        [self setJoin_circle:NO];
        
        
    }];
    [view.circle_logo sd_setImageWithURL:[NSURL URLWithString:self.circle_logo] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    view.circle_name.text = self.circle_name;
    view.circle_user_cnt.text = string(self.circle_user_cnt, @"个话题");
    BOOL is_Join = NO;
    if ([self.is_join isEqualToString:@"1"]) {
        is_Join = YES;
    }
    
    if (is_Join) {
        view.button.selected = YES;

    }else{

        view.button.selected = NO;
        
    }
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(70);
        }];

    
  
    return tableHeadView;

}
#pragma mark -- 跳转登陆页
- (void)loginClicksss{
    //跳转到登录页
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MBLoginViewController *myView = [story instantiateViewControllerWithIdentifier:@"MBLoginViewController"];
    myView.vcType = @"mabao";
    MBNavigationViewController *VC = [[MBNavigationViewController alloc] initWithRootViewController:myView];
    [self presentViewController:VC animated:YES completion:nil];
}
-(NSString *)titleStr{

    return self.title?:@"全部帖子";
}
- (NSString *)rightImage{
    
   return @"post_btn";
    
}
-(void)rightTitleClick{
    if ([self.is_join isEqualToString:@"0"]) {
         [self prompt];
    }else{
        _isDimiss = YES;
        MBReleaseTopicViewController *VC = [[MBReleaseTopicViewController    alloc] init];
        VC.circle_id = self.circle_id;
        [self pushViewController:VC Animated:YES];
    }


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
- (void)configureCell:(MBDetailsCircleCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = YES; // Enable to use "-sizeThatFits:"
   cell.dataDic = _dataArray[indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [tableView fd_heightForCellWithIdentifier:@"MBDetailsCircleCell" cacheByIndexPath:indexPath configuration:^(MBDetailsCircleCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];

    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MBDetailsCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBDetailsCircleCell"];
   [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = _dataArray[indexPath.row];
    MBPostDetailsViewController *VC = [[MBPostDetailsViewController   alloc] init];
    VC.post_id = dic[@"post_id"];
    [self pushViewController:VC Animated:YES];
    
    
}
- (void)prompt{
    
    NSString *str = @"";
    NSString *str1 = [NSString stringWithFormat:@"加入话题所在的圈子才能发帖哦～%@?",str];
    NSRange range = [str1 rangeOfString:str];
    //修改title
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:str1];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:UIcolor(@"d66263") range:NSMakeRange(range.location, range.length)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(range.location, range.length)];
    
    
    UIAlertController *alertCancel = [UIAlertController alertControllerWithTitle:str1 message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertCancel setValue:alertControllerStr forKey:@"attributedTitle"];
    
    UIAlertAction *reloadAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }];
    [reloadAction setValue:UIcolor(@"575c65") forKey:@"titleTextColor"];
    
    UIAlertAction *reloadAction1 = [UIAlertAction actionWithTitle:@"加入圈子" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self setJoin_circle:YES];
        
    }];
    [alertCancel addAction:reloadAction];
    [alertCancel addAction:reloadAction1];
    [reloadAction1 setValue:UIcolor(@"d66263") forKey:@"titleTextColor"];
    [self presentViewController:alertCancel animated:YES completion:nil];
}
-(void)show:(NSString *)str1 and:(NSString *)str2 time:(NSInteger)timer{
    
    NSString *comment_content = [NSString stringWithFormat:@"%@ %@",str1,str2];
    NSRange range = [comment_content rangeOfString:str2];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:comment_content];
    [att addAttributes:@{NSForegroundColorAttributeName:UIcolor(@"d66263")}  range:NSMakeRange(range.location, range.length)];
    [att addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} range:NSMakeRange(range.location, range.length )];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    UILabel *lable =    [hud valueForKeyPath:@"label"];
    
    hud.color = RGBCOLOR(219, 171, 171);
    hud.mode = MBProgressHUDModeText;
    hud.labelText = comment_content;
    hud.labelColor = UIcolor(@"575c65");
    lable.attributedText = att;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.minSize = CGSizeMake(235, 70);
    [hud hide:YES afterDelay:timer];
    [self dismiss];
    
}
@end
