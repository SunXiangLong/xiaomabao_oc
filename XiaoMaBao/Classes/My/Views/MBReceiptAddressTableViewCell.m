//
//  MBReceiptAddressTableViewCell.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/11.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBReceiptAddressTableViewCell.h"
#import "MBNetworking.h"
#import "MBSignaltonTool.h"
@interface MBReceiptAddressTableViewCell ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;

@end

@implementation MBReceiptAddressTableViewCell

- (void)setIsDefault:(BOOL)isDefault{
    _isDefault = isDefault;
    
    if (isDefault) {
        [self.defaultBtn setTitle:@"设为默认" forState:UIControlStateNormal];
        
    }else{
        [self.defaultBtn setTitle:@"设为默认" forState:UIControlStateNormal];
    }
}

- (IBAction)setDefault:(id)sender {
    
    
    UIImage *defaultImage = [UIImage imageNamed:@"pitch_on"];
    UIImage *UndefaultImage = [UIImage imageNamed:@"pitch_no"];
    if (self.isDefault) {
        [self.DefaultButton setImage:defaultImage forState:UIControlStateNormal];
        
        //设置默认
        NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
        NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
        [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"address/setDefault"] parameters:@{@"session":dict,@"address_id":self.address_id} success:^(NSURLSessionDataTask *operation, id responseObject) {
//            NSLog(@"成功---responseObject%@",responseObject);
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDefaultAddress" object:nil];
            
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            NSLog(@"失败");
        }];

    }else{
        
        
        [self.DefaultButton setImage:UndefaultImage forState:UIControlStateNormal];
       
    }
}
- (IBAction)edit:(id)sender {
    
    if (!self.consignee) {
        self.consignee = @"";
    }
    if (!self.mymobile) {
        self.mymobile = @"";
    }
    if (!self.province_name) {
        self.province_name = @"";
    }
    if (!self.city_name) {
        self.city_name = @"";
    }
    if (!self.district_name) {
        self.district_name = @"";
    }
    if (!self.myaddress) {
        self.myaddress = @"";
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.consignee,@"consignee",self.mymobile,@"mobile",self.province_name,@"province_name",self.city_name,@"city_name",self.district_name,@"district_name",self.myaddress,@"address",self.address_id,@"ID", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"editAddress" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];

}

- (IBAction)deleteAddress:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否删除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"取消删除");
        
    }else if(buttonIndex == 1)
    {
        NSLog(@"确认删除");
        [self deletemyaddressWithUrl:@"address/delete"];
    }
}

//删除收货地址
-(void)deletemyaddressWithUrl:(NSString *)url
{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"address/delete"] parameters:@{@"session":sessiondict,@"address_id":self.address_id} success:^(NSURLSessionDataTask *operation, id responseObject) {
        
//        NSLog(@"成功---responseObject%@",[responseObject valueForKeyPath:@"data"]);
        NSLog(@"self.cellIndex%ld",self.cellIndex);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteAddress" object:nil userInfo:nil];

        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"失败");
    }];
    
}

@end
