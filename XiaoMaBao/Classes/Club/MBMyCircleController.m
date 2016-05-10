//
//  MBMyCircleController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBMyCircleController.h"
#import "MBMyCircleViewTo.h"
#import "MBMycircleTableViewCell.h"
#import "MBShopingViewController.h"
#import "MBActivityViewController.h"
#import "MBWebViewController.h"
#import "MBGroupShopController.h"
#import "MBDetailsCircleController.h"
#import "MBLoginViewController.h"
@interface MBMyCircleController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
    /**
     *  轮播图数组
     */
    NSArray *_bandImageArray;
    /**
     *  推荐麻包圈数组
     */
    NSMutableArray *_recommendArray;
    /**
     *  我的麻包圈数组
     */
    NSMutableArray *_myCircleArray;
    
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MBMyCircleController
-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [MobClick beginLogPageView:@"MBMyCircleController"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick endLogPageView:@"MBMyCircleController"];
     [self setShufflingFigureData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _recommendArray = [NSMutableArray array];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}
/**
 *  广告轮播图UI
 *
 *  @return
 */
- (UIView *)setHeaderView{
    UIView *view =[[UIView alloc] init];
    view.frame = CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_WIDTH*33/75+ UISCREEN_WIDTH/4*204/160);
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH,UISCREEN_WIDTH*33/75) delegate:self     placeholderImage:[UIImage imageNamed:@"placeholder_num3"]];
    NSMutableArray *imaageUrlArr = [NSMutableArray array];
    for (NSDictionary *dic in _bandImageArray) {
        [imaageUrlArr addObject:dic[@"ad_img"]];
    }
    cycleScrollView.imageURLStringsGroup = imaageUrlArr;
    cycleScrollView.autoScrollTimeInterval = 3.0f;
    cycleScrollView.delegate = self;
    [view addSubview:cycleScrollView];
    
    MBMyCircleViewTo *view1 = [MBMyCircleViewTo instanceView];
    view1.frame = CGRectMake(0, MaxY(cycleScrollView), UISCREEN_WIDTH, UISCREEN_WIDTH/4*204/160);
    [view addSubview:view1];
    
    @weakify(self);
    [[view1.myCircleViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *number) {
        NSLog(@"%ld",[number integerValue]);
        @strongify(self);
        
    }];
    return view;
}
/**
 *  广告轮播图数据
 *
 *  @return nil
 */
