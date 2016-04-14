//
//  MBSpecificationsCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 15/12/22.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MBSpecificationsCelldelegate <NSObject>
-(void)getDic:(NSDictionary *)dic;
@end
@interface MBSpecificationsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *view;
@property(nonatomic,copy) NSDictionary *dic;
@property(nonatomic,assign) NSInteger row;
@property(nonatomic,assign) id<MBSpecificationsCelldelegate> delegate;
-(void)setUI;
@end
