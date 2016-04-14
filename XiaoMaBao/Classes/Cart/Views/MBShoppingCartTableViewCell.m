//
//  MBShoppingCartTableViewCell.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/1.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBShoppingCartTableViewCell.h"
#import "MBNetworking.h"
#import "MBSignaltonTool.h"
@implementation MBShoppingCartTableViewCell
- (void)awakeFromNib {
   
        UIView *view = [[UIView alloc] init];
    
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.equalTo(self.Reduction.mas_left).offset(0);
    
        }];
    
    
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
       
        [view addGestureRecognizer:tap];
    
}
-(void)tap:(UITapGestureRecognizer *)gesture{
    
//    NSString *row = [NSString stringWithFormat:@"%ld",(long)self.row];
//    
//    
//    NSDictionary *reduceNumber = [NSDictionary dictionaryWithObjectsAndKeys:row,@"indexPath", nil];
//    
//    NSNotification *notification = [NSNotification notificationWithName:@"click" object:nil userInfo:reduceNumber];
//    
//    
//    
//    //通过通知中心发送通知
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(click:)]) {
        [self.delegate click:self.row];
    }
    
    
    
}
////选择购物车
//- (IBAction)GoogSelect:(UIButton *)button {
//    if (button.selected) {
//        self.selectImageview.image = [UIImage imageNamed:@"pitch_no"];
//        button.selected = !button.selected;
//
//        //创建通知
//        NSString * goods_number = self.goods_number.text;
//        NSString * rec_id = self.rec_id;
//        
//        NSDictionary *reduceNumber = [NSDictionary dictionaryWithObjectsAndKeys:goods_number,@"goods_number",rec_id,@"rec_id", nil];
//        
//        NSNotification *notification = [NSNotification notificationWithName:@"deselect" object:nil userInfo:reduceNumber];
//        
//        //通过通知中心发送通知
//        [[NSNotificationCenter defaultCenter] postNotification:notification];
//        
//    }else if(!button.selected){
//        self.selectImageview.image = [UIImage imageNamed:@"icon_true"];
//        button.selected = !button.selected;
//        
//        //创建通知
//        NSString * goods_number = self.goods_number.text;
//        NSString * rec_id = self.rec_id;
//        
//        NSDictionary *reduceNumber = [NSDictionary dictionaryWithObjectsAndKeys:goods_number,@"goods_number",rec_id,@"rec_id", nil];
//        
//        NSNotification *notification =[NSNotification notificationWithName:@"select" object:nil userInfo:reduceNumber];
//        
//        //通过通知中心发送通知
//        [[NSNotificationCenter defaultCenter] postNotification:notification];
//    }
//}

////删除购物车
//- (IBAction)DelteCart:(id)sender {
//    
//    
//    [self deleteOrSaveTocollecionWithstr:@"是否删除"];
//     self.deleteOrSaveTag = 0;
//}
//
//#pragma -mark 加入收藏
////收藏购物车物品
//- (IBAction)Savecollect:(id)sender {
//
//   
//    [self deleteOrSaveTocollecionWithstr:@"是否加入收藏"];
//    self.deleteOrSaveTag = 1;
//
//}

//-(void)deleteOrSaveTocollecionWithstr:(NSString *)string
//{
//    UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:self
//                                           cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil ];
//    [alert show];
//}

//数量减1
- (IBAction)reduce:(id)sender {
  
    NSString * selected = self.isSelect;
    
    //数量减1
    NSString *number = self.goods_number.text;
    NSInteger goodNumber = [number integerValue];
    goodNumber--;
    if (goodNumber <= 0) {
        [self.viewController  show:@"商品件数最少为1" time:1];
        return;
    }
    if([self.isSelect isEqualToString:@"0"]){
        self.goods_number.text = [NSString stringWithFormat:@"%ld",goodNumber];
    }
    
    //创建通知
    NSString * goods_number = [NSString stringWithFormat:@"%ld",goodNumber ];
    NSString * rec_id = self.rec_id;
    NSString *row = [NSString stringWithFormat:@"%ld",self.row];
    NSDictionary *reduceNumber = [NSDictionary dictionaryWithObjectsAndKeys:goods_number,@"goods_number",rec_id,@"rec_id", selected,@"selected",row,@"row",nil];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(reduceShop:)]) {
        [self.delegate  reduceShop:reduceNumber];
    }

    
}
//数量加1
- (IBAction)Add:(id)sender {
    
    
        NSString * selected = self.isSelect;
    //数量加1
    NSString *number = self.goods_number.text;
    NSInteger goodNumber = [number integerValue];
    goodNumber++;
    
    if([self.isSelect isEqualToString:@"0"]){
        self.goods_number.text = [NSString stringWithFormat:@"%ld",goodNumber];
    }
    
    //创建通知
    NSString * goods_number = [NSString stringWithFormat:@"%ld",goodNumber];
    NSString * rec_id = self.rec_id;
    
    NSString *row = [NSString stringWithFormat:@"%ld",self.row];
    
    NSDictionary *reduceNumber = [NSDictionary dictionaryWithObjectsAndKeys:goods_number,@"goods_number",rec_id,@"rec_id", selected,@"selected",row,@"row", nil];
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(addShop:)]) {
        [self.delegate  addShop:reduceNumber];
    }


}

-(NSString *)subwitstring:(NSString *)str
{
    NSString *subtotal1 = [str substringFromIndex:1];
    NSString *subtotal2 = [subtotal1 substringToIndex:subtotal1.length-1];
    return subtotal2;
}

-(void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    switch (imageArray.count) {
        case 0:            break;
        case 1:   self.imageView1.image = imageArray[0];         break;
        case 2:   self.imageView1.image= imageArray[0];self.imageView2.image =imageArray[1];       break;
        case 3: self.imageView1.image= imageArray[0];self.imageView2.image =imageArray[1];
            self.imageView3.image=imageArray[2]; break;
        default:self.imageView1.image= imageArray[0];self.imageView2.image =imageArray[1];
            self.imageView3.image=imageArray[2]; self.imageVIew4.image = imageArray[3];
            break;
    }
}

@end
