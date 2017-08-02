//
//  MBMBSMCategoryTwoVC.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/6/28.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBSMCategoryTwoVC.h"
#import "MBSMCategoryCell.h"
#import "MBSMCategoryModel.h"
@interface MBSMCategoryTwoVC ()

@end

@implementation MBSMCategoryTwoVC

-(void)setCatListsArray:(NSArray<catListsModel *> *)catListsArray{
    _catListsArray = catListsArray;
    [self.collectionView reloadData];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
   

    layout.sectionInset = UIEdgeInsetsMake(20, 25, 20, 25);
    layout.minimumLineSpacing = 25;
    layout.minimumInteritemSpacing = 20;
    CGFloat width = (UISCREEN_WIDTH * 43/75 - 91)/3;
    MMLog(@"%f--%f",UISCREEN_WIDTH * 43/75 ,width*3+91)
    layout.itemSize = CGSizeMake( width,width*85/81);
    _collectionView.collectionViewLayout = layout;
     _collectionView.alwaysBounceVertical = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark --UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
  
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return _catListsArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    
    MBSMCategoryTwoCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBSMCategoryTwoCollCell" forIndexPath:indexPath];
    cell.model = _catListsArray[indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.backCatID) {
        self.backCatID(_catListsArray[indexPath.row].cat_id);
        return;
    }
    [self performSegueWithIdentifier:@"fleaMarketCategoryVC" sender:nil];
    
}
@end
