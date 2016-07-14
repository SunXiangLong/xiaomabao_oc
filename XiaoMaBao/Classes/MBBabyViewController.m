//
//  MBBabyViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/25.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBabyViewController.h"
#import "MBBabyManagementViewController.h"
#import "headView.h"
#import "headView1.h"
#import "MBGrowingTipsTableViewCell.h"
#import "MBSecurityTipTableViewCell.h"
#import "MBTDetailableViewCell.h"
#import "MBDefaultTableViewCell.h"
#import "LGPhotoPickerViewController.h"
#import "LGPhoto.h"
#import "MBPublishedViewController.h"
#import "MBLoginViewController.h"
#import "MBVaccineViewController.h"
#import "MBUpdateBabyInforViewController.h"
@interface MBBabyViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,LGPhotoPickerViewControllerDelegate,LocationManagerDelegate>
{
    UIImage *_image;
    NSInteger _page;
    NSMutableArray *_logArray;
    MBUserDataSingalTon *userInfo;
    NSString *strSid;
    
    
    
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextFie;
@property (weak, nonatomic) IBOutlet UITextField *birthdaytextFie;

@property (weak, nonatomic) IBOutlet UITextField *genderTextFie;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign)BOOL isBool;
@property (nonatomic,assign)BOOL isBoolFaBiao;
@property (nonatomic,assign)BOOL callback;
@property (nonatomic, assign) LGShowImageType showType;
@property (nonatomic,assign) id photo;
@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,strong) NSString *gender;
@property (nonatomic,strong) NSString *birthday;

@end

@implementation MBBabyViewController
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBBabyViewController"];
    _isBool = YES;
    
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBBabyViewController"];
    userInfo = [MBSignaltonTool getCurrentUserInfo];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSString *is_baby_add = [MBSignaltonTool getCurrentUserInfo].is_baby_add;
    
    
    if (!sid) {
        [self setUIOne];
        strSid = nil;
    }else{
        if (strSid&&[strSid isEqualToString:uid]) {
            if ([is_baby_add isEqualToString:@"1"]) {
                if (!_isBool) {
                    __unsafe_unretained __typeof(self) weakSelf = self;
                    [DXLocationManager getlocationWithBlock:^(double longitude, double latitude) {
                        weakSelf.longitude = [NSString stringWithFormat:@"%f",longitude];
                        weakSelf.latitude = [NSString stringWithFormat:@"%f" , latitude];
                        if (weakSelf.longitude) {
                            [self setheadData];
                        }else{
                            [self show:@"位置获取失败" time:1];
                        }
                        
                    }];
                }
                
                
                
            }else{
                __unsafe_unretained __typeof(self) weakSelf = self;
                [DXLocationManager getlocationWithBlock:^(double longitude, double latitude) {
                    
                    
                    weakSelf.longitude = [NSString stringWithFormat:@"%f",longitude];
                    weakSelf.latitude = [NSString stringWithFormat:@"%f" , latitude];
                    if (weakSelf.longitude) {
                        [self setUIOne];
                    }else{
                        [self show:@"位置获取失败" time:1];
                    }
                    
                }];
                
                
            }
            
        }else{
            if ([is_baby_add isEqualToString:@"1"]) {
                _page = 1;
                userInfo = [MBSignaltonTool getCurrentUserInfo];
                [_logArray removeAllObjects];
                __unsafe_unretained __typeof(self) weakSelf = self;
                [DXLocationManager getlocationWithBlock:^(double longitude, double latitude) {
                    
                    
                    weakSelf.longitude = [NSString stringWithFormat:@"%f",longitude];
                    weakSelf.latitude = [NSString stringWithFormat:@"%f" , latitude];
                    if (weakSelf.longitude) {
                        [self setheadData];
                    }else{
                        [self show:@"位置获取失败" time:1];
                    }
                }];
                
            }else{
                [self setUIOne];
            }
            
        }
        
        strSid = uid;
        
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollView.hidden = YES;
    
    [GetLocationManger getMyLocationWithDelegate:YES];
    
    
}
- (void)setUITwo{
    [self setData];
    
    _scrollView.hidden = YES;
    if (!_tableView) {
        [self.view addSubview:[self setTableView]];
    }
    
    _page = 1;
    
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 上拉刷新
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self setData];
        [weakSelf.tableView.mj_footer endRefreshing];
        
    }];
    // 默认先隐藏footer
    self.tableView.mj_footer.hidden = YES;
    self.titleStr = userInfo.user_baby_info[@"nickname"];
    [self.navBar.rightButton setImage:[UIImage imageNamed:@"crame_image"] forState:UIControlStateNormal];
    
}
- (void)setUIOne{
    [self.tableView.mj_footer removeFromSuperview];
    self.tableView.mj_footer  = nil;
    
    [_tableView removeFromSuperview];
    _tableView = nil;
    _scrollView.hidden = NO;
    _nameTextFie.delegate = self;
    _birthdaytextFie.delegate = self;
    _genderTextFie.delegate = self;
    _scrollView.delegate = self;
    _bottom.constant = UISCREEN_HEIGHT-TOP_Y-48-50;
    self.titleStr = @"添加宝宝";
    
    
}
- (UITableView *)setTableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = CGRectMake(0, TOP_Y, UISCREEN_WIDTH, UISCREEN_HEIGHT-49-TOP_Y);
        _tableView.delegate = self;
        _tableView.dataSource= self;
        _tableView.tableHeaderView = [self settableHeadView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.photo = userInfo.user_baby_info[@"photo"];
        self.nickname = userInfo.user_baby_info[@"nickname"];
        self.gender =  userInfo.user_baby_info[@"gender"];
        self.birthday = userInfo.user_baby_info[@"birthday"];
    }
    _tableView.tableHeaderView = [self settableHeadView];
    return _tableView;
}

