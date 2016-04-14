//
//  MBAddressListController.m
//  XiaoMaBao
//
//  Created by 朱理哲 on 15/8/29.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//
#define kCellIdentifier @"MBAddressListController"
#import "MBAddressListController.h"
#import "MobClick.h"
@interface MBAddressListController()<UITableViewDataSource,UITableViewDelegate>{
}

@property(weak,nonatomic)UITableView* tableView ;
@property(strong,nonatomic) NSMutableArray* cityLists ;

@property(strong,nonatomic) NSString* name ;
@property(nonatomic) NSInteger provinceId ;
@property(nonatomic) NSInteger cityId ;

@property(nonatomic) NSInteger level;

@end

@implementation MBAddressListController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBAddressListController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBAddressListController"];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    

    UITableView* tableView = [[UITableView alloc]init];
    tableView.frame = CGRectMake(0, TOP_Y, [self screenWidth], [self screenHeight]-44);
    tableView.delegate = self ;
    tableView.dataSource = self ;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    self.tableView = tableView ;
    [self.view addSubview:self.tableView];
    self.level= 0;
    [self getCityList:@"1"];
}

-(NSMutableArray *)cityLists{
    if (_cityLists == nil) {
        _cityLists = [NSMutableArray array];
    }
    return _cityLists ;
}

#pragma mark - 获取item菜单
-(void)getCityList:(NSString *)parent_id
{
    
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"region"] parameters:@{@"parent_id":parent_id} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject != nil) {
            NSDictionary* d = [responseObject valueForKeyPath:@"data"];
            self.cityLists = d[@"regions"];
        }
        
        [self.tableView reloadData];
        self.level++;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _cityLists.count ;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    NSDictionary* city = self.cityLists[indexPath.row];
    cell.textLabel.text = city[@"name"];
    return cell ;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * city = self.cityLists[indexPath.row];
    if(self.level > 2){
        //三级菜单
        NSString * name = [NSString stringWithFormat:@"%@-%@",self.name,city[@"name"]];
        if (self.cityBlock) {
            self.cityBlock(name,self.provinceId,self.cityId,[city[@"id"] integerValue]);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if(self.level > 1){
        //二级菜单
        NSString * name = [NSString stringWithFormat:@"%@-%@",self.name,city[@"name"]];
        self.name = name;
        self.cityId = [city[@"id"] integerValue];
        
        [self getCityList:city[@"id"]];
    }else{
        //一级菜单
        self.name = city[@"name"];
        self.provinceId = [city[@"id"] integerValue];
        
        [self getCityList:city[@"id"]];
    }
    
}

- (NSString *)titleStr{
    return @"地区选择";
}


@end
