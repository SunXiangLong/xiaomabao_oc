//
//  MBWeatherAndMoodViewController.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/2/18.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "BkBaseViewController.h"

typedef enum : NSUInteger {
   MBWeatherType = 0,
   MBmoodType,
   MBcircleType
} MBType;
typedef void(^WWBlock)(UIImage *image,MBType type,NSString *row);
typedef void(^MMBlock)(NSDictionary *dci);
@interface MBWeatherAndMoodViewController : BkBaseViewController
@property (nonatomic ,strong) NSArray *infoArray;
@property (nonatomic, copy) WWBlock block;
@property (nonatomic, copy) MMBlock circleBlock;
@property (nonatomic,assign) MBType  type;
@end
