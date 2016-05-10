//
//  MBPostDetailsViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBPostDetailsViewController.h"
#import "MBPostDetailsOneCell.h"
#import "MBPostDetailsTwoCell.h"
@interface MBPostDetailsViewController ()
{
    CGFloat _allHeight;
    NSArray *_dataArray;
    NSInteger _page;
    NSString *_poster;
    NSString *_isImage;
}
/**
 *  存放cell高度的数组
 */

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSMutableArray *commentsArray;
@end

@implementation MBPostDetailsViewController
- (NSMutableArray *)commentsArray{
    if (!_commentsArray) {
        _commentsArray = [NSMutableArray array];
    }
    return _commentsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _page =1;
    _poster = @"3";
    _isImage = @"0";
    _allHeight    = 10*(UISCREEN_WIDTH-20)*105/125;
    [self setData];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(setData)];
    footer.refreshingTitleHidden = YES;
    self.tableView.mj_footer = footer;
}
#pragma mark -- 我的圈轮播图数据
- (void)setData{
    NSString *page = s_Integer(_page);
    NSString *url = [NSString stringWithFormat:@"%@%@/%@/%@/%@/%@",BASE_URL_root,@"/circle/get_post_detail",self.post_id,page,_poster,_isImage];
    
    [MBNetworking newGET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        if (responseObject) {
            if (_page ==1) {
                NSArray *post_detail = [responseObject valueForKeyPath:@"post_detail"];
                [self.commentsArray addObjectsFromArray:[responseObject valueForKeyPath:@"comments"]];
                
                
                _dataArray = @[post_detail,_commentsArray];
                 [_tableView reloadData];
                _page++;
                
            }else{
                
                if ([[responseObject valueForKeyPath:@"data"] count]>0) {
                     [_commentsArray addObjectsFromArray:[responseObject valueForKeyPath:@"comments"]];                    _page++;
                    [_tableView reloadData];
                    [self.tableView .mj_footer endRefreshing];
                    
                }else{
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    return ;
                }

            
            }
          
        
            return ;
        }
        
        [self show:@"没有相关数据" time:1];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self show:@"请求失败" time:1];
    }];
    
    
}
-(NSString *)titleStr{
    
    return self.title?:@"全部";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [_dataArray[section] count];;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _allHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        MBPostDetailsOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBPostDetailsOneCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MBPostDetailsOneCell"owner:nil options:nil]firstObject];
        }
        cell.indexPath = indexPath;
        @weakify(self);
        [[cell.myCircleViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSArray *arr) {
            @strongify(self);
            NSNumber *cellHeight = arr.firstObject;
            NSIndexPath *indexPath = arr.lastObject;
            _allHeight = _allHeight+([cellHeight floatValue] - (UISCREEN_WIDTH-20)*105/125 );
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            
            
        }];
        
        return cell;
    }
    
    MBPostDetailsTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBPostDetailsTwoCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBPostDetailsTwoCell"owner:nil options:nil]firstObject];
    }
    cell.indexPath = indexPath;
    @weakify(self);
    [[cell.myCircleViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSArray *arr) {
        @strongify(self);
        NSNumber *cellHeight = arr.firstObject;
        NSIndexPath *indexPath = arr.lastObject;
        _allHeight = _allHeight+([cellHeight floatValue] - (UISCREEN_WIDTH-20)*105/125 );
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
        
    }];

    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
