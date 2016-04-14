//
//  MBAddAddressViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/12.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//
#define kMargin 12
#import "MBAddAddressViewController.h"
#import "MBSignaltonTool.h"
#import "MBNetworking.h"
#import "PureLayout.h"
#import "MBAddressListController.h"
#import "MobClick.h"
@interface AddressCell:UIControl{
    //title
    
    //content
    
}
@property(weak,nonatomic) UILabel* cellTitle;
@property(weak,nonatomic) UILabel* labelClick;
@property(weak,nonatomic) UITextField* cellContentView;
@property(weak,nonatomic) UIView* line;

@property(assign,nonatomic) BOOL didUpdateConstraints;
@property(assign,nonatomic) BOOL isOneLabelButton;
@property(nonatomic,strong)NSString *str;
@end

@implementation AddressCell

-(instancetype)initWithTitle:(NSString*)title {
    if (self = [super init]) {
        UILabel* labelTitle = [UILabel newAutoLayoutView];
        labelTitle.font = [UIFont systemFontOfSize:18.0f];
        labelTitle.text = title ;
        labelTitle.textAlignment =  NSTextAlignmentCenter;
        labelTitle.textColor = [UIColor colorWithHexString:@"2ba390"];
        self.cellTitle = labelTitle ;
        self.isOneLabelButton = YES;
        [self addSubview:labelTitle];
        
        UIView* line = [UIView new];
        line.backgroundColor = [UIColor lightGrayColor];
        line.alpha = 0.1 ;
        self.line = line ;
        [self addSubview:line];
        
        [self updateConstraints];
    }
    return self ;
}

-(instancetype)initWithTitle:(NSString*)title content:(NSString*)content canClick:(BOOL)click{
    if (self = [super init]) {
        UILabel* labelTitle = [UILabel newAutoLayoutView];
        labelTitle.font = [UIFont systemFontOfSize:14.0f];
        labelTitle.text = title ;
        self.cellTitle = labelTitle ;
        [self addSubview:labelTitle];
    
        if (click) {
            UILabel* labelClick = [UILabel new];
            labelClick.font = [UIFont systemFontOfSize:12.0f];
            labelClick.text = content ;
            self.labelClick = labelClick ;
            [self addSubview:labelClick];
            
        }
        else{
            UITextField* contentView = [UITextField new];
            contentView.font = [UIFont systemFontOfSize:12.0f];
            contentView.placeholder = content ;
            self.cellContentView = contentView ;
            [self addSubview:contentView];
        }
        
    
        
        UIView* line = [UIView new];
        line.backgroundColor = [UIColor lightGrayColor];
        line.alpha = 0.1 ;
        self.line = line ;
        [self addSubview:line];
        
        [self updateConstraints];
    }
    return self ;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    if(!self.isOneLabelButton){
        CGRect frame = self.frame ;
        self.cellTitle.frame = CGRectMake(kMargin, 0, 68, frame.size.height-1);
        self.cellContentView.frame = CGRectMake(CGRectGetMaxX(self.cellTitle.frame), 0,frame.size.width - 68 - kMargin, frame.size.height-1);
        self.labelClick.frame = CGRectMake(CGRectGetMaxX(self.cellTitle.frame), 0,frame.size.width - 68 - kMargin, frame.size.height-1);
        self.line.frame = CGRectMake(0, frame.size.height - 1, frame.size.width ,1);
    }else{
        CGRect frame = self.frame ;
        self.cellTitle.frame = CGRectMake(0, 0, frame.size.width-1, frame.size.height-1);
        self.line.frame = CGRectMake(0, frame.size.height - 1, frame.size.width ,1);
    }
    
}

@end

@interface MBAddAddressViewController ()
@property(nonatomic,strong)NSMutableArray *MyfieldArray;
@property(weak,nonatomic) AddressCell* cellConsignee ;
@property(weak,nonatomic) AddressCell* cellPhone ;
@property(weak,nonatomic) AddressCell* cellAddr ;
@property(weak,nonatomic) AddressCell* cellAddrDetail ;
@property(weak,nonatomic) AddressCell* buttonDefault ;
@property(weak,nonatomic) AddressCell* buttonSave ;