#pragma mark -- 我的圈轮播图数据
- (void)setShufflingFigureData{
    
   
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/circle/get_circle_ads"];
    
    [MBNetworking newGET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSLog(@"%@",responseObject);
        
        if (responseObject) {
            if ([[responseObject valueForKeyPath:@"data"] count]>0) {
                _bandImageArray = [responseObject valueForKeyPath:@"data"];
                [self setData];
                return ;
            }
            
        }
        
        [self show:@"没有相关数据" time:1];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self show:@"请求失败" time:1];
    }];
    
    
}
#pragma mark -- 推荐麻包圈数据数据
- (void)setData{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    if (!sid) {
        
        NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/circle/get_recommend_cat"];
        
        [MBNetworking newGET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
     
//            NSLog(@"%@",responseObject);
            if (responseObject) {
                
                _recommendArray = [NSMutableArray arrayWithArray:[responseObject valueForKeyPath:@"recommend"]];
                _tableView.tableHeaderView = [self setHeaderView];
             
                [_tableView reloadData];
                return ;
                
            }
            
            [self show:@"没有相关数据" time:1];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            [self show:@"请求失败" time:1];
        }];
        
    }else{
        NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/UserCircle/get_user_circle"];
        
        [MBNetworking   POSTOrigin:url parameters:@{@"session":sessiondict} success:^(id responseObject) {
   
//            NSLog(@"%@",responseObject);
            
            if (responseObject) {
                 _myCircleArray = [NSMutableArray arrayWithArray:[responseObject valueForKeyPath:@"user_circle"]];
                 _recommendArray = [NSMutableArray arrayWithArray:[responseObject valueForKeyPath:@"recommend"]];
                _tableView.tableHeaderView = [self setHeaderView];
             
                [_tableView reloadData];
                return ;
                
            }
            
            [self show:@"没有相关数据" time:1];
            
            
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self show:@"请求失败 " time:1];
            NSLog(@"%@",error);
        }];
        
    }
    
    
}
#pragma mark--加入圈子或取消加入圈子
- (void)setJoin_circle:(NSString *)circle_id indexPath:(NSIndexPath *)indexPath {
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    if (!sid) {
        [self loginClicksss];
        return;
    }
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/UserCircle/join_circle"];
    
    [self show];
    
    [MBNetworking   POSTOrigin:url parameters:@{@"session":sessiondict,@"circle_id":circle_id} success:^(id responseObject) {
        if ([[responseObject  valueForKeyPath:@"status"]isEqualToNumber:@1]) {
            
            if (indexPath.section==0) {
                [self prompt:indexPath];
                
            }else{
                [self show:@"成功加入 " and:_recommendArray[indexPath.row][@"circle_name"] time:1];
                [_myCircleArray addObject:_recommendArray[indexPath.row]];
                [_recommendArray removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self show:@"请求失败 " time:1];
        NSLog(@"%@",error);
    }];
    
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    NSInteger ad_type = [_bandImageArray[index][@"ad_type"] integerValue];
    
    
    switch (ad_type) {
        case 1: {
            MBActivityViewController *VC = [[MBActivityViewController alloc] init];
            VC.act_id = _bandImageArray[index][@"act_id"];
            VC.title = _bandImageArray[index][@"ad_name"];
            [self pushViewController:VC Animated:YES];
        }break;
        case 2: {
            
            MBShopingViewController *VC = [[MBShopingViewController alloc] init];
            VC.GoodsId = _bandImageArray[index][@"ad_con"];
            VC.title = _bandImageArray[index][@"ad_name"];
            [self pushViewController:VC Animated:YES];
        }break;
        case 3: {
            MBWebViewController *VC = [[MBWebViewController alloc] init];
            VC.url =  [NSURL URLWithString:_bandImageArray[index][@"ad_con"]];
            VC.title = _bandImageArray[index][@"ad_name"];
            [self pushViewController:VC Animated:YES];
            
        }break;
        case 4: {
            
            MBGroupShopController *VC = [[MBGroupShopController alloc] init];
            VC.title = _bandImageArray[index][@"ad_name"];
            
            [self pushViewController:VC Animated:YES];
            
        }break;
        case 5: {
            
        }break;
        default: break;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {
        return  _myCircleArray.count;
        
    }else{
        return _recommendArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        if (_myCircleArray.count == 0) {
            return 0;
        }
        return 41;
    }
    
    if (_recommendArray.count == 0) {
        return 0;
    }
    return 41;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 41);
    UIView *backTopView = [[UIView alloc] init];
    backTopView.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 10);
    backTopView.backgroundColor = BACKColor;
    [view addSubview:backTopView];
    UILabel *lable = [[UILabel alloc] init];
    lable.font =  YC_YAHEI_FONT(16);
    lable.textColor = UIcolor(@"575c65");
    [view addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.centerY.mas_equalTo(5);
    }];
    
    NSString *numStr = s_Integer(_myCircleArray.count);
    NSString *comment_content = [NSString stringWithFormat:@"我的麻包圈(%@)",numStr];
    
    
    NSRange range = [comment_content rangeOfString:numStr];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:comment_content];
    [att addAttributes:@{NSForegroundColorAttributeName:UIcolor(@"d66263")}  range:NSMakeRange(6, range.length)];
    [att addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} range:NSMakeRange(6, range.length )];
    
    
    if (section == 0) {
        lable.text = comment_content;
        lable.attributedText  = att;
        
    }else{
        lable.text = @"推荐麻包圈";
    }
    
    UIImageView *image = [[UIImageView alloc] init];
    image.backgroundColor = UIcolor(@"eaeaea");
    [view addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _recommendArray[indexPath.row] ;
    if (indexPath.section ==0) {
        dic = _myCircleArray[indexPath.row];
    }
    MBMycircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBMycircleTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBMycircleTableViewCell"owner:nil options:nil]firstObject];
    }
    cell.indexPath = indexPath;
    cell.indexPath = indexPath;
    cell.user_name.text = dic[@"circle_name"];
    cell.user_center.text = dic[@"circle_desc"];
    [cell.user_image sd_setImageWithURL:[NSURL URLWithString:dic[@"circle_logo"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    
    if (indexPath.section ==1) {
        [cell.user_button setTitle:@"+" forState:UIControlStateNormal];
        cell.user_button.titleLabel.font = BOLDSYSTEMFONT(30);
        [cell.user_button setBackgroundColor:[UIColor whiteColor]];
    }else{
        if (_myCircleArray.count==0) {
            cell.noLable.hidden = NO;
            cell.selectionStyle =  UITableViewCellSelectionStyleNone;
            cell.exclusiveTouch = NO;
        }
    }
    
    @weakify(self);
    [[cell.myCircleCellSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSIndexPath *indexPath) {
        @strongify(self);
        
        NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
        if (!sid) {
            [self loginClicksss];
            return ;
        }
        
        NSDictionary *dic;
        if (indexPath.section == 0) {
            dic = _myCircleArray[indexPath.row];
            
        }else{
            dic = _recommendArray[indexPath.row];
            
        }
        [self setJoin_circle:dic[@"circle_id"] indexPath:indexPath];
        
    }];
    
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *dic;
    if (indexPath.section == 0) {
        dic = _myCircleArray[indexPath.row];
        
    }else{
        dic = _recommendArray[indexPath.row];

    }
    NSString *str ;
    if (indexPath.section == 0) {
        str = @"1";
    }else{
        str = @"0";
    }
    MBDetailsCircleController *VC = [[MBDetailsCircleController alloc] init];
    VC.circle_id = dic[@"circle_id"];
    VC.circle_user_cnt = dic[@"circle_user_cnt"];
    VC.circle_name = dic[@"circle_name"];
    VC.circle_logo = dic[@"circle_logo"];
    VC.is_join = str;
    [self pushViewController:VC Animated:YES];
}
- (void)prompt:(NSIndexPath *)indexPath{
    
    NSString *str = _myCircleArray[indexPath.row][@"circle_name"];
    NSString *str1 = [NSString stringWithFormat:@"你确定退出%@?",str];
    NSRange range = [str1 rangeOfString:str];
    //修改title
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:str1];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:UIcolor(@"d66263") range:NSMakeRange(range.location, range.length)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(range.location, range.length)];
    
    
    UIAlertController *alertCancel = [UIAlertController alertControllerWithTitle:str1 message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertCancel setValue:alertControllerStr forKey:@"attributedTitle"];
    
    UIAlertAction *reloadAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self show:@"成功退出" and:str time:1];
        [_recommendArray addObject:_myCircleArray[indexPath.row]];
        [_myCircleArray removeObjectAtIndex:indexPath.row];
        
        [self.tableView reloadData];
        
    }];
    [reloadAction setValue:UIcolor(@"575c65") forKey:@"titleTextColor"];
    
    UIAlertAction *reloadAction1 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertCancel addAction:reloadAction];
    [alertCancel addAction:reloadAction1];
    [reloadAction1 setValue:UIcolor(@"d66263") forKey:@"titleTextColor"];
    [self presentViewController:alertCancel animated:YES completion:nil];
}

#pragma mark ---让tabview的headview跟随cell一起滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 41;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
    _tableView.editing = NO;
    
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