/**
 *  添加宝宝头像
 *
 *  @param sender
 */
- (IBAction)PhotoButton:(id)sender {
   
    [self setCamera];
}
/**
 *  完成－－提交
 *
 *  @param sender
 */
- (IBAction)subButton:(id)sender {
    
    if (_nameTextFie.text.length ==0) {
        [self show:@"请输入宝宝小名" time:1];
        return;
    }
    if (_birthdaytextFie.text.length==0) {
        [self show:@"请选择宝生日宝s" time:1];
        return;
    }
    if (_genderTextFie.text.length ==0) {
        [self show:@"请选择宝宝性别" time:1];
        return;
    }
    if (!_image) {
        [self show:@"请选择宝宝照片" time:1];
        return;
    }
    
    
    [self getsubData];
    
}
/**
 *  移除textView的第一响应
 */
- (void)cacelTextfile{
    [_nameTextFie resignFirstResponder];
    
}
/**
 *  提交宝宝基本信息
 */
-(void)getsubData
{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [self showProgress];
    NSString *str = @"";
    if ([_genderTextFie.text isEqualToString:@"男"]) {
        str = @"0";
    }else{
        str = @"1";
        
    }
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/athena/babyadd"] parameters:@{@"session":sessiondict,@"nickname":_nameTextFie.text,@"birthday":_birthdaytextFie.text,@"gender":str,@"act":@"insert"} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData * data = [UIImage reSizeImageData:_image maxImageSize:300 maxSizeWithKB:300];
        
        if(data != nil){
            [formData appendPartWithFileData:data name:@"children" fileName:@"children.jpg" mimeType:@"image/jpeg"];
        }
        
    } progress:^(NSProgress *progress) {
        //        NSLog(@"%f",progress.fractionCompleted);
        self.progress = progress.fractionCompleted;
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject valueForKeyPath:@"status"]isEqualToNumber:@1]) {
            
            [self getUserInfo];
            
        }else{
            
            [self show:@"保存失败" time:1];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [self show:@"请求失败！" time:1];
    }];
    
    
}


/**
 *  更新宝宝信息到个人信息里面
 */
-(void)getUserInfo
{
    
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"user/info"] parameters:@{@"session":sessiondict}
               success:^(NSURLSessionDataTask *operation, id responseObject) {
                   //                   NSLog(@"UserInfo成功---responseObject%@",[responseObject valueForKeyPath:@"data"]);
                   
                   [self show:@"保存成功" time:1];
                   
                   NSDictionary *dic = [responseObject valueForKeyPath:@"data"];
                   userInfo.is_baby_add = [NSString stringWithFormat:@"%@", dic[@"is_baby_add"]];
                   userInfo.user_baby_info = dic[@"user_baby_info"];
                   [self setheadData];
                   
                   
               } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                   NSLog(@"%@",error);
                   [self show:@"请求失败" time:1];
               }];
}

