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
#import "MBShopingViewController.h"
#import "MJRefresh.h"
#import "MBMyCollectionCollectionViewCell.h"
#import "MBActivityViewController.h"
#import "MBHomeMenuButton.h"
@interface MBMyCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate, UIAlertViewDelegate>{

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
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerNib:[UINib nibWithNibName:@"MBMyCollectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"MBMyCollectionTableViewCell"];
        tableView.dataSource = self,tableView.delegate = self;
        tableView.frame = CGRectMake(0, TOP_Y, self.view.ml_width, self.view.ml_height - TOP_Y);
        _tableView = tableView;
        UILongPressGestureRecognizer *longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        longPressGr.minimumPressDuration = 0.5f;
        longPressGr.numberOfTouchesRequired = 1;
        [tableView addGestureRecognizer:longPressGr];
    }
    return _tableView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
       
        flowLayout.minimumLineSpacing  = 8;
        flowLayout.minimumInteritemSpacing = 8;
   
        CGFloat width = (self.view.ml_width - 24) / 2;
        flowLayout.itemSize = CGSizeMake(width, width+30);
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, TOP_Y, self.view.ml_width, self.view.ml_height - TOP_Y)collectionViewLayout:flowLayout];
          collectionView.backgroundColor = BG_COLOR;
          collectionView.alwaysBounceVertical = YES;
        [collectionView registerNib:[UINib nibWithNibName:@"MBMyCollectionCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MBMyCollectionCollectionViewCell"];
         [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
        collectionView.dataSource = self,collectionView.delegate = self;
        _collectionView = collectionView;
    }
    return _collectionView;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBMyCollectionViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBMyCollectionViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.view.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
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
//获取购物车数据
-(void)getMycollection
{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *session = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSString *page = [NSString stringWithFormat:@"%ld",_page];
  
    
    [self show];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/collect/goods_list"] parameters:@{@"session":session,@"page":page} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dismiss];
        
        if ([[responseObject valueForKeyPath:@"data"] count]>0) {
            [_CartinfoDict addObjectsFromArray:[responseObject valueForKeyPath:@"data"]];
            _page ++;
        }else{
          [self.tableView.mj_footer endRefreshingWithNoMoreData];
        
        }
        
        [self loadItemViewWithTag:0];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self show:@"请求失败" time:1];
      
        [self loadItemViewWithTag:0];
    }];
    
}
#pragma -mark 根据 uid 、sid、获取收藏的品牌列表
-(void)GetcollectBrandsList
{
    
    
    NSString *page = [NSString stringWithFormat:@"%ld",(long)self.page];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSDictionary *pagination = [NSDictionary dictionaryWithObjectsAndKeys:page,@"page",@"20",@"count",nil];
    [self show];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"user/collectBrands/list"] parameters:@{@"session":sessiondict,@"pagination":pagination} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dismiss];
        NSLog(@"获取收藏的品牌成功---responseObject%@",[responseObject valueForKeyPath:@"data"]);
        _collectBrandsListArray = [responseObject valueForKeyPath:@"data"];
        
        [self.view addSubview:self.collectionView];
        
        if (_collectBrandsListArray.count == 0) {
            self.stateStr = @"暂无收藏品牌数据";
        }else{
        
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self show:@"请求失败" time:1];
    }];
    
}

