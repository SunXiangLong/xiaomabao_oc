//
//  WLZ_ChangeCountView.h
//  WLZ_ShoppingCart
//
//  Created by lijiarui on 15/12/14.
//  Copyright © 2015年 lijiarui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLZ_ChangeCountView : UIView
//加
@property (nonatomic, strong) UIButton *addButton;
//减
@property (nonatomic, strong) UIButton *subButton;
//数字按钮
@property (nonatomic, strong) UITextField  *numberFD;

//已选数
@property (nonatomic, assign) NSInteger choosedCount;


//总数
@property (nonatomic, assign) NSInteger totalCount;

- (instancetype)initWithFrame:(CGRect)frame chooseCount:(NSInteger)chooseCount totalCount:(NSInteger)totalCount;
@end