- (void)loginClicksss{
    //跳转到登录页
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MBLoginViewController *myView = [story instantiateViewControllerWithIdentifier:@"MBLoginViewController"];
    myView.vcType = @"mabao";
    MBNavigationViewController *VC = [[MBNavigationViewController alloc] initWithRootViewController:myView];
    [self presentViewController:VC animated:YES completion:nil];}
#pragma mark --- 宝宝生日
-(void)selectBirthday{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate  *date = [NSDate date];
    [ActionSheetDatePicker showPickerWithTitle:nil datePickerMode:UIDatePickerModeDate selectedDate:date
                                     doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                                         //实例化一个NSDateFormatter对象
                                         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                         //设定时间格式,这里可以设置成自己需要的格式
                                         [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                                         //用[NSDate date]可以获取系统当前时间
                                         NSString *currentDateStr = [dateFormatter stringFromDate:selectedDate];
                                         
                                         _birthdaytextFie.text = currentDateStr;
                                     } cancelBlock:^(ActionSheetDatePicker *picker) {
                                         
                                     } origin:_birthdaytextFie];
    
}
#pragma mark --- 宝宝性别
-(void)selectBabyGender{
    // Create an array of strings you want to show in the picker:
    NSArray *genders = [NSArray arrayWithObjects:@"男",@"女",nil];
    [ActionSheetStringPicker showPickerWithTitle:@"请选择性别"
                                            rows:genders
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           if(selectedIndex == 0){
                                               
                                               _genderTextFie.text = @"男";
                                           }else{
                                               _genderTextFie.text = @"女";
                                           }
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:_genderTextFie];
   
}
#pragma maek -- 拍照或从相机获取图片
- (void)setCamera{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 7.99) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                       
                                                             handler:^(UIAlertAction * action) {}];
        UIAlertAction* fromPhotoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action) {                                                                      [self presentPhotoPickerViewControllerWithStyle:LGShowImageTypeImagePicker];
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
/**
 *  选择相册图片
 *
 *  @param style
 */
- (void)presentPhotoPickerViewControllerWithStyle:(LGShowImageType)style {
    LGPhotoPickerViewController *pickerVc = [[LGPhotoPickerViewController alloc] initWithShowType:style];
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.maxCount = 1;   // 最多能选9张图片
    pickerVc.delegate = self;
    self.showType = style;
    [pickerVc showPickerVc:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --请求安心提示数据
- (void)setheadData{
    _logArray = [NSMutableArray array];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/athena/tips"];
    if (! sid) {
        return;
    }
    [self show];
    [MBNetworking POST:url parameters:@{@"session":sessiondict,@"device":@"ios",@"longitude":self.longitude,@"latitude":self.latitude}
               success:^(NSURLSessionDataTask *operation, MBModel *responseObject) {
                   
                   
                   if(1 == [[responseObject valueForKey:@"status"]  intValue]){
                       [self dismiss];
                       NSArray *arr = [responseObject valueForKeyPath:@"data"];
                       //                      NSLog(@"%@",arr);
                       
                       
                       for (NSDictionary *dic in arr) {
                           if ([dic[@"data"] count] >0  ) {
                               if ([dic[@"group"]isEqualToString:@"tianqi"]) {
                                   [_logArray insertObject:dic  atIndex:0];
                               }else{
                                   [_logArray addObject:dic];
                               }
                               
                           }
                           
                       }
                       
                       if (_isBoolFaBiao) {
                           [self setData];
                       }else{
                           [self setUITwo];
                       }
                       
                       
                       
                   }
                   
               } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                   
                   [self show:@"请求失败 " time:1];
                   NSLog(@"%@",error);
                   
               }
     ];
    
    
}
/**
 *  请求日志列表
 */
- (void)setData{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page];
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/athena/diarylist"];
    if (! sid) {
        return;
    }
    
    [MBNetworking POST:url parameters:@{@"session":sessiondict,@"page":page}
               success:^(NSURLSessionDataTask *operation, MBModel *responseObject) {
                   
                   
                   if(1 == [[responseObject valueForKey:@"status"]  intValue]){
                       [self dismiss];
                       NSDictionary *userData = [responseObject valueForKeyPath:@"data"];
                       NSArray *arr = userData[@"result"];
                       //                       NSLog(@"%@",arr);
                       
                       
                       if (_page==1) {
                           
                           if (arr.count==0) {
                               NSArray *arr = @[];
                               NSDictionary *dic = @{@"data":arr,@"shuju":@"zero"};
                               [_logArray addObject:dic ];
                               _page++;
                               
                               [self.tableView reloadData];
                               return ;
                           }
                           NSMutableArray *arrs = [NSMutableArray array];
                           for (NSDictionary *dic in arr) {
                               NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
                               [muDic  setObject:dic[@"dategroup"] forKey:@"dategroup"];
                               NSMutableArray *muArr = [NSMutableArray arrayWithArray:dic[@"data"]];
                               [muDic setObject:muArr forKey:@"data"];
                               [arrs addObject:muDic];
                           }
                           NSInteger count = _logArray.count;
                           [_logArray addObjectsFromArray:arrs];
                           
                           
                           if (_isBoolFaBiao) {
                               
                               
                               if ([_logArray[count][@"data"] count]<2) {
                                   [self.tableView reloadData];
                               }else{
                                   NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:count];
                                   
                                   
                                   
                                   
                                   [[self tableView] scrollToRowAtIndexPath:indexPath
                                                           atScrollPosition:UITableViewScrollPositionTop animated:YES];
                                   
                                   
                                   
                                   //                                   [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                   [self.tableView reloadData];
                                   
                               }
                               
                           }else{
                               
                               [self.tableView reloadData];
                           }
                           
                           _page++;
                       }else{
                           
                           
                           
                           NSArray *oneArray = _logArray.lastObject[@"data"];
                           NSArray *twoArray = arr.lastObject[@"data"];
                           
                           if (arr.count == 0||([oneArray.lastObject[@"id"]isEqualToString:twoArray.lastObject[@"id"]])) {
                               [self.tableView.mj_footer endRefreshingWithNoMoreData];
                               return ;
                           }
                           if([arr.firstObject[@"max_page"] integerValue]<_page) {
                               [self.tableView.mj_footer endRefreshingWithNoMoreData];
                               
                           }else{
                               [_logArray addObjectsFromArray:arr];
                               [self.tableView reloadData];
                               _page ++;
                           }
                           
                           
                           
                       }
                       
                       
                   }
                   
               } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                   
                   [self show:@"请求失败 " time:1];
                   NSLog(@"%@",error);
                   
               }
     ];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    
    
    if (!sid) {
        [self loginClicksss];
        return NO;
    }
    if ([_nameTextFie isEqual:textField]) {
        
        
        return YES;
    }else if([_birthdaytextFie isEqual:textField]){
        
        [self cacelTextfile];
        [self selectBirthday];
        return NO;
    }else{
        
        [self cacelTextfile];
        [self selectBabyGender];
        return NO;
    }
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self cacelTextfile];
    
}
- (void)pickerViewControllerDoneAsstes:(NSArray *)assets isOriginal:(BOOL)original{
    
    LGPhotoAssets *photo = assets.firstObject;
    UIImage *image = photo.thumbImage;
    [_photoButton setImage:image forState:UIControlStateNormal];
    _image = image;
    
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (image) {
            [_photoButton setImage:image forState:UIControlStateNormal];
            _image = image;
        }
        
    }];
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -- 添加过宝宝的UI

