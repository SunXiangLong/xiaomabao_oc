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
#import "MBBabysDiaryViewController.h"
#import "MBBabyDueDateController.h"
#import "MBBabyToolCell.h"
#import "MBCollectionViewFlowLayout.h"
#import "STPhotoKitController.h"
#import "UIImagePickerController+ST.h"
#import "MBPostDetailsViewController.h"
#import "MBpreparePregnantSetViewController.h"
#import "MBLovelyBabyModel.h"
#import "MBBabyGenderViewController.h"
@interface MBNewBabyController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,STPhotoKitDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    /**
     *  是否从下个界面返回的
     */
    BOOL _isDismiss;
    
    /**
     *  修改的宝宝头像
     */
    UIImage *_baby_image;

    /**
     *  宝宝头像
     */
    id _images;
    
    NSInteger _row;
    
    
    UIImageView *_guideImageView;
    NSInteger _guideImageIndex;

   
}
/**
 *  顶部view
 */
@property (weak, nonatomic) IBOutlet UIView *topView;
/**
 *  日期选择view
 */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

/**
 设置宝宝信息button
 */
@property (weak, nonatomic) IBOutlet UIButton *beginParentingButton;

/**
 回到今天button
 */
@property (weak, nonatomic) IBOutlet UIButton *backTadyButton;
/**
 *  底层展示控件
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *babyStatleTableVIew;
@property (weak, nonatomic) IBOutlet UIView *babtStatle;

/**
 上一个日期button
 */
@property (weak, nonatomic) IBOutlet UIButton *reftButton;
/**
 下一个日期button
 */
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
/**
 *  宝宝id
 */
@property (nonatomic, copy)  NSString *baby_id;

/**
 我的状态分类数据
 */
@property (nonatomic,copy) NSArray *datArr;

///**
// 我的状态
// */
//@property (nonatomic,assign) MBStateOfTheBaby type;
@property (nonatomic,strong) RACSignal *toolSignal;
@property (nonatomic,strong) RACSignal *baySignal;

@property (nonatomic,strong) MBLovelyBabyModel *lovelyBabyModel;

@property (copy, nonatomic) NSMutableArray *dataArray;
@property (copy, nonatomic) NSMutableArray *dateArray;
@end

@implementation MBNewBabyController
-(NSArray *)datArr{
    if (!_datArr) {
        _datArr = @[
                    @{@"title":@"备孕中",@"summary":@"我在备孕中做好准备，迎接宝宝到来",@"icon": [UIImage imageNamed:@"forPregnant"]},
                    @{@"title":@"我在怀孕中",@"summary":@"怀胎十月，关爱母婴健康",@"icon": [UIImage imageNamed:@"babyUnborn"]},
                    @{@"title":@"宝宝已出生",@"summary":@"产后调养与恢复，和宝宝共同健康成长",@"icon": [UIImage imageNamed:@"babyBorn"]}
                    
                    ];
    }
    return _datArr;
}
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
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    _babtStatle.hidden = true;
    self.navBar.title = @"";
    /**
     *  判断用户是否登陆和设置过宝宝信息
     */
    if ([MBSignaltonTool getCurrentUserInfo].is_baby_add) {
        
        _baby_id = [MBSignaltonTool getCurrentUserInfo].user_baby_info.Id;
        /**
         *  判断是不是第二次进入这个界面 且用户状态没发生改变 就不在重请求数据
         */
        
        if (![sid isEqualToString:_oldSid]){
            
            /**
             *  第二次进入界面且登陆状态改变 上一次进入是否请求到z数据 有就清空
             */
 
            
            self.toolSignal = [self requestDataToolkitSignal];
            self.baySignal = [self requestDataLovelyBabySignal:nil];
            [self bindModel];
            _oldSid = sid;
            
        }else{
            
            if (!_lovelyBabyModel) {
                self.toolSignal = [self requestDataToolkitSignal];
                self.baySignal = [self requestDataLovelyBabySignal:nil];
                  [self bindModel];
            }
            
        }
        
    }else{
        self.navBar.title = @"宝宝状态";
        _babyStatleTableVIew.tableFooterView = [[UIView alloc] init];
        _babtStatle.hidden = false;
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
    [self.collectionView registerNib:[UINib nibWithNibName:@"MBNewBabyCell" bundle:nil] forCellWithReuseIdentifier:@"MBNewBabyCell"];

    
}

