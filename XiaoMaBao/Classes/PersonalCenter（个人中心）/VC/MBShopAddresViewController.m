//
//  MBShopAddresViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/24.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBShopAddresViewController.h"
#import "MBShopAddressTableViewCell.h"
#import "MBNewAddressViewController.h"
#import "MBConfirmModel.h"
@interface MBShopAddresViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *addAddressButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)NSMutableArray<MBConsigneeModel *> *addressList;
@end
@implementation MBShopAddresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.tableFooterView = [[UIView  alloc ] init];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [self getTheAddress:false];
}
- (IBAction)newaddress:(id)sender {
    MBNewAddressViewController *VC = [[MBNewAddressViewController alloc] init];
    [self pushViewController:VC Animated:YES];
}
- (NSString *)titleStr{
    return @"收货地址";
}
-(void)getTheAddress:(BOOL)isRefresh
{
    if (!isRefresh) {
         [self show];
    }
   
    // 海淀区
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking   POSTOrigin:string(BASE_URL_root, @"/address/address_list") parameters:@{@"session":dict} success:^(id responseObject) {
        [self dismiss];
        _addAddressButton.hidden = false;
        MMLog(@"%@",responseObject);
        if (responseObject[@"status"]&&[responseObject[@"status"] isKindOfClass:[NSDictionary class]]&&[responseObject[@"status"][@"succeed"] integerValue] == 1) {
            _addressList = [[NSArray modelDictionary:responseObject modelKey:@"data" modelClassName:@"MBConsigneeModel"] mutableCopy];
            
            [_tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败" time:1];
    }];
    
}
- (void)deleteTheAddressInterface:(MBConsigneeModel *)model{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [self show];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/address/address_delete"] parameters:@{@"session":sessiondict,@"address_id":model.address_id} success:^(NSURLSessionDataTask *operation, id responseObject) {
        [self dismiss];
        if( [[responseObject valueForKey:@"status"][@"succeed"]isEqualToNumber:@1]){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_addressList indexOfObject:model] inSection:0];
            [_addressList removeObject:model];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败" time:1];
        MMLog(@"失败");
    }];
    
}
- (void)setTheDefaultAddress:(MBConsigneeModel *)model{

    //设置默认
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking  POSTOrigin:string(BASE_URL_root, @"/address/set_default_address") parameters:@{@"session":dict,@"address_id":model.address_id} success:^(id responseObject) {
        MBConsigneeModel * __block oldModel = nil;
        if ([responseObject[@"status"][@"succeed"] integerValue] == 1) {
            [_addressList enumerateObjectsUsingBlock:^(MBConsigneeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.is_default intValue] == 1) {
                    obj.is_default = @"0";
                    oldModel = obj;
                }
            }];
            model.is_default = @"1";
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_addressList indexOfObject:model] inSection:0];
            if (oldModel) {
                 NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:[_addressList indexOfObject:oldModel] inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath,oldIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }else{
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
           
            
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败" time:1];
    }];
 
}
- (void)deleteTheAddress:(MBConsigneeModel *)model{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否确定删除该地址？"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                   
                                                        handler:^(UIAlertAction * action) {}];
    UIAlertAction* fromPhotoAction = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDestructive                                                                handler:^(UIAlertAction * action) {
        
        [self deleteTheAddressInterface:model];
        
    }];
    [alertController addAction:fromPhotoAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _addressList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 116;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MBShopAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBShopAddressTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBShopAddressTableViewCell" owner:nil options:nil]firstObject];
    }
    cell.model = _addressList[indexPath.row];
    cell.editAddress = ^(MBConsigneeModel *model, MBEditTheAddressType type) {
        switch (type) {
            case 0:{
                MBNewAddressViewController *VC = [[MBNewAddressViewController alloc] init];
                VC.model = model;
                VC.title  = @"编辑收货地址";
                [self pushViewController:VC Animated:YES];
            }break;
            case 1:{
                [self deleteTheAddress:model];
            }break;
            case 2:{
                [self setTheDefaultAddress:model];
            }break;
            default:break;
        }
    };
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_isPersonalCenter) {
        [self popViewControllerAnimated:YES];
        self.changeAddress(_addressList[indexPath.row]);
    }
}

@end