- (UIView *)settableHeadView{
    
    UIView *view = [[UIView alloc] init];
    
    view.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 158);
    
    
    headView1 *view1 = [headView1 instanceView];
    
    
    
    
    if ([self.photo isKindOfClass:[NSString class]]) {
        
        
        [view1.touxiang sd_setImageWithURL:[NSURL URLWithString:self.photo] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    }
    if ([self.photo isKindOfClass:[UIImage class]]){
        
        view1.touxiang.image = self.photo;
    }else{
        
        //        NSLog(@"11122233444");
    }
    
    view1.touxiang.contentMode =  UIViewContentModeScaleAspectFill;
    view1.touxiang.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    view1.touxiang.clipsToBounds  = YES;
    view1.touxiang.userInteractionEnabled = YES;
    view1.namelable.text = self.nickname;
    NSString *str = self.gender;
    if ([str isEqualToString:@"0"]) {
        str = @"小萌男";
    }else{
        str = @"小萌女";
    }
    view1.shuoming.text = [NSString stringWithFormat:@" %@出生 %@",self.birthday,str];
    [view addSubview: view1];
    
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    [view1.touxiang addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhotoTapped)]];
    
    
    
    return view;
    
    
}
-(void)takePhotoTapped{
    MBUpdateBabyInforViewController *VC = [[MBUpdateBabyInforViewController alloc] init];
    if ([self.photo isKindOfClass:[NSString class]]) {
        VC.imageUrl =self.photo;
    }else{
        VC.image = self.photo;
    }
    
    NSString *str =  userInfo.user_baby_info[@"gender"];
    VC.xingbie = [str isEqualToString:@"0"]?@"男":@"女";
    VC.name = userInfo.user_baby_info[@"nickname"];
    VC.daty = userInfo.user_baby_info[@"birthday"];
    VC.ID = userInfo.user_baby_info[@"id"];
    __unsafe_unretained __typeof(self) weakSelf = self;
    VC.block=^(NSString *name,NSString *xingbie,NSString *daty,UIImage *imageUrl){
        weakSelf.photo= imageUrl;
        weakSelf.nickname =name;
        weakSelf.gender = xingbie;
        weakSelf.birthday = daty;
        
        weakSelf.tableView.tableHeaderView = [self settableHeadView];
    };
    [self pushViewController:VC Animated:YES];
}
-(void)rightTitleClick{
    
    if ([userInfo.is_baby_add isEqualToString:@"1"]){
        
        _page = 1;
        
//        __unsafe_unretained __typeof(self) weakSelf = self;
        MBPublishedViewController   *VC = [[MBPublishedViewController alloc] init];
//        VC.block = ^(){
//            _isBoolFaBiao = YES;
//            
//            [weakSelf setheadData];
//        };
     
        [self pushViewController:VC Animated:YES];
        
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _logArray.count;
    
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    
    NSString *group = _logArray[section][@"group"];
    NSArray*data = _logArray[section][@"data"];
    
    if ([group  isEqualToString:@"chengzhang"]) {
        if ([data isKindOfClass:[NSArray class]]) {
            return 0;
        }else{
            return 1;
        }
        
        
        
    }else if([group isEqualToString:@"anxin"]&&data.count>0){
        return data.count;
        
    }else if([group isEqualToString:@"tianqi"]){
        
        return 1;
    }else{
        if ([_logArray[section][@"data"]count] ==0) {
            return 1;
        }else{
            return [_logArray[section][@"data"]count];
        }
        
        
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 31);
    
    headView *view1 = [headView instanceView];
    
    [view addSubview:view1];
    
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    NSString *group = _logArray[section][@"group"];
    NSArray*data = _logArray[section][@"data"];
    
    if ([group  isEqualToString:@"chengzhang"]&&[_logArray[section][@"data"] isKindOfClass:[NSDictionary class]]) {
        view1.tishiLable.text = @"成长贴士";
        
        
        
    }else if([group isEqualToString:@"anxin"]&&data.count>0){
        
        view1.tishiLable.text = @"安心提示";
    }else if([group isEqualToString:@"tianqi"]){
        
        view1.tishiLable.text = @"天气提醒";
    }else{
        if ([_logArray[section][@"data"]count] ==0) {
            view1.tishiLable.text= @"";
        }else{
            view1.tishiLable.text =[NSString stringWithFormat:@"%@",_logArray[section][@"dategroup"]];
            
            view1.numLable.text = [NSString stringWithFormat:@"%ld篇",[_logArray[section][@"data"]count]];
        }
        
        
    }
    
    
    
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *group = _logArray[indexPath.section][@"group"];
    NSArray*data = _logArray[indexPath.section][@"data"];
    
    if ([group  isEqualToString:@"chengzhang"]&&[_logArray[indexPath.section][@"data"] isKindOfClass:[NSDictionary class]]) {
        NSString *str = _logArray[indexPath.section][@"data"][@"summary"];
        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:14] withMaxSize:CGSizeMake(UISCREEN_WIDTH-50, 999)];
        return size.height+20;
        
    }else if([group isEqualToString:@"anxin"]&&data.count>0){
        return 60;
        
    }else if([group isEqualToString:@"tianqi"]){
        
        NSString *str = _logArray[indexPath.section][@"data"][@"content"];
        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:14] withMaxSize:CGSizeMake(UISCREEN_WIDTH-50, 999)];
        return size.height+20;
    }
    
    
    else{
        if ([_logArray[indexPath.section][@"data"]count] ==0) {
            return (UISCREEN_WIDTH-20)*407/838+20;
        }else{
            return 75;
        }
        
        
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 28;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *group = _logArray[indexPath.section][@"group"];
    NSArray*data = _logArray[indexPath.section][@"data"];
    
    if ([group  isEqualToString:@"chengzhang"]&&[_logArray[indexPath.section][@"data"] isKindOfClass:[NSDictionary class]]) {
        
        MBGrowingTipsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBGrowingTipsTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MBGrowingTipsTableViewCell" owner:nil options:nil]firstObject];
        }
        cell.lableText.text  = _logArray[indexPath.section][@"data"][@"summary"];
        
        return cell;
        
    }else if([group isEqualToString:@"anxin"]&&data.count>0){
        MBSecurityTipTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBSecurityTipTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MBSecurityTipTableViewCell" owner:nil options:nil]firstObject];
        }
        
        
        cell.nameLable.text = _logArray[indexPath.section][@"data"][indexPath.row][@"title"];
        
        cell.freeLable.text = _logArray[indexPath.section][@"data"][indexPath.row][@"free"];
        cell.usefullLable.text = _logArray[indexPath.section][@"data"][indexPath.row][@"usefull"];
        cell.timeLable.text = [NSString stringWithFormat:@"接种日期：%@ %@", _logArray[indexPath.section][@"data"][indexPath.row][@"act_day"], _logArray[indexPath.section][@"data"][indexPath.row][@"act_week"]];
        
        return cell;
        
    }else if([group isEqualToString:@"tianqi"]){
        
        MBGrowingTipsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBGrowingTipsTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MBGrowingTipsTableViewCell" owner:nil options:nil]firstObject];
        }
        cell.lableText.text  = _logArray[indexPath.section][@"data"][@"content"];
        
        return cell;
    }else{
        
        
        if ([_logArray[indexPath.section][@"data"]count] ==0) {
            MBDefaultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBDefaultTableViewCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"MBDefaultTableViewCell" owner:nil options:nil]firstObject];
            }
            
            return cell;
        }else{
            MBTDetailableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBTDetailableViewCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"MBTDetailableViewCell" owner:nil options:nil]firstObject];
            }
            
            cell.xiqiLable.text = _logArray[indexPath.section][@"data"][indexPath.row][@"week"];
            cell.dataLable.text =  _logArray[indexPath.section][@"data"][indexPath.row][@"day"];
            cell.miaoshuLable.text = _logArray[indexPath.section][@"data"][indexPath.row][@"content"];
            // cell.nameLable.text = userInfo.user_baby_info[@"nickname"];
            cell.timeLable.text = [NSString stringWithFormat:@"%@月%@日 %@", _logArray[indexPath.section][@"data"][indexPath.row][@"month"], _logArray[indexPath.section][@"data"][indexPath.row][@"day"], _logArray[indexPath.section][@"data"][indexPath.row][@"addtime"]];
            NSArray *photo = _logArray[indexPath.section][@"data"][indexPath.row][@"photo"];
            if (photo.count>0) {
                NSURL *url = [NSURL URLWithString: _logArray[indexPath.section][@"data"][indexPath.row][@"photo"][0]];
                [cell.showImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder_num2"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    cell.showImageView.alpha = 0.3f;
                    [UIView animateWithDuration:1
                                     animations:^{
                                         cell.showImageView.alpha = 1.0f;
                                     }
                                     completion:nil];
                }];
            }
            cell.showImageView .contentMode =  UIViewContentModeScaleAspectFill;
            cell.showImageView .autoresizingMask = UIViewAutoresizingFlexibleHeight;
            cell.showImageView .clipsToBounds  = YES;
            
            
            NSString *mood = _logArray[indexPath.section][@"data"][indexPath.row][@"mood"];
            NSString *weather = _logArray[indexPath.section][@"data"][indexPath.row][@"weather"];
            NSString *position = _logArray[indexPath.section][@"data"][indexPath.row][@"position"];
            
            
            if ([mood isEqualToString:@""]&&[weather isEqualToString:@""]) {
                
            }else{
                if ([mood isEqualToString:@""]) {
                    cell.showImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"mb_weather%@",weather]];
                }else if ([weather isEqualToString:@""]){
                    cell.showImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"mood%@_image",weather]];
                }else{
                    cell.showImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"mood%@_image",mood]];
                    cell.showsImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"mb_weather%@",weather]];
                    
                }
                
            }
            
            if (![position isEqualToString:@""]) {
                cell.dingweiImageView.image = [UIImage imageNamed:@"place_image"];
                cell.didianLabletext.text = position;
            }
            
            return cell;
            
            
        }
        
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *group = _logArray[indexPath.section][@"group"];
    NSArray*data = _logArray[indexPath.section][@"data"];
    
    if ([group  isEqualToString:@"chengzhang"]&&[_logArray[indexPath.section][@"data"] isKindOfClass:[NSDictionary class]]) {
        
        MBVaccineViewController *VC = [[MBVaccineViewController alloc] init];
        VC.url = [NSURL URLWithString: _logArray[indexPath.section][@"data"][@"url"]];
        VC.title = @"成长贴士";
        [self pushViewController:VC Animated:YES];
        
    }else if([group isEqualToString:@"anxin"]&&data.count>0){
        MBVaccineViewController *VC = [[MBVaccineViewController alloc] init];
        VC.url = [NSURL URLWithString: _logArray[indexPath.section][@"data"][indexPath.row][@"url"]];
        VC.title =  _logArray[indexPath.section][@"data"][indexPath.row][@"title"];
        [self pushViewController:VC Animated:YES];
        
    }else if ([group  isEqualToString:@"tianqi"]&&[_logArray[indexPath.section][@"data"] isKindOfClass:[NSDictionary class]]){
        MBVaccineViewController *VC = [[MBVaccineViewController alloc] init];
        VC.url = [NSURL URLWithString: _logArray[indexPath.section][@"data"][@"url"]];
        VC.title = @"天气提醒";
        [self pushViewController:VC Animated:YES];
        
    }
    
    else{
        if ([_logArray[indexPath.section][@"data"]count] ==0) {
            [self rightTitleClick];
        }else{
            MBBabyManagementViewController *VC = [[MBBabyManagementViewController alloc] init];
            VC.ID = _logArray[indexPath.section][@"data"][indexPath.row][@"id"];
            
            
            
            VC.photoArray = _logArray[indexPath.section][@"data"][indexPath.row][@"photo"];
            VC.date = [NSString stringWithFormat:@"%@-%@-%@",_logArray[indexPath.section][@"data"][indexPath.row][@"year"], _logArray[indexPath.section][@"data"][indexPath.row][@"month"], _logArray[indexPath.section][@"data"][indexPath.row][@"day"]];
            VC.addtime = _logArray[indexPath.section][@"data"][indexPath.row][@"addtime"];
            VC.content = _logArray[indexPath.section][@"data"][indexPath.row][@"content"];
            
            
            VC.indexPath = indexPath;
            
            
            __unsafe_unretained __typeof(self) weakSelf = self;
            VC.block = ^(NSIndexPath *indexPath){
                
                
                
                [_logArray[indexPath.section][@"data"] removeObjectAtIndex:indexPath.row];
                
                if ([_logArray[indexPath.section][@"data"] count]==0) {
                    
                    [_logArray removeObjectAtIndex:indexPath.section];
                    if (_logArray.count <3) {
                        NSArray *arr = @[];
                        NSDictionary *dic = @{@"data":arr,@"shuju":@"zero"};
                        [_logArray addObject:dic ];
                        [self.tableView reloadData];
                    }else{
                        NSIndexSet *set = [NSIndexSet indexSetWithIndex:indexPath.section];
                        [weakSelf.tableView deleteSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                    
                    
                }else{
                    [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                
            };
            
            [self pushViewController:VC Animated:YES];
        }
        
    }
    
    
}


#pragma mark ---让tabview的headview跟随cell一起滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 31;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
    _tableView.editing = NO;
    
}

@end
