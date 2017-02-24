//
//  MBNewAddressViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/24.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBNewAddressViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <ContactsUI/ContactsUI.h>
#import <ContactsUI/ContactsUI.h>
@interface MBNewAddressViewController ()<UIPickerViewDataSource, UIPickerViewDelegate,ABPeoplePickerNavigationControllerDelegate,CNContactPickerDelegate>
{
    //省市区ID
    NSString *_provinceID;
    NSString *_cityID;
    NSString *_districtID;
    
    NSInteger _levels;
    NSInteger _level;
}
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *xiangxiAddress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet UITextField *photo;


@property (strong, nonatomic) IBOutlet UIPickerView *myPicker;
@property (strong, nonatomic) IBOutlet UIView *pickerBgView;
@property (strong, nonatomic) UIView *maskView;
//data
@property (strong, nonatomic) NSDictionary *pickerDic;
@property (strong, nonatomic) NSArray *provinceArray;
@property (strong, nonatomic) NSArray *cityArray;
@property (strong, nonatomic) NSArray *townArray;
@property (strong, nonatomic) NSArray *selectedArray;
@end

@implementation MBNewAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getCityList:@"1"];
    _provinceID = _address_dic[@"province"];
    _cityID = _address_dic[@"city"];
    _districtID = _address_dic[@"district"];
    self.bottom.constant = UISCREEN_HEIGHT-TOP_Y;
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT)];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyPicker)]];
    self.pickerBgView.ml_width = UISCREEN_WIDTH;
    if (self.address_dic) {
        _name.text = self.address_dic[@"consignee"];
        _photo.text = self.address_dic[@"mobile"];
        _address.text = [NSString stringWithFormat:@"%@-%@-%@",self.address_dic[@"province_name"],self.address_dic[@"city_name"],self.address_dic[@"district_name"]];
        _xiangxiAddress.text = self.address_dic[@"address"];
    }
}
#pragma mark -- 选着通讯录联系人
- (IBAction)selectTheContact:(id)sender {
    
    if (!iOS_9) {
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        //判断授权状态
        
        if (status == kABAuthorizationStatusNotDetermined) {
            
            ABAddressBookRef book = ABAddressBookCreateWithOptions(NULL, NULL);
            
            ABAddressBookRequestAccessWithCompletion(book, ^(bool granted, CFErrorRef error) {
                
                if (granted) {
                    //查找所有联系人
                    [self selectTheContact];
                }else
                {
                    MMLog(@"授权失败");
                }
            });
        }else if (status == kABAuthorizationStatusAuthorized)
        {
            //已授权
            [self selectTheContact];
        }

    }else{
    
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        //判断授权状态
        
        if (status == CNAuthorizationStatusNotDetermined) {
            
            CNContactStore *book = [[CNContactStore alloc] init];
            [book requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                
                if (granted) {
                    //查找所有联系人
                    [self selectTheContact];
                }else
                {
                    [self show:@"授权失败" time:1];
                
                }
            }];
            
        }else if (status == CNAuthorizationStatusAuthorized)
        {
            //已授权
            [self selectTheContact];
        }else if(status == CNAuthorizationStatusDenied){
        
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                     message:@"请前往－设置－隐私－通讯录设置"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                           
                                                                 handler:^(UIAlertAction * action) {}];
            
            
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];

        }

    
    }
    
    
}
- (void)selectTheContact{
    if (iOS_9) {
        
        // 1.创建选择联系人的控制器
        CNContactPickerViewController *contactVc = [[CNContactPickerViewController alloc] init];
        
        // 2.设置代理
        contactVc.delegate = self;
        
        // 3.弹出控制器
        [self presentViewController:contactVc animated:YES completion:nil];
    }else{
        
        // 1.创建选择联系人的控制器
        ABPeoplePickerNavigationController *ppnc = [[ABPeoplePickerNavigationController alloc] init];
        
        // 2.设置代理
        ppnc.peoplePickerDelegate = self;
        
        // 3.弹出控制器
        [self presentViewController:ppnc animated:YES completion:nil];
        
    }


}
#pragma mark -- 省市联动取消
- (IBAction)Cancel:(id)sender {
    [self hideMyPicker];
}
#pragma mark -- 省市联动确定
- (IBAction)determine:(id)sender {
    
    NSString *sheng  = [self.provinceArray objectAtIndex:[self.myPicker selectedRowInComponent:0]][@"name"];
    _provinceID =  [self.provinceArray objectAtIndex:[self.myPicker selectedRowInComponent:0]][@"id"];
    
    
    NSString *shi = [self.cityArray objectAtIndex:[self.myPicker selectedRowInComponent:1]][@"name"];
    _cityID = [self.cityArray objectAtIndex:[self.myPicker selectedRowInComponent:1]][@"id"];
    
    
    NSString *qu =  [self.townArray objectAtIndex:[self.myPicker selectedRowInComponent:2]][@"name"];
    _districtID = [self.townArray objectAtIndex:[self.myPicker selectedRowInComponent:2]][@"id"];
    NSString *str = [NSString stringWithFormat:@"%@-%@-%@",sheng,shi,qu];
    self.address.text = str;
    
    
    
    
    [self hideMyPicker];
    
}
#pragma mark -- 隐藏pickView
- (void)hideMyPicker {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        self.pickerBgView.ml_y = self.view.ml_height;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.pickerBgView removeFromSuperview];
    }];
}
- (IBAction)selectAddress:(id)sender {
    
    [_name resignFirstResponder];
    [_photo resignFirstResponder];
    [_xiangxiAddress resignFirstResponder];
    
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.pickerBgView];
    self.maskView.alpha = 0;
    self.pickerBgView.ml_y = self.view.ml_height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.3;
        self.pickerBgView.ml_y = self.pickerBgView.ml_y -self.pickerBgView.ml_height;
    }];

}

