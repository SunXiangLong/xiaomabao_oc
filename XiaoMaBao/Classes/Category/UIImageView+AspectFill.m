//
//  UIImageView+AspectFill.m
//  XiaoMaBao
//
//  Created by xiaomabao on 16/9/19.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "UIImageView+AspectFill.h"

@implementation UIImageView (AspectFill)
- (void)imageViewFill{
    self.contentMode =  UIViewContentModeScaleAspectFill;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.clipsToBounds  = YES;
}
@end
