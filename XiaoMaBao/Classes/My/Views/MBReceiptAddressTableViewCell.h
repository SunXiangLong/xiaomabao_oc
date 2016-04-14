//
//  MBReceiptAddressTableViewCell.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/11.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBReceiptAddressTableViewCell : UITableViewCell
@property (assign,nonatomic) BOOL isDefault;
@property (weak, nonatomic) IBOutlet UILabel *consigneeName;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *mobile;
- (IBAction)setDefault:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *DefaultButton;


- (IBAction)deleteAddress:(id)sender;
@property(nonatomic,copy)NSString *address_id;
@property(nonatomic,assign)NSInteger cellIndex;
//收货人
@property(nonatomic,copy)NSString *consignee;
//手机
@property(nonatomic,copy)NSString *mymobile;
//省份
@property(nonatomic,copy)NSString *province_name;
//城市
@property(nonatomic,copy)NSString *city_name;
//县
@property(nonatomic,copy)NSString *district_name;
//地址
@property(nonatomic,copy)NSString *myaddress;



@end
