//
//  MBShoppingCartTableViewCell.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/1.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BkBaseViewController.h"
@protocol MBShoppingCartTableViewdelegate<NSObject>
- (void)click:(NSInteger)row;
- (void)addShop:(NSDictionary *)dic;
- (void)reduceShop:(NSDictionary *)dic;
@end
@interface MBShoppingCartTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageVIew4;
@property (weak, nonatomic) IBOutlet UIImageView *Carimageview;
@property (weak, nonatomic) IBOutlet UILabel *GoodsDescribe;
@property (weak, nonatomic) IBOutlet UILabel *Goods_price;
@property (weak, nonatomic) IBOutlet UILabel *Market_Price;
@property (weak, nonatomic) IBOutlet UILabel *goods_number;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageview;
@property(strong,nonatomic)NSString *goodID;
@property(strong,nonatomic)NSString *rec_id;
@property(strong,nonatomic)NSString * isSelect;
@property(weak,nonatomic)BkBaseViewController * viewController;
@property (weak, nonatomic) IBOutlet UIButton *Reduction;

@property (weak, nonatomic) IBOutlet UIView *maskView;

@property(assign,nonatomic)NSInteger row;
@property(weak,nonatomic)id<MBShoppingCartTableViewdelegate>delegate;
@property(assign,nonatomic)int deleteOrSaveTag;
- (IBAction)reduce:(id)sender;
- (IBAction)Add:(id)sender;
@property (nonatomic,strong) NSArray *imageArray;
@property(copy,nonatomic)NSDictionary *dataDic;
@end
