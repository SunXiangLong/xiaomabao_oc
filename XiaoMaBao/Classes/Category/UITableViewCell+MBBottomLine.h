//
//  UITableViewCell+MBBottomLine.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/11/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (MBBottomLine)

/**
 让cell地下的边线挨着左边界
 */
-(void)uiedgeInsetsZero;


/**移除cell最下的线*/
-(void)removeUIEdgeInsetsZero;
@end
