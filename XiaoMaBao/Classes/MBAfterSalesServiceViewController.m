//
//  MBAfterSalesServiceViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 15/11/25.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import "MBAfterSalesServiceViewController.h"
#import "TopTableViewCell.h"
#import "GoodsTableViewCell.h"
#import "ApplyTableViewCell.h"
#import "ProblemTableViewCell.h"
#import "PhotoCollectionViewCell.h"
#import "RefundWayTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MobClick.h"
#import "MBDeliveryInformationViewController.h"
#import "MBRefundScheduleViewController.h"
@interface MBAfterSalesServiceViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSArray *_goods_detailArray;
    NSMutableArray *_numArray;
    UITextField *_consigneeTectField;
    UITextField *_phoneTextfield;
    UITextField *_addressTextField;
    UITextField *_detailedAddressTextField;
    UITextView *_ProblemDescriptionTextView;
    NSString   *_ProblemDescriptionText;
    UITextField *_problem;
    UITextField *_textField;
    UILabel *_lable;
    UICollectionView *_collectionView;
    NSMutableArray  *_photoArray;
    UIView *_view;
    NSLayoutConstraint *_topLayout;
    NSInteger num;
    
    NSInteger _levels;
    NSInteger _level;
    //省市区ID
    NSString *_provinceID;
    NSString *_cityID;
    NSString *_districtID;
 
    NSString *_province;
    NSString *_city;
    NSString *_district;
    
    NSString *_refund_type;//退换货类型 (退货:1，换货:2)
    
    //NSDictionary *_refundDiction;
    
    NSString *_order_total_money;
    NSString *_order_total_num;
    
    NSDictionary *_refunDic;

}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
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

@implementation MBAfterSalesServiceViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBAfterSalesServiceViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBAfterSalesServiceViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setInitialize];
    [self ListeningKeyboard];
    [self initView];
    [self getCityList:@"1"];
    [self getPickerData];
    
    

    
    
    
   
}
- (void)setInitialize{
    self.titleStr = @"申请售后服务";
    
    _top.constant = TOP_Y;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //增加一个
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddoneGoods:) name:@"RefundAdd" object:nil];
    //减少一个
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reduceoneGoods:) name:@"RefundMrice" object:nil];
    //退货
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refund:) name:@"refund" object:nil];
    //换货
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(huan:) name:@"huan" object:nil];
    //省市联动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adress:) name:@"refundAdress" object:nil];
    //提交
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(submit:) name:@"refundSubmit" object:nil];
    
    
     _numArray = [NSMutableArray array];
    _photoArray = [NSMutableArray array];
    
   
    
    [_photoArray addObject:[UIImage imageNamed:@"refund_pictures"]];

}

#pragma mark - init view
- (void)initView {
    
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT)];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyPicker)]];
    
    self.pickerBgView.ml_width = UISCREEN_WIDTH;
}


#pragma mark 增加一个

-(void)AddoneGoods:(NSNotification *)notif
{
    
    
    
    
    NSInteger row = [notif.userInfo[@"row"]  integerValue  ];
    [_numArray replaceObjectAtIndex:row withObject:notif.userInfo[@"goodsNumber"]];
    NSInteger order_num = 0;
    double    order_money = 0.00;
    for (int i=0;i<_numArray.count;i++  ) {
        NSString *str = _numArray[i];
        if (![str isEqualToString:@"0"]) {
            order_num += [str integerValue];
        }
        if (_refunDic) {
            NSArray *order  =   _refunDic[@"refund_goods_detail"];
            NSString *str1= order[i][@"goods_price"];
                order_money +=([str integerValue]*[str1 doubleValue]);
        }
    
    }
    
    
    _order_total_num = [NSString stringWithFormat:@"%ld",order_num];
    _order_total_money = [NSString stringWithFormat:@"%.2f",order_money];
    
    
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    
}

