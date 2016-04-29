//
//  MBMyCircleController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBMyCircleController.h"
#import "MBMyCircleView.h"
#import "MBMycircleTableViewCell.h"
#import "MBShopingViewController.h"
#import "MBActivityViewController.h"
#import "MBWebViewController.h"
#import "MBGroupShopController.h"
@interface MBMyCircleController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{

    
    NSArray *_bandImageArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSMutableArray *myArray;
@property (copy, nonatomic) NSMutableArray *recommendedMyArray;
@end

@implementation MBMyCircleController
-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    [MobClick beginLogPageView:@"MBMyCircleController"];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [MobClick endLogPageView:@"MBMyCircleController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _myArray = [NSMutableArray arrayWithObjects:@1,@2,@3, nil];
    _recommendedMyArray = [NSMutableArray arrayWithObjects:@1,@2,@3,@4, nil];
    _tableView.tableHeaderView = [self setHeaderView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}
/**
 *  广告轮播图
 *
 *  @return
 */
- (UIView *)setHeaderView{
    UIView *view =[[UIView alloc] init];
    view.frame = CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_WIDTH*33/75+125);
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH,UISCREEN_WIDTH*33/75) delegate:self     placeholderImage:[UIImage imageNamed:@"placeholder_num3"]];
    cycleScrollView.imageURLStringsGroup =@[@"",@"",@""];
    cycleScrollView.autoScrollTimeInterval = 3.0f;
    [view addSubview:cycleScrollView];
    
    MBMyCircleView *view1 = [MBMyCircleView instanceView];
    view1.frame = CGRectMake(0, MaxY(cycleScrollView), UISCREEN_WIDTH, 125);
    [view addSubview:view1];

    @weakify(self);
    [[view1.myCircleViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *number) {
//        NSLog(@"%ld",[number integerValue]);
        @strongify(self);
        
    }];
    return view;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    NSInteger ad_type = [_bandImageArray[index][@"ad_type"] integerValue];
    
    
    switch (ad_type) {
        case 1: {
            MBActivityViewController *VC = [[MBActivityViewController alloc] init];
            VC.act_id = _bandImageArray[index][@"act_id"];
            VC.title = _bandImageArray[index][@"ad_name"];
            [self pushViewController:VC Animated:YES];
        }break;
        case 2: {
            
            MBShopingViewController *VC = [[MBShopingViewController alloc] init];
            VC.GoodsId = _bandImageArray[index][@"ad_con"];
            VC.title = _bandImageArray[index][@"ad_name"];
            [self pushViewController:VC Animated:YES];
        }break;
        case 3: {
            MBWebViewController *VC = [[MBWebViewController alloc] init];
            VC.url =  [NSURL URLWithString:_bandImageArray[index][@"ad_con"]];
            VC.title = _bandImageArray[index][@"ad_name"];
            [self pushViewController:VC Animated:YES];
            
        }break;
        case 4: {
            
            MBGroupShopController *VC = [[MBGroupShopController alloc] init];
            VC.title = _bandImageArray[index][@"ad_name"];
            
            [self pushViewController:VC Animated:YES];
            
        }break;
        case 5: {
            
        }break;
        default: break;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {
        if (_myArray.count==0) {
            return 1;
        }
        return  _myArray.count;
    
    }else{
        return _recommendedMyArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {

        return 41;
    }
    
    if (_recommendedMyArray.count == 0) {
        return 0;
    }
    return 41;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 41);
    UIView *backTopView = [[UIView alloc] init];
    backTopView.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 10);
    backTopView.backgroundColor = BACKColor;
    [view addSubview:backTopView];
    UILabel *lable = [[UILabel alloc] init];
    lable.font =  YC_YAHEI_FONT(16);
    lable.textColor = UIcolor(@"575c65");
    [view addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.centerY.mas_equalTo(5);
    }];
    
    NSString *numStr = s_Integer(_myArray.count);
    NSString *comment_content = [NSString stringWithFormat:@"我的麻包圈(%@)",numStr];
 
    
    NSRange range = [comment_content rangeOfString:numStr];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:comment_content];
    [att addAttributes:@{NSForegroundColorAttributeName:UIcolor(@"d66263")}  range:NSMakeRange(6, range.length)];
    [att addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} range:NSMakeRange(6, range.length )];
   

    if (section == 0) {
        lable.text = comment_content;
         lable.attributedText  = att;
        
    }else{
    lable.text = @"推荐麻包圈";
    }
    
    UIImageView *image = [[UIImageView alloc] init];
    image.backgroundColor = UIcolor(@"eaeaea");
    [view addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MBMycircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBMycircleTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBMycircleTableViewCell"owner:nil options:nil]firstObject];
    }
    cell.indexPath = indexPath;
    
  
    if (indexPath.section ==1) {
        [cell.user_button setTitle:@"+" forState:UIControlStateNormal];
        cell.user_button.titleLabel.font = BOLDSYSTEMFONT(30);
        [cell.user_button setBackgroundColor:[UIColor whiteColor]];
    }else{
        if (_myArray.count==0) {
            cell.noLable.hidden = NO;
            cell.selectionStyle =  UITableViewCellSelectionStyleNone;
            cell.exclusiveTouch = NO;
        }
    }
    
    @weakify(self);
    [[cell.myCircleCellSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSIndexPath *indexPath) {
         @strongify(self);
        if (indexPath.section==0) {
            [self prompt:indexPath];
            
        }else{
            [_myArray addObject:_recommendedMyArray[indexPath.row]];
            [_recommendedMyArray removeObjectAtIndex:indexPath.row];
            [self show:@"成功加入 " and:@"1-3岁宝宝" time:1];
            [self.tableView reloadData];
        }
    }];
    return cell;
    
  
 

    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)prompt:(NSIndexPath *)indexPath{
    
    NSString *str = @"1-3岁宝宝";
    NSString *str1 = [NSString stringWithFormat:@"你确定退出%@?",str];
    NSRange range = [str1 rangeOfString:str];
    //修改title
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:str1];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:UIcolor(@"d66263") range:NSMakeRange(range.location, range.length)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(range.location, range.length)];
   
    
    UIAlertController *alertCancel = [UIAlertController alertControllerWithTitle:str1 message:nil preferredStyle:UIAlertControllerStyleAlert];
  
    [alertCancel setValue:alertControllerStr forKey:@"attributedTitle"];
    
    UIAlertAction *reloadAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        [_myArray removeObjectAtIndex:indexPath.row];
       [self show:@"成功退出 " and:@"1-3岁宝宝" time:1];
        [self.tableView reloadData];
      
    }];
    [reloadAction setValue:UIcolor(@"575c65") forKey:@"titleTextColor"];

    UIAlertAction *reloadAction1 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertCancel addAction:reloadAction];
    [alertCancel addAction:reloadAction1];
    [reloadAction1 setValue:UIcolor(@"d66263") forKey:@"titleTextColor"];
    [self presentViewController:alertCancel animated:YES completion:nil];
}

#pragma mark ---让tabview的headview跟随cell一起滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 41;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
    _tableView.editing = NO;
    
}
-(void)show:(NSString *)str1 and:(NSString *)str2 time:(NSInteger)timer{

    NSString *comment_content = [NSString stringWithFormat:@"%@ %@",str1,str2];
    NSRange range = [comment_content rangeOfString:str2];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:comment_content];
    [att addAttributes:@{NSForegroundColorAttributeName:UIcolor(@"d66263")}  range:NSMakeRange(5, range.length)];
    [att addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} range:NSMakeRange(5, range.length )];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    UILabel *lable =    [hud valueForKeyPath:@"label"];
    
    hud.color = RGBCOLOR(219, 171, 171);
    hud.mode = MBProgressHUDModeText;
    hud.labelText = comment_content;
    hud.labelColor = UIcolor(@"575c65");
    lable.attributedText = att;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.minSize = CGSizeMake(235, 70);
    [hud hide:YES afterDelay:timer];
    [self dismiss];
    
}
@end
