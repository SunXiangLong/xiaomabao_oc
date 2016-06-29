//
//  MBNewBabyController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/30.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBNewBabyController.h"
#import "MBNewBabyCell.h"
#import "MBCollectionHeadView.h"
#import "MBNewBabyOneTableCell.h"
#import "MBNewBabyHeadView.h"
#import "MBNewBabyTwoTableCell.h"
#import "MBNewBabyThreeTableCell.h"
#import "MBNewBabyFourTableCell.h"
#import "MBBabyWebController.h"
#import "MBSetBabyInformationController.h"
#import "MBabyRecordController.h"
#import "MBBabyDueDateController.h"
#import "MBLoginViewController.h"
#import "MBBabyToolCell.h"
#import "MBCollectionViewFlowLayout.h"
#import "TGCameraNavigationController.h"
#import "STPhotoKitController.h"
#import "UIImagePickerController+ST.h"
#import "STConfig.h"
#import "MBPostDetailsViewController.h"
@interface MBNewBabyController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,STPhotoKitDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
   
    
    NSInteger _row;
    /**
     *  宝宝状态 yes已出生  no怀孕中
     */
    BOOL _babyState;
    /**
     *  宝宝性别  @“1”男  @“0”女
     */
    NSString *_babyGender;
    
    NSDate *_current_date;
    NSDate *_start_date;
    NSDate *_end_date;
    
    /**
     *  是否从下个界面返回的
     */
    BOOL _isDismiss;
   
    /**
     *  修改的宝宝头像
     */
    UIImage *_baby_image;
    
    NSDictionary  *_day_info;
    /**
     *  宝宝头像
     */
     id _images;
    
    NSString *_oldUid;
    
    /**
     *  是在怀孕状态 还是宝宝已出生  yes 是怀孕  no 宝宝出生后
     */
    BOOL  _isPregnant;
    
}
/**
 *  顶部view
 */
@property (weak, nonatomic) IBOutlet UIView *topView;
/**
 *  日期选择view
 */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIButton *beginParentingButton;

@property (weak, nonatomic) IBOutlet UIButton *backTadyButton;
/**
 *  底层展示控件
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  妈妈状态选择view
 */
@property (weak, nonatomic) IBOutlet UIView *myStateView;
/**
 *  宝宝性别选择view
 */
@property (weak, nonatomic) IBOutlet UIView *babyGenderView;

@property (copy, nonatomic) NSMutableArray *dataArray;
@property (copy, nonatomic) NSMutableArray *dateArray;

@property (weak, nonatomic) IBOutlet UIButton *reftButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
/**
 *  宝宝id
 */
@property (nonatomic, copy)  NSString *baby_id;
@end

