//
//  MBEvaluationViewView.h
//  XiaoMaBao
//
//  Created by liulianqi on 15/12/29.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MBEvaluationViewView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>



@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UITextView *EvaluationViewViewTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *evaluationCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *submit;
@property (nonatomic,copy) NSMutableArray *photoArray;
@property (weak, nonatomic) IBOutlet UIImageView *UIimageview;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (nonatomic,strong) UIViewController *ViewControlle;
@property (nonatomic,strong) NSString *order_id;
- (IBAction)submit:(UIButton *)sender;

+ (instancetype)viewFromNIB;
- (void)dic:(NSDictionary *)dic;
@end
