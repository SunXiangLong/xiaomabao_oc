//
//  HMWaterflowLayout.h
//  04-瀑布流
//
//  Created by apple on 14/12/4.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMWaterflowLayout;

@protocol HMWaterflowLayoutDelegate <NSObject>
- (CGFloat)waterflowLayout:(HMWaterflowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath;
@end

@interface HMWaterflowLayout : UICollectionViewLayout
@property (nonatomic, assign) UIEdgeInsets sectionInset;
/** 每一列之间的间距 */
@property (nonatomic, assign) CGFloat columnMargin;
/** 每一行之间的间距 */
@property (nonatomic, assign) CGFloat rowMargin;
/** 显示多少列 */
@property (nonatomic, assign) int columnsCount;

@property (nonatomic, weak) id<HMWaterflowLayoutDelegate> delegate;

@property (nonatomic , assign) CGFloat naviHeight;//默认为64.0,
@property (nonatomic , assign) int itemNum;//第几个item的头部悬浮
@property (nonatomic , assign) BOOL allItems;//是否全部悬浮，默认全部悬浮
@end