#pragma mark 减少一个
-(void)reduceoneGoods:(NSNotification *)notif
{
   
    NSInteger row = [notif.userInfo[@"row"]  integerValue  ];
    [_numArray replaceObjectAtIndex:row withObject:notif.userInfo[@"goodsNumber"]];
    NSInteger order_num = 0;
    double    order_money = 0.00;
    for (int i=0;i<_numArray.count;i++  ) {
        NSString *str = _numArray[i];
        if (![str isEqualToString:@"0"]) {
            order_num += [str integerValue];
        }
        if (_refunDic) {
            NSArray *order  =   _refunDic[@"refund_goods_detail"];
            NSString *str1= order[i][@"goods_price"];
            order_money +=([str integerValue]*[str1 doubleValue]);
        }
        
    }
    
    
    _order_total_num = [NSString stringWithFormat:@"%ld",order_num];
    _order_total_money = [NSString stringWithFormat:@"%.2f",order_money];
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
}
#pragma mark - 退货
- (void)refund:(NSNotification *)notif{
   _refund_type = @"1";
    _view.alpha = 0;
    num = 5;
    _topLayout.constant = 20;
    [_tableView reloadData];
   
    
    
    
}
#pragma mark －换货
- (void)huan:(NSNotification *)notif{
      _refund_type = @"2";
      _topLayout.constant = 200;
      _view.alpha = 1;
      num = 4;
       [_tableView reloadData];
}
#pragma mark －地址
- (void)adress:(NSNotification *)notif{
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.pickerBgView];
    self.maskView.alpha = 0;
    self.pickerBgView.ml_y = self.view.ml_height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.3;
        self.pickerBgView.ml_y = self.pickerBgView.ml_y -self.pickerBgView.ml_height;
    }];

   
}
#pragma mark --提交
- (void)submit:(NSNotification *)notif{
    
    
    if (!_ProblemDescriptionTextView.text.length >0) {
        [self show:@"请添加问题描述" time:1];
        return;
    }
    if (_photoArray.count<2) {
        [self show:@"请添加图片" time:1];
        return;
    }
    NSInteger number = 0;
    for (NSString *str in _numArray) {
        number +=[str integerValue];
    }
    
    
    if (number == 0) {
        
        [self show:@"请选择要退货商品" time:1];
        return;

    }
    
    
    
    if (num == 4) {
        NSString *regex = @"^\\d{11}$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isValid = [predicate evaluateWithObject:_phoneTextfield.text];
        
        if (!isValid) {
            [self show:@"请输入11位手机号" time:1];
            return;
        }
        
    }
    
    [self submitInformation];
    
    
}
#pragma mark ---提交上传数据
- (void)submitInformation{

    
    
    if ( !_consigneeTectField.text  ) {
        _consigneeTectField.text = @"";
    }
    if (!_detailedAddressTextField.text) {
        _detailedAddressTextField.text = @"";
    }
    
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSMutableDictionary *tabledic = [NSMutableDictionary dictionary];
    NSArray *arr ;
    NSString *order_id;
    if (_refunDic) {
        arr = _refunDic[@"refund_goods_detail"];
        order_id = _refunDic[@"order_id"];
        for (int i=0;i<arr.count;i++) {
            NSDictionary *dic = arr[i];
            [tabledic setObject:_numArray[i] forKey:dic[@"goods_id"]];
        }
   }
    
    
    NSString *refund_goods = [NSString stringWithFormat:@"[%@]",[self dictionaryToJson:tabledic]] ;
    
    NSString *str1 = _consigneeTectField.text;
    NSString *str2 = _phoneTextfield.text;
    NSString *str3 = _detailedAddressTextField.text;
    NSString *str4  = @"1";
    if (!str1) {
        str1 = @"";
    }
    if (!str2) {
        str2 = @"";
    }
    if (!str3) {
        str3 = @"";
    }
    NSDictionary *parmeters = @{@"session":sessiondict,@"order_id":order_id,@"refund_type":_refund_type,@"refund_way":str4,@"refund_reason":_ProblemDescriptionTextView.text,@"consignee":str1,@"mobile":str2,@"address":str3,@"province":_provinceID,@"city":_cityID,@"district":_districtID,@"refund_goods":refund_goods};
    
   // NSLog(@"%@",parmeters);
    
    
    
    [self show];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"refund/apply"]
            parameters:parmeters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                for (int i = 0; i<_photoArray.count-1; i++) {
                    NSData * data;
                    if ([_photoArray[i]isKindOfClass:[UIImage class]] ) {
//                        data = UIImageJPEGRepresentation(_photoArray[i],0.5);
                        data = [UIImage reSizeImageData:_photoArray[i] maxImageSize:800 maxSizeWithKB:800];
                    }
                    
                    if(data != nil){
                        [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"refund_pic%d",i+1] fileName:[NSString stringWithFormat:@"refund_pic%d.jpg",i+1] mimeType:@"image/jpeg"];
                    }

                }
        
}
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   //NSLog(@"success:%@",[responseObject valueForKeyPath:@"status"]);
                  // NSLog(@"data:%@",[responseObject valueForKeyPath:@"data"]);
                    [self dismiss];
