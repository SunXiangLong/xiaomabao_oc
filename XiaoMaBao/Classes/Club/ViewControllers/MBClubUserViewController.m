//
//  MBClubUserViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/16.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBClubUserViewController.h"
#import "HMWaterflowLayout.h"
#import "HMShop.h"
#import "MJExtension.h"
#import "HMShopCell.h"
#import "MBNetworking.h"
#import "MBSignaltonTool.h"
#import "MobClick.h"
@interface MBClubUserViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, HMWaterflowLayoutDelegate>
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *shops;
@property (weak,nonatomic) UIView *topView;
@property (assign,nonatomic)NSInteger page;
@end

@implementation MBClubUserViewController

- (NSMutableArray *)shops
{
    if (_shops == nil) {
        self.shops = [NSMutableArray array];
    }
    return _shops;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBClubUserViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBClubUserViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarViewBackgroundColor:[UIColor clearColor]];
    self.page = 1;
    UIView *topView = [[UIView alloc] init];
    topView.userInteractionEnabled = NO;
    topView.frame = CGRectMake(0, 0, self.view.ml_width, 190);
    [self.view addSubview:_topView = topView];
    
    UIImageView *picImgView = [[UIImageView alloc] init];
    picImgView.frame = topView.bounds;
    [topView addSubview:picImgView];
    
    UIView *peopleView = [[UIView alloc] init];
    peopleView.frame = CGRectMake(0, topView.ml_height - 33, self.view.ml_width, 33);
    peopleView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [topView addSubview:peopleView];
    
    NSArray *topTitles = @[
                           @"关注",
                           @"粉丝",
                           @"积分",
                           @"麻豆"
                           ];
    NSArray *numberTitles = @[
                              @"258",
                              @"1001",
                              @"208",
                              @"80"
                              ];
    
    for (NSInteger i = 0; i < topTitles.count; i++) {
        
        UIButton *numberLbl = [UIButton buttonWithType:UIButtonTypeCustom];
        numberLbl.titleLabel.textAlignment = NSTextAlignmentCenter;
        [numberLbl setTitle:numberTitles[i] forState:UIControlStateNormal];
        [numberLbl setTitleColor:[UIColor colorWithHexString:@"63a3c6"] forState:UIControlStateNormal];
        numberLbl.titleLabel.font = [UIFont systemFontOfSize:18];
        numberLbl.frame = CGRectMake(100 + MARGIN_20 + i * 60, 3, 55, 15);
        [peopleView addSubview:numberLbl];
        numberLbl.tag = i;
        
        UIButton *titleLbl = [UIButton buttonWithType:UIButtonTypeCustom];
        titleLbl.tag = i;
        titleLbl.titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleLbl setTitle:topTitles[i] forState:UIControlStateNormal];
        [titleLbl setTitleColor:[UIColor colorWithHexString:@"63a3c6"] forState:UIControlStateNormal];
        titleLbl.titleLabel.font = [UIFont systemFontOfSize:12];
        titleLbl.frame = CGRectMake(numberLbl.ml_x, 18, 60, 15);
        [peopleView addSubview:titleLbl];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor whiteColor];
        lineView.frame = CGRectMake(CGRectGetMaxX(titleLbl.frame), MARGIN_5, PX_ONE, peopleView.ml_height - MARGIN_10);
        [peopleView addSubview:lineView];
    }
    
    UIImageView *headProfileImgView = [[UIImageView alloc] init];
    headProfileImgView.frame = CGRectMake(24, 105, 66, 66);
    headProfileImgView.layer.borderWidth = 2.0;
    headProfileImgView.layer.cornerRadius = 33;
    headProfileImgView.layer.borderColor = [UIColor colorWithHexString:@"63a3c6"].CGColor;
    [topView addSubview:headProfileImgView];
    
    UIButton *starBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [starBtn setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    starBtn.frame = CGRectMake(CGRectGetMaxX(headProfileImgView.frame) + MARGIN_10, headProfileImgView.ml_y + (headProfileImgView.ml_height - 20) * 0.5, 55, 20);
    [topView addSubview:starBtn];
    
    [self loadCollectionView];
}
#pragma mark 提子列表
-(void)getTieZiList
{
    NSString *page = [NSString stringWithFormat:@"%ld",(long)self.page];
    MBUserDataSingalTon *info = [MBSignaltonTool getCurrentUserInfo];
    NSString *user_id = info.uid;
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"mbqz/post/list "] parameters:@{@"page":page,@"count":@"10",@"type":@"0",@"user_id":user_id} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"成功");
        
        NSDictionary *dict = [responseObject valueForKeyPath:@"data"];
        NSLog(@"圈子信息帖子列表---%@",dict);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
    
}

static NSString *const ID = @"shop";

- (void)loadCollectionView{
    
    // 1.初始化数据
    NSArray *shopArray = [HMShop objectArrayWithFilename:@"1.plist"];
    [self.shops addObjectsFromArray:shopArray];
    
    HMWaterflowLayout *layout = [[HMWaterflowLayout alloc] init];
    layout.delegate = self;
    layout.columnsCount = 2;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.topView.ml_height, self.view.ml_width, self.view.ml_height - self.topView.ml_height) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:@"HMShopCell" bundle:nil] forCellWithReuseIdentifier:ID];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

#pragma mark - <HMWaterflowLayoutDelegate>
- (CGFloat)waterflowLayout:(HMWaterflowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
    HMShop *shop = self.shops[indexPath.item];
    return shop.h / shop.w * width;
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shops.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HMShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.shop = self.shops[indexPath.item];
    return cell;
}

- (NSString *)titleStr{
    return @"麻麻_特别宅’";
}

@end
