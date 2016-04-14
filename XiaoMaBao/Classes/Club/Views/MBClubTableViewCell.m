//
//  MBClubTableViewCell.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/13.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBClubTableViewCell.h"
#import "MBClub.h"
#import "MBClubFrame.h"
#import "NSString+BQ.h"
#import "UIImageView+WebCache.h"
#import "MBNetworking.h"
#import "MBSignaltonTool.h"
@interface MBClubTableViewCell ()

// Author
@property (weak,nonatomic) UIView *authorView;
@property (weak,nonatomic) UIImageView *authorImgView;
@property (weak,nonatomic) UILabel *authorLbl;
@property (weak,nonatomic) UIImageView *authorLevelImgView;
@property (weak,nonatomic) UIButton *authorStarBtn;

@property (weak, nonatomic) UIImageView *picImgV;
@property (weak, nonatomic) UILabel *titleLbl;
@property (weak, nonatomic) UILabel *contentLbl;

// Common
@property (weak, nonatomic) UIView *commonView;
@property (weak, nonatomic) UIImageView *commonAuthorImgV;
@property (weak, nonatomic) UILabel *commonAuthorNameLbl;
@property (weak, nonatomic) UILabel *commonAuthorReplyLbl;
@property (weak, nonatomic) UILabel *commonContentLbl;
@property (weak, nonatomic) UIButton *commonTimeBtn;
@property (weak, nonatomic) UIView *commonLineView;


// bottom
@property (weak, nonatomic) UIView *bottomV;
@property (weak, nonatomic) UIButton *enjoyBtn;
@property (weak, nonatomic) UIButton *askBtn;
@property (weak, nonatomic) UIButton *shareBtn;
@end

