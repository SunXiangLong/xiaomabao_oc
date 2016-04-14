//
//  MBActivityTableViewCell.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/16.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBActivityTableViewCell.h"
#import "MBClubActivityFrame.h"
#import "UIImageView+WebCache.h"
@interface MBActivityTableViewCell ()
@property (weak, nonatomic) UIView *authorV;
@property (weak, nonatomic) UIImageView *authorImgV;
@property (weak, nonatomic) UILabel *authorLbl;
@property (weak, nonatomic) UIButton *authorAddBtn;

@property (weak, nonatomic) UIImageView *picImgV;
@property (weak, nonatomic) UILabel *titleLbl;
@property (weak, nonatomic) UILabel *contentLbl;
@property (weak, nonatomic) UIButton *bottomBtn;



@end

@implementation MBActivityTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *authorV = [[UIView alloc] init];
        authorV.backgroundColor = [UIColor colorWithHexString:@"63a3c6"];
        [self.contentView addSubview:_authorV = authorV];
        
        UIImageView *authorImgV = [[UIImageView alloc] init];
        authorImgV.layer.borderColor = [UIColor whiteColor].CGColor;
        authorImgV.layer.borderWidth = PX_ONE;
        [authorV addSubview:_authorImgV = authorImgV];
        authorImgV.layer.cornerRadius = 13;
        
        UILabel *authorLbl = [[UILabel alloc] init];
        authorLbl.font = [UIFont systemFontOfSize:12];
        authorLbl.textColor = [UIColor whiteColor];
        [authorV addSubview:_authorLbl = authorLbl];
        
        UIButton *authorAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [authorV addSubview:_authorAddBtn = authorAddBtn];
        
        UIImageView *picImgV = [[UIImageView alloc] init];
        picImgV.backgroundColor = [UIColor randomColor];
        [self.contentView addSubview:_picImgV = picImgV];
        
        UILabel *titleLbl = [[UILabel alloc] init];
        titleLbl.textColor = [UIColor colorWithHexString:@"e8465e"];
        titleLbl.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:_titleLbl = titleLbl];
        
        UILabel *contentLbl = [[UILabel alloc] init];
        contentLbl.font = [UIFont systemFontOfSize:14];
        contentLbl.numberOfLines = 0;
        contentLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        [self.contentView addSubview:_contentLbl = contentLbl];
        
        UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bottomBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [bottomBtn setTitle:@"马上去看看" forState:UIControlStateNormal];
        bottomBtn.layer.cornerRadius = 13;
        bottomBtn.backgroundColor = [UIColor colorWithHexString:@"63a3c6"];
        [self.contentView addSubview:_bottomBtn = bottomBtn];
        
    }
    return self;
}

- (void)setActivityFrame:(MBClubActivityFrame *)activityFrame{
    _activityFrame = activityFrame;
    
    MBClubActivity *activity = activityFrame.activity;
    
    self.authorLbl.text = activity.act_name;
    self.titleLbl.text = activity.act_content;
    self.contentLbl.text = activity.act_content;
    //头像
    if (![activity.act_imgs isEqual:[NSNull null]]) {
        [self.authorImgV sd_setImageWithURL:[NSURL URLWithString:activity.act_imgs]];
    }
    //大图片
    if (![activity.act_imgs isEqual:[NSNull null]]) {
        [self.picImgV sd_setImageWithURL:[NSURL URLWithString:activity.act_imgs]];
    }
    
    self.authorV.frame = activityFrame.authorF;
    self.titleLbl.frame = activityFrame.titleLblF;
    self.contentLbl.frame = activityFrame.contentF;
    self.picImgV.frame = activityFrame.picImgF;
    self.bottomBtn.frame = activityFrame.buttonF;
    
    // author
    self.authorImgV.frame = CGRectMake(MARGIN_8, (self.authorV.ml_height - 25) * 0.5, 26, 26);
    self.authorLbl.frame = CGRectMake(CGRectGetMaxX(self.authorImgV.frame) + MARGIN_5, 0, 120, self.authorV.ml_height);
    self.authorAddBtn.frame = CGRectMake(self.authorLbl.ml_width - 50, (self.authorLbl.ml_height - 25) * 0.5, 25, 25);
    
}

@end
