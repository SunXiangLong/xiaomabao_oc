//
//  MBSellingCollectionViewCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/13.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBSellingCollectionViewCell.h"
#import "MBTimeModel.h"
@interface MBSellingCollectionViewCell()

@property (nonatomic, weak)   id           model;
@property (nonatomic, weak)   NSIndexPath *indexPath;
@end
@implementation MBSellingCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self registerNSNotificationCenter];
}
-(void)loadData:(id)data indexPath:(NSIndexPath *)indexPath{
    if ([data isMemberOfClass:[MBTimeModel class]]) {
        
        self.model = data;
        self.indexPath = indexPath;
        
        MBTimeModel *model = (MBTimeModel*)data;
        
        
        _timeLable.text  = [NSString stringWithFormat:@"%@",[model currentTimeString]];
    }
    
    
}
- (void)dealloc {
    
    [self removeNSNotificationCenter];
}

#pragma mark - 通知中心
- (void)registerNSNotificationCenter {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationCenterEvent:)
                                                 name:NOTIFICATION_TIME_CELL
                                               object:nil];
}

- (void)removeNSNotificationCenter {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_TIME_CELL object:nil];
}

- (void)notificationCenterEvent:(id)sender {
    
    [self loadData:self.model indexPath:self.indexPath];
}

@end
