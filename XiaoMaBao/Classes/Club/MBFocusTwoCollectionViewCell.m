//
//  MBFocusTwoCollectionViewCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBFocusTwoCollectionViewCell.h"
#import "MBPersonalCanulaCircleViewController.h"

@implementation MBFocusTwoCollectionViewCell

- (void)awakeFromNib {
    self.userImageview.userInteractionEnabled = YES;
    [self.userImageview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backView)]];
    
    
}
- (void)backView{
    MBPersonalCanulaCircleViewController *VC = [[MBPersonalCanulaCircleViewController alloc] init];
    VC.user_id = self.user_id;
    [self.VC pushViewController:VC Animated:YES];
    
}
-(void)setprase:(NSArray *)prase{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dic in prase) {
        [arr addObject:dic[@"praise_avatar"]];
    }
    MBLevelDisplayImagesView *view = [[MBLevelDisplayImagesView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH-30, 20)];
    view.urlImageArray  =  arr  ;
    [self.bottomImageView addSubview:view];
    
}
- (IBAction)fenxiang:(UIButton *)sender {
}

- (IBAction)pinglun:(UIButton *)sender {
}

- (IBAction)praiseButton:(UIButton *)sender {
    [self setFocus:sender];
}
#pragma mark -- 点赞
- (void)setFocus:(UIButton *)sender{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/communicate/praise"];
    if (! sid) {
        return;
    }
    __unsafe_unretained __typeof(self) weakSelf = self;
    [MBNetworking POST:url parameters:@{@"session":sessiondict,@"talk_id":self.talk_id}
               success:^(AFHTTPRequestOperation *operation, MBModel *responseObject) {
                   
                   NSLog(@"%@",responseObject.data);
                   
                   
                   if(1 == [[responseObject valueForKey:@"status"]  intValue]){
                       
                       if ([self.is_praise isEqualToString:@"0"]) {
                           weakSelf.is_praise = @"1";
                       }else{
                           weakSelf.is_praise = @"0";
                       }
                       
                       
                       NSNotification *notification =[NSNotification notificationWithName:@"is_attention" object:nil userInfo:@{@"indexPath":weakSelf.indexPath,@"is_praise":weakSelf.is_praise}];
                       
                       [sender setSelected:!sender.isSelected];
                       //通过通知中心发送通知
                       [[NSNotificationCenter defaultCenter] postNotification:notification];
                       
                   }
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   
                   
                   NSLog(@"%@",error);
                   
               }
     ];
    
    
}
@end
