//
//  MBTopCargoTwoCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/18.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBTopCargoTwoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,assign) BOOL type;
- (void)setTypeUI:(NSArray *)arry ;
@end
