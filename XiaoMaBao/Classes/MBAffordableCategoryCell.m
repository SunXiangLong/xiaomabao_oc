//
//  MBAffordableCategoryCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/22.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBAffordableCategoryCell.h"
#import "MBAffordableCategoryCollectionCell.h"
@implementation BFIndexedCollectionView

@end
@implementation MBAffordableCategoryCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UICollectionViewFlowLayout *flowLayout =  [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 15;
    flowLayout.sectionInset =   UIEdgeInsetsMake(15, 8, 15, 8);
    self.collectionView = [[BFIndexedCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[MBAffordableCategoryCollectionCell class] forCellWithReuseIdentifier:AffordableCategoryCollectionCell];
    self.collectionView.backgroundColor = [UIColor whiteColor];

    [self.contentView addSubview:self.collectionView];
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
}



- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate 
{
    _collectionView.dataSource = dataSourceDelegate;
    _collectionView.delegate = dataSourceDelegate;
    
    [_collectionView setContentOffset:_collectionView.contentOffset animated:NO];
    
    [_collectionView reloadData];
}


@end
