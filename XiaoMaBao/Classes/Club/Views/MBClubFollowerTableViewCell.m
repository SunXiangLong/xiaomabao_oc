//
//  MBClubFollowerTableViewCell.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/15.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBClubFollowerTableViewCell.h"

@interface MBClubFollowerTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@end

@implementation MBClubFollowerTableViewCell

- (void)setIsStart:(BOOL)isStart{
    _isStart = isStart;
    
    if (isStart) {
        [self.startBtn setTitle:@"已关注" forState:UIControlStateNormal];
        self.startBtn.backgroundColor = [UIColor colorWithHexString:@"d9dfe5"];
    }else{
        [self.startBtn setTitle:@"关注" forState:UIControlStateNormal];
        self.startBtn.backgroundColor = [UIColor colorWithHexString:@"63a3c6"];
    }
}


@end