@implementation MBNewBabyController
-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}
-(NSMutableArray *)dateArray{
    
    if (!_dateArray) {
        
        _dateArray = [NSMutableArray array];
    }
    
    return _dateArray;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSString *is_baby_add = [MBSignaltonTool getCurrentUserInfo].is_baby_add;
    /**
     *  判断用户是否登陆和设置过宝宝信息
     */
    if (is_baby_add&&[is_baby_add isEqualToString:@"1"]) {
           
         _baby_id = [MBSignaltonTool getCurrentUserInfo].user_baby_info[@"id"];
        /**
         *  判断是不是第二次进入这个界面 且用户状态没发生改变 就不在重请求数据
         */
        if (![uid isEqualToString:_oldUid]){
            
        /**
         *  第二次进入界面且登陆状态改变 上一次进入是否请求到数据 有就清空
         */
            [self.dataArray removeAllObjects];
            [self.dateArray removeAllObjects];
            
        _babyGenderView.hidden = YES;
        _myStateView.hidden = YES;
        [self setToolkit:NO date:nil];
        _oldUid = uid;
            
        }else{

            NSInteger count = self.dataArray.count;
           
            if (count == 0) {
  
                  [self setToolkit:NO date:nil];
            }
       
        }
       
    }else{
           
        _babyGenderView.hidden = NO;
        _myStateView.hidden = NO;
        _reftButton.hidden = YES;
        _leftButton.hidden = YES;
        _beginParentingButton.hidden = YES;
        _backTadyButton.hidden = YES;
  
        [_dataArray removeAllObjects];
        [_dateArray removeAllObjects];
        [_tableView reloadData];
        [_collectionView reloadData];
        
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.bounces = NO;
    
    
   

    MBCollectionViewFlowLayout *flowLayout = ({
        MBCollectionViewFlowLayout *flowLayout =  [[MBCollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((UISCREEN_WIDTH-90)/3,45);
        // 设置内边距
        CGFloat inset = (UISCREEN_WIDTH-90 - (UISCREEN_WIDTH-90)/3) * 0.5;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
     
        flowLayout;
    });
    _collectionView.scrollEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.collectionViewLayout = flowLayout;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"MBNewBabyCell" bundle:nil] forCellWithReuseIdentifier:@"MBNewBabyCell"];
    

}
- (IBAction)button:(UIButton *)sender {
    
    if ([sender isEqual:_backTadyButton]) {
        _row = [_dateArray indexOfObject:_current_date];
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_row inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
          [self setData:[self setDate:_current_date]];
        sender.hidden= YES;
        
    }else{
        _babyGenderView.hidden = NO;
    
    
    }
}

- (IBAction)touchs:(UITapGestureRecognizer *)sender {
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    if (!sid) {
        [self loginClicksss];
        return;
    }
    switch (sender.view.tag) {
            
        case 0:{
            _babyGenderView.hidden = YES;
            _babyGender = @"0";
        }  break;
        case 1:{
            _babyGenderView.hidden = YES;
            _babyGender = @"1";
        }  break;
        default: break;
            
            
    }
    MBSetBabyInformationController *VC = [[MBSetBabyInformationController alloc] init];
    
    VC.babyGender = _babyGender;
    [self pushViewController:VC Animated:YES];
}

- (IBAction)touch:(id)sender {
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    if (!sid) {
        [self loginClicksss];
        return;
    }
    switch (tap.view.tag) {
        case 0: {
            
            
            _babyState = NO;
            _babyGenderView.hidden = YES;
            _myStateView.hidden = YES;
            MBBabyDueDateController *VC = [[MBBabyDueDateController alloc] init];
            
            [self pushViewController:VC Animated:YES];
            
            
            return;
            
            
        }
        case 1: {
            _babyState = YES;
            _myStateView.hidden = YES;
            
            return;
        } break;
            
        default: break;
            
    }
    
    
}



- (IBAction)back:(UIButton *)sender {
    
   
    if (_row == _dateArray.count-1) {
        return;
    }
    if ([_dateArray[_row] isEqualToDate:_current_date]) {
        _backTadyButton.hidden = YES;
    }
    _row ++;
    [self collectionViewOffset];
    NSDate *date = _dateArray[_row];
    if (sender) {
        _backTadyButton.hidden = NO;
      [self setToolkit:NO date:[self setDate:date]];
    }
    
    
}
- (IBAction)next:(UIButton *)sender {


    
    if (_row == 0) {
        return;
    }
    if ([_dateArray[_row] isEqualToDate:_current_date]) {
        _backTadyButton.hidden = YES;
    }
    _row --;
    [self collectionViewOffset];
    NSDate *date = _dateArray[_row];
    
    _backTadyButton.hidden = NO;
    [self setToolkit:NO date:[self setDate:date]];

    
    
}
/**
 *  请求工具数据
 */
- (void)setToolkit:(BOOL)refresh date:(NSString *)date{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    if (!refresh) {
        [self show];
    }
    
    NSDictionary *parameters = @{@"session":sessiondict};
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/mengbao/get_user_toolkit_v2"];
    [MBNetworking   POSTOrigin:url parameters:parameters success:^(id responseObject) {
        
//        NSLog(@"%@",responseObject);
        
        if (refresh) {
            self.dataArray[1] = [responseObject valueForKeyPath:@"data"];
            
            [_tableView  reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else if(date){
              self.dataArray[1] = [responseObject valueForKeyPath:@"data"];
            [self setData:date];
        }else{
            [self.dataArray addObject:[responseObject valueForKeyPath:@"data"]];
            [self setData:date];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败 " time:1];
        NSLog(@"%@",error);
    }];
    
    
}

/**
 *  请求萌宝数据
 *
 *
 */
#pragma mark--请求萌宝数据
- (void)setData:(NSString *)date{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSDictionary *parameters = @{@"session":sessiondict};
    if (date) {
       
         parameters = @{@"session":sessiondict,@"current_date":date};
        
      
    }
    
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/mengbao/get_index_info"];
    [MBNetworking   POSTOrigin:url parameters:parameters success:^(id responseObject) {
        [self dismiss];
        _isPregnant = [[responseObject valueForKeyPath:@"type"] isEqualToString:@"pregnant"];
//        NSLog(@"%@",responseObject);
        if (date) {

            _day_info = [responseObject valueForKeyPath:@"day_info"];
            [self setTableHeadView:_day_info];
            self.dataArray[0] = [responseObject valueForKeyPath:@"remind"];
            if ( [responseObject valueForKeyPath:@"recommend_posts"]) {
                self.dataArray[2] = [responseObject valueForKeyPath:@"recommend_posts"];
            }
            if ([responseObject valueForKeyPath:@"recommend_topics"]) {
                self.dataArray[3][0] = [responseObject valueForKeyPath:@"recommend_topics"];
            }
            if ([responseObject valueForKeyPath:@"recommend_goods"]) {
                self.dataArray[3][0] = [responseObject valueForKeyPath:@"recommend_goods"];
            }
 
            [_tableView reloadData];
      
        }else{
            _day_info = [responseObject valueForKeyPath:@"day_info"];
            [self setTableHeadView:_day_info];
            [self.dataArray insertObject:[responseObject valueForKeyPath:@"remind"] atIndex:0];
            [self.dataArray addObject:[responseObject valueForKeyPath:@"recommend_posts"]];
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObjectsFromArray:[responseObject valueForKeyPath:@"recommend_topics"]];
            [arr addObjectsFromArray:[responseObject valueForKeyPath:@"recommend_goods"]];
            [self.dataArray addObject:@[arr]];
            _tableView.delegate = self;
            _tableView.dataSource =self;
            _current_date = [self setDateStr:[responseObject valueForKeyPath:@"current_date"]];
            _start_date   =  [self setDateStr:[responseObject valueForKeyPath:@"start_date"]];
            _end_date     = [self setDateStr:[responseObject valueForKeyPath:@"end_date"]];
            [_tableView reloadData];
            [self calculateDate];
            
            
            
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败 " time:1];
        NSLog(@"%@",error);
    }];
    
    
}
- (void)setBabyImage{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/athena/save_baby_photo"] parameters:@{@"session":sessiondict,@"baby_id":_baby_id} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    
            NSData * data =  UIImageJPEGRepresentation(_baby_image, 1.0);
            if(data != nil){
                [formData appendPartWithFileData:data name:@"photo" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
            }
            
        } progress:^(NSProgress *progress) {
         
        } success:^(NSURLSessionDataTask *task, MBModel *responseObject) {
            [self show:@"设置成功" time:1];
        
            [self setTableHeadView:_day_info];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error);
            [self show:@"请求失败！" time:1];
        }];
}
/**
 *  根据开始 和结束时间 计算天数并以 yyyy—MM－dd的date存入数据
 */
- (void)calculateDate{
    
 
    if (_isPregnant) {
        
        /**
         *  若到第38周到40周 之间 提示设置宝宝信息
         */
        NSDate *date =  [_start_date dateByAddingDays:266];
        
        if ([_current_date isLaterThan:date]) {
            _beginParentingButton.hidden = NO;
        }
        
    }else{
    
        
        /**
         *  超过六岁 就显示第一天的数据
         */
        if ( [_current_date daysFrom:_start_date]>[_end_date daysFrom:_start_date]) {
            
            return;
        }
    }

    
    [_dateArray addObject:_current_date];
    
    NSInteger  i =1;
    
    while (i<[_end_date daysFrom:_current_date]+2) {
        
        [_dateArray addObject: [_current_date dateByAddingDays:i]];

        i++;
    }

    
    i=1;
    
    while (i<[_current_date daysFrom:_start_date]) {
        [_dateArray insertObject:[_current_date dateBySubtractingDays:i] atIndex:0];
        i++;
    }
    [_collectionView reloadData];
    
    _reftButton.hidden = NO;
    _leftButton.hidden = NO;
    _row = [_dateArray indexOfObject:_current_date];
    [self collectionViewOffset];
  [self back:nil];

 

}
/**
 *  让collectionView 移动到指定的cell
 */
- (void)collectionViewOffset{
    
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_row inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
}
/**
 *  设置tableView的headView
 *
 *  @param day_info day_info字典
 */
- (void)setTableHeadView:(NSDictionary *)day_info{
    NSString *center = day_info[@"content"];
    self.tableView.tableHeaderView = ({
        CGFloat height = 0;
        if (day_info) {
            height =  123+(UISCREEN_WIDTH - 40)/4+88+[center sizeWithFont:SYSTEMFONT(15) withMaxSize:CGSizeMake(UISCREEN_WIDTH -50, MAXFLOAT)].height;
        }else{
            
            height =  123+(UISCREEN_WIDTH - 40)/4*15/14;
        }
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, height)];
        MBNewBabyHeadView  *headView = [MBNewBabyHeadView instanceView];
        headView.dataDic = day_info;
        if (_baby_image) {
            _images = _baby_image;
            headView.baby_image.image = _baby_image;
        }else{
            if (_isPregnant) {
                headView.came_image.hidden = YES;
                _images = day_info[@"images"];
                
                [headView.baby_image sd_setImageWithURL:URL(day_info[@"images"]) placeholderImage:[UIImage imageNamed:@"headPortrait"]];
                headView.baby_image.userInteractionEnabled = NO;
            }else{
                _images = [MBSignaltonTool getCurrentUserInfo].user_baby_info[@"photo"];
                     headView.came_image.hidden = NO;
                  headView.baby_image.userInteractionEnabled = YES;
                [headView.baby_image sd_setImageWithURL:URL([MBSignaltonTool getCurrentUserInfo].user_baby_info[@"photo"]) placeholderImage:[UIImage imageNamed:@"headPortrait"]];
            
            }
           
        }
        headView.frame = view.frame;
        [view addSubview:headView];
        @weakify(self);
        [[headView.myCircleViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *tag) {
            @strongify(self);
            NSString *url;
            NSString *title;
            switch ([tag integerValue]) {
                case 0: {
                    
                        MBabyRecordController *VC = [[MBabyRecordController alloc] init];
                        VC.image = _images;
                        [self pushViewController:VC Animated:YES];
                    
           
                    return ;
                    
                }break;
                case 1:{
                    
                    url = @"/discovery/knowledge_index";
                    title = @"知识库";
                    
                }break;
                case 2:{
                    
                    url = @"/safefood/category";
                    title = @"能不能吃";
                }break;
                case 3:{
                    
                    NSString *url = @"http://www.xiaomabao.com/tools/jewel.html";
                    MBBabyWebController *VC = [[MBBabyWebController alloc] init];
                    VC.url = URL(url);
                    VC.title = @"百宝箱";
                    [self pushViewController:VC Animated:YES];
                    return;
                    
                }break;
                default:{
                    if (self.baby_id) {
                        
                        [self editImageSelected];
                    }
                    
                    
                }
                    break;
            }
            
            MBBabyWebController *VC = [[MBBabyWebController alloc] init];
            VC.url = URL(string(BASE_URL_root, url));
            VC.title = title;
            [self pushViewController:VC Animated:YES];
            
        }];
        
        view;
    });
    
    
}
#pragma mark -- 跳转登陆页
- (void)loginClicksss{
    //跳转到登录页
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MBLoginViewController *myView = [story instantiateViewControllerWithIdentifier:@"MBLoginViewController"];
    myView.vcType = @"mabao";
    MBNavigationViewController *VC = [[MBNavigationViewController alloc] initWithRootViewController:myView];
    [self presentViewController:VC animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ---UICollectionViewDelagate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dateArray.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MBNewBabyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBNewBabyCell" forIndexPath:indexPath];
    NSDate *date = _dateArray[indexPath.item];
    
    cell.date.text = [NSString stringWithFormat:@"%ld月%ld日", date.month,date.day];
    cell.time.text = [NSString stringWithFormat:@"%ld天", [date daysFrom:_start_date]+1];
    cell.date.font = SYSTEMFONT(16);
    cell.time.font = SYSTEMFONT(12);
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _row = indexPath.row;
    _backTadyButton.hidden = NO;
    
    [self collectionViewOffset];
    NSDate *date = _dateArray[_row];
    [self setToolkit:NO date:[self setDate:date]];

}
#pragma mark ---UITableViewDelagate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if (section==1) {
        
        return [_dataArray[section] count]+1;
    }
    return [_dataArray[section] count];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:  return 65;;
        case 1: {
            if ([_dataArray[indexPath.section] count] == indexPath.row ) {
                return 45;
            }else{
                
                NSArray *arr =  _dataArray[indexPath.section][indexPath.row][@"toolkit_detail"];
                if (arr&&arr.count > 0 ) {
                    if (arr.count >3 ) {
                       return 45 +20*3;
                    }
                   return  45 +20*arr.count;
                }
              
                return 60;
            }
            
        }
        case 2:  return 140;
        default: return (UISCREEN_WIDTH-2)/2*200/375+2+((UISCREEN_WIDTH -6)/4-10)+54;
            
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if ([_dataArray[section] count]==0) {
            return 0;
        }
    }
    
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 2 || section == 3) {
        
        return 60;
    }
    
    return 0.00001;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 50)];
    MBCollectionHeadView  *headView = [MBCollectionHeadView instanceView];
    headView.frame = View.frame;
    switch (section) {
        case 0: headView.tishi.text = @"- 提醒事项 -";     break;
        case 1: headView.tishi.text = @"- 工具 -";         break;
        case 2: headView.tishi.text = @"- 麻包圈推荐 -";    break;
        case 3: headView.tishi.text = @"- 麻包精选活动 -";   break;
        default:
            break;
    }
    
    [View addSubview:headView];
    return View;
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 60);
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    [view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(view.mas_centerY);
        make.height.mas_equalTo(46);
        make.width.mas_equalTo(103);
        
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(footerGes:)];
    imageView.tag = section;
    [imageView addGestureRecognizer:tap];
    if (section == 2) {
        
        imageView.image = [UIImage imageNamed:@"axiajiao1"];
     

        
    }else if (section == 3){
        
        imageView.image = [UIImage imageNamed:@"axiajiao2"];
        
    }
    
    
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0: {
            
            MBNewBabyOneTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBNewBabyOneTableCell"];
            
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"MBNewBabyOneTableCell"owner:nil options:nil]firstObject];
            }
            
            [self setUIEdgeInsetsZero:cell];
            cell.dataDic = _dataArray[indexPath.section][indexPath.row];
            return cell;
        }
        case 1: {
            
            if ([_dataArray[indexPath.section] count] == indexPath.row) {
                MBNewBabyTwoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBNewBabyOneTableCell"];
                if (!cell) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"MBNewBabyTwoTableCell"owner:nil options:nil]firstObject];
                }
                [self setUIEdgeInsetsZero:cell];
                return cell;
            }
            
            
            MBBabyToolCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBBabyToolCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"MBBabyToolCell"owner:nil options:nil]firstObject];
            }
            cell.dataDic = _dataArray[indexPath.section][indexPath.row];
            [self setUIEdgeInsetsZero:cell];
            return cell;
        }
        case 2: {
            MBNewBabyThreeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBNewBabyThreeTableCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"MBNewBabyThreeTableCell"owner:nil options:nil]firstObject];
            }
            cell.dataDic = _dataArray[indexPath.section][indexPath.row];
            [self setUIEdgeInsetsZero:cell];
            return cell;
        }
            
        default: {
            MBNewBabyFourTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBNewBabyFourTableCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"MBNewBabyFourTableCell"owner:nil options:nil]firstObject];
            }
            cell.VC = self;
            cell.dataArr = _dataArray[indexPath.section][0];
            [self setUIEdgeInsetsZero:cell];
            return cell;
        }
            
            
    }
    
    
}
- (void)footerGes:(UITapGestureRecognizer *)sender {
    if (sender.view.tag ==2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabBarBtn_selected" object:nil userInfo:@{@"selected":@"3"}];
        self.tabBarController.selectedIndex = 3;
    }else if (sender.view.tag== 3){
     [[NSNotificationCenter defaultCenter] postNotificationName:@"tabBarBtn_selected" object:nil userInfo:@{@"selected":@"2"}];
       self.tabBarController.selectedIndex = 2;
    
    }
}
/**
 *  让cell地下的边线挨着左边界
 */
