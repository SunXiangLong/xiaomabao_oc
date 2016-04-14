//
//  ShowBigView.h
//  
//  功能:展示图片
//  Created by Kevin on 15/5/12.
//
//

#import <UIKit/UIKit.h>

@interface refreshData : NSObject
@property (nonatomic, strong) NSString *localUrl;
@property (nonatomic, assign) NSUInteger index;

@end

typedef void(^offsetBlock)(NSInteger);

@interface XNShowBigView : UIView

+ (void)showBigWithFrames:(CGRect)frames andCtrl:(CGFloat)ctrl andImageList:(NSArray *)images andClickedIndex:(NSInteger)index andOffsetBlock:(offsetBlock)offsetBlock;

@end