#pragma mark --请求三级联动数据
-(void)getCityList:(NSString *)parent_id
{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/address/get_regions"] parameters:@{@"parent_id":parent_id,@"session":dict} success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        
        if (responseObject != nil) {
            NSDictionary* d = [responseObject valueForKeyPath:@"data"];
            
            if (_level == 0 ){
                _provinceArray = d[@"regions"];
                [self getCityList:_provinceArray[0][@"id"]];
                
                
            }else if(_level == 1){
                _cityArray = nil;
                _cityArray = d[@"regions"];
                
                [self getCityList:_cityArray[0][@"id"]];
                
                [_myPicker  reloadComponent:1];
                [_myPicker selectedRowInComponent:1];
                [_myPicker selectedRowInComponent:2];
                
            }else {
                _townArray = nil;
                _townArray = d[@"regions"];
                [_myPicker  reloadComponent:2];
                [_myPicker selectRow:0 inComponent:2 animated:YES];
                
                return ;
            }
            
            
            _level ++;
        }
        
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        
    }];
    
}
- (NSString *)titleStr{

    return self.title?:@"添加收货地址";
}
-(NSString *)rightStr{
    
    return @"保存";
}
-(void)rightTitleClick{
    if ([self.title isEqualToString:@"编辑收货地址"]) {
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"编辑收货地址？"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                       
                                                             handler:^(UIAlertAction * action) {}];
        UIAlertAction* fromPhotoAction = [UIAlertAction actionWithTitle:@"删除该地址" style:UIAlertActionStyleDestructive                                                                 handler:^(UIAlertAction * action) {
           [self delete];
            
        }];
        UIAlertAction* fromPhotoAction1 = [UIAlertAction actionWithTitle:@"保存修改地址" style:UIAlertActionStyleDestructive                                                                 handler:^(UIAlertAction * action) {
            [self settingSave];
            
        }];
        UIAlertAction* fromPhotoAction2 = [UIAlertAction actionWithTitle:@"保存修改并设为默认收货地址" style:UIAlertActionStyleDestructive                                                                 handler:^(UIAlertAction * action) {
            [self settingDefaultSave];
            
        }];
        [alertController addAction:fromPhotoAction];
        [alertController addAction:cancelAction];
         [alertController addAction:fromPhotoAction1];
        [alertController addAction:fromPhotoAction2];

        [self presentViewController:alertController animated:YES completion:nil];

    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"保存收货地址"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                       
                                                             handler:^(UIAlertAction * action) {}];
        UIAlertAction* fromPhotoAction = [UIAlertAction actionWithTitle:@"保存地址" style:UIAlertActionStyleDestructive                                                                 handler:^(UIAlertAction * action) {
                    [self settingSave];
            
        }];
        UIAlertAction* fromPhotoAction1 = [UIAlertAction actionWithTitle:@"设为默认地址并保存" style:UIAlertActionStyleDestructive                                                                 handler:^(UIAlertAction * action) {
                    [self settingDefaultSave];
            
        }];

        [alertController addAction:cancelAction];
        [alertController addAction:fromPhotoAction];
         [alertController addAction:fromPhotoAction1];
        [self presentViewController:alertController animated:YES completion:nil];
    
    
    }
}

