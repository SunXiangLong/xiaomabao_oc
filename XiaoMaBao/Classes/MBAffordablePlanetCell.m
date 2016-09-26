//
//  MBAffordablePlanetCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/21.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBAffordablePlanetCell.h"
#import "MBAffordableCell.h"
@implementation AFIndexedCollectionView

@end
@implementation MBAffordablePlanetCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    _showImage = [[UIImageView alloc ] init];
    [self.contentView addSubview:_showImage];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UICollectionViewFlowLayout *flowLayout =  [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset =  UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView = [[AFIndexedCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[MBAffordableCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    [self.collectionView  registerNib:[UINib nibWithNibName:@"MBAffordablePlanetMoreCell" bundle:nil] forCellWithReuseIdentifier:@"MBAffordablePlanetMoreCell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:self.collectionView];
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.showImage.frame = CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_WIDTH*35/75);
    self.collectionView.frame = CGRectMake(0, UISCREEN_WIDTH*35/75, UISCREEN_WIDTH,155);
}



- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath
{
    _collectionView.dataSource = dataSourceDelegate;
    _collectionView.delegate = dataSourceDelegate;
    _collectionView.indexPath = indexPath;
    [_collectionView setContentOffset:_collectionView.contentOffset animated:NO];
    
    [_collectionView reloadData];
}
@end