@implementation MBClubTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Fix the bug in iOS7 - initial constraints warning
    self.contentView.bounds = [UIScreen mainScreen].bounds;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *picImgV = [[UIImageView alloc] init];
        picImgV.backgroundColor = [UIColor randomColor];
        [self.contentView addSubview:_picImgV = picImgV];
        
        // 顶部的作者View
        UIView *authorView = [[UIView alloc] init];
        authorView.backgroundColor = [UIColor randomColor];
        [self.contentView addSubview:_authorView = authorView];
        
        UIImageView *authorImgView = [[UIImageView alloc] init];
        authorImgView.layer.borderColor = [UIColor whiteColor].CGColor;
        authorImgView.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
        authorImgView.layer.cornerRadius = 13;
        [authorView addSubview:_authorImgView = authorImgView];
        
        UILabel *authorLbl = [[UILabel alloc] init];
        authorLbl.text = @"小麻包";
        authorLbl.font = [UIFont systemFontOfSize:8];
        authorLbl.textColor = [UIColor whiteColor];
        authorLbl.numberOfLines = 0;
        authorLbl.font = [UIFont systemFontOfSize:12];
        [authorView addSubview:_authorLbl = authorLbl];
        
        UIImageView *levelImgView = [[UIImageView alloc] init];
        levelImgView.image = [UIImage imageNamed:@"level01"];
        [authorView addSubview:_authorLevelImgView = levelImgView];
        
        UIButton *authorStarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        authorStarBtn.layer.borderWidth = 1;
        authorStarBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        authorStarBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        authorStarBtn.layer.cornerRadius = 10;
        [authorStarBtn setTitle:@"+关注" forState:UIControlStateNormal];
        [authorView addSubview:_authorStarBtn = authorStarBtn];
        [authorStarBtn addTarget:self action:@selector(AddpraiseClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLbl = [[UILabel alloc] init];
        titleLbl.numberOfLines = 0;
        titleLbl.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_titleLbl = titleLbl];
        
        UILabel *contentLbl = [[UILabel alloc] init];
        contentLbl.numberOfLines = 0;
        contentLbl.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_contentLbl = contentLbl];
        
        // Common
        UIView *commonView = [[UIView alloc] init];
        commonView.backgroundColor = [UIColor randomColor];
        [self.contentView addSubview:_commonView = commonView];
        
        UIImageView *commonAuthorImgV = [[UIImageView alloc] init];
        commonAuthorImgV.layer.cornerRadius = 15.0;
        commonAuthorImgV.image = [UIImage imageNamed:@"level01"];
        [commonView addSubview:_commonAuthorImgV = commonAuthorImgV];
        
        UILabel *commonAuthorNameLbl = [[UILabel alloc] init];
        commonAuthorNameLbl.text = @"阿啊";
        commonAuthorNameLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        commonAuthorNameLbl.font = [UIFont systemFontOfSize:10];
        [commonView addSubview:_commonAuthorNameLbl = commonAuthorNameLbl];
        
        UILabel *commonAuthorReplyLbl = [[UILabel alloc] init];
        commonAuthorReplyLbl.text = @"abc阿啊2312312";
        commonAuthorReplyLbl.textColor = [UIColor colorWithHexString:@"63a3c6"];
        commonAuthorReplyLbl.font = [UIFont systemFontOfSize:10];
        [commonView addSubview:_commonAuthorReplyLbl = commonAuthorReplyLbl];
        
        UILabel *commonContentLbl = [[UILabel alloc] init];
        commonContentLbl.text = @"大伟儿玩儿玩儿玩儿";
        commonContentLbl.numberOfLines = 3;
        commonContentLbl.textColor = [UIColor colorWithHexString:@"313232"];
        commonContentLbl.font = [UIFont systemFontOfSize:12];
        [commonView addSubview:_commonContentLbl = commonContentLbl];
        
        UIButton *commonTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [commonTimeBtn setTitle:@"aweewrwe权威权威权威去二" forState:UIControlStateNormal];
        commonTimeBtn.titleLabel.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        commonTimeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        commonTimeBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [commonView addSubview:_commonTimeBtn = commonTimeBtn];
        
        UIView *commonLineView = [[UIView alloc] init];
        commonLineView.backgroundColor = [UIColor colorWithHexString:@"d9dfe5"];
        [commonView addSubview:_commonLineView = commonLineView];
        
        // Bottom
        UIView *bottomV = [[UIView alloc] init];
        bottomV.backgroundColor = [UIColor randomColor];
        [self.contentView addSubview:_bottomV = bottomV];
        
        UIButton *enjoyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        enjoyBtn.imageView.contentMode = UIViewContentModeCenter;
        [enjoyBtn setTitleColor:[UIColor colorWithHexString:@"e8465e"] forState:UIControlStateNormal];
        enjoyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [enjoyBtn setTitle:@"12赞" forState:UIControlStateNormal];
        enjoyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [enjoyBtn setImage:[UIImage imageNamed:@"nice"] forState:UIControlStateNormal];
        [bottomV addSubview:_enjoyBtn = enjoyBtn];
        [_enjoyBtn addTarget:self action:@selector(praiseClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *askBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        askBtn.imageView.contentMode = UIViewContentModeCenter;
        askBtn.tintColor = [UIColor whiteColor];
        askBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [askBtn setImage:[UIImage imageNamed:@"message_null"] forState:UIControlStateNormal];
        [bottomV addSubview:_askBtn = askBtn];
        
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [bottomV addSubview:_shareBtn = shareBtn];
    }
    return self;
}