@end

@implementation MBAddAddressViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBAddAddressViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBAddAddressViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _MyfieldArray = [NSMutableArray array];

    self.view.backgroundColor = [UIColor whiteColor];
  
//    收货人
    AddressCell* cellConsignee = [[AddressCell alloc]initWithTitle:@"收 货 人:" content:@"收货人" canClick:NO];
    cellConsignee.frame = CGRectMake(0, TOP_Y, [self screenWidth], 44);
    cellConsignee.cellContentView.text = _infoArray[0];
    self.cellConsignee = cellConsignee ;
    [self.view addSubview:cellConsignee];
    
//    手机号码
    AddressCell* cellPhone = [[AddressCell alloc]initWithTitle:@"手机号码:" content:@"手机号" canClick:NO];
    cellPhone.cellContentView.keyboardType = UIKeyboardTypePhonePad ;
    cellPhone.frame = CGRectMake(0, CGRectGetMaxY(cellConsignee.frame)+1, [self screenWidth], 44);
    cellPhone.cellContentView.text = _infoArray[1];
    self.cellPhone = cellPhone ;
    [self.view addSubview:cellPhone];
    
//    所在地址
    AddressCell* cellAddr = [[AddressCell alloc]initWithTitle:@"所在地址:" content:@"选择所在地址" canClick:NO];
    cellAddr.cellContentView.enabled = NO ;
    cellAddr.frame = CGRectMake(0, CGRectGetMaxY(cellPhone.frame)+1, [self screenWidth], 44);
    cellAddr.labelClick.text = _infoArray[2];
    [cellAddr addTarget:self action:@selector(cityList) forControlEvents:UIControlEventTouchUpInside];
    self.cellAddr = cellAddr ;

    [self.view addSubview:cellAddr];
//    详细信息
    AddressCell* cellAddrDetail = [[AddressCell alloc]initWithTitle:@"详细地址:" content:@"输入详细地址" canClick:NO];
    cellAddrDetail.frame = CGRectMake(0, CGRectGetMaxY(cellAddr.frame)+1, [self screenWidth], 44);
    cellAddrDetail.cellContentView.text = _infoArray[3];
    self.cellAddrDetail = cellAddrDetail ;
    [self.view addSubview:cellAddrDetail];
    
    //设置默认并保存
    AddressCell* buttonDefault = [[AddressCell alloc]initWithTitle:@"设为默认并保存"];
    buttonDefault.frame = CGRectMake(0, CGRectGetMaxY(cellAddrDetail.frame)+1, [self screenWidth], 44);
    self.buttonDefault = buttonDefault ;
    [_buttonDefault addTarget:self action:@selector(settingDefaultSave) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonDefault];
    
    //保存
    AddressCell* buttonSave = [[AddressCell alloc]initWithTitle:@"保存"];
    buttonSave.frame = CGRectMake(0, CGRectGetMaxY(buttonDefault.frame)+1, [self screenWidth], 44);
    self.buttonSave = buttonSave ;
    [_buttonSave addTarget:self action:@selector(settingSave) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonSave];
}


#pragma mark - 选择地址
-(void)cityList{
    MBAddressListController* list = [[MBAddressListController alloc]init];
    
    list.cityBlock = ^(NSString* cityName,NSInteger provinceId,NSInteger cityId,NSInteger districtId){
        self.cellAddr.cellContentView.text = cityName;
        self.cityId = cityId;
        self.provinceId = provinceId;
        self.districtId = districtId;
    };
    
    [self.navigationController pushViewController:list animated:YES];
}

- (NSString *)titleStr{
    if (self.TheTitle) {
        return self.TheTitle;
    }else{
        return @"添加收获地址";
    }
}

//设置默认保存
-(void)settingDefaultSave{
    
    
    NSLog(@"设置默认保存");
    [self save:YES];
}

//设置保存
-(void)settingSave{
    NSLog(@"设置保存");
    [self save:NO];
}

