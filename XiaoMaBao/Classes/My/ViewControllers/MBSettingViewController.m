//
//  MBSettingViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/7.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBSettingViewController.h"
#import "MBSettingTableViewCell.h"
#import "MBEditProfileViewController.h"
#import "MBEditPwdViewController.h"
#import "MBServiceProvisionViewController.h"
#import "MBAboutViewController.h"
#import "UIImageView+WebCache.h"
#import "SFHFKeychainUtils.h"
#import "MBLogOperation.h"
#import "MBNewBabyController.h"
@interface MBSettingViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSString *_cacheSize;
}
@property (strong,nonatomic) NSArray *lists;
@property (strong,nonatomic) UITableView *tableView;
@end

@implementation MBSettingViewController

- (NSArray *)lists{
    if (!_lists) {
        
        
            _lists = @[
                       @"修改个人资料",
                       @"服务条款",
                       @"关于麻包",
                       @"清除缓存"
                       ];
        
       
    }
    return _lists;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 获取Caches目录路径
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesDir = [paths objectAtIndex:0];
        _cacheSize = [NSString stringWithFormat:@"%.2fM",[self folderSizeAtPath:cachesDir]];
        
        // 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
    
    _tableView = [[UITableView alloc] init];
    [_tableView registerNib:[UINib nibWithNibName:@"MBSettingTableViewCell" bundle:nil] forCellReuseIdentifier:@"MBSettingTableViewCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.frame = CGRectMake(0, TOP_Y, self.view.ml_width, self.view.ml_height - TOP_Y);
    _tableView.dataSource = self, _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    UIView *footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, self.view.ml_width, 53);
    
    UIButton *exitBtn = [[UIButton alloc] init];
    [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(unLogin) forControlEvents:UIControlEventTouchUpInside];
    exitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    exitBtn.frame = CGRectMake(30, 20, footerView.ml_width - 60, 33);
    exitBtn.backgroundColor = NavBar_Color;
    exitBtn.layer.cornerRadius = 16;
    [footerView addSubview:exitBtn];
    
    _tableView.tableFooterView = footerView;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lists.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"MBSettingTableViewCell";
    
    MBSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.titleLbl.text = self.lists[indexPath.row];
      MBUserDataSingalTon *userInfo = [MBSignaltonTool getCurrentUserInfo];
    NSInteger row;
    if([userInfo.collection_num isEqualToString:@"0"]){
        row =4;
    }else{
    
        row =3;
    }
        
    
    if( indexPath.row == row){
        
    
        
        if (!_cacheSize || [_cacheSize isEqualToString:@"nanM"]) {
            _cacheSize = @"0.00M";
        }
        
        cell.rightLbl.text = _cacheSize;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
        if (indexPath.row == 0) {
            [MobClick event:@"SetUp0"];
            MBEditProfileViewController *editVc = [[MBEditProfileViewController alloc] init];
            [self.navigationController pushViewController:editVc animated:YES];
        }else if (indexPath.row == 1){
            [MobClick event:@"SetUp1"];
            MBServiceProvisionViewController *evaluateVc = [[MBServiceProvisionViewController alloc] init];
            [self.navigationController pushViewController:evaluateVc animated:YES];
        }else if (indexPath.row == 2){
            [MobClick event:@"SetUp2"];
            MBAboutViewController *serviceVc = [[MBAboutViewController alloc] init];
            [self.navigationController pushViewController:serviceVc animated:YES];
        }else if (indexPath.row == 3){
            [MobClick event:@"SetUp3"];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:[NSString stringWithFormat:@"缓存大小为：%@，确定要清除缓存吗？",_cacheSize] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];

        }

    
    
}

- (void)unLogin{
    [MobClick event:@"SetUp4"];
    MBUserDataSingalTon *user = [MBSignaltonTool getCurrentUserInfo];
    
    [user clearUserInfo];
    
    MBNavigationViewController *nav =   self.tabBarController.childViewControllers.firstObject ;
    MBNewBabyController *VC = nav.childViewControllers.firstObject;
    VC.oldSid = nil;
    [MBLogOperation deletePasswordAndUserName];
    //发送通知，改变麻包圈的圈子状态 未登录，显示推荐圈子
    [[NSNotificationCenter defaultCenter] postNotificationName:@"circleState" object:nil];
    //清除极光推送 个推的uuid。
    [MobClick profileSignOff];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)titleStr{
    return @"设置";
}

-(float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

-(float)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize +=[self fileSizeAtPath:absolutePath];
        }
        //SDWebImage框架自身计算缓存的实现
        folderSize += [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}

-(void)clearCache{
    [self show];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:cachesDir]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:cachesDir];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[cachesDir stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
    _cacheSize = nil;
    [self dismiss];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1){
        
        // 获取Caches目录路径
       
        [self clearCache];
        [self.tableView reloadData];
    }

    
    
}

@end
