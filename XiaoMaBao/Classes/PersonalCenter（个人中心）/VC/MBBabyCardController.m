//
//  MBBabyCardController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBabyCardController.h"
#import "MBBabyCardCell.h"
#import "MBDindingBabyCardController.h"
#import "MaBaoCardModel.h"
@interface MBBabyCardController ()
{
    
    NSInteger _page;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottom;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIView *showView;
@property (copy, nonatomic) NSMutableArray<MaBaoCardModel *> *dataArray;
@property (copy, nonatomic) NSMutableArray *recordSelectedArray;
@end

@implementation MBBabyCardController
-(NSMutableArray<MaBaoCardModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (RACSubject *)myCircleViewSubject {
    
    if (!_myCircleViewSubject) {
        
        _myCircleViewSubject = [RACSubject subject];
    }
    
    return _myCircleViewSubject;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 1;
    [self setData];
    
    self.navBar.rightButton.titleLabel.font = YC_RTWSYueRoud_FONT(15);
    self.navBar.rightButton.mj_w = 90;
    self.navBar.rightButton.mj_x = UISCREEN_WIDTH - 90;
    self.navBar.rightButton.mj_y = 23;
    _tableView.tableFooterView = [[UIView alloc] init];
    
}
-(NSString *)titleStr{
    
    return  _isJustLookAt?@"查看麻包卡":@"选择使用的麻包卡";
}

-(NSString *)rightStr{
    
    return @"绑定新卡";
}
-(void)rightTitleClick{
    
    @weakify(self);
    MBDindingBabyCardController *VC = [[MBDindingBabyCardController alloc] init];
    [[VC.myCircleViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSDictionary *coupon) {
        @strongify(self);
        _page = 1;
        [self.dataArray removeAllObjects];
        [self setData];
        
    }];
    [self pushViewController:VC Animated:YES];
    
    
}
/**
 *  选择麻包卡并使用  可以多选
 *
 *
 */
- (IBAction)bindUses:(id)sender {
    NSMutableArray *selectArray = [NSMutableArray array];
    
    [self.dataArray enumerateObjectsUsingBlock:^(MaBaoCardModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.isSelected) {
            [selectArray addObject:obj];
        }
    }];
    
    
    [self.myCircleViewSubject sendNext:selectArray];
    
    [self popViewControllerAnimated:YES];
    
}
/**
 *  请求麻包卡数据
 */
- (void)setData{
    
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *session = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSString *page = [NSString stringWithFormat:@"%ld",_page];
    [self show];
    [MBNetworking  POSTOrigin:string(BASE_URL_root, @"/mcard/mlist") parameters:@{@"session":session,@"page":page} success:^(id responseObject) {
        [self dismiss];
        
        NSArray *modelArr = [NSArray modelDictionary:responseObject modelKey:@"data" modelClassName:@"MaBaoCardModel"];
        if (_page == 1) {
            if (modelArr&&modelArr.count > 0) {
                MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(setData)];
                footer.refreshingTitleHidden = YES;
                self.tableView.mj_footer = footer;
            }else{
                _showView.hidden = false;
                return ;
            }
            
        }else{
            if (self.tableView.mj_footer) {
                [self.tableView.mj_footer endRefreshing];
            }
            
            if (!(modelArr&&modelArr.count > 0)) {
                 [self.tableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            
        }
        
        if (_isJustLookAt) {
            _tableViewBottom.constant = 0;
        }else{
            _button.hidden = false;
        }
        _page++;
        [self.dataArray addObjectsFromArray:modelArr];
        [self.tableView reloadData];
     
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败" time:1];
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray?1:0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MBBabyCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBBabyCardCell" forIndexPath:indexPath];
    cell.isJustLookAt = self.isJustLookAt;
    cell.model = _dataArray[indexPath.row];
    [cell uiedgeInsetsZero];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isJustLookAt) {
        return;
    }
    
    if (_dataArray[indexPath.row].over_date) {
        
        return;
    }

    UIAlertController *alerCV = [UIAlertController alertControllerWithTitle:@"提示" message:self.dataArray[indexPath.row].isSelected?@"只使用该麻包卡还是取消选中该麻包卡":@"只使用该麻包卡还是选中该麻包卡" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *aler1 = [UIAlertAction actionWithTitle:@"使用" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    
        [self.myCircleViewSubject sendNext:@[_dataArray[indexPath.row]]];
        [self popViewControllerAnimated:YES];
    }];
    UIAlertAction *aler2 = [UIAlertAction actionWithTitle:self.dataArray[indexPath.row].isSelected?@"取消选中":@"选中" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
        self.dataArray[indexPath.row].isSelected =  !self.dataArray[indexPath.row].isSelected;
        [self.tableView reloadData];
    }];
    [alerCV addAction:aler1];
    [alerCV addAction:aler2];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alerCV animated:YES completion:nil];
    });

    
   
    
}
@end