#pragma mark -- 通知前一个界面改变进度状态
                   NSString *section = [NSString stringWithFormat:@"%ld",self.section];
                   NSDictionary *reduce = @{@"refund":@"2",@"section":section};
                   NSNotification *notification =[NSNotification notificationWithName:@"Refund_status" object:nil userInfo:reduce];
                   
                   //通过通知中心发送通知
                   [[NSNotificationCenter defaultCenter] postNotification:notification];
                   MBRefundScheduleViewController   *VC = [[MBRefundScheduleViewController alloc] init];
                   VC.type = @"1";
                   if (_type ) {
                       VC.order_sn = self.order_sn;
                       VC.orderid  = self.order_id;
                   }else{
                       VC.order_sn = _refunDic[@"order_sn"];
                       VC.orderid  = _refunDic[@"order_id"];
                   }
                   
                   [self.navigationController pushViewController:VC animated:YES];
                  
                   [self show:[responseObject valueForKeyPath:@"status"][@"error_desc"] time:1];
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   NSLog(@"%@",error);
               
                   [self show:@"请求失败！" time:1];
               }
     ];




}
#pragma mark ---字典转Json
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark - 退货订单数据
- (void)getPickerData {
    
    [self show];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"refund/info"] parameters:@{@"session":sessiondict,@"order_id":self.order_id}success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dismiss];
        
        NSLog(@"成功获取退货信息---responseObject%@",[responseObject valueForKeyPath:@"data"]);
      
        _refunDic = [responseObject valueForKeyPath:@"data"];
        NSDictionary *dic = [responseObject valueForKeyPath:@"data"];
        if (dic) {
            
            NSString *refund_type = [NSString stringWithFormat:@"%@",dic[@"refund_type"]];
            _refund_type = refund_type;
            
            NSArray *arr= dic[@"refund_goods_detail"];
            for (NSDictionary *dic in arr) {
                [_numArray addObject:dic[@"goods_refund_number"]];
            }
            
                if ([_refund_type isEqualToString:@"1"]) {
                    num = 5;
                }else{
                    
                    num = 4;
                }

            
            
            
            if (![dic[@"refund_pic1"]isEqualToString:@""]) {
                
                
                [_photoArray insertObject:_refunDic[@"refund_pic1"] atIndex:0 ];
            }
            if (![dic[@"refund_pic2"]isEqualToString:@""]) {
                
                
                [_photoArray insertObject:_refunDic[@"refund_pic2"] atIndex:0 ];
            }
            if (![dic[@"refund_pic3"]isEqualToString:@""]) {
                
                [_photoArray insertObject:_refunDic[@"refund_pic3"] atIndex:0 ];
            }
            
            
            _cityID = dic[@"city"];
            _districtID = dic[@"district"];
            _provinceID = dic[@"province"];
            
            
            
            [self getOneCityList:dic[@"province"]];
        }
      

        
        [_tableView reloadData];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      [self show:@"请求失败！" time:1];
        NSLog(@"%@",error);
        
    }
     ];
    
    
}

