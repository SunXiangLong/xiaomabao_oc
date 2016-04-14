//
//  MBTimeModel.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/19.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBTimeModel : NSObject
@property (nonatomic,assign) NSInteger timeNum;

-(void)countDown;
-(NSString *)currentTimeString;
@end
