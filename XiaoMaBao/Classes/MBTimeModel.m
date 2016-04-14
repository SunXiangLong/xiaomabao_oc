//
//  MBTimeModel.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/19.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBTimeModel.h"

@implementation MBTimeModel
-(void)countDown{
    _timeNum -=1;

}
-(NSString *)currentTimeString{
    if (_timeNum<=0) {
        return @"团购已结束";
        
    }else{
        NSInteger leftdays = _timeNum/(24*60*60);
        NSInteger hour = (_timeNum-leftdays*24*3600)/3600;
        NSInteger minute = (_timeNum - hour*3600-leftdays*24*3600)/60;
        NSInteger second = (_timeNum - hour *3600 - 60*minute-leftdays*24*3600);
        
         return [NSString stringWithFormat:@"仅剩%ld天%ld时%ld分%ld秒",leftdays,hour,minute,second];
        
       
    }

}
@end