#pragma mark --注册监听键盘的通知
- (void)ListeningKeyboard{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
        _lable =    [[UILabel alloc] initWithFrame:CGRectMake(0, UISCREEN_HEIGHT, UISCREEN_WIDTH, 30)];
        _lable.backgroundColor = [UIColor grayColor];
        _lable.textColor = [UIColor whiteColor];
        _lable.textAlignment = 2;
        [self.view addSubview:_lable];
    

    
    
}
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    if (_lable) {
        [self.view addSubview:_lable];
        [UIView animateWithDuration:.3f animations:^{
            _lable.frame = CGRectMake(0, UISCREEN_HEIGHT-height-29, UISCREEN_WIDTH, 30);
        }];
    }
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:.5f animations:^{
        _lable.frame = CGRectMake(0, UISCREEN_HEIGHT, UISCREEN_WIDTH, 30);
    }];
    [_lable removeFromSuperview];
}
- (void)infoAction:(NSNotification *)aNotification

{
  _lable.text =  _textField.text;
    
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
    _addressTextField.text = str;
    

    
    
    [self hideMyPicker];

}
#pragma maek -- 拍照或从相机获取图片
- (void)setCamera{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 7.99) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                       
                                                             handler:^(UIAlertAction * action) {}];
        UIAlertAction* fromPhotoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action) {                                                                     UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            imagePicker.allowsEditing = YES;
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }];
        UIAlertAction* fromCameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault                                                             handler:^(UIAlertAction * action) {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:fromCameraAction];
        [alertController addAction:fromPhotoAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                 message:@"你的系统版本版本过低，最低支持8.0以上"
                                                                          preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
       [self presentViewController:alertController animated:YES completion:nil];
    }
}
#pragma mark --请求三级联动数据
-(void)getCityList:(NSString *)parent_id
{
    
    
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"region"] parameters:@{@"parent_id":parent_id} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
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
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
      
    }];
    
}
- (void)getOneCityList:(NSString *)parent_id{
    
    
    
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"region"] parameters:@{@"parent_id":parent_id} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
         NSDictionary *d = [responseObject valueForKeyPath:@"data"];
        if (_levels==0) {
            for (NSDictionary *dic in _provinceArray) {
                NSString *str = [NSString stringWithFormat:@"%@",dic[@"id"]];
                
                if ([str isEqualToString:_provinceID]) {
                    
                    _province = dic[@"name"];
                    
                    [_tableView reloadData];
                    
                }
                
            }
            for (NSDictionary *dic in d[@"regions"]) {
                 NSString *str = [NSString stringWithFormat:@"%@",dic[@"id"]];
                if ([str isEqualToString:_cityID]) {
                    _city = dic[@"name"];
                    
                       [_tableView reloadData];
                  
                }
            }
          [self getOneCityList:_refunDic[@"city"]];
        }else {
            for (NSDictionary *dic in d[@"regions"]) {
                 NSString *str = [NSString stringWithFormat:@"%@",dic[@"id"]];
                if ([str isEqualToString:_districtID]) {
                    _district = dic[@"name"];
                       [_tableView reloadData];
       
                }
            }
          

        }
        _levels ++;
            
        
     
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
       
    }];


}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
//    NSLog(@"%@",image);
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (image) {
            if (_photoArray.count <4) {
                [_photoArray insertObject:image atIndex:0];
                [_collectionView reloadData];
            }
        }
        
    }];
    

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ---UICollectionViewDelegate
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    return insets;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

     PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell" forIndexPath:indexPath];
    id order = _photoArray[indexPath.item];

    if ([order isKindOfClass:[NSString class]] ) {
        [cell.image sd_setImageWithURL:order placeholderImage:[UIImage imageNamed:@"icon_nav03"]];
    }else{
      cell.image.image = _photoArray[indexPath.item];
    }
    
    

    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger num1 = _photoArray.count-1;
    if (indexPath.item == num1) {
        if (_photoArray.count<4) {
            [self setCamera];
        }else{
        
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多上传三张图片" delegate: self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [view show];
        
        }
        
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                 message:@"是否删除图片"
                                                                          preferredStyle: UIAlertControllerStyleAlert];
       
        UIAlertAction *delete  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [_photoArray removeObjectAtIndex:indexPath.item];
            [_collectionView reloadData];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [alertController addAction:delete];
        [self presentViewController:alertController animated:YES completion:nil];
    
    }
}
#pragma mark ---UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return num;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==1) {
       
            
        return _numArray.count;
       
    }else {
        return 1;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 40;
    }else if (indexPath.section == 1){
        return 80;
        
    }else if(indexPath.section == 2){
        return 80;
        
    }else if(indexPath.section == 3){
        if (num==5  ) {
            return 80;
        }else{
            return 550;
        }
    
    }else{
        return 350;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 0) {
        
        TopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"TopTableViewCell" owner:self options:nil]firstObject];
        }
        if (_refunDic) {
          
            cell.orderNumber.text = _refunDic[@"order_sn"];
            if (_order_total_money&&_order_total_num) {
                cell.price.text = [NSString stringWithFormat:@"￥%@", _order_total_money];
                cell.GoodsNumber.text = [NSString stringWithFormat:@"数量：%@",_order_total_num];
            }else{
                NSString *price = _refunDic[@"refund_total_money"];
                cell.price.text = [NSString stringWithFormat:@"￥%@",price];
                cell.GoodsNumber.text =  [NSString stringWithFormat:@"数量：%@",_refunDic[@"refund_total_goods_num"]];
            }
            
        }
        
        
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        return cell ;
    
    }else if(indexPath.section == 1){
      
        GoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"GoodsTableViewCell" owner:self options:nil]firstObject];
        }
        
        
        
        if (_refunDic) {
            NSDictionary *dic = _refunDic[@"refund_goods_detail"][indexPath.row];
            
            
            if (dic) {
                NSString *str = dic[@"goods_price"];
                cell.name.text = dic[@"goods_name"];
                cell.price.text = [NSString stringWithFormat:@"￥%@",str];
                cell.goodsNumber = dic[@"goods_max_refund_number"];
                if (_numArray.count>0) {
                    cell.goodsNumbei.text = _numArray[indexPath.row];
                }
                cell.tuihuo.text = [NSString stringWithFormat:@"退货数量（最多为%@件）",dic[@"goods_max_refund_number"]];
                NSURL *url =[NSURL URLWithString:dic[@"goods_img"]];
                [cell.goodsImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_nav03_press"]];
            }
            
            
            cell.row =  indexPath.row;
        }
        
        
      
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        
    
        return cell;
    }else if (indexPath.section == 2){
        
        ApplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ApplyTableViewCell" owner:self options:nil]firstObject];
            
            
        }
        NSString *str = [NSString stringWithFormat:@"%@",_refunDic[@"refund_type"]];
        if (_refunDic) {
            
            if ([str isEqualToString:@"1"]) {
              cell.refund.selected = YES;
                
            }else{
               cell.huan.selected = YES;
         
            }
        
            
        }
        if (_refund_type ) {
            
            
            if ([_refund_type isEqualToString:@"1"]) {
                cell.refund.selected = YES;
                cell.huan.selected = NO;
            }else{
                cell.huan.selected = YES;
                cell.refund.selected = NO;
            
            }
        }
        
        
     cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        
        return cell ;
        
    }else if(indexPath.section ==3){
        
        if (num ==5) {
            RefundWayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefundWayTableViewCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"RefundWayTableViewCell" owner:self options:nil]firstObject];
            }
            cell.selectionStyle =  UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            ProblemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProblemTableViewCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"ProblemTableViewCell" owner:self options:nil]firstObject];
            }
            _consigneeTectField = cell.consigneeTectField;
            _phoneTextfield = cell.phoneTextfield;
            _addressTextField = cell.addressTextField;
            _detailedAddressTextField = cell.detailedAddressTextField;
            _ProblemDescriptionTextView =cell.ProblemDescriptionTextView;
            _ProblemDescriptionTextView.delegate = self;
            _consigneeTectField.delegate = self;
            _phoneTextfield.delegate = self;
            _phoneTextfield.keyboardType =  UIKeyboardTypePhonePad;
            _detailedAddressTextField.delegate = self;
            _collectionView = cell.conllectionView;
            _view = cell.view;
            _collectionView.delegate = self;
            _collectionView.dataSource = self;
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            flowLayout.minimumInteritemSpacing =5;
            flowLayout.itemSize = CGSizeMake(60,60);
            _collectionView.collectionViewLayout = flowLayout;
            _topLayout = cell.topDistance;
            [_collectionView registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCollectionViewCell"];
            _problem = cell.problem;
            
            if (_refunDic) {
                    _consigneeTectField.text = _refunDic[@"consignee"];
                    _phoneTextfield.text = _refunDic[@"mobile"];
                    _detailedAddressTextField.text = _refunDic[@"address"];
                    if (_ProblemDescriptionText) {
                        _ProblemDescriptionTextView.text = _ProblemDescriptionText;
                        if (_ProblemDescriptionText.length>0) {
                             _problem.placeholder = nil;
                        }
                        
                    }else{
                     _ProblemDescriptionTextView.text = _refunDic[@"refund_reason"];
                     _ProblemDescriptionText = _refunDic[@"refund_reason"];
                        if (_ProblemDescriptionText.length>0) {
                             _problem.placeholder = nil;
                        }
                    }
                   
                
                    if (_province) {
                        _addressTextField.text = [NSString stringWithFormat:@"%@-%@-%@",_province,_city,_district];
                    }
                
                
            }
            
            cell.selectionStyle =  UITableViewCellSelectionStyleNone;
            
            
            return cell ;
        
        }
        
        
    }else{
        
        ProblemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProblemTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ProblemTableViewCell" owner:self options:nil]firstObject];
        }
        _consigneeTectField = cell.consigneeTectField;
        _phoneTextfield = cell.phoneTextfield;
        _addressTextField = cell.addressTextField;
        _detailedAddressTextField = cell.detailedAddressTextField;
        _ProblemDescriptionTextView =cell.ProblemDescriptionTextView;
        _ProblemDescriptionTextView.delegate = self;
        _consigneeTectField.delegate = self;
        _phoneTextfield.delegate = self;
        _detailedAddressTextField.delegate = self;
        _collectionView = cell.conllectionView;
        _view = cell.view;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing =5;
        flowLayout.itemSize = CGSizeMake(60,60);
        _collectionView.collectionViewLayout = flowLayout;
        _topLayout = cell.topDistance;
        [_collectionView registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCollectionViewCell"];
        _problem = cell.problem;
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        if (_ProblemDescriptionText) {
            _ProblemDescriptionTextView.text = _ProblemDescriptionText;
        }else{
            _ProblemDescriptionTextView.text = _refunDic[@"refund_reason"];
            _ProblemDescriptionText = _refunDic[@"refund_reason"];
        }
      
        if (_ProblemDescriptionTextView.text.length>0) {
             _problem.placeholder = nil;
        }
        if (num==5) {
            cell.topDistance.constant = 20;
            cell.view.alpha = 0;
        }
        
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;

        
        return cell ;
        
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{

    [_consigneeTectField resignFirstResponder];
    [_phoneTextfield resignFirstResponder];
    [_addressTextField resignFirstResponder];
    [_detailedAddressTextField resignFirstResponder];
    [_ProblemDescriptionTextView resignFirstResponder];

}
#pragma mark -- UIScrollViewdelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    [_consigneeTectField resignFirstResponder];
    [_phoneTextfield resignFirstResponder];
    [_addressTextField resignFirstResponder];
    [_detailedAddressTextField resignFirstResponder];
    [_ProblemDescriptionTextView resignFirstResponder];
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


#pragma mark --UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _problem.placeholder = nil;
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView;{
    _ProblemDescriptionText = textView.text;
    if (textView.text.length>0) {
        
    }else{
        _problem.placeholder = @"请输入详细的问题描述";
    }
    
    
    return YES;
}
#pragma mark --UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoAction:) name:UITextFieldTextDidChangeNotification object:nil];
    _textField = textField;
    _lable.text = textField.text;
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _lable.text = textField.text;
    
}

@end
