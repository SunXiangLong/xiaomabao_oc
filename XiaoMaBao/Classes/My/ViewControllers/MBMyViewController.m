//
//  MBPersonalSettingsViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBMyViewController.h"
#import "MBMyCollectionViewCell.h"
#import "BkTabBarButton.h"
#import "MBSettingViewController.h"
#import "MBOrderListViewController.h"
#import "MBShoppingCartViewController.h"
#import "MBMyCollectionViewController.h"
#import "MBVoucherViewController.h"
#import "MBHistoryRecoderViewController.h"
#import "MBShopAddresViewController.h"
#import "MBBackServiceViewController.h"
#import "NTalkerChatViewController.h"
#import "XNGoodsInfoModel.h"
#import "MBHelpServiceViewController.h"
#import "MBLoginViewController.h"
#import "MBVaccineViewController.h"
#import "MBRefundHomeController.h"
#import "MBHealthViewController.h"
#import "MBMyHeadView.h"
#import "MBPersonalCanulaCircleViewController.h"
#import "MBMyServiceController.h"
@interface MBMyViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSArray *_menuItemTitles;
    NSArray *_menuItemImages;
    
    NSArray *_dataOne;
    NSArray *_dataTwo;
    
    NSString *_header_img;
    NSString *_nick_name;
    BOOL _isbool;
    
    NSDictionary     *_userDic;
    
}

@property (strong, nonatomic)  UICollectionView *collerctonView;
@end

@implementation MBMyViewController
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBPersonalSettingsViewController"];
    
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBPersonalSettingsViewController"];
    
    if (!_isbool) {
        NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
        if (sid) {
            
           [self setHeadUserData];
        }else{
            [self.collerctonView  removeFromSuperview];
            self.collerctonView = nil;
            [self.view addSubview:self.collerctonView];
            
            
        }
    }
    
    
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self data];
    [self.view addSubview:self.collerctonView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageBadge:) name:@"messageBadge" object:nil];


}
- (void)messageBadge:(NSNotification *)notificat{
    NSString *messageNumber = [User_Defaults objectForKey:@"messageNumber"];
    if (messageNumber&&[messageNumber intValue]>0 ) {
        [self.messageBadge autoBadgeSizeWithString:messageNumber];
        self.messageBadge.hidden = NO;
    }else{
        self.messageBadge.hidden = YES;
    }
    
    
}
#pragma mark -- 跳转登陆页
- (void)loginClicksss{
    _isbool  = NO;
    //跳转到登录页
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MBLoginViewController *myView = [story instantiateViewControllerWithIdentifier:@"MBLoginViewController"];
    myView.vcType = @"mabao";
    MBNavigationViewController *VC = [[MBNavigationViewController alloc] initWithRootViewController:myView];
    [self presentViewController:VC animated:YES completion:nil];
}

#pragma mark -- 个人详情
- (void)backView{
    MBPersonalCanulaCircleViewController *VC = [[MBPersonalCanulaCircleViewController alloc] init];
    [self pushViewController:VC Animated:YES];
    
}
#pragma mark --获取用户麻包圈的基本信息
- (void)setHeadUserData{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/communicate/getusermbqinfo"];
    if (! sid) {
        return;
    }
    [MBNetworking POST:url parameters:@{@"session":sessiondict}
               success:^(AFHTTPRequestOperation *operation, MBModel *responseObject) {
                   
//                   NSLog(@"%@ %@",[responseObject valueForKey:@"status"],responseObject.data);
                   
                   
                   if(1 == [[responseObject valueForKey:@"status"]  intValue]){
                       
                       
                       _userDic  = [responseObject valueForKeyPath:@"data"];
                       [self.collerctonView reloadData];
                       
                       
                   }else{
                       [self show:@"获取用户数据失败" time:1];
                   }
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   
                   [self show:@"请求失败 " time:1];
                   NSLog(@"%@",error);
                   
               }
     ];
    
    
}
-(void)getUserInfo
{
   
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    if (!sid) {
        return;
    }
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"user/info"] parameters:@{@"session":sessiondict}
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"UserInfo成功---responseObject%@",[responseObject valueForKeyPath:@"data"]);
     
                   
                   NSDictionary *dic = [responseObject valueForKeyPath:@"data"];
                   _header_img = dic[@"header_img"];
                   _nick_name = dic[@"nick_name"];
                   [_collerctonView reloadData];
                   
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   NSLog(@"%@",error);
                   [self show:@"请求失败" time:1];
               }];
    
}