//设置默认保存
-(void)settingDefaultSave{
    [self save:YES];
}

//设置保存
-(void)settingSave{
   
    [self save:NO];
}

- (void)save:(BOOL)isDefault{
    if ([self.title isEqualToString:@"编辑收货地址"]) {
        
        [self addaddressOrupdateAddressWithUrl:@"/address/address_edit" isDefault:isDefault];
        
    }else{
        [self addaddressOrupdateAddressWithUrl:@"/address/address_add"  isDefault:isDefault];
    }
}



//添加收货地址
-(void)addaddressOrupdateAddressWithUrl:(NSString *)url isDefault:(BOOL)isDefault
{
    
    
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];

    if (self.name.text.length<1) {
        [self show:@"请输入收货人姓名" time:1];
        return;
    }
    if (self.photo.text.length<1) {
        [self show:@"请输入手机号码" time:1];
        return;
    }
    if (_provinceID&&_cityID&&_districtID) {}else{
        [self show:@"请选择所在地地址" time:1];
        return;
    }
    if (self.xiangxiAddress.text.length<1) {
        [self show:@"请输入详细地址" time:1];
        return;
    }

    NSDictionary *addressDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                 self.name.text,@"consignee",
                                 @"1",@"country",
                                 [NSString stringWithFormat:@"%@",_provinceID],@"province",
                                 [NSString stringWithFormat:@"%@",_cityID ],@"city",
                                 [NSString stringWithFormat:@"%@",_districtID ],@"district",
                                 self.xiangxiAddress.text,@"address",
                                 self.photo.text,@"mobile",
                                 (isDefault?@"1":@"0"),@"default_address",nil];
    
    
    
    
    //更新收货地址
    if ([url isEqualToString:@"/address/address_edit"]) {
        [self show:@"正在更新..."];
        [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/address/address_edit"] parameters:@{@"session":sessiondict,@"address_id":self.address_dic[@"address_id"],@"address":addressDict}
                   success:^(NSURLSessionDataTask *operation, id responseObject) {
                       [self dismiss];
//                       MMLog(@"成功---responseObject%@",[responseObject valueForKeyPath:@"data"]);
                       
                       if ([addressDict[@"default_address"] isEqualToString:@"1"]) {
                           
                           [self setDefault];
                           
                       }else{
                          
                           //刷新数据
                           [self popViewControllerAnimated:YES];
                           
                       }
                       
                   }
                   failure:^(NSURLSessionDataTask *operation, NSError *error) {
                       MMLog(@"%@",error);
                       [self show:@"请求失败" time:1];
                   }
         ];
        
    }
    //添加收货地址
    else if ([url isEqualToString:@"/address/address_add"]){
//        [self show:@"正在添加..." time:1];
        [MBNetworking  POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/address/address_add"] parameters:@{@"session":sessiondict,@"address":addressDict}
         
                    success:^(NSURLSessionDataTask *operation, id responseObject) {
                        
                        
                        //刷新数据
                        [self popViewControllerAnimated:YES];
                        
                        
                        
                    }
                    failure:^(NSURLSessionDataTask *operation, NSError *error) {
                        MMLog(@"失败");
                        [self show:@"请求失败" time:1];
                    }
         ];
    }
    
}
- (void)delete{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    MMLog(@"%@",self.address_dic);
    
    
    
    [self show];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/address/address_delete"] parameters:@{@"session":sessiondict,@"address_id":self.address_dic[@"address_id"]} success:^(NSURLSessionDataTask *operation, id responseObject) {
        [self dismiss];
        if( [[responseObject valueForKey:@"status"][@"succeed"]isEqualToNumber:@1]){
            
            
            [self popViewControllerAnimated:YES];
        }
        
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"失败");
    }];
    
}
//设置默认收货地址
-(void)setDefault{
    
    //设置默认
    
    
    //设置默认
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/address/set_default_address"] parameters:@{@"session":dict,@"address_id":self.address_dic[@"address_id"]} success:^(NSURLSessionDataTask *operation, id responseObject) {
        if( [[responseObject valueForKey:@"status"][@"succeed"]isEqualToNumber:@1]){
            
            
            //刷新数据
            [self show:@"修改成功" time:1];
            [self popViewControllerAnimated:YES];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
    }];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray.count;
    } else if (component == 1) {
        return self.cityArray.count;
    } else {
        return self.townArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    
    
    if (component == 0) {
        return [self.provinceArray objectAtIndex:row][@"name"];
    } else if (component == 1) {
        return [self.cityArray objectAtIndex:row][@"name"];
    } else {
        return [self.townArray objectAtIndex:row][@"name"];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 110;
    } else if (component == 1) {
        return 100;
    } else {
        return 110;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
    if (component == 0) {
        _level = 1;
        
        
        NSString *str = _provinceArray[row][@"id"];
        if (self.provinceArray.count > 0) {
            [self getCityList:str];
            
        }
    }
    
    
    
    
    if (component == 1) {
        _level = 2;
        if (self.provinceArray.count > 0 && self.cityArray.count > 0) {
            NSString *str = _cityArray[row][@"id"];
            [self getCityList:str];
        } else {
            self.townArray = nil;
        }
        
    }
    
    
}


#pragma mark - <ABPeoplePickerNavigationControllerDelegate>
// 当用户选中某一个联系人时会执行该方法,并且选中联系人后会直接退出控制器
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
    // 1.获取选中联系人的姓名
    CFStringRef lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
    CFStringRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    
    // (__bridge NSString *) : 将对象交给Foundation框架的引用来使用,但是内存不交给它来管理
    // (__bridge_transfer NSString *) : 将对象所有权直接交给Foundation框架的应用,并且内存也交给它来管理
    NSString *lastname = (__bridge_transfer NSString *)(lastName);
    NSString *firstname = (__bridge_transfer NSString *)(firstName);
    

      _name.text = [NSString stringWithFormat:@"%@%@",lastname,firstname];
    // 2.获取选中联系人的电话号码
    // 2.1.获取所有的电话号码
    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
//    CFIndex phoneCount = ABMultiValueGetCount(phones);
     NSString *phoneValue = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, 0);
    _photo.text = phoneValue;
    
    // 2.2.遍历拿到每一个电话号码
