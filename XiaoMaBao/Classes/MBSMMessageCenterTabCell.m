//
//  MBSMMessageCenterTabCell.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/7/4.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBSMMessageCenterTabCell.h"
#import "XiaoMaBao-Swift.h"
@interface MBSMMessageCenterTabCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatorView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statueView;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@end
@implementation MBSMMessageCenterTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(JMSGConversation *)model{
    _model = model;
    
    if (model.unreadCount  != nil&&([model.unreadCount integerValue]) > 0 ) {
        _numLabel.hidden =false;
        
        if ([model.unreadCount integerValue] > 99) {
            _numLabel.text = @"99+";
        }else{
            _numLabel.text  = [NSString stringWithFormat:@"%@",model.unreadCount];
        }
    }else{
        _numLabel.hidden =true;
    }
    JMSGUser *user = (JMSGUser *)model.target;
    [user thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
      
       
        self.avatorView.image = [UIImage imageWithData:data]?:[UIImage imageNamed:@"headPortrait"];
      
      
    }];
    

    _titleLabel.text = user.displayName;
    
    _msgLabel.text = model.latestMessageContentText;
    
    
    double  time = model.latestMessage.timestamp.doubleValue / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    
    _dateLabel.text = [date conversationDate];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
