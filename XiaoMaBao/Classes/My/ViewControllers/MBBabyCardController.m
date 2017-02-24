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
@interface MBBabyCardController ()
{
    
    NSInteger _page;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSMutableArray *dataArray;
@property (copy, nonatomic) NSMutableArray *recordSelectedArray;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIView *showView;


@end

@implementation MBBabyCardController
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)recordSelectedArray{
    if (!_recordSelectedArray) {
        _recordSelectedArray = [NSMutableArray array];
    }
    return _recordSelectedArray;
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
    
    return @"选择使用的麻包卡";
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
        //        [self.tableView reloadData];
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
    
    
    for (NSInteger i = 0;  i<_recordSelectedArray.count;i++) {
        NSNumber *num = _recordSelectedArray[i];
        if ([num integerValue] == 1 ) {
            [selectArray addObject:_dataArray[i]];
        }
    }
    
    
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
        
        if (_page == 1) {
            MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(setData)];
            footer.refreshingTitleHidden = YES;
            self.tableView.mj_footer = footer;
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        
        _showView.hidden = false;
        
        if ([[responseObject valueForKeyPath:@"data"] count] > 0) {
            NSArray *array = [responseObject valueForKeyPath:@"data"];
            [self.dataArray addObjectsFromArray:array];
            for (NSDictionary *dic in array) {
                
                [self.recordSelectedArray addObject:@0];
            }
            _page ++;
            _tableView.hidden = NO;
            [self.tableView reloadData];
            
            //            if (self.dataArray.count > 0&&![self.dataArray.firstObject isEqual:[[responseObject valueForKeyPath:@"data"] firstObject]]) {
            //
            //
            //                [self.dataArray insertObject:[[responseObject valueForKeyPath:@"data"] firstObject] atIndex:0];
            //                [self.recordSelectedArray insertObject:@1 atIndex:0];
            //                [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            //
            //                _page ++;
            //
            //            }else{
            //
            //
            //
            //
            //            }
            
        }else{
            if (_page == 1) {
                _tableView.hidden = YES;
                _button.hidden = true;
                
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            
        }
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败" time:1];
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MBBabyCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBBabyCardCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBBabyCardCell"owner:nil options:nil]firstObject];
    }
    cell.dataDic = _dataArray[indexPath.row];
    cell.indexPath = indexPath;
    @weakify(self);
    [[cell.myCircleViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSArray *arr) {
        @strongify(self);
        
        
        self.recordSelectedArray[[arr.firstObject row]] = arr.lastObject;
        
    }];
    
    if ([self.recordSelectedArray[indexPath.row] integerValue] == 0) {
        cell.seleButton.selected    = NO;
    }else{
        cell.seleButton.selected    = YES;
    }
    [cell uiedgeInsetsZero];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([_dataArray[indexPath.row][@"over_date"] integerValue] == 1) {
        return;
    }
    [self.myCircleViewSubject sendNext:@[_dataArray[indexPath.row]]];
    
    [self popViewControllerAnimated:YES];
    
}
@end
