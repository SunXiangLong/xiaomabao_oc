//
//  MBMyCollectionTableViewCell.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/8.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBMyCollectionTableViewCell.h"
#import "MBNetworking.h"
#import "MBSignaltonTool.h"
@implementation MBMyCollectionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)saveToCart:(id)sender {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否加入购物车" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alert show];
    [self goJoinCart];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"取消删除");
        
    }else if(buttonIndex == 1)
    {
        NSLog(@"确认删除");
        [self goJoinCart];
    }
}
- (void)goJoinCart{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    if (self.goodsNum == nil) {
        self.goodsNum = @"1";
    }
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"cart/create"] parameters:@{@"session":dict, @"goods_id":self.goods_id,@"number":self.goodsNum,@"spec":@""} success:^(NSURLSessionDataTask *operation, id responseObject) {
//        NSLog(@"成功---responseObject%@",[responseObject valueForKeyPath:@"status"]);
        NSDictionary * status = (NSDictionary *)[responseObject valueForKey:@"status"];
        
        if (status[@"succeed"]) {
            [self show:@"加入购物车成功!" time:1];
        }else{
           
             [self show:@"加入购物车失败!" time:1];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"失败");
    }];
    
}
-(void)show:(NSString *)str time:(NSInteger)timer{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:timer];
    
}
@end
