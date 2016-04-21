//
//  MBTopCargoController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/18.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBTopCargoController.h"
#import "JCCollectionViewWaterfallLayout.h"
#import "MBCollectionHeadView.h"
#import "MBTopCargoOneCell.h"
#import "MBTopCargoCell.h"
#import "MBTopCargoTwoCell.h"
@interface MBTopCargoController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate>
{
    
    
    NSArray *_titArray;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation MBTopCargoController
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick beginLogPageView:@"MBTopCargoController"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick endLogPageView:@"MBTopCargoController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navBar removeFromSuperview];
    _titArray = @[@"送给爱玩的TA",@"送给爱吃的TA",@"送给爱打扮的TA",@"送给爱睡觉的TA",@"送给爱旅游的TA"];
    
    [self setCollectionViewUI];
}
- (void)setCollectionViewUI{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView.collectionViewLayout = layout;
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView1"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView2"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView3"];
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView4"];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"MBTopCargoCell" bundle:nil] forCellWithReuseIdentifier:@"MBTopCargoCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"MBTopCargoOneCell" bundle:nil] forCellWithReuseIdentifier:@"MBTopCargoOneCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"MBTopCargoTwoCell" bundle:nil] forCellWithReuseIdentifier:@"MBTopCargoTwoCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"MBTopCargoTwoCell" bundle:nil] forCellWithReuseIdentifier:@"MBTopCargoThreeCell"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"%ld",index);
    
}

#pragma mark --UICollectionViewdelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    switch (section) {
        case 0:  return   1;
        case 1:  return   25;
        case 2:  return   8;
        default: return  12;
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    switch (section) {
        case 0:   return  0;
        case 1:   return  16;
        case 2:   return  8;
        default:  return 8;
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        
      return   UIEdgeInsetsMake(0, 0, 10, 0);
        
    }else if(section == 1){
    
      return   UIEdgeInsetsMake(0, 0, 0, 0);
        
    }
    
    return   UIEdgeInsetsMake(8, 8, 8, 8);
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 1) {
            UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView1" forIndexPath:indexPath];
            MBCollectionHeadView  *headView = [MBCollectionHeadView instanceView];
            headView.tishi.text = @"设计师品牌";
            [reusableview addSubview:headView];
            [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(31);
            }];
            
            return reusableview;
        }else if(indexPath.section == 2){
            UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView2" forIndexPath:indexPath];
            MBCollectionHeadView  *headView = [MBCollectionHeadView instanceView];
            [reusableview addSubview:headView];
            headView.tishi.text = @"本月热销";
            [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_equalTo(0);
                make.height.mas_equalTo(31);
            }];
            return reusableview;
        }else if(indexPath.section == 3){
            UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView3" forIndexPath:indexPath];
            MBCollectionHeadView  *headView = [MBCollectionHeadView instanceView];
            [reusableview addSubview:headView];
            headView.tishi.text = @"推荐设计师品牌";
            [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_equalTo(0);
                make.height.mas_equalTo(31);
            }];
            return  reusableview;
        }else{
            
            UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView4" forIndexPath:indexPath];
            
            SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH,UISCREEN_WIDTH*33/75) delegate:self     placeholderImage:[UIImage imageNamed:@"placeholder_num3"]];
            cycleScrollView.imageURLStringsGroup = @[@"",@"",@""];
            cycleScrollView.autoScrollTimeInterval = 3.0f;
            [reusableview addSubview:cycleScrollView];
            return reusableview;
        }
        
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return _titArray.count;
    }else if(section == 1){
        return 1;
    }else if(section == 2){
        
        return 4;
        
    }
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        MBTopCargoOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBTopCargoOneCell" forIndexPath:indexPath];
        cell.title.text = _titArray[indexPath.row];
        return cell;
    }else if (indexPath.section == 1){
        
        MBTopCargoTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBTopCargoTwoCell" forIndexPath:indexPath];
        cell.type = NO;
        [cell setTypeUI:nil];
        return cell;
    }else if(indexPath.section == 3){
        if (indexPath.item== arc4random_uniform(7)) {
            
            MBTopCargoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBTopCargoCell" forIndexPath:indexPath];
            cell.backgroundColor  = MBColor;
            return cell;
        }
        
        MBTopCargoTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBTopCargoThreeCell" forIndexPath:indexPath];
        cell.type = YES;
        
        [cell setTypeUI:nil ];
        return cell;
    }
    
    MBTopCargoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBTopCargoCell" forIndexPath:indexPath];
    cell.backgroundColor  = MBColor;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return CGSizeMake((UISCREEN_WIDTH-4)/5, (UISCREEN_WIDTH-4)/5*14/19+30);
    }else if (indexPath.section == 1) {
        
        return CGSizeMake(UISCREEN_WIDTH, (UISCREEN_WIDTH-16-25)/2*54/43 + 16);
        
    }else if(indexPath.section == 2){
        if (indexPath.row== 0) {
            return CGSizeMake((UISCREEN_WIDTH-16), (UISCREEN_WIDTH-16)*430/916);
        }
        return CGSizeMake((UISCREEN_WIDTH-32)/3,(UISCREEN_WIDTH-32)/3);
    }else {
        return  CGSizeMake((UISCREEN_WIDTH-16-12)/2,(UISCREEN_WIDTH-16-12)/2);
    }
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return CGSizeMake(UISCREEN_WIDTH, UISCREEN_WIDTH*33/75);
    }
    return CGSizeMake(UISCREEN_WIDTH, 31);;
}


@end