- (void)data{
    _menuItemTitles = @[
                        @"我的订单",
                        @"服务订单",
                        @"麻布袋",
                        @"我的收藏"
                        ];
    
    _menuItemImages = @[
                        @"order_image",
                        @"serviceOrder",
                        @"sack_image",
                        @"collection_image"
                        ];
    _dataOne = @[@{@"image":@"browsinghistor_image",@"name":@"浏览记录"},
                 @{@"image":@"phote_image",@"name":@"热线电话",@"photo":@"400-0056-830"},
                 @{@"image":@"address_image",@"name":@"收货地址"},
                 @{@"image":@"service_image",@"name":@"售后服务"},
                 @{@"image":@"customer_image",@"name":@"在线客服"},
                 @{@"image":@"help_image",@"name":@"麻包帮助"},
                 @{@"image":@"refund_image",@"name":@"退货换货"},
                 @{@"image":@"vouchers_image",@"name":@"代金券"},
                 ];
    
    
    _dataTwo = @[@{@"image":@"vaccine_image",@"name":@"疫苗记录"},
                @{@"image":@"prenatal_image",@"name":@"产检"},
                @{@"image":@"knowledge_image",@"name":@"知识库"},
                @{@"image":@"bb_image",@"name":@"宝宝身高体重"},
                @{@"image":@"iconfont_image",@"name":@"睡前故事"}
                 ];
}
- (UICollectionView *)collerctonView{

    
   
    if (!_collerctonView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(UISCREEN_WIDTH/4,UISCREEN_WIDTH/12*72/86+33);
        flowLayout.minimumInteritemSpacing =0;
        flowLayout.minimumLineSpacing = 0;
        self.collerctonView= [[UICollectionView alloc] initWithFrame:CGRectMake(0, TOP_Y, UISCREEN_WIDTH, UISCREEN_HEIGHT-TOP_Y-49) collectionViewLayout:flowLayout];
        _collerctonView.alwaysBounceVertical = YES;
        _collerctonView.delegate = self;
        _collerctonView .dataSource = self;
        _collerctonView.backgroundColor = [UIColor colorWithHexString:@"f2f3f7"];
        [_collerctonView registerNib:[UINib nibWithNibName:@"MBMyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MBMyCollectionViewCell"];
        [_collerctonView    registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView1"];
        [_collerctonView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView2"];
        
        return _collerctonView;
    }
    
    return _collerctonView;
    
    
}
- (void)onClick:(UIButton *)button{
    switch (button.tag) {
        case 0: {
            MBOrderListViewController *VC = [[MBOrderListViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];}break;
        case 1:{
        

            MBMyServiceController *VC  = [[MBMyServiceController alloc] init];
            [self pushViewController:VC Animated:YES];
        }break;
        case 2: {
            MBShoppingCartViewController *VC =[[MBShoppingCartViewController alloc] init];
            VC.showBottomBar = @"yes";
            [self pushViewController:VC Animated:YES];
            }  break;
        case 3:{
            MBMyCollectionViewController *VC =[[MBMyCollectionViewController alloc] init]; [self pushViewController:VC Animated:YES];}  break;
        default:
            break;
    }
    
}



//-(NSString *)leftImage{
//return @"message_image";
//}
-(void)leftTitleClick{



}
-(NSString *)rightImage{
    return @"setup_image";
    
}

- (void)rightTitleClick{
    NSNotification *messageBadge =[NSNotification notificationWithName:@"messageBadge" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:messageBadge];
    _isbool = NO;
    if (self.isLogin) {
        MBSettingViewController *settingVc = [[MBSettingViewController alloc] init];
        [self.navigationController pushViewController:settingVc animated:YES];
    }else{
        
        [self loginClicksss];
       
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark --UICollectionViewdelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        if (indexPath.section == 0) {
            UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView1" forIndexPath:indexPath];
     
            UIView *topView = [[UIView alloc] init];
            topView.frame = CGRectMake(0, 10, UISCREEN_WIDTH, UISCREEN_WIDTH*268/960);
            [reusableview addSubview:topView];
            NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
            if (!sid) {
                
                UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                loginBtn.titleLabel.font = [UIFont systemFontOfSize:25];
                loginBtn.frame = CGRectMake(0, (topView.ml_height - 25) * 0.5, self.view.ml_width, 25);
                [loginBtn setTitleColor:[UIColor colorWithHexString:@"d66263"] forState:UIControlStateNormal];
                [loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
                loginBtn.titleLabel.textAlignment = 1;
                
                
                [topView addSubview:loginBtn];
                [loginBtn addTarget:self action:@selector(loginClicksss) forControlEvents:UIControlEventTouchUpInside];
                
                return reusableview;
                
                
            }
            
            MBMyHeadView *headView = [MBMyHeadView instanceView];
            headView.frame = topView.frame;
            headView.user_image.layer.cornerRadius = (topView.ml_height-8)/2;
            [reusableview   addSubview:headView];
            [headView.user_image sd_setImageWithURL:[NSURL URLWithString:_userDic[@"avatar"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
            headView.user_guanzhu.text  = _userDic[@"attentions"];
            headView.user_price.text = _userDic[@"fans"];
            headView.user_tiezi.text = _userDic[@"article"];
           [headView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backView)]];
            
             
            
            UIView *view = [[UIView alloc] init];
            view.frame = CGRectMake(0, CGRectGetMaxY(topView.frame)+10, UISCREEN_WIDTH, UISCREEN_WIDTH*150/960);
            view.backgroundColor = [UIColor colorWithHexString:@"d66263"];
            [reusableview addSubview:view];
            
            
            
            CGFloat width = [UIScreen mainScreen].bounds.size.width / _menuItemTitles.count;
            for (NSInteger i = 0; i < _menuItemTitles.count; i++) {
                BkTabBarButton *menuBtn = [BkTabBarButton buttonWithType:UIButtonTypeCustom];
                menuBtn.tag = i;
                menuBtn.num = 25 ;
                [menuBtn setTitleColor:[UIColor colorWithHexString:@"000000"] forState:UIControlStateNormal];
                menuBtn.titleLabel.font = [UIFont systemFontOfSize:12];
                [menuBtn setTitle:_menuItemTitles[i] forState:UIControlStateNormal];
                [menuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [menuBtn setImage:[UIImage imageNamed:_menuItemImages[i]] forState:UIControlStateNormal];
                menuBtn.frame = CGRectMake(i * width, 0, width, view.ml_height);
                
                [menuBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:menuBtn];
                
                if (_menuItemImages.count-1!=i) {
                    UIView *linView = [[UIView alloc] init];
                    linView.backgroundColor = [UIColor whiteColor];
                    [menuBtn addSubview:linView];
                    [linView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(10);
                        make.bottom.mas_equalTo(-10);
                        make.right.mas_equalTo(-1);
                        make.width.mas_equalTo(1);
                    }];
                }
            }
            
            
            
            UILabel *lable = [[UILabel    alloc] init];
            lable.frame = CGRectMake(0, CGRectGetMaxY(view.frame)+10, UISCREEN_WIDTH, UISCREEN_WIDTH*65/960);
            lable.backgroundColor = [UIColor colorWithHexString:@"d66263"];
            lable.text = @"我的账户";
            lable.textColor = [UIColor whiteColor];
            lable.textAlignment = 1;
            lable.font = [UIFont systemFontOfSize:14];
            [reusableview   addSubview:lable];
            return reusableview;
        }else{
            UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView2" forIndexPath:indexPath];
            UILabel *lable = [[UILabel    alloc] init];
            lable.frame = CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_WIDTH*65/960);
            lable.backgroundColor = [UIColor colorWithHexString:@"d66263"];
            lable.text = @"生活健康";
            lable.textColor = [UIColor whiteColor];
            lable.textAlignment = 1;
            lable.font = [UIFont systemFontOfSize:14];
            [reusableview   addSubview:lable];
            return  reusableview;
        }
        
    }
    
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MBMyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBMyCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (_dataOne.count>indexPath.row) {
            cell.showImageVIew.image = [UIImage imageNamed:_dataOne[indexPath.row][@"image"]];
            cell.nameLable.text = _dataOne[indexPath.item][@"name"];
            
            if (indexPath.item==1) {
                
                
                cell.photoLable.text = @"400-0056-830";
            }
        }else{
            cell.showImageVIew.image = nil;
            cell.nameLable.text = @"";
            cell.photoLable.text = @"";
        }
        
    }else{
        if (_dataTwo.count>indexPath.row) {
            cell.showImageVIew.image = [UIImage imageNamed:_dataTwo[indexPath.row][@"image"]];
            cell.nameLable.text = _dataTwo[indexPath.item][@"name"];
            cell.photoLable.text = @"";
        }else{
            cell.showImageVIew.image = nil;
            cell.nameLable.text = @"";
            cell.photoLable.text = @"";
        }
        
    }
    
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _isbool  = YES;
      NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    
    if (indexPath.section==0) {
        if (indexPath.row==1||indexPath.row==3||indexPath.row==4||indexPath.row==5) {
            
        }else{
            if (!sid) {
                [self loginClicksss];
                
                return;
            }
        }
        switch (indexPath.row) {
            case 0:{MBHistoryRecoderViewController *VC = [[MBHistoryRecoderViewController alloc] init];
                [self pushViewController:VC Animated:YES];
            }break;
            case 1: {//拨打电话号码
                NSString * telStr = [NSString stringWithFormat:@"telprompt://%@",@"400-0056-830"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
            }break;
            case 2:{MBShopAddresViewController *VC = [[MBShopAddresViewController alloc] init];
                 VC.PersonalCenter = @"yes";
                [self pushViewController:VC Animated:YES];}break;
            case 3:{MBBackServiceViewController *VC = [[MBBackServiceViewController alloc] init];
                [self pushViewController:VC Animated:YES];}break;
            case 4: [self service]; break;
            case 5: {MBHelpServiceViewController *VC = [[MBHelpServiceViewController alloc] init];
                [self pushViewController:VC Animated:YES];}break;
            case 6: {MBRefundHomeController *VC = [[MBRefundHomeController alloc] init];
                [self pushViewController:VC Animated:YES];}break;
            default:{MBVoucherViewController *VC =[[MBVoucherViewController alloc] init]; [self pushViewController:VC Animated:YES];}
                break;
        }
    }else{

        
        switch (indexPath.row) {
            case 0: { MBVaccineViewController *VC = [[MBVaccineViewController alloc] init];
                NSString *urlStr =[NSString stringWithFormat:@"%@%@",BASE_PHP,@"/vaccine_record"];
                NSURL *urls = [NSURL  URLWithString:[NSString stringWithFormat:@"%@",urlStr]];
                VC.url = urls;
                VC.title =  @"疫苗纪录";
                [self pushViewController:VC Animated:YES];  } break;
            case 1: {  MBVaccineViewController *VC = [[MBVaccineViewController alloc] init];
                NSString *urlStr =[NSString stringWithFormat:@"%@%@",BASE_PHP,@"/pregnancy_record"];
                NSURL *url = [NSURL  URLWithString:[NSString stringWithFormat:@"%@",urlStr]];
                VC.url = url;
                VC.title =  @"产检";
                [self pushViewController:VC Animated:YES]; }break;
            case 2: { MBVaccineViewController *VC = [[MBVaccineViewController alloc] init];
                NSString *urlStr =[NSString stringWithFormat:@"%@%@",BASE_PHP,@"/knowledge_index/ios"];
                NSURL *url = [NSURL  URLWithString:[NSString stringWithFormat:@"%@",urlStr]];
                VC.url = url;
                VC.title =  @"知识库";
                VC.isSearch = YES;
                [self pushViewController:VC Animated:YES];}break;
                
            case 3: {
                MBHealthViewController *VC = [[MBHealthViewController alloc] init];
                NSString *urlStr =[NSString stringWithFormat:@"%@",BASE_PHP_test];
                NSURL *url = [NSURL  URLWithString:[NSString stringWithFormat:@"%@",urlStr]];
                VC.url = url;
                VC.title =  @"宝宝身高体重";
                [self pushViewController:VC Animated:YES];}break;
            case 4: {
                MBHealthViewController *VC = [[MBHealthViewController alloc] init];
                NSString *urlStr =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/vedio/vediolist/"];
                NSURL *url = [NSURL  URLWithString:[NSString stringWithFormat:@"%@",urlStr]];
                VC.url = url;
                VC.title =  @"睡前故事";
       
                [self pushViewController:VC Animated:YES];}break;
            default:
                break;
        }
        
        
    }
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        if (self.isLogin) {
            return CGSizeMake(UISCREEN_WIDTH , UISCREEN_WIDTH*268/960+UISCREEN_WIDTH*150/960+UISCREEN_WIDTH*65/960+30);
        }
        return CGSizeMake(UISCREEN_WIDTH , UISCREEN_WIDTH*268/960+20);
    }else{
        return CGSizeMake( UISCREEN_WIDTH, UISCREEN_WIDTH*65/960);
    }
    
}
-(NSString *)titleStr{
    
    return @"个人中心";
}
- (void)service{

    XNGoodsInfoModel *info = [[XNGoodsInfoModel alloc] init];
    info.appGoods_type = @"0";
    info.clientGoods_Type = @"1";
    info.goods_id = @"ntalker_test";
    info.goods_showURL = @"http://pic.shopex.cn/pictures/goodsdetail/29b.jpg?rnd=111111";
    info.goods_imageURL = @"http://pic.shopex.cn/pictures/goodsdetail/29b.jpg?rnd=111111";
    info.goodsTitle = @"起案件是否可时间段回复开始的的女的开局被罚款vfkvfdvbdfk";
    info.goodsPrice = @"¥17.0";
    info.goods_URL = @"https://www.baidu.com";
    
    NTalkerChatViewController *ctrl = [[NTalkerChatViewController alloc] init];
    ctrl.productInfo = info;
    ctrl.settingid = @"kf_9761_1432534158571";//【必传】 客服组id
    ctrl.erpParams = @"www.baidu.com";
    
    
    ctrl.pushOrPresent = NO;
    
    if (ctrl.pushOrPresent == YES) {
        [self.navigationController pushViewController:ctrl animated:YES];
    } else {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
        ctrl.pushOrPresent = NO;
        [self presentViewController:nav animated:YES completion:nil];
    }
 
    
}

@end
