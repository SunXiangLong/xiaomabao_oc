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
#import "MobClick.h"
#import "SFHFKeychainUtils.h"
#import "MBLogOperation.h"
@interface MBSettingViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (strong,nonatomic) NSArray *lists;
@property (strong,nonatomic) UITableView *tableView;
@end

@implementation MBSettingViewController

- (NSArray *)lists{
    if (!_lists) {
          MBUserDataSingalTon *userInfo = [MBSignaltonTool getCurrentUserInfo];
        if ([userInfo.collection_num isEqualToString:@"0"]) {
            _lists = @[
                       @"修改个人资料",
                       @"修改密码",
                       @"服务条款",
                       @"关于麻包",
                       @"清除缓存"
                       ];
        }else{
        
            _lists = @[
                       @"修改个人资料",
                       @"服务条款",
                       @"关于麻包",
                       @"清除缓存"
                       ];
        }
       
    }
    return _lists;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    
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
        // 获取Caches目录路径
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesDir = [paths objectAtIndex:0];
        
        
        NSString * cacheSize = [NSString stringWithFormat:@"%.2fM",[self folderSizeAtPath:cachesDir]];
    
        
        if ([cacheSize isEqualToString:@"nanM"]) {
            cacheSize = @"0.00M";
        }
        
        cell.rightLbl.text = cacheSize;
    }else if(indexPath.row == 5){
        cell.rightLbl.text = @"当前版本：v1.0";
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MBUserDataSingalTon *userInfo = [MBSignaltonTool getCurrentUserInfo];
    if ([userInfo.collection_num isEqualToString:@"0"]) {
        if (indexPath.row == 0) {
            MBEditProfileViewController *editVc = [[MBEditProfileViewController alloc] init];
            [self.navigationController pushViewController:editVc animated:YES];
        }else if (indexPath.row == 1){
            MBEditPwdViewController *pwdVc = [[MBEditPwdViewController alloc] init];
            [self.navigationController pushViewController:pwdVc animated:YES];
        }else if (indexPath.row == 2){
            MBServiceProvisionViewController *evaluateVc = [[MBServiceProvisionViewController alloc] init];
            [self.navigationController pushViewController:evaluateVc animated:YES];
        }else if (indexPath.row == 3){
            MBAboutViewController *serviceVc = [[MBAboutViewController alloc] init];
            [self.navigationController pushViewController:serviceVc animated:YES];
        }else if (indexPath.row == 4){
            // 获取Caches目录路径
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *cachesDir = [paths objectAtIndex:0];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:[NSString stringWithFormat:@"缓存大小为：%.2fM，确定要清除缓存吗？",[self folderSizeAtPath:cachesDir]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    
    }else{
        if (indexPath.row == 0) {
            MBEditProfileViewController *editVc = [[MBEditProfileViewController alloc] init];
            [self.navigationController pushViewController:editVc animated:YES];
        }else if (indexPath.row == 1){
            MBServiceProvisionViewController *evaluateVc = [[MBServiceProvisionViewController alloc] init];
            [self.navigationController pushViewController:evaluateVc animated:YES];
        }else if (indexPath.row == 2){
            MBAboutViewController *serviceVc = [[MBAboutViewController alloc] init];
            [self.navigationController pushViewController:serviceVc animated:YES];
        }else if (indexPath.row == 3){
            // 获取Caches目录路径
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *cachesDir = [paths objectAtIndex:0];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:[NSString stringWithFormat:@"缓存大小为：%.2fM，确定要清除缓存吗？",[self folderSizeAtPath:cachesDir]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];

        }

    
    }
}

- (void)unLogin{
    MBUserDataSingalTon *user = [MBSignaltonTool getCurrentUserInfo];
    
    [user clearUserInfo];
    [MBLogOperation deletePasswordAndUserName];
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

-(void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1){
        
        // 获取Caches目录路径
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesDir = [paths objectAtIndex:0];
        [self clearCache:cachesDir];
        [self.tableView reloadData];
    }

    
    
}

@end
