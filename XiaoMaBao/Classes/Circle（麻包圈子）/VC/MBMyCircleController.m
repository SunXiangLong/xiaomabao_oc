//
//  MBMyCircleController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBMyCircleController.h"
#import "MBMycircleTableViewCell.h"
#import "MBGoodsDetailsViewController.h"
#import "MBActivityViewController.h"
#import "MBWebViewController.h"
#import "MBGroupShopController.h"
#import "MBDetailsCircleController.h"
#import "MBCollectionPostController.h"
#import "MBVoiceViewController.h"
#import "MBArticleViewController.h"
#import "MBArticleCollectViewController.h"
#import "MBBabyWebController.h"
@interface MBMyCircleController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
    /**
     *  轮播图数组
     */
    NSArray *_bandImageArray;
    NSInteger _numberOfSections;
    
}
@property (weak, nonatomic) IBOutlet SDCycleScrollView *shufflingView;
@property (weak, nonatomic) IBOutlet UIView *tableHeadView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  推荐麻包圈数组
 */
@property (copy, nonatomic) NSMutableArray *recommendArray;
/**
 *  我的麻包圈数组
 */
@property (copy, nonatomic) NSMutableArray *myCircleArray;
@end

@implementation MBMyCircleController
-(NSMutableArray *)recommendArray{
    
    if (!_recommendArray) {
        
        _recommendArray = [NSMutableArray   array];
    }
    return _recommendArray;
}
-(NSMutableArray *)myCircleArray{

    if (!_myCircleArray) {
        
        _myCircleArray = [NSMutableArray   array];
    }
    return _myCircleArray;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:@"MaBaoCircle1"];
    [self.navBar removeFromSuperview];
    
   
    [self headerView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self setShufflingFigureData];
    
    // 改变麻包圈状态  根据其他界面的在改变去改变（退出登录，加入或退出圈子等）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(circleState) name:@"circleState" object:nil];

    
}
/**
 *  广告轮播图UI
 *
 *  @return
 */
- (void)headerView{
    
    self.tableHeadView.ml_height = UISCREEN_WIDTH*35/75 + 90;
    self.shufflingView.delegate = self;
    self.shufflingView.placeholderImage = [UIImage imageNamed:@"placeholder_num3"];
    self.shufflingView.autoScrollTimeInterval = 5.0f;
}

- (void)circleState{
    [self.recommendArray removeAllObjects];
    [self.myCircleArray removeAllObjects];
    
    [self setData];


}
- (IBAction)buttonClick:(UIButton *)sender {
   NSString *sid  = [MBSignaltonTool getCurrentUserInfo].sid;
    switch (sender.tag) {
        case 0:
        {
            [MobClick event:@"MyCircle1"];
            MBWebViewController *VC = [[MBWebViewController alloc] init];
            VC.url =  [NSURL URLWithString:string(@"http://api.xiaomabao.com", @"/discovery/story")];
            VC.isloging = YES;
            VC.title = @"麻包故事";
            [self pushViewController:VC Animated:YES];
            
            
        }break;
        case 1:{
            [MobClick event:@"MyCircle2"];
            MBVoiceViewController *Vc  = [[MBVoiceViewController alloc] init];
            [self pushViewController:Vc Animated:YES];
            
        }break;
        case 2: {
            [MobClick event:@"MyCircle3"];
            if (!sid) {
                [self  loginClicksss:@"mabao"];
                return ;
            }
            
            MBArticleCollectViewController *VC = [[MBArticleCollectViewController alloc] init];
            [self pushViewController:VC Animated:YES];
        }break;
        case 3:
        {
            [MobClick event:@"MyCircle4"];
            if (!sid) {
                [self  loginClicksss:@"mabao"];
                return ;
            }

             [self performSegueWithIdentifier:@"MBCollectionPostController" sender:nil];
        } break;
        case 4:
        {
            
            
            MBBabyWebController *VC = [[MBBabyWebController alloc] init];
            VC.url = URL(@"https://api.xiaomabao.com/discovery/talk_list");
            VC.title = @"英文绘本、儿歌";
            [self pushViewController:VC Animated:YES];
            
        } break;
        default:
            break;
    }
}

/**
 *  广告轮播图数据
 *
 *  @return nil
 */
