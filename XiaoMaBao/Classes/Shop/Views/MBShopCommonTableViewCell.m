//
//  MBShopCommonTableViewCell.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/6.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBShopCommonTableViewCell.h"
#import "MBShopCommonFrame.h"
#import "MBShopCommon.h"

@interface MBShopCommonTableViewCell ()

@property (weak,nonatomic) UILabel *authorLbl;
@property (weak,nonatomic) UIButton *levelBtn;
@property (weak,nonatomic) UILabel *contentLbl;
@property (weak,nonatomic) UIView *figureView;
@property (weak,nonatomic) UIView *lineBottomView;

@end

@implementation MBShopCommonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 创建View
        UILabel *authorLbl = [[UILabel alloc] init];
        authorLbl.font = [UIFont systemFontOfSize:12];
        authorLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        [self.contentView addSubview:_authorLbl = authorLbl];
        
        UIButton *levelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_levelBtn = levelBtn];
        
        UILabel *contentLbl = [[UILabel alloc] init];
        contentLbl.numberOfLines = 0;
        contentLbl.font = [UIFont systemFontOfSize:11];
        contentLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        [self.contentView addSubview:_contentLbl = contentLbl];
        
        UIView *figureView = [[UIView alloc] init];
        [self.contentView addSubview:_figureView = figureView];
        
        UIView *lineBottomView = [[UIView alloc] init];
        lineBottomView.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
        [self.contentView addSubview:_lineBottomView = lineBottomView];
    }
    return self;
}

- (void)setShopCommonFrame:(MBShopCommonFrame *)shopCommonFrame{
    _shopCommonFrame = shopCommonFrame;
    
    MBShopCommon *common = shopCommonFrame.shopCommon;
    
    NSInteger count = common.figures.count;
    
    NSInteger showCount = (NSInteger)([UIScreen mainScreen].bounds.size.width / 60.0);
    
    for (NSInteger i = 0; i < count; i++) {
        NSInteger col = i % showCount;
        NSInteger row = i / showCount;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.figureView  addSubview:btn];
        btn.frame = CGRectMake((col * 60 + MARGIN_5), row * (60 + MARGIN_5), 60, 60);
        [btn setImage:[UIImage imageNamed:common.figures[i]] forState:UIControlStateNormal];
    }
    
    // data
    self.authorLbl.text = common.author;
    self.contentLbl.text = common.content;
    
    // frame
    self.authorLbl.frame = shopCommonFrame.authorF;
    self.contentLbl.frame = shopCommonFrame.contentF;
    self.levelBtn.frame = shopCommonFrame.levelF;
    self.figureView.frame = shopCommonFrame.figureF;
    self.lineBottomView.frame = shopCommonFrame.lineBottomF;
}

@end