//    for (int i = 0; i < phoneCount; i++) {
//        // 2.2.1.获取电话对应的key
//        NSString *phoneLabel = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
//        
//        // 2.2.2.获取电话号码
//        NSString *phoneValue = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
//        
//        MMLog(@"%@ %@", phoneLabel, phoneValue);
//    }
//    
    // 注意:管理内存
    CFRelease(phones);
}

// 当用户选中某一个联系人的某一个属性时会执行该方法,并且选中属性后会退出控制器
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    MMLog(@"%s", __func__);
}

#pragma mark - <CNContactPickerDelegate>
// 当选中某一个联系人时会执行该方法
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
    // 1.获取联系人的姓名
    NSString *lastname = contact.familyName;
    NSString *firstname = contact.givenName;
   
    _name.text = [NSString stringWithFormat:@"%@%@",lastname,firstname];
    // 2.获取联系人的电话号码
    NSArray *phoneNums = contact.phoneNumbers;
    CNLabeledValue *labeledValue = phoneNums.firstObject;
    // 2.2.获取电话号码
    CNPhoneNumber *phoneNumer = labeledValue.value;
    NSString *phoneValue = phoneNumer.stringValue;
    _photo.text = phoneValue;
    
    
//    for (CNLabeledValue *labeledValue in phoneNums) {
//        // 2.1.获取电话号码的KEY
//        NSString *phoneLabel = labeledValue.label;
//        
//        // 2.2.获取电话号码
//        CNPhoneNumber *phoneNumer = labeledValue.value;
//        NSString *phoneValue = phoneNumer.stringValue;
//        
//        MMLog(@"%@",phoneValue);
//    }
}

// 当选中某一个联系人的某一个属性时会执行该方法
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
    
}

// 点击了取消按钮会执行该方法
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{  
}
@end