- (void)setClubFrame:(MBClubFrame *)clubFrame{
    _clubFrame = clubFrame;
    
    if (clubFrame.club.content) {
        self.titleLbl.font = [UIFont systemFontOfSize:18];
        self.contentLbl.font = [UIFont systemFontOfSize:14];
        self.contentLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
    }else{
        self.titleLbl.font = [UIFont systemFontOfSize:12];
        self.contentLbl.font = [UIFont systemFontOfSize:12];
        self.contentLbl.textColor = [UIColor blackColor];
    }
    
    //标题
    self.titleLbl.text = clubFrame.club.title;
    //内容
    self.contentLbl.text = clubFrame.club.content;
    //头像
    if (![clubFrame.club.pic isEqual:[NSNull null]]) {
        [self.authorImgView sd_setImageWithURL:[NSURL URLWithString:clubFrame.club.pic]];
    }
    //大图片
    if (![clubFrame.club.Bigpic isEqual:[NSNull null]]) {
        [self.picImgV sd_setImageWithURL:[NSURL URLWithString:clubFrame.club.Bigpic] placeholderImage:[UIImage imageNamed:@"tempShow_05"]];
    }
    
    //昵称
    self.authorLbl.text = clubFrame.club.nick_name;
    //赞数
    [_enjoyBtn setTitle:clubFrame.club.praise_num forState:UIControlStateNormal];
    //评论数
    [_askBtn setTitle:clubFrame.club.comment_num forState:UIControlStateNormal];
    
    
    // Author on the UI Head
    self.authorView.frame = clubFrame.authorF;
    self.authorImgView.frame = CGRectMake(MARGIN_8, 2, 26, 26);
    CGSize authorLblSize = [self.authorLbl.text sizeWithFont:self.authorLbl.font withMaxSize:CGSizeMake(self.ml_width, self.authorView.ml_height)];
    self.authorLbl.frame = CGRectMake(CGRectGetMaxX(self.authorImgView.frame) + MARGIN_5, 0, authorLblSize.width, self.authorView.ml_height);
    self.authorLevelImgView.frame = CGRectMake(CGRectGetMaxX(self.authorLbl.frame) + MARGIN_5, (self.authorView.ml_height - 20) * 0.5, 20, 20);
    self.authorStarBtn.frame = CGRectMake(self.authorView.ml_width - 50 - MARGIN_8, (self.authorView.ml_height - 20) * 0.5, 50, 20);
    
    self.contentLbl.frame = clubFrame.contentF;
    self.picImgV.frame = clubFrame.picF;
    self.titleLbl.frame = clubFrame.titleF;
    
    if (clubFrame.club.common) {
        
        // Common
        self.commonView.frame = clubFrame.commonF;
        self.commonAuthorImgV.frame = CGRectMake(0, 0, 30, 30);
        CGSize commonAuthorNameLblSize = [self.commonAuthorNameLbl.text sizeWithFont:self.commonAuthorNameLbl.font withMaxSize:CGSizeMake(self.commonView.ml_width, self.commonView.ml_height)];
        self.commonAuthorNameLbl.frame = CGRectMake(CGRectGetMaxX(self.authorImgView.frame) + MARGIN_10, 0, commonAuthorNameLblSize.width, 10);
        self.commonAuthorReplyLbl.frame = CGRectMake(CGRectGetMaxX(self.commonAuthorNameLbl.frame) + MARGIN_5, 0, self.commonView.ml_width - commonAuthorNameLblSize.width, 10);
        CGSize commonContentLblSize = [self.commonContentLbl.text sizeWithFont:self.commonContentLbl.font withMaxSize:CGSizeMake(self.commonView.ml_width - MARGIN_20 - CGRectGetMaxX(self.authorImgView.frame), 50)];
        self.commonContentLbl.frame = CGRectMake(CGRectGetMaxX(self.authorImgView.frame) + MARGIN_20, CGRectGetMaxY(self.commonAuthorNameLbl.frame) + MARGIN_5, commonContentLblSize.width, commonContentLblSize.height);
        self.commonTimeBtn.frame = CGRectMake(0, CGRectGetMaxY(self.commonContentLbl.frame) + MARGIN_5, self.commonView.ml_width, 10);
        
    }
    
    // bottom
    self.bottomV.frame = clubFrame.bottomF;
    self.enjoyBtn.frame = CGRectMake(MARGIN_8, 0, 150, self.bottomV.ml_height);
    self.shareBtn.frame = CGRectMake(self.bottomV.ml_width - 28, 0, 20, 20);
    self.askBtn.frame = CGRectMake(CGRectGetMinX(self.shareBtn.frame) - 100, (self.bottomV.ml_height - 18) * 0.5 , 100, 18);
}
#pragma -mark点赞
-(void)praiseClick:(UIButton *)button
{
    NSString *type;
    if (button.selected) {
        type = @"1";
        button.selected = NO;
    }else
    {
        button.selected = YES;
        type = @"0";
    }
    NSString *post_id = _clubFrame.club.post_id;
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_QUANZI,@"/follow/add&"] parameters:@{@"post_id":post_id,@"type":type} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"点赞成功");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");

    }];
    

}
#pragma -mark添加关注

-(void)AddpraiseClick:(UIButton *)button
{
    MBUserDataSingalTon *info = [MBSignaltonTool getCurrentUserInfo];
    NSString *user_id = info.uid;
    if (!user_id) {
        return;
    }
    NSString *follow_id = _clubFrame.club.follow_id;
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_QUANZI,@"/praise/set&"] parameters:@{@"user_id":user_id,@"follow_id":follow_id} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"关注成功");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
        
    }];
}
@end
