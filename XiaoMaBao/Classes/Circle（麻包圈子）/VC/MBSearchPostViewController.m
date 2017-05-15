//
//  MBSearchPostViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/5/9.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBSearchPostViewController.h"
#import "MBSearchPostCVCell.h"
#import "MBPostDetailsViewController.h"
@interface MBSearchPostViewController ()
{
    NSInteger _page;
    NSString *_searchText;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation MBSearchPostViewController
-(NSMutableArray *)recommend_goods{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = false;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = true;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navBar removeFromSuperview];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"MBSearchPostCVCell" bundle:nil] forCellWithReuseIdentifier:@"MBSearchPostCVCell"];
    [self everyoneData];
    WS(weakSelf)
    self.didSearchBlock =  ^(MBSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        _page = 1;
        _searchText = searchText;
        [weakSelf.recommend_goods removeAllObjects];
        [weakSelf.collectionView reloadData];
        [weakSelf setSearchCircleData];
    };
   
}
#pragma mark -- 大家都在搜数据
- (void)everyoneData{
    
    [self show];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/circle/get_hot_search_words"];
    
    [MBNetworking newGET:url parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        [self dismiss];
        MMLog(@"%@",responseObject);
        
        if (responseObject) {
            if ([[responseObject valueForKeyPath:@"data"] count]>0) {
                self.baseSearchTableView.hidden = false;
                self.hotSearches = responseObject[@"data"];
                self.hotSearchStyle =  PYHotSearchStyleColorfulTag;
                self.searchBar.placeholder = @"请输入要搜索帖子";
                self.hotSearchHeader.text = @"大家都在搜";
               
                return ;
            }
            
        }
        
        [self show:@"没有相关数据" time:1];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败" time:1];
    }];
    
    
}
#pragma mark -- 根据关键字搜索圈子数据
- (void)setSearchCircleData{
    
    NSString *page  = s_Integer(_page);
    
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/circle/search_post"];
    NSString *str = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self show];
    
    [MBNetworking   POSTOrigin:str parameters:@{@"page":page,@"keyword":_searchText} success:^(id responseObject) {
        [self dismiss];
        //            MMLog(@"%@",responseObject);
        if (responseObject) {
            if ([[responseObject valueForKeyPath:@"data"] count]>0) {
                if (_page ==1) {
                    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
                    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(setSearchCircleData)];
                    footer.refreshingTitleHidden = YES;
                    _collectionView.mj_footer = footer;
                  
                }else{
                    [_collectionView .mj_footer endRefreshing];
                }
                [self.view bringSubviewToFront:self.collectionView];
                [self.dataArray addObjectsFromArray:[responseObject valueForKeyPath:@"data"]];
                
                
                _page++;
                [_collectionView reloadData];
                
                
                
            }else{
                [_collectionView.mj_footer endRefreshingWithNoMoreData];
                return ;
            }
            
        }else{
            [self show:@"没有相关数据" time:1];
        }
        
        
        
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败 " time:1];
        MMLog(@"%@",error);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   }



#pragma mark --UICollectionViewdelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _dataArray[indexPath.item];
      CGFloat height = 0;
    if ( [dic[@"post_imgs"] count] > 0) {
        height+=  (UISCREEN_WIDTH -50)/3*133/184;
        height+= 10;
    }
    
    YYTextContainer  *titleContarer = [YYTextContainer new];
    //限制宽度
    titleContarer.size             = CGSizeMake(UISCREEN_WIDTH - 30,CGFLOAT_MAX);
    NSMutableAttributedString  *titleAttr = [self getAttr:dic[@"post_content"]];
    YYTextLayout *titleLayout = [YYTextLayout layoutWithContainer:titleContarer text:titleAttr];
    height+= titleLayout.textBoundingSize.height;
    height+=65;
    return CGSizeMake(UISCREEN_WIDTH, height);

}
- (NSMutableAttributedString*)getAttr:(NSString*)attributedString {
    NSMutableAttributedString * resultAttr = [[NSMutableAttributedString alloc] initWithString:attributedString];
    
    //对齐方式 这里是 两边对齐
    resultAttr.yy_alignment = NSTextAlignmentLeft;
    //设置行间距
    resultAttr.yy_lineSpacing = 1;
    //设置字体大小
    resultAttr.yy_font = YC_YAHEI_FONT(13);
    //可以设置某段字体的大小
    //[resultAttr yy_setFont:[UIFont boldSystemFontOfSize:CONTENT_FONT_SIZE] range:NSMakeRange(0, 3)];
    //设置字间距
    resultAttr.yy_kern = [NSNumber numberWithFloat:1.0];
    
    return resultAttr;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    MBSearchPostCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBSearchPostCVCell" forIndexPath:indexPath];
    cell.dataDic = self.dataArray[indexPath.item];
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _dataArray[indexPath.row];
    MBPostDetailsViewController *VC = [[MBPostDetailsViewController   alloc] init];
    VC.post_id = dic[@"post_id"];
    [self pushViewController:VC Animated:false];
    
}

@end
