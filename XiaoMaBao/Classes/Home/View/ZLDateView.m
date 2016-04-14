//
//  ZLDateView.m
//  日历
//
//  Created by 张磊 on 14-11-2.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import "ZLDateView.h"

@interface ZLDateView ()
// 用来保存的日期
@property (nonatomic , strong) NSMutableArray *dateFrames;
// 星期几
@property (nonatomic , assign) NSInteger weekday;
@property (nonatomic , assign) NSInteger monthDay;
@property (nonatomic , copy) NSString *day;
@property (nonatomic , copy) NSString *month;
@property (nonatomic , copy) NSString *year;
@property (nonatomic , assign) NSInteger monthThisDay;

@end

@implementation ZLDateView

- (NSMutableArray *)dateFrames{
    if (!_dateFrames) {
        _dateFrames = [NSMutableArray array];
    }
    return _dateFrames;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        [self setNeedsDisplay];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
        [self setNeedsDisplay];
    }
    return self;
}


- (void) setup{
    
    
//    self.backgroundColor = [UIColor whiteColor];
    NSDate *mydate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM"; // 当前月份
    NSString *month = [formatter stringFromDate:mydate];
    self.month = month;
    formatter.dateFormat = @"yy"; // 当前年
    NSString *year = [formatter stringFromDate:mydate];
    self.year = year;
    formatter.dateFormat = @"dd"; // 当前天
    self.day = [formatter stringFromDate:mydate];
    
    NSDate *datetime = [[NSDate date] initWithTimeIntervalSinceNow:-(24 *60 * 60 * ([self.day intValue] ))];
    
    
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:mydate];
    
     NSDateComponents *monthComps = [calendar components:unitFlags fromDate:datetime];

    self.monthThisDay = [monthComps weekday];
    
    if ([comps weekday] == 1) {
        self.weekday = 6;
    }else{
        self.weekday = [comps weekday] - 1;
    }
    
    self.monthDay = [self getTimeAtMonth:month year:self.year];
    
}

#pragma mark 根据月份来获取时间
- (NSInteger) getTimeAtMonth : (NSString *) month year:(NSString *)year{
    
    // 1\3\5\7\8\10\12 == 31
    // 2 闰年就是29天.否则28天
    // 4\6\9\11 == 30天
    NSArray *oneMonth = @[@"01",@"03",@"05",@"07",@"08",@"10",@"12"];
    NSArray *twoMonth = @[@"02"];
    
    if ([oneMonth containsObject:month]) {
        // 31天
        return 31;
    }else if ([twoMonth containsObject:month]){
        // 2月判断是否为闰年
        if ([year intValue] % 100 != 0 && ([year intValue] % 4 == 0 || [year intValue] % 400) ) {
            return 29;
        }else{
            return 28;
        }
        
    }else {
       return 30;
    }
}

- (void)setMonthDay:(NSInteger)monthDay{
    _monthDay = monthDay;
    [self setNeedsDisplay];
}

- (void)setDatys:(NSArray *)datys{
    _datys = datys;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    // 如果存在日期就开始绘制
    if (self.monthDay) {
        
        [self.dateFrames removeAllObjects];
        
        NSArray *month = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
        // 30天
        // 生成30个日期的控件View
        // 每行展示7个
        NSInteger column = 7;
        NSInteger number = self.monthDay;
        
        NSInteger btnW = self.frame.size.width / (column + 1);
        CGFloat margin = btnW / column;
        NSInteger btnH = self.frame.size.height / 7;

        UIFont *font = [UIFont systemFontOfSize:14];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSFontAttributeName] = font;

        NSInteger lastDay = 30;
        if([self.month isEqualToString:@"01"]){
            int y = self.year.intValue - 1;
            NSString * yy = [NSString stringWithFormat:@"%d",y];
            lastDay = [self getTimeAtMonth:@"12" year:yy];
        }else{
            int m = self.month.intValue - 1;
            NSString * mm = [NSString stringWithFormat:@"%d",m];
            if(m < 10){
                mm = [NSString stringWithFormat:@"0%d",m];
            }
            
            lastDay = [self getTimeAtMonth:mm year:self.year];
        }
        
        for (NSInteger lastIndex = lastDay - self.monthThisDay + 1 , index =  0; lastIndex <= lastDay; lastIndex++, index++) {
            
            // 计算Frame
            NSInteger col = index % column;
            NSInteger row = index / column + 1;
            
            dict[NSForegroundColorAttributeName] = [UIColor blackColor];
            
            CGFloat btnX = col * (btnW + margin) + margin + 10;
            CGFloat btnY = row * btnH - 20;
            CGRect frame = CGRectMake(btnX, btnY, btnW, btnH);
            [[NSString stringWithFormat:@"%ld",lastIndex] drawInRect:frame withAttributes:dict];
            
//            NSString * s = @"1";
            
            [self.dateFrames addObject:[NSValue valueWithCGRect:frame]];
            
        }
        
        for (NSInteger index = 1, startIndex = self.monthThisDay; index <= number; index++,startIndex++) {
            // 计算Frame
            NSInteger col = startIndex % column;
            NSInteger row = startIndex / column + 1;
            
            if ([self.day intValue] == index) {
                dict[NSForegroundColorAttributeName] = [UIColor blueColor];
            }else{
                dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
            }
            
            for (NSInteger i = 0; i < self.datys.count; i++) {
                if ([self.datys[i] integerValue] == index) {
                    dict[NSForegroundColorAttributeName] = [UIColor redColor];
                }
            }
            
            CGFloat btnX = col * (btnW + margin) + margin + 10;
            CGFloat btnY = row * btnH - 20;
            CGRect frame = CGRectMake(btnX, btnY, btnW, btnH);
            [[NSString stringWithFormat:@"%d",index] drawInRect:frame withAttributes:dict];
            [self.dateFrames addObject:[NSValue valueWithCGRect:frame]];
        }
    }
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    NSInteger dateFramesCount = self.dateFrames.count;
    for (int i = 0; i < dateFramesCount; i++) {
        NSValue *value = self.dateFrames[i];
        CGRect frame = [value CGRectValue];
        if (CGRectContainsPoint(frame, point)) {
            
            if ([self.delegate respondsToSelector:@selector(dateViewDidClickDateView:atIndexDay:)]) {
                [self.delegate dateViewDidClickDateView:self atIndexDay:i+1];
            }
        }
    }
}

@end
