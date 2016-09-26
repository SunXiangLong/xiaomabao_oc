//
//  GoodsTableViewCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 15/11/26.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import "GoodsTableViewCell.h"

@implementation GoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)marice:(id)sender {
    
    
    //数量减1
    NSString *number = self.goodsNumbei.text;
    NSInteger goodNumber = [number integerValue];
    goodNumber--;
    if (goodNumber < 0) {
        [self show:@"退货商品件数最少为0" time:1];
        return;
    }
    self.goodsNumbei.text = [NSString stringWithFormat:@"%ld",goodNumber];
    NSString *row = [NSString stringWithFormat:@"%ld",self.row];
    NSDictionary *reduceNumber = @{@"goodsNumber":self.goodsNumbei.text,@"row":row};
    
    NSNotification *notification =[NSNotification notificationWithName:@"RefundMrice" object:nil userInfo:reduceNumber];
    
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];


}

- (IBAction)add:(id)sender {
    
    //数量减1
    NSString *number = self.goodsNumbei.text;
    NSInteger goodNumber = [number integerValue];
    
    NSInteger goodNumber1 = [self.goodsNumber integerValue];
    goodNumber++;
    if (goodNumber > goodNumber1) {
        [self show:@"退货商品件数不能大于购买件数" time:1];
        return;
    }
    self.goodsNumbei.text = [NSString stringWithFormat:@"%ld",goodNumber];
    
    NSString *row = [NSString stringWithFormat:@"%ld",self.row];
    NSDictionary *reduceNumber = @{@"goodsNumber":self.goodsNumbei.text,@"row":row};
    NSNotification *notification =[NSNotification notificationWithName:@"RefundAdd" object:nil userInfo:reduceNumber];
    
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];

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
