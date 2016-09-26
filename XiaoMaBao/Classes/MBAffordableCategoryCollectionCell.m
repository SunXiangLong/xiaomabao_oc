//
//  MBAffordableCategoryCollectionCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/22.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBAffordableCategoryCollectionCell.h"
@interface MBAffordableCategoryCollectionCell ()


@property (strong, nonatomic)  UIImageView *showImageView;
@end
@implementation MBAffordableCategoryCollectionCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUI];
        
        
    }
    
    return self;
}
- (void)setUI{

  
    [self.contentView addSubview:({
         _showImageView = [[UIImageView alloc] init];
        _showImageView.contentMode =  UIViewContentModeScaleAspectFill;
        _showImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _showImageView.clipsToBounds  = YES;
        _showImageView;
        
    })];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _showImageView.frame = self.contentView.bounds;
    
}
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
    [_showImageView sd_setImageWithURL:URL(dataDic[@"icon"]) placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    }
@end
