//
//  MBRealNameViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/3/2.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBRealNameViewController.h"

@interface MBRealNameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *idCard;

@end

@implementation MBRealNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.model.consignee &&![self.model.consignee isEqualToString:@""]) {
        _name.text = self.model.consignee;
    }else{
        _name.enabled = true;
    }
    
    // Do any additional setup after loading the view from its nib.
}
-(NSString *)rightStr{
  return @"保存";
}
-(NSString *)titleStr{
return @"实名认证";
}
-(void)rightTitleClick{
    if (!_name.text) {
        [self show:@"请输入姓名" time:.5];
        return;
    }
    if (![_idCard.text isValidWithIdentityNum] ) {
        [self show:@"请输入正确的身份证号码" time:.5];
        return;
    }
    
    [self authentication];
}
#pragma mark -- 验证身份证
- (void)authentication{
    [self show];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;

    

    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking POSTOrigin:[NSString stringWithFormat:@"%@/idcard/add",BASE_URL_root] parameters:@{@"real_name":_name.text, @"identity_card":_idCard.text,@"session":sessiondict} success:^(id responseObject) {
        [self dismiss];
        if ([s_str(responseObject[@"status"]) isEqualToString:@"1"]) {
            [self show:responseObject[@"msg"] time:1];
            self.model.idcard.identity_card = _idCard.text;
            self.model.idcard.is_black = @0;
            self.model.idcard.status = @1;
            [self popViewControllerAnimated:true];
        }else{
           [self show:@"认证失败" time:1];

        }

    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);

        [self show:@"请求失败" time:1];
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
