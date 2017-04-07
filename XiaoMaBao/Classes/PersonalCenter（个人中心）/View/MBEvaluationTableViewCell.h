//
//  MBEvaluationTableViewCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 15/12/30.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BkBaseViewController.h"
@protocol MBEvaluationTableViewCellDelegate<NSObject>
-(void)ProductEvaluation:(NSString *)str row:(NSInteger)row;
-(void)CommodityImages:(NSArray *)array row:(NSInteger)row;
-(void)CommodityGrade:(NSInteger)num row:(NSInteger)row;
-(void)SubmitEvaluation:(NSInteger)row;
-(void)label:(NSString *)str row:(NSInteger)row;
@end


@interface MBEvaluationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labeltext;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;
@property (weak, nonatomic) IBOutlet UIView *View;
- (IBAction)submit:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property(nonatomic,strong) BkBaseViewController *ViewControlle;
@property (nonatomic,assign)  NSInteger row;
@property (nonatomic,assign)  NSInteger num;
@property (nonatomic,copy) NSArray *photoArr;
@property (nonatomic,assign) id<MBEvaluationTableViewCellDelegate>delegate;
-(void)setinit;
@end