#pragma mark －－商品和品牌
- (UIView *)setupTabTuiChu{
    UIView *tabView = [[UIView alloc] init];
    tabView.backgroundColor = [UIColor whiteColor];
    tabView.frame = CGRectMake(0, 0, self.view.ml_width, 36);
    
    
    MBHomeMenuButton *btn1 = [MBHomeMenuButton buttonWithType:UIButtonTypeCustom];
    btn1.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn1 setTitle:@"商品" forState:UIControlStateNormal];
    btn1.frame = CGRectMake(0, 0, self.view.ml_width * 0.5, tabView.ml_height);
    btn1.tag = 0;
    [btn1 addTarget:self action:@selector(clickTuiChuTab:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *tabLineView = [[UIView alloc] init];
    tabLineView.frame = CGRectMake(btn1.ml_width, 0, PX_ONE, btn1.ml_height);
    tabLineView.backgroundColor = [UIColor colorWithHexString:@"aaaaaa"];
    [tabView addSubview:tabLineView];
    
    MBHomeMenuButton *btn2 = [MBHomeMenuButton buttonWithType:UIButtonTypeCustom];
    btn2.tag = 1;
    [btn2 setTitle:@"品牌" forState:UIControlStateNormal];
    btn2.frame = CGRectMake(btn1.ml_width, 0, btn1.ml_width,tabView.ml_height);
    btn2.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [btn2 addTarget:self action:@selector(clickTuiChuTab:) forControlEvents:UIControlEventTouchUpInside];
    
    [tabView addSubview:btn1];
    [tabView addSubview:btn2];
    
    
    if (_isbool) {
        btn2.currentSelectedStatus = YES;
    }else{
        btn1.currentSelectedStatus = YES;
    }
    UIView *linview1 = [[UIView alloc] init];
    linview1.backgroundColor = [UIColor grayColor];
    linview1.frame = CGRectMake(0, tabView.ml_height-2, self.view.ml_width * 0.5, 2);
    UIView *linview2 = [[UIView alloc] init];
    linview2.backgroundColor = [UIColor grayColor];
    linview2.frame = CGRectMake(0, tabView.ml_height-2, self.view.ml_width * 0.5, 2);
    [btn1 insertSubview:linview1 belowSubview:btn1.lineView];
    [btn2 insertSubview:linview2 belowSubview:btn2.lineView];
    
    
    return tabView;
}
#pragma mark - 单品团和品牌团
- (void)clickTuiChuTab:(MBHomeMenuButton *)btn{
    
    btn.currentSelectedStatus = YES;
    
    if (btn.tag == 0) {
        _isbool = NO;
        MBHomeMenuButton *btn2 = (MBHomeMenuButton *)[btn.superview viewWithTag:2];
        [UIView animateWithDuration:.25 animations:^{
            btn2.currentSelectedStatus = NO;
           [_tableView reloadData];
        }];
        
    }else if (btn.tag == 1){
        _isbool =YES;
     
        // 即将推出
        MBHomeMenuButton *btn1 = (MBHomeMenuButton *)[btn.superview viewWithTag:1];
        [UIView animateWithDuration:.25 animations:^{
            btn1.currentSelectedStatus = NO;
        }];
        
        
    }
     [self loadItemViewWithTag:btn.tag];
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [longPress locationInView:_tableView];
        
        NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:point]; // 可以获取我们在哪个cell上长按
        self.selIndexPath = indexPath;
        if (indexPath != nil) {
            NSLog(@"%ld", indexPath.row);
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
        [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/collect/del_goods"] parameters:paramDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
            
            MBModel *model = responseObject;
            NSDictionary *staus = model.status;
            
            
            if ([staus[@"succeed"] integerValue] == 1) {
                [self show:@"已从收藏中移除" time:1];
                [self.CartinfoDict removeObject:[self.CartinfoDict objectAtIndex:self.selIndexPath.row]];
           [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.selIndexPath] withRowAnimation:UITableViewRowAnimationFade];
               
            }            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"失败");
        }];
        
    }
}

- (void)loadItemViewWithTag:(NSInteger)index{
    
    if (index == 0) {
        [self.collectionView removeFromSuperview];
        self.collectionView = nil;
        [self.view addSubview:self.tableView];

    }else{
        [self.tableView removeFromSuperview];
        self.tableView = nil;
        [self GetcollectBrandsList];

    }
    
}


#pragma mark -- UITabledelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.CartinfoDict.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self setupTabTuiChu];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 36;
    
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
    MBShopingViewController *shop = [[MBShopingViewController alloc] init];
    shop.GoodsId = [[self.CartinfoDict objectAtIndex:indexPath.row] valueForKeyPath:@"goods_id"];
    [self.navigationController pushViewController:shop animated:YES];
}
#pragma mark ---UICollectionViewdelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _collectBrandsListArray.count;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
   
        return UIEdgeInsetsMake(8,8, 8, 8);
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MBMyCollectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBMyCollectionCollectionViewCell" forIndexPath:indexPath];
    
    NSURL *url = [NSURL URLWithString:[[_collectBrandsListArray objectAtIndex:indexPath.item] valueForKeyPath:@"brand_logo"]];
    [cell.showImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder_num2"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cell.showImageView.alpha = 0.3f;
        [UIView animateWithDuration:1
                         animations:^{
                             cell.showImageView.alpha = 1.0f;
                         }
                         completion:nil];
    }];

    cell.nameLable.text= [[_collectBrandsListArray objectAtIndex:indexPath.item] valueForKeyPath:@"brand_name"];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     MBActivityViewController *categoryVc = [[MBActivityViewController alloc] init];
  
    categoryVc.act_id = _collectBrandsListArray[indexPath.item][@"brand_id"];
    categoryVc.title = _collectBrandsListArray[indexPath.item][@"brand_name"];
    
    
    [self.navigationController pushViewController:categoryVc animated:YES];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
 UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        UIView *view = [self setupTabTuiChu];
        [reusableview   addSubview:view];
        return  reusableview;
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
        return CGSizeMake(UISCREEN_WIDTH, 36);
    
    
}
- (NSString *)titleStr{
    return @"我的收藏";
}

@end
