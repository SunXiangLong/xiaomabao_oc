//
//  MBVideoViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/8/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBVideoViewController.h"
#import "MBVideoViewCell.h"
#import "MBVideoView.h"
@interface MBVideoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;

@end

@implementation MBVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_CollectionView registerNib:[UINib nibWithNibName:@"MBVideoViewCell" bundle:nil] forCellWithReuseIdentifier:@"MBVideoViewCell"];
     [_CollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
}
-(NSString *)titleStr{
  return @"视频";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --UICollectionViewdelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{

    return  0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return  0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
//    (CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
        return   UIEdgeInsetsMake(0, 6, 0, 6);
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        
        
        if (indexPath.section == 0) {
            UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
            MBVideoView *view = [MBVideoView instanceView];
            [reusableview    addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_equalTo(0);
                CGFloat height = 105+(UISCREEN_WIDTH-22)*350/706;
                make.height.mas_equalTo(height);
                
            }];
       
            
            return reusableview;
        }
        
    }
    
    return nil;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MBVideoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBVideoViewCell" forIndexPath:indexPath];
    
    return cell;
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
   
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
        
        return CGSizeMake((UISCREEN_WIDTH - 12)/2 ,(197 - 132)+((UISCREEN_WIDTH - 12)/2 - 10 )*225/342);
    
    
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(UISCREEN_WIDTH, 105+(UISCREEN_WIDTH-22)*350/706);
    
}

@end