#pragma mark -- 我的圈轮播图数据
- (void)setShufflingFigureData{
    
     [self show];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/circle/get_circle_ads"];
    
    [MBNetworking newGET:url parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
       
        if (responseObject) {
            if ([[responseObject valueForKeyPath:@"data"] isKindOfClass:[NSArray class]]) {
                _bandImageArray = [responseObject valueForKeyPath:@"data"];
               
                NSMutableArray *imaageUrlArr = [NSMutableArray array];
                for (NSDictionary *dic in _bandImageArray) {
                    [imaageUrlArr addObject:dic[@"ad_img"]];
                }
                self.shufflingView.delegate = self;
                self.shufflingView.imageURLStringsGroup = imaageUrlArr;
                [self setData];
                return ;
            }
            
        }
        
        [self show:@"没有相关数据" time:1];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
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
        [MBNetworking newGET:url parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
            [self dismiss];
            
            if (responseObject) {
                [self.recommendArray addObjectsFromArray:[responseObject valueForKeyPath:@"recommend"]];
                _numberOfSections = 1;
                self.tableHeadView.hidden = NO;
                [self.tableView reloadData];
                return ;
            }
            
            [self show:@"没有相关数据" time:1];
            
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            MMLog(@"%@",error);
            [self show:@"请求失败" time:1];
        }];
        
    }else{
        NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/UserCircle/get_user_circle"];
        
        [MBNetworking   POSTOrigin:url parameters:@{@"session":sessiondict} success:^(id responseObject) {
            [self dismiss];
          
            if (responseObject) {
                
                [self.myCircleArray addObjectsFromArray:[responseObject valueForKeyPath:@"user_circle"]];
                [self.recommendArray addObjectsFromArray:[responseObject valueForKeyPath:@"recommend"]];
                _numberOfSections = 2;
                self.tableHeadView.hidden = NO;
                [self.tableView reloadData];
                [self myCircleDefaults];
               
                
            }
            
            

        }failure:^(NSURLSessionDataTask *operation, NSError *error) {
            [self show:@"请求失败 " time:1];
            MMLog(@"%@",error);
        }];
        
    }
    
    
}
#pragma mark--加入圈子或取消加入圈子
- (void)setJoin_circle:(NSString *)circle_id indexPath:(NSIndexPath *)indexPath {
    NSString *sid  = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    [self show];
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/UserCircle/join_circle"];
    
    [MBNetworking   POSTOrigin:url parameters:@{@"session":sessiondict,@"circle_id":circle_id} success:^(id responseObject) {
      [self dismiss];
        if ([[responseObject  valueForKeyPath:@"status"]isEqualToNumber:@1]) {
           
            if (indexPath.section==0) {
                [self show:@"成功退出" and:_myCircleArray[indexPath.row][@"circle_name"] time:1];
                [_recommendArray addObject:_myCircleArray[indexPath.row]];
                [_myCircleArray removeObjectAtIndex:indexPath.row];
                [self myCircleDefaults];
                [self.tableView reloadData];

                
            }else{
                [self show:@"成功加入 " and:_recommendArray[indexPath.row][@"circle_name"] time:1];
                [_myCircleArray addObject:_recommendArray[indexPath.row]];
                [_recommendArray removeObjectAtIndex:indexPath.row];

                 [self myCircleDefaults];
                [self.tableView reloadData];
            }
            
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败 " time:1];
        MMLog(@"%@",error);
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    NSInteger ad_type = [_bandImageArray[index][@"ad_type"] integerValue];
    
    [MobClick event:@"MyCircle0"];
    switch (ad_type) {
        case 1: {
            MBActivityViewController *VC = [[MBActivityViewController alloc] init];
            VC.act_id = _bandImageArray[index][@"act_id"];
            VC.title = _bandImageArray[index][@"ad_name"];
            [self pushViewController:VC Animated:YES];
        }break;
        case 2: {
            
            MBGoodsDetailsViewController *VC = [[MBGoodsDetailsViewController alloc] init];
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

- (void)configureCell:(MBMycircleTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
     NSString *sid  = [MBSignaltonTool getCurrentUserInfo].sid;
    cell.fd_enforceFrameLayout = YES;
    NSDictionary *dic;
    if (indexPath.section ==0&&sid) {
        dic = self.myCircleArray[indexPath.row];
    }else{
        
        if (self.recommendArray.count > 0) {
            dic = self.recommendArray[indexPath.row];
        }
    }
    
    cell.indexPath = indexPath;
    cell.dataDic = dic;
    WS(weakSelf)
    cell.buttonClick = ^(NSIndexPath *indexPath){
        
        NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
        if (!sid) {
            [weakSelf  loginClicksss:@"mabao"];
            return ;
        }
        
        
        if (indexPath.section == 0) {
            [MobClick event:@"MyCircle7"];
            [weakSelf prompt:indexPath];
            
        }else{
            [MobClick event:@"MyCircle8"];
            [weakSelf setJoin_circle:_recommendArray[indexPath.row][@"circle_id"] indexPath:indexPath];
        }
    };
}
#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return _numberOfSections;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSString *sid  = [MBSignaltonTool getCurrentUserInfo].sid;
    if (section == 0) {
        if (sid) {
            if (self.myCircleArray.count ==0) {
                
                return 1;
            }
            
            return self.myCircleArray.count;
        }
        
        return self.recommendArray.count;
        

    }
    
    return self.recommendArray.count;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *sid  = [MBSignaltonTool getCurrentUserInfo].sid;
    if (indexPath.section == 0 && self.myCircleArray.count == 0 && sid) {
    return 64;
    }
    
    return [tableView fd_heightForCellWithIdentifier:@"MBMycircleTableViewCell" cacheByIndexPath:indexPath configuration:^(MBMycircleTableViewCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
        
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 41;
}

#pragma mark -- UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *sid  = [MBSignaltonTool getCurrentUserInfo].sid;

    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 41);
    UIView *backTopView = [[UIView alloc] init];
    backTopView.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 5);
    backTopView.backgroundColor = BACKColor;
    [view addSubview:backTopView];
    YYLabel *lable = [[YYLabel alloc] init];
    [view addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.centerY.mas_equalTo(3);
    }];
    
    if (sid&&section == 0) {
        NSString *numStr = s_Integer(_myCircleArray.count);
        NSString *comment_content = [NSString stringWithFormat:@"我的麻包圈( %@ )",numStr];
        NSRange range = [comment_content rangeOfString:numStr];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:comment_content];
        att.yy_font = YC_RTWSYueRoud_FONT(15);
        att.yy_color = UIcolor(@"575757");
        [att yy_setColor:UIcolor(@"d66263") range:range];
        lable.attributedText  = att;
    }else{
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"推荐麻包圈"];
        att.yy_font = YC_RTWSYueRoud_FONT(15);
        att.yy_color = UIcolor(@"575757");
        lable.attributedText  = att;
    }
    [self addBottomLineView:view];
    return view;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *sid  = [MBSignaltonTool getCurrentUserInfo].sid;
    if (indexPath.section == 0 && self.myCircleArray.count == 0 && sid) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBMycircleTableViewCellTo" forIndexPath:indexPath];
        [cell uiedgeInsetsZero];
    
        return cell;
    }else{
        
        NSDictionary *dic;
        if (indexPath.section ==0&&sid) {
            dic = self.myCircleArray[indexPath.row];
        }else{
            
            if (self.recommendArray.count > 0) {
                dic = self.recommendArray[indexPath.row];
            }
        }

        
        MBMycircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBMycircleTableViewCell" forIndexPath:indexPath];
         [self configureCell:cell atIndexPath:indexPath];
        [cell uiedgeInsetsZero];
        return cell;
    
    }
    

    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *sid  = [MBSignaltonTool getCurrentUserInfo].sid;
    if (indexPath.section == 0 && self.myCircleArray.count == 0 && sid) {
    
        
        return;
    
    }
    NSDictionary *dic;
    NSString *str  = @"0";
    if (indexPath.section == 0&&sid) {
        [MobClick event:@"MyCircle5"];
        dic = _myCircleArray[indexPath.row];
        str = @"1";
    }else{
        [MobClick event:@"MyCircle6"];
        if (self.recommendArray.count > 0) {
            dic = self.recommendArray[indexPath.row];
        }
        
    }
    
    MBDetailsCircleController *VC = [[MBDetailsCircleController alloc] init];
    VC.circle_id = dic[@"circle_id"];
    VC.circle_user_cnt = dic[@"circle_post_cnt"];
    VC.circle_name = dic[@"circle_name"];
    VC.circle_logo = dic[@"circle_logo"];
    VC.is_join = str;
    [self pushViewController:VC Animated:YES];
}
/**
 *  保存我的麻包圈数据，和更多圈数据比较，（更多圈数据未分类）
 */
- (void)myCircleDefaults{
    NSArray *myCircleArr = _myCircleArray;
    [User_Defaults setObject:myCircleArr forKey:@"myCircle"];
    [User_Defaults synchronize];
    
   
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
        [self setJoin_circle:_myCircleArray[indexPath.row][@"circle_id"] indexPath:indexPath];

        
    }];
    [reloadAction setValue:UIcolor(@"575c65") forKey:@"titleTextColor"];
    
    UIAlertAction *reloadAction1 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertCancel addAction:reloadAction];
    [alertCancel addAction:reloadAction1];
    [reloadAction1 setValue:UIcolor(@"d66263") forKey:@"titleTextColor"];
    [self presentViewController:alertCancel animated:YES completion:nil];
}


@end
