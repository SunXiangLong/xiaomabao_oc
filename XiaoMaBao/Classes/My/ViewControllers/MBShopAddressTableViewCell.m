//
//  MBShopAddressTableViewCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/24.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBShopAddressTableViewCell.h"
#import "MBNewAddressViewController.h"
@implementation MBShopAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)default:(id)sender {
    if (!self.isDefault) {
        
        //设置默认
        NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
        NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
        [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"address/setDefault"] parameters:@{@"session":dict,@"address_id":self.addressDic[@"id"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if( [[responseObject valueForKey:@"status"][@"succeed"]isEqualToNumber:@1]){
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDefaultAddress" object:nil];
            }
          
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
        
    }
}

- (IBAction)editor:(id)sender {
    MBNewAddressViewController *VC = [[MBNewAddressViewController alloc] init];
    VC.address_dic = self.addressDic;
    VC.title = @"编辑收货地址";
    [self.VC pushViewController:VC Animated:YES];
    
    
}
- (IBAction)delete:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否确定删除该地址？"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                   
                                                         handler:^(UIAlertAction * action) {}];
    UIAlertAction* fromPhotoAction = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDestructive                                                                handler:^(UIAlertAction * action) {
            [self setDelete];
        
    }];
     [alertController addAction:fromPhotoAction];
    [alertController addAction:cancelAction];
   
    [self.VC presentViewController:alertController animated:YES completion:nil];
}
- (void)setDelete{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"address/delete"] parameters:@{@"session":sessiondict,@"address_id":self.addressDic[@"id"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if( [[responseObject valueForKey:@"status"][@"succeed"]isEqualToNumber:@1]){
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDefaultAddress" object:nil];
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

@end
