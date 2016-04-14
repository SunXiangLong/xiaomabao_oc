//
//  XNEvaluateCell.m
//  XNChatCore
//
//  Created by Ntalker on 15/11/9.
//  Copyright © 2015年 Kevin. All rights reserved.
//

#import "XNEvaluateCell.h"
#import "XNEvaluateMessage.h"

#define ntalker_textColor2               [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0]

#define KWidth [UIScreen mainScreen].bounds.size.width

@interface XNEvaluateCell ()

@property (strong, nonatomic) UILabel *evaluateLabel;

@end

@implementation XNEvaluateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.evaluateLabel = [[UILabel alloc] init];
        self.evaluateLabel.backgroundColor = [UIColor clearColor];
        self.evaluateLabel.textColor = ntalker_textColor2;
        self.evaluateLabel.frame = CGRectMake(0, 10, KWidth - 20, 100);
        self.evaluateLabel.textAlignment = NSTextAlignmentCenter;
        self.evaluateLabel.numberOfLines = 0;
        self.evaluateLabel.layer.masksToBounds = YES;
        self.evaluateLabel.layer.cornerRadius = 3.0;
        self.evaluateLabel.font = [UIFont systemFontOfSize:16.0 * KWidth/414.0];
        [self.contentView addSubview:self.evaluateLabel];
    }
    return self;
}

- (void)configureAnything:(XNBaseMessage *)message
{
    if (![message isKindOfClass:[XNEvaluateMessage class]]) {
        return;
    }
//    XNEvaluateMessage *evaluateMessage = (XNEvaluateMessage *)message;
//    self.evaluateLabel.text = [NSString stringWithFormat:@"评价结果:%@; %@; %@",evaluateMessage.evaluateContent,evaluateMessage.solveStatus.length?evaluateMessage.solveStatus:@"",evaluateMessage.proposal.length?evaluateMessage.proposal:@""];
    self.evaluateLabel.text = @"评价提交成功";
    [self.evaluateLabel sizeToFit];
    
    CGRect frame = _evaluateLabel.frame;
    frame.origin.x = (KWidth - frame.size.width)/2;
    _evaluateLabel.frame = frame;
    
    self.frame = CGRectMake(0, 0, KWidth, _evaluateLabel.frame.size.height + 10);
}

- (void)dealloc
{
    
}

@end
