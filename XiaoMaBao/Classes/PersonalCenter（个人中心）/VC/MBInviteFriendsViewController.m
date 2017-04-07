//
//  MBInviteFriendsViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/3/30.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBInviteFriendsViewController.h"
#import "MBUseHelpViewController.h"
#import "MBCouponsCell.h"
#import "MBInviteFriendsModel.h"
@interface MBInviteFriendsViewController ()
{
    NSInteger  _page;
}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImage;
@property (weak, nonatomic) IBOutlet UIImageView *shareImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MBInviteFriendsModel *model;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UILabel *shareTtitle;

@end

@implementation MBInviteFriendsViewController
-(void)setModel:(MBInviteFriendsModel *)moel{
    _model = moel;
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    [self.view bringSubviewToFront:_shareView];
    [self.topView layoutIfNeeded];
    self.topView.mj_h = _bottomImage.bottom + 50;
    
    [self reloadData];
   
}
-(NSString *)titleStr{

return @"邀请好友";
}
- (IBAction)shareViewDetermine:(id)sender {
    _shareTtitle.text = @"分享成功!";
    [UIView animateWithDuration:.8 animations:^{
        _shareView.hidden = true;
    }];
}

- (IBAction)shareButtonClick:(UIButton *)sender {
    
    
    if (!_model.share) {
        return;
    }
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:_model.share.title
                                     images:[UIImage imageNamed:@"headPortrait"] //传入要分享的图片
                                        url:_model.share.url
                                      title:_model.share.desc
                                       type:SSDKContentTypeAuto];
    SSDKPlatformType type;
    switch (sender.tag) {
        case 0:{
            type = SSDKPlatformSubTypeWechatSession;
        }break;
        case 1:{
            type = SSDKPlatformSubTypeWechatTimeline;
        }break;
        case 2:{
            type = SSDKPlatformSubTypeQQFriend;
        }break;
        default:{
            type = SSDKPlatformSubTypeQZone;
        }break;
    }
    
    //进行分享
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        MMLog(@"%@--%ld-%@-%@",error,state,userData,contentEntity);
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                _shareTtitle.text = @"分享成功!";
                [UIView animateWithDuration:.8 animations:^{
                    _shareView.hidden = false;
                }];
            
            }break;
            case SSDKResponseStateCancel:
            {
                _shareTtitle.text = @"您取消了分享!";
                [UIView animateWithDuration:.8 animations:^{
                    _shareView.hidden = false;
                }];
                
                
            }break;
            case SSDKResponseStateFail:
            {
                _shareTtitle.text = @"分享失败!";
                [UIView animateWithDuration:.8 animations:^{
                    _shareView.hidden = false;
                }];
            }break;
    
            default:
                break;
        }
    
    }];

}
-(void)reloadData
{
    [self show];

    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking   POSTOrigin:string(BASE_URL_root, @"/invite/coupon") parameters:@{@"session":sessiondict,@"page":s_Integer(_page)} success:^(id responseObject) {
        [self dismiss];
        MMLog(@"%@",responseObject);
        if (_page == 1) {
            [self.tableView footerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        if (![self charmResponseObject:responseObject]) {
            return ;
        };
        MBInviteFriendsModel *model =  [MBInviteFriendsModel yy_modelWithDictionary:responseObject];
   
        if (_page == 1) {
            self.model = [MBInviteFriendsModel yy_modelWithDictionary:responseObject];
        }else{
            [self.model.counponArray addObjectsFromArray:model.counponArray];
            [self.tableView reloadData];
        }
       
        if (model.counponArray.count == 0) {
           [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        _page++;
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败！" time:1];
    }];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"MBUseHelpViewController"]) {
        MBUseHelpViewController *VC = (MBUseHelpViewController *)segue.destinationViewController;
        VC.URL = [NSURL URLWithString:string(BASE_URL_root, @"/agreement/invite")];
        VC.title  = @"邀请好友规则";
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _model?1:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.model.counponArray.count?self.model.counponArray.count:1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.model.counponArray.count?59:(UISCREEN_WIDTH - 200)*270/276+30;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 50);
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *topImage = [[UIImageView alloc] init];
    topImage.backgroundColor = UIcolor(@"f3f3f3");
    [view addSubview:topImage];
    UILabel *sectionLbl = [[UILabel alloc] init];
    sectionLbl.textColor = UIcolor(@"555555");
    sectionLbl.text = @"邀请成功记录";
    sectionLbl.font = [UIFont systemFontOfSize:14];
    [view addSubview:sectionLbl];
    [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo(10);
    }];
 
    [sectionLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(10);
    }];
    [self addBottomLineView:view];
    return view;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MBCouponsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBCouponsCell" forIndexPath:indexPath];
    if (self.model.counponArray.count) {
        cell.model = self.model.counponArray[indexPath.row];
        [self addBottomLineView:cell left:18];
    }
    
    return cell;
    
}

@end