- (void)bindModel{

    [[RACSignal combineLatest:@[RACObserve(self, baySignal),RACObserve(self, toolSignal)] reduce:^id(RACSignal *signBaby,RACSignal *signTool){
        
        
        return [[RACSignal combineLatest:@[signBaby,signTool] reduce:^id(MBLovelyBabyModel *model,NSDictionary *dic){
             model.toolArr  =   [NSArray modelDictionary:dic modelKey:@"data" modelClassName:@"MBMyToolModel"];
             model.isHiddenTool = [dic[@"hidden"] boolValue];
            return model;
        }] subscribeNext:^(MBLovelyBabyModel *model) {
            
            if (model) {
                
             
                _lovelyBabyModel = model;
                [self calculateDate];
                if (_dataArray.count == 4) {
                    
                    NSMutableArray *arr = [NSMutableArray array];
                    [arr addObject:_dataArray.lastObject[0][0]];
                    [arr addObject:_dataArray.lastObject[0][1]];
                    [arr addObjectsFromArray:model.recommend_goods];
                    self.dataArray[0] = model.remind;
                    self.dataArray[1] = model.toolArr;
                    self.dataArray[3] = @[arr];
                }else{
                    
                    
                    NSMutableArray *arr = [NSMutableArray array];
                    [arr addObjectsFromArray:model.recommend_topics];
                    [arr addObjectsFromArray:model.recommend_goods];
                    [self.dataArray addObjectsFromArray:@[model.remind,model.toolArr,model.recommend_posts,@[arr]]];
                }
               
                [self setTableHeadView];
                [self.tableView reloadData];
            
                
                if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isGuide"]) {
                    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT)];
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageIndex)];
                    image.image = [UIImage imageNamed:string(@"guideImage", s_Integer(_guideImageIndex))];
                    image.userInteractionEnabled = true;
                    [image addGestureRecognizer:tap];
                    [[UIApplication  sharedApplication].keyWindow addSubview:_guideImageView = image];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"isGuide" forKey:@"isGuide"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                }

                
            }
        }];
    }] subscribeNext:^(MBLovelyBabyModel *model) {}];


}
- (IBAction)button:(UIButton *)sender {
    
    if ([sender isEqual:_backTadyButton]) {
        _row = [_dateArray indexOfObject:[NSDate date]];
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_row inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        self.toolSignal = [self requestDataToolkitSignal];
        self.baySignal = [self requestDataLovelyBabySignal: [NSString dateConversionString:[NSDate date]]];
    
    }else{
    
        [self performSegueWithIdentifier:@"MBBabyGenderViewController" sender:_baby_id];
    }
    
    sender.hidden= YES;
}





- (IBAction)back:(UIButton *)sender {
    
    
    
    if (_row == 0) {
        return;
    }
    if ([_dateArray[_row] isEqualToDate:_lovelyBabyModel.currentDate ]) {
        _backTadyButton.hidden = YES;
    }
    _row --;
    [self collectionViewOffset];
    NSDate *date = _dateArray[_row];
    
    _backTadyButton.hidden = NO;
    self.toolSignal = [self requestDataToolkitSignal];
    self.baySignal = [self requestDataLovelyBabySignal:[NSString dateConversionString:date]];
    
//    [self setToolkit:NO date:[self setDate:date]];
    
    
}
- (IBAction)next:(UIButton *)sender {
    
    if (_row == _dateArray.count-1) {
        return;
    }
    if ([_dateArray[_row] isEqualToDate:_lovelyBabyModel.currentDate ]) {
        _backTadyButton.hidden = YES;
    }
    _row ++;
    [self collectionViewOffset];
    NSDate *date = _dateArray[_row];
    if (sender) {
        _backTadyButton.hidden = NO;
        self.toolSignal = [self requestDataToolkitSignal];
        self.baySignal = [self requestDataLovelyBabySignal:[NSString dateConversionString:date]];
//        [self setToolkit:NO date:[self setDate:date]];
    }
    
    
    
    
}


-(void)imageIndex{
    _guideImageIndex++;
    if (_guideImageIndex == 5) {
        _guideImageView.hidden = true;
        return;
    }
    _guideImageView.image = [UIImage imageNamed:string(@"guideImage", s_Integer(_guideImageIndex))];
    
}

/**
 获取工具数据源

 @return 工具数据源Signal
 */