- (void)setUIEdgeInsetsZero:(UITableViewCell *)cell{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins   = false;
    
}
/**
 *  移除cell最下的线
 */
- (void)setRemoveUIEdgeInsetsZero:(UITableViewCell *)cell{
    cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);
    cell.layoutMargins = UIEdgeInsetsMake(0, 10000, 0, 0);
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    switch (indexPath.section) {
        case 0: {
            MBBabyWebController *VC = [[MBBabyWebController alloc] init];
            VC.url = URL(_dataArray[indexPath.section][indexPath.row][@"url"]);
            VC.title = _dataArray[indexPath.section][indexPath.row][@"title"];
            [self pushViewController:VC Animated:YES];
        }break;
        case 1: {
            if ([_dataArray[indexPath.section] count] == indexPath.row ) {
                
                MBBabyWebController *VC = [[MBBabyWebController alloc] init];
                VC.url = URL(string(BASE_URL_root, @"/mengbao/toolkit"));
                VC.title = @"添加工具到首页";
                @weakify(self);
                [[VC.myCircleViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString *str) {
                    @strongify(self);
                    [self setToolkit:YES date:nil];
                }];
                [self pushViewController:VC Animated:YES];
            }else{
                NSDictionary *dic = _dataArray[indexPath.section][indexPath.row];
                MBBabyWebController *VC = [[MBBabyWebController alloc] init];
                VC.url = URL(dic[@"toolkit_url"]);
                VC.title = dic[@"toolkit_name"];
                [self pushViewController:VC Animated:YES];
                
            }
            
            
        }break;
        case 2: {
         
            MBPostDetailsViewController *VC = [[MBPostDetailsViewController   alloc] init];
            VC.post_id = _dataArray[indexPath.section][indexPath.row][@"post_id"];
            [self pushViewController:VC Animated:YES];
            
        }break;
        case 3: {
            
            
            
        }break;
        default:
            break;
    }
}
- (void)photoKitController:(STPhotoKitController *)photoKitController resultImage:(UIImage *)resultImage
{
    _baby_image = resultImage;
    [self setBabyImage];

    
}
#pragma mark - 2.UIImagePickerController的委托

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *imageOriginal = [info objectForKey:UIImagePickerControllerOriginalImage];
        STPhotoKitController *photoVC = [[STPhotoKitController alloc] init];
        [photoVC setDelegate:self];
        [photoVC setImageOriginal:imageOriginal];
        
        [photoVC setSizeClip:CGSizeMake(300, 300)];
       
        [self presentViewController:photoVC animated:YES completion:nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
        
    }];
}

#pragma mark - --- event response 事件相应 ---
- (void)editImageSelected
{
    UIAlertController *alertController = [[UIAlertController alloc]init];
    
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *controller = [UIImagePickerController imagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        
        if ([controller isAvailableCamera] && [controller isSupportTakingPhotos]) {
            [controller setDelegate:self];
            [self presentViewController:controller animated:YES completion:nil];
        }else {
            NSLog(@"%s %@", __FUNCTION__, @"相机权限受限");
        }
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"从相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *controller = [UIImagePickerController imagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [controller setDelegate:self];
        if ([controller isAvailablePhotoLibrary]) {
            [self presentViewController:controller animated:YES completion:nil];
        }    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:action0];
    [alertController addAction:action1];
    [alertController addAction:action2];
    
    [self presentViewController:alertController animated:YES completion:nil];
}



/**
 *  根据字符串时间获取时间戳
 *
 *  @param dateStr 字符串时间
 *
 *  @return NSTimeInterval
 */
- (NSDate *)setDateStr:(NSString *)dateStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter  dateFromString:dateStr];
    return date;
}

- (NSString *)setDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
   return  [formatter stringFromDate:date];


}
@end
