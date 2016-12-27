//
//  MBGiveFriendsViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/12/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBGiveFriendsViewController.h"
@interface MBGiveFriendsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *beanNumber;
@property (weak, nonatomic) IBOutlet UITextField *iPhone;
@property (weak, nonatomic) IBOutlet UITextField *number;
@end
@implementation MBGiveFriendsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _beanNumber.text = _num;
}
- (IBAction)confirm:(UIButton *)sender {
    if (_iPhone.text.length == 0) {
        [self show:@"请输入对方账号" time:.8];
        return;
    }
    
    if (_number.text.length == 0) {
        [self show:@"请输入赠送数量" time:.8];
        return;
    }
    [self requestDaTa];
}

-(NSString *)titleStr{
    return @"赠送麻豆";
}
-(void)requestDaTa{

    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [self show];
    [MBNetworking POSTOrigin:string(BASE_URL_root, @"/bean/send") parameters:@{@"session":dict,@"friend_account":_iPhone.text,@"send_number":_number.text} success:^(id responseObject) {
        [self dismiss];
        if (responseObject) {
            MMLog(@"%@",responseObject);
            self.block();
            [self popViewControllerAnimated:true];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败" time:.8];
    }];
   
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
