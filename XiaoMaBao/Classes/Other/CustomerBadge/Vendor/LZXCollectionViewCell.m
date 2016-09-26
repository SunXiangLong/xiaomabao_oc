//
//  LZXCollectionViewCell.m
//  引导页
//
//  Created by twzs on 16/6/23.
//  Copyright © 2016年 LZX. All rights reserved.
//

#import "LZXCollectionViewCell.h"

@implementation LZXCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageviewbg = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:self.imageviewbg];
    }
    return self;
}

@end