- (void)save:(BOOL)isDefault{
    
    
   
    
    
    if ([self.TheTitle isEqualToString:@"编辑收货地址"]) {
        

        [self addaddressOrupdateAddressWithUrl:@"address/update" isDefault:isDefault];
    }else{
        [self addaddressOrupdateAddressWithUrl:@"address/add"  isDefault:isDefault];
    }
}

//设置默认收货地址
-(void)setDefault
{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"address/setDefault"] parameters:@{@"session":sessiondict,@"address_id":@""}
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
            NSLog(@"成功---responseObject%@",[responseObject valueForKeyPath:@"data"]);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteAddress" object:nil userInfo:nil];
        
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"失败");
        }
    ];
    
}

//添加收货地址
-(void)addaddressOrupdateAddressWithUrl:(NSString *)url isDefault:(BOOL)isDefault
{

   
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
   
    
    if (self.cellConsignee.cellContentView.text.length<1) {
        [self show:@"请输入收货人姓名" time:1];
        return;
    }
    if (self.cellPhone.cellContentView.text.length<1) {
        [self show:@"请输入手机号码" time:1];
        return;
    }
    if (self.provinceId&&self.cityId&&self.districtId) {}else{
        [self show:@"请选择所在地地址" time:1];
        return;
    }
    if (self.cellAddrDetail.cellContentView.text.length<1) {
        [self show:@"请输入详细地址" time:1];
        return;
    }
    
    NSDictionary *addressDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                 self.cellConsignee.cellContentView.text,@"consignee",
                                 @"1",@"country",
                                 [NSString stringWithFormat:@"%ld",self.provinceId ],@"province",
                                 [NSString stringWithFormat:@"%ld",self.cityId ],@"city",
                                 [NSString stringWithFormat:@"%ld",self.districtId ],@"district",
                                 self.cellAddr.cellContentView.text,@"district_name",
                                 self.cellAddrDetail.cellContentView.text,@"address",
                                 self.cellPhone.cellContentView.text,@"mobile",
                                 (isDefault?@"1":@"0"),@"default_address",nil];
   
  
  
    
    //更新收货地址
    if ([url isEqualToString:@"address/update"]) {
        [self show:@"正在更新..."];
        [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"address/update"] parameters:@{@"session":sessiondict,@"address_id":self.address_id,@"address":addressDict}
         
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
               NSLog(@"成功---responseObject%@",[responseObject valueForKeyPath:@"data"]);
               
               if ([addressDict[@"default_address"] isEqualToString:@"1"]) {
                   
                   [self moren];
                   
               }else{
                  [self show:@"修改成功" time:1];
                   //刷新数据
                   [self.navigationController popViewControllerAnimated:YES];
                   [[NSNotificationCenter defaultCenter] postNotificationName:@"AddOrUpdateAddress" object:nil userInfo:nil];
               }
          
               
               
            
            
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               NSLog(@"失败");
               [self show:@"请求失败" time:1];
           }
        ];

    }
    //添加收货地址
    else if ([url isEqualToString:@"address/add"]){
        [self show:@"正在添加..." time:1];
        [MBNetworking  POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"address/add"] parameters:@{@"session":sessiondict,@"address":addressDict}
         
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
                NSLog(@"成功---responseObject%@",[responseObject valueForKeyPath:@"data"]);
                NSLog(@"成功状态---responseObject%@",[responseObject valueForKeyPath:@"status"]);
                [self show:@"添加成功"time:1];
                //刷新数据
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AddOrUpdateAddress" object:nil userInfo:nil];
            

            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"失败");
                [self show:@"请求失败" time:1];
            }
        ];
    }
    
}
-(void)moren{

    //设置默认
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"address/setDefault"] parameters:@{@"session":dict,@"address_id":self.address_id} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"成功---responseObject%@",responseObject);
        
        //刷新数据
        [self show:@"修改成功" time:1];
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddOrUpdateAddress" object:nil userInfo:nil];
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
        [self show:@"请求失败" time:1];
    }];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

 [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)to:nil from:nil forEvent:nil];

}
@end
