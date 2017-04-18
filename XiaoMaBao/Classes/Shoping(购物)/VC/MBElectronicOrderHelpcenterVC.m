//
//  MBElectronicOrderHelpcenterVC.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/3/22.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBElectronicOrderHelpcenterVC.h"
#import "MBCardHelpCenterTitleCell.h"

@interface MBElectronicOrderHelpcenterVC ()
{

    NSArray *_imageData;
    NSArray *_titleData;
    NSInteger _selectionpage;
}
@property (weak, nonatomic) IBOutlet MBBaseCollectionView *centerCllectionView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet MBBaseCollectionView *topCollectionView;
@end

@implementation MBElectronicOrderHelpcenterVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [[CADisplayLink displayLinkWithTarget:self selector:@selector(login)] addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.topView layoutIfNeeded];
    [self addBottomLineView:self.topView];
    _titleData = @[
                   @"购买流程",
                   @"使用流程",
                   @"企业专属特权",
                   @"购卡章程"
                   ];
    _imageData = @[
                   [UIImage imageNamed:@"helpCentrtOne"],
                   [UIImage imageNamed:@"helpCentrtTo"],
                   [UIImage imageNamed:@"helpCentrtThree"],
                   [UIImage imageNamed:@"helpCentrtFour"]
                   ];
    _selectionpage = 0;
    [self.topCollectionView reloadData];
    [self.centerCllectionView reloadData];
    // Do any additional setup after loading the view.
}
- (void)login{
    MMLog(@"123444");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString *)titleStr{
    
    return @"帮助中心";
}
#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if ([collectionView isEqual:self.topCollectionView] ) {
        
        MMLog(@"%lu",(unsigned long)_titleData.count);
        return _titleData.count;
    }
    
    return _imageData.count;
    
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([collectionView isEqual:self.topCollectionView] ) {
        MBCardHelpCenterTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBCardHelpCenterTitleCell" forIndexPath:indexPath];
        cell.ttitleLabel.text = _titleData[indexPath.item];
        if (_selectionpage == indexPath.row) {
            cell.ttitleLabel.textColor = UIcolor(@"e8564e");
            cell.lineView.hidden = false;
        }else{
            cell.ttitleLabel.textColor = UIcolor(@"555555");
            cell.lineView.hidden = true;
        }
        
        
        return cell;
    }
    
    
    MBCardHelpCenterCenterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBCardHelpCenterCenterCell" forIndexPath:indexPath];
  
    cell.image = _imageData[indexPath.item];
    
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([collectionView isEqual:self.topCollectionView] ) {
    
        _selectionpage  = indexPath.row;
        [self.topCollectionView reloadData];
        [self.centerCllectionView setContentOffset:CGPointMake(UISCREEN_WIDTH*indexPath.row, 0) animated:true];
    }
    
    
}
#pragma mark <UICollectionViewDelegate>
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([collectionView isEqual:self.topCollectionView]){
        NSInteger leng = [_titleData[indexPath.row] length];
        return  CGSizeMake(leng*14+36,40);
    }
    return  CGSizeMake(UISCREEN_WIDTH,UISCREEN_HEIGHT - 40 -TOP_Y);
    
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if ([scrollView isEqual:self.centerCllectionView]  ) {
        // 取出对应的子控制器
        _selectionpage  = scrollView.contentOffset.x / scrollView.ml_width;
        [self.topCollectionView reloadData];
        
    }
    
    
    
}

@end
