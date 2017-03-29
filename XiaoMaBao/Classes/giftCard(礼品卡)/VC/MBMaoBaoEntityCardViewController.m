//
//  MBMaoBaoEntityCardViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/3/20.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBMaoBaoEntityCardViewController.h"
#import "MBWelfareCardCollectionViewCell.h"
#import "MBWelfareCardModel.h"
#import "MBGoodsDetailsViewController.h"
@interface MBMaoBaoEntityCardViewController ()
{
 NSInteger _page;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collecionView;
@property (strong, nonatomic) NSMutableArray <MBWelfareCardModel *> *modelArray;
@end

@implementation MBMaoBaoEntityCardViewController
-(NSMutableArray<MBWelfareCardModel *> *)modelArray{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navBar removeFromSuperview];
    self.navBar = nil;
    _page = 1;
    [self requestData];
//
   
    // Do any additional setup after loading the view.
}
-(void)requestData{
    
    [self show];
    [MBNetworking newGET:string(BASE_URL_root, string(@"/giftcard/entity_card/", s_Integer(_page))) parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self dismiss];
        if (_page == 1&&[responseObject[@"cards_list"] count] > 0) {
            MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
            footer.refreshingTitleHidden = YES;
            self.collecionView.mj_footer = footer;
        }else{
            if (_page == 1) {
                
            }else{
                [self.collecionView.mj_footer endRefreshing];
            }
            
        }
        if ([responseObject[@"cards_list"] count] > 0) {
            [_modelArray addObjectsFromArray:[NSArray modelDictionary:responseObject modelKey:@"cards_list" modelClassName:@"MBWelfareCardModel"]];
            _page ++;
        }else{
            [self.collecionView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        [self.collecionView reloadData];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self show:@"请求失败，请检查你的网络连接或稍后再试" time:.5];
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.modelArray.count;
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MBWelfareCardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBWelfareCardCollectionViewCell" forIndexPath:indexPath];
    cell.model = _modelArray[indexPath.row];
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MBGoodsDetailsViewController *shopDetailVc = [[MBGoodsDetailsViewController alloc] init];
    shopDetailVc.GoodsId = _modelArray[indexPath.row].goods_id;
    [self pushViewController:shopDetailVc Animated:true];
    
    
}
#pragma mark <UICollectionViewDelegate>
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 3;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 3;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    
    return UIEdgeInsetsMake(3, 3, 3, 3);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return  CGSizeMake((UISCREEN_WIDTH - 9)/2,(UISCREEN_WIDTH - 9)/2+92);
    
}

@end