- (RACSignal *)requestDataToolkitSignal{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSDictionary *parameters = @{@"session":[MBSignaltonTool getCurrentUserInfo].sessiondict};
     
        [MBNetworking   POSTOrigin:string(BASE_URL_root, @"/mengbao/get_user_toolkit_v2") parameters:parameters success:^(id responseObject) {
            [subscriber sendNext:responseObject];
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
}


/**
 获取萌宝数据源

 @param date 萌宝数据源Signal
 @return 日期
 */
- (RACSignal *)requestDataLovelyBabySignal:(NSString *)date{
    

    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        NSDictionary *parameters = @{@"session":[MBSignaltonTool getCurrentUserInfo].sessiondict};
        if (date) {
            parameters = @{@"session":[MBSignaltonTool getCurrentUserInfo].sessiondict,@"current_date":date};
        }
        [MBNetworking   POSTOrigin:string(BASE_URL_root, @"/mengbao/get_index_info") parameters:parameters success:^(id responseObject) {
            [subscriber sendNext:[MBLovelyBabyModel yy_modelWithDictionary:responseObject]];
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
    
}

/**上传宝宝头像 */
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
        [self setTableHeadView];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败！" time:1];
    }];
}
/**
 *  根据开始 和结束时间 计算天数并以 yyyy—MM－dd的date存入数据
 */
- (void)calculateDate{
    
    if (self.dateArray.count > 0) {
        return;
    }
    
    switch (_lovelyBabyModel.stateBabyType) {
        case isPregnantBaby:{

            // 若到第38周到40周 之间 提示设置宝宝信息
            NSDate *date =  [_lovelyBabyModel.startDate  dateByAddingDays:266];
            
            if ([_lovelyBabyModel.currentDate isLaterThan:date]) {
                _beginParentingButton.hidden = NO;
            }
            
        }break;
        case theBabyIsBorn:{
            //超过六岁 就显示第一天的数据
            if ( [_lovelyBabyModel.currentDate daysFrom:_lovelyBabyModel.startDate]>[_lovelyBabyModel.endDate daysFrom:_lovelyBabyModel.startDate]) {
                
                return;
            }
            
        }break;
        default:
            break;
    }
    
    
    
    NSInteger  i = 0;
    
    while (i<[_lovelyBabyModel.endDate daysFrom:_lovelyBabyModel.currentDate]) {
        
        [_dateArray addObject: [_lovelyBabyModel.currentDate dateByAddingDays:i]];
        
        i++;
    }
    
    i = 1;
    
    while (i<[_lovelyBabyModel.currentDate daysFrom:_lovelyBabyModel.startDate]) {
        
        [_dateArray insertObject:[_lovelyBabyModel.currentDate dateBySubtractingDays:i] atIndex:0];
        i++;
    }
    [_dateArray insertObject:_lovelyBabyModel.startDate atIndex:0];
    [_dateArray insertObject:[_lovelyBabyModel.startDate dateBySubtractingDays:1] atIndex:0];
   
    
    [_collectionView reloadData];
    
    _reftButton.hidden = NO;
    _leftButton.hidden = NO;
    _row = [_dateArray indexOfObject:_lovelyBabyModel.currentDate];
    [self collectionViewOffset];
    
    
    
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
- (void)setTableHeadView{
    self.tableView.tableHeaderView = ({

        MBNewBabyHeadView  *headView = [MBNewBabyHeadView instanceView];
        headView.image = _baby_image;
        headView.model = _lovelyBabyModel.day_info;
        [headView layoutIfNeeded];
        headView.mj_w =  UISCREEN_WIDTH;
        headView.mj_h = _lovelyBabyModel.stateBabyType == readyToPregnantBaby?headView.preparePregnantView.ml_maxY :headView.functionalClassificationView.ml_maxY;
 
        @weakify(self);
        headView.sortingOptionsEvent = ^(NSDictionary *dic,MBBlockState type) {
            @strongify(self);
            switch (type) {
                case theJumpPage:{
                
                    MBBabyWebController *VC = [[MBBabyWebController alloc] init];
                    VC.url = dic[@"url"];
                    VC.title = dic[@"title"];;
                    [self pushViewController:VC Animated:YES];
                
                }break;
                case recordTheBaby:{
                    
                    [self performSegueWithIdentifier:@"MBBabysDiaryViewController" sender:nil];
                    
                }break;
                case setHead:{
                    if (self.baby_id) {
    
                        [self editImageSelected];
                    }
                    
                }break;
                case setThePregnancy:{
                    
                     [self performSegueWithIdentifier:@"MBpreparePregnantSetViewController" sender:self.baby_id];
                    
                }break;
                case setTheDueDate:{
                   
                    MBBabyDueDateController *VC = [[MBBabyDueDateController alloc] init];
                    VC.baby_id = _baby_id;
                    VC.setUpAfterTheMaternalRefresh = ^{
                        [self.dataArray removeAllObjects];
                        self.toolSignal = [self requestDataToolkitSignal];
                        self.baySignal  =  [self requestDataLovelyBabySignal:nil];
                    };
                    [self pushViewController:VC Animated:YES];
                    
                }break;
                default:
                    break;
            }
            
            
            

        };

        
        headView;
    });
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ---UICollectionViewDelagate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.dateArray.count > 0) {
        return 1;
    }
    return 0;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dateArray.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MBNewBabyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBNewBabyCell" forIndexPath:indexPath];
    NSDate *date = _dateArray[indexPath.item];
    cell.date.text = [NSString stringWithFormat:@"%ld月%ld日",[date month], [date day]];
    cell.time.text = [NSString stringWithFormat:@"%ld天", [date daysFrom:_lovelyBabyModel.startDate] + 1];
    cell.date.font = SYSTEMFONT(16);
    cell.time.font = SYSTEMFONT(12);
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _row = indexPath.row;
    _backTadyButton.hidden = NO;
    [self collectionViewOffset];
    NSDate *date = _dateArray[_row];
    self.toolSignal = [self requestDataToolkitSignal];
    self.baySignal = [self requestDataLovelyBabySignal: [NSString dateConversionString:date]];

    
}
#pragma mark ---UITableViewDelagate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 1) {
        return 1;
    }
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 1) {
        return self.datArr.count;
    }
    
    
    if (section == 1) {
        if (_lovelyBabyModel.isHiddenTool) {
           
            return 0;
        }
        
        return [_dataArray[section] count]+1;
    }
    
    return [_dataArray[section] count];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1) {
        return 75;
    }
    
    switch (indexPath.section) {
        case 0:  return 65;;
        case 1: {
            if ([_dataArray[indexPath.section] count] == indexPath.row ) {
                return 45;
            }else{
                MBMyToolModel *model = ( MBMyToolModel *) _dataArray[indexPath.section][indexPath.row];
                NSArray *arr =   model.toolkit_detail;
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
    if (tableView.tag == 1) {
        return 0;
    }
    
    if (section == 0) {
        if ([_dataArray[section] count] == 0) {
            
            return 0;
        }
    }
    if (section == 1) {
        if (_lovelyBabyModel.isHiddenTool) {
            return 0;
        }
    }
    
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView.tag == 1) {
        return 0;
    }
    if (section == 2 || section == 3) {
        
        return 60;
    }
    
    return 0.00001;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 1) {
        return nil;
    }
    
    if (section==1) {
        if (_lovelyBabyModel.isHiddenTool) {
            return nil;
        }
    }
    UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 50)];
    MBCollectionHeadView  *headView = [MBCollectionHeadView instanceView];
    headView.frame = View.frame;
    switch (section) {
        case 0: headView.tishi.text = @"- 提醒事项 -";     break;
        case 1: headView.tishi.text = @"- 工具 -";         break;
        case 2: headView.tishi.text = @"- 麻包圈推荐 -";    break;
        case 3: headView.tishi.text = @"- 麻包精选活动 -";   break;
        default:break;
    }
    
    [View addSubview:headView];
    return View;
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView.tag == 1) {
        return nil;
    }
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
    if (tableView.tag == 1) {
        MBNewBabyOneTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBNewBabyOneTableCell"];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MBNewBabyOneTableCell"owner:nil options:nil]firstObject];
        }
        cell.dataDic = _datArr[indexPath.row];
        [cell uiedgeInsetsZero];
        return cell;
    }
    switch (indexPath.section) {
        case 0: {
            
            MBNewBabyOneTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBNewBabyOneTableCell"];
            
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"MBNewBabyOneTableCell"owner:nil options:nil]firstObject];
            }
            
            [cell uiedgeInsetsZero];
            cell.model = _dataArray[indexPath.section][indexPath.row];
            return cell;
        }
        case 1: {
            
            if ([_dataArray[indexPath.section] count] == indexPath.row) {
                MBNewBabyTwoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBNewBabyOneTableCell"];
                if (!cell) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"MBNewBabyTwoTableCell"owner:nil options:nil]firstObject];
                }
                [cell uiedgeInsetsZero];
                return cell;
            }
            
            
            MBBabyToolCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBBabyToolCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"MBBabyToolCell"owner:nil options:nil]firstObject];
            }
            cell.model = _dataArray[indexPath.section][indexPath.row];
            [cell uiedgeInsetsZero];
            return cell;
        }
        case 2: {
            MBNewBabyThreeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBNewBabyThreeTableCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"MBNewBabyThreeTableCell"owner:nil options:nil]firstObject];
            }
            cell.model = _dataArray[indexPath.section][indexPath.row];
            [cell uiedgeInsetsZero];
            return cell;
        }
            
        default: {
            MBNewBabyFourTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBNewBabyFourTableCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"MBNewBabyFourTableCell"owner:nil options:nil]firstObject];
            }
            cell.VC = self;
            cell.dataArr = _dataArray[indexPath.section][0];
            [cell uiedgeInsetsZero];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    if (!sid) {
        [self loginClicksss:@"mabao"];
        return;
    }
    if (tableView.tag ==1) {
        if (indexPath.row ==  0){
            
            
            [self performSegueWithIdentifier:@"MBpreparePregnantSetViewController" sender:nil];
        }else  if (indexPath.row == 1) {
            [MobClick event:@"Mengbao0"];
            MBBabyDueDateController *VC = [[MBBabyDueDateController alloc] init];
            [self pushViewController:VC Animated:YES];
        }else{
            [MobClick event:@"Mengbao1"];
            
            [self performSegueWithIdentifier:@"MBBabyGenderViewController" sender:nil];
        }
        return;
    }
    switch (indexPath.section) {
        case 0: {
            
            [MobClick event:@"Mengbao4"];
            MBBabyWebController *VC = [[MBBabyWebController alloc] init];
            VC.url = URL(_dataArray[indexPath.section][indexPath.row][@"url"]);
            VC.title = _dataArray[indexPath.section][indexPath.row][@"title"];
            [self pushViewController:VC Animated:YES];
        }break;
        case 1: {
            if ([_dataArray[indexPath.section] count] == indexPath.row ) {
                [MobClick event:@"Mengbao5"];
                MBBabyWebController *VC = [[MBBabyWebController alloc] init];
                VC.url = URL(string(@"http://api.xiaomabao.com", @"/mengbao/toolkit"));
                VC.title = @"添加工具到首页";
                @weakify(self);
                [[VC.myCircleViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString *str) {
                    @strongify(self);
                    self.toolSignal = [self requestDataToolkitSignal];
//                    [self setToolkit:YES date:nil];
                }];
                [self pushViewController:VC Animated:YES];
            }else{
                [MobClick event:@"Mengbao5"];
                NSDictionary *dic = _dataArray[indexPath.section][indexPath.row];
                MBBabyWebController *VC = [[MBBabyWebController alloc] init];
                VC.url = URL(dic[@"toolkit_url"]);
                VC.title = dic[@"toolkit_name"];
                [self pushViewController:VC Animated:YES];
                
            }
            
            
        }break;
        case 2: {
            [MobClick event:@"Mengbao6"];
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


#pragma mark - STPhotoKitDelegate
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
            MMLog(@"%s %@", __FUNCTION__, @"相机权限受限");
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {    
    if (sender) {
        
        if ([segue.identifier isEqualToString:@"MBpreparePregnantSetViewController"]) {
            MBpreparePregnantSetViewController *VC  =  [segue destinationViewController];
            WS(weakSelf)
            VC.afterTheDateSetForPregnantRefreshAgain = ^{
                [_dataArray removeAllObjects];
                weakSelf.toolSignal = [self requestDataToolkitSignal];
                weakSelf.baySignal  =  [self requestDataLovelyBabySignal:nil];
            };
        }else if ([segue.identifier isEqualToString:@"MBBabyGenderViewController"]){
        
            MBBabyGenderViewController *VC  =  [segue destinationViewController];
            VC.baby_id = sender;
            WS(weakSelf)
            [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"setTheBabyInformationToCompleteTheRefresh" object:nil] subscribeNext:^(id x) {
                [_dataArray removeAllObjects];
                weakSelf.toolSignal = [self requestDataToolkitSignal];
                weakSelf.baySignal  =  [self requestDataLovelyBabySignal:nil];
            }];

            
        
        }
       
        
    }
}
@end
