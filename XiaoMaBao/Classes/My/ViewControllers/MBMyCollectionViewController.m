//
//  MBMyCollectionViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/8.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBMyCollectionViewController.h"
#import "MBNetworking.h"
#import "MBSignaltonTool.h"
#import "UIImageView+WebCache.h"
#import "MBMyCollectionTableViewCell.h"
#import "MBGoodsDetailsViewController.h"
#import "MJRefresh.h"
#import "MBMyCollectionCollectionViewCell.h"
#import "MBActivityViewController.h"
#import "MBHomeMenuButton.h"
@interface MBMyCollectionViewController ()<UITableViewDataSource,UITableViewDelegate, UIAlertViewDelegate>{

    BOOL _isbool;
   

}
@property (weak,nonatomic) UIView *menuView;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) UICollectionView *collectionView;
@property (weak,nonatomic) UIView *lineView;
@property (assign,nonatomic) NSInteger page;
@property (strong,nonatomic) NSArray *collectBrandsListArray;
@property (nonatomic, strong) NSIndexPath *selIndexPath;

@end

@implementation MBMyCollectionViewController

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerNib:[UINib nibWithNibName:@"MBMyCollectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"MBMyCollectionTableViewCell"];
        tableView.dataSource = self,tableView.delegate = self;
        tableView.frame = CGRectMake(0, TOP_Y, UISCREEN_WIDTH, UISCREEN_HEIGHT - TOP_Y);
        _tableView = tableView;
        UILongPressGestureRecognizer *longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        longPressGr.minimumPressDuration = 0.5f;
        longPressGr.numberOfTouchesRequired = 1;
        [tableView addGestureRecognizer:longPressGr];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    [self.view addSubview:self.tableView];
    [self getMycollection];
    _CartinfoDict = [NSMutableArray array];
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self getMycollection];
        [weakSelf.tableView.mj_footer endRefreshing];
        
    }];
    // 默认先隐藏footer
    self.tableView.mj_footer.hidden = YES;
}
//获取数据
-(void)getMycollection
{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *session = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSString *page = [NSString stringWithFormat:@"%ld",_page];
  
    
    [self show];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/collect/goods_list"] parameters:@{@"session":session,@"page":page} success:^(NSURLSessionDataTask *operation, id responseObject) {
        [self dismiss];
        
        if (_page == 1) {
            if ([[responseObject valueForKeyPath:@"data"] count] == 0) {
                self.tableView.mj_footer.hidden = true;
                self.stateStr = @"暂无收藏商品数据";
            }
            
        }
        if ([[responseObject valueForKeyPath:@"data"] count]>0) {
            [_CartinfoDict addObjectsFromArray:[responseObject valueForKeyPath:@"data"]];
            _page ++;
            [self.tableView reloadData];
        }else{
        
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
      
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败" time:1];
      
        
    }];
    
}





- (void)longPressAction:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [longPress locationInView:_tableView];
        
        NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:point]; // 可以获取我们在哪个cell上长按
        self.selIndexPath = indexPath;
        if (indexPath != nil) {
         
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定要删除本收藏吗？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        }
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
        NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
        NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
        NSString *rec_id =  [[self.CartinfoDict objectAtIndex:self.selIndexPath.row] valueForKeyPath:@"rec_id"];
        NSDictionary *paramDict = @{@"session":sessiondict,@"rec_id":rec_id};
        [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/collect/del_goods"] parameters:paramDict success:^(NSURLSessionDataTask *operation, id responseObject) {
          
            
            MBModel *model = responseObject;
            NSDictionary *staus = model.status;
            
            
            if ([staus[@"succeed"] integerValue] == 1) {
                [self show:@"已从收藏中移除" time:1];
                [self.CartinfoDict removeObject:[self.CartinfoDict objectAtIndex:self.selIndexPath.row]];
           [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.selIndexPath] withRowAnimation:UITableViewRowAnimationFade];
               
            }            
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            MMLog(@"%@",error);
        }];
        
    }
}



#pragma mark -- UITabledelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.CartinfoDict.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"MBMyCollectionTableViewCell";
    MBMyCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.decribe.text = [[self.CartinfoDict objectAtIndex:indexPath.row] valueForKeyPath:@"goods_name"];
    cell.goods_price.text = [[self.CartinfoDict objectAtIndex:indexPath.row] valueForKeyPath:@"shop_price_formatted"];
    cell.goods_id = [[self.CartinfoDict objectAtIndex:indexPath.row] valueForKeyPath:@"goods_id"];
    cell.goodsNum = [[self.CartinfoDict objectAtIndex:indexPath.row] valueForKeyPath:@"goods_number"];
    NSString *urlstr = [[self.CartinfoDict objectAtIndex:indexPath.row] valueForKeyPath:@"goods_thumb"];
    
    NSURL *url = [NSURL URLWithString:urlstr];
    [cell.showimageview sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MBGoodsDetailsViewController *shop = [[MBGoodsDetailsViewController alloc] init];
    shop.GoodsId = [[self.CartinfoDict objectAtIndex:indexPath.row] valueForKeyPath:@"goods_id"];
    [self.navigationController pushViewController:shop animated:YES];
}

- (NSString *)titleStr{
    return @"商品收藏";
}

@end
