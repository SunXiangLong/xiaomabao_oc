//
//  MBAttentionOrFansTableViewCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBAttentionOrFansTableViewCell.h"
@interface  MBAttentionOrFansTableViewCell()

@end
@implementation MBAttentionOrFansTableViewCell

- (void)awakeFromNib {
    self.showImageView.userInteractionEnabled = YES;
    [self.showImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backView)]];
}
- (IBAction)guanzhuButton:(UIButton *)sender {
    [self  setUserTell];
}
#pragma mark --获取数据
- (void)setUserTell{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
  
    
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/communicate/payattention"];
    if (! sid) {
        return;
    }

//    __unsafe_unretained __typeof(self) weakSelf = self;
    
    [MBNetworking POST:url parameters:@{@"session":sessiondict,@"user_id":self.user_id}
               success:^(AFHTTPRequestOperation *operation, MBModel *responseObject) {
                   
//                   NSLog(@"%@ %@",[responseObject valueForKey:@"status"],responseObject.data);
             
                   
                   if(1 == [[responseObject valueForKey:@"status"]  intValue]){
                       
                       if ([self.is_attention isEqualToString:@"1"]) {
                           NSLog(@"-----%@",self.is_attention);
                           self.is_attention = @"0";
                            NSLog(@"+++++++%@",self.is_attention);
                       }else{
                                NSLog(@"222222%@",self.is_attention);
                              self.is_attention = @"1";
                                NSLog(@"333333%@",self.is_attention);
                       }
                       
                            NSLog(@"%@",self.is_attention);
                       
                       if ([self.is_attention isEqualToString:@"0"]) {
                           self.attentionButton.backgroundColor = [UIColor colorR:192 colorG:88 colorB:89];
                           [self.attentionButton setTitle:@"+关注" forState:UIControlStateNormal];
                       }else{
                           [self.attentionButton setBackgroundColor:[UIColor colorWithHexString:@"e09292"]];
                           [self.attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
                           
                       }

//
//                       NSNotification *notification =[NSNotification notificationWithName:@"attention" object:nil userInfo:@{@"indexPath":weakSelf.indexPath,@"is_attention":weakSelf.is_attention}];
//                       
//                      
//                       //通过通知中心发送通知
//                       [[NSNotificationCenter defaultCenter] postNotification:notification];
                     
                   } }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   
          
                   NSLog(@"%@",error);
                   
               }
     ];
    
    
}
- (void)backView{

    if (self.delegate&&[self.delegate respondsToSelector:@selector(touxiangdianji:)]) {
        [self.delegate touxiangdianji:self.indexPath];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
