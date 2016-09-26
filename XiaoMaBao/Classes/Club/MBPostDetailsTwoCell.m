//
//  MBPostDetailsOneCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBPostDetailsTwoCell.h"
#import "YYWebImage.h"
@interface MBPostDetailsTwoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *user_head;
@property (weak, nonatomic) IBOutlet UILabel *user_name;
@property (weak, nonatomic) IBOutlet UILabel *comment_time;
@property (weak, nonatomic) IBOutlet UILabel *comment_floor;
@property (weak, nonatomic) IBOutlet UILabel *comment_content;
@property (weak, nonatomic) IBOutlet UIImageView *user_head_user_head;
@property (weak, nonatomic) IBOutlet UILabel *comment_reply_comment_content;
@property (weak, nonatomic) IBOutlet UILabel *comment_reply_user_name;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *comment_reply_height;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (strong, nonatomic)   UIImageView *oldimageView;
@end
@implementation MBPostDetailsTwoCell

//- (RACSubject *)myCircleViewSubject {
//    
//    if (!_myCircleViewSubject) {
//        
//        _myCircleViewSubject = [RACSubject subject];
//    }
//    
//    return _myCircleViewSubject;
//}
//- (IBAction)reply:(UIButton *)sender {
//    [self.myCircleViewSubject  sendNext:self.indexPath];
//
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    self.comment_time.text = dataDic[@"comment_time"];
    self.comment_floor.text = dataDic[@"comment_floor"];
    self.comment_content.text = dataDic[@"comment_content"];
    self.user_name.text = dataDic[@"user_name"];
    [self.user_head sd_setImageWithURL:URL(dataDic[@"user_head"]) placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    [self.comment_content rowSpace:6];
    [self.comment_content columnSpace:1];
    if (dataDic[@"comment_reply"]) {
        
        NSString *comment_reply_comment_content =  dataDic[@"comment_reply"][@"comment_content"];
        CGFloat comment_reply_user_name_height  =  [comment_reply_comment_content sizeWithFont: SYSTEMFONT(12) lineSpacing:2 withMax:UISCREEN_WIDTH -70];
        self.comment_reply_user_name.text = dataDic[@"comment_reply"][@"user_name"];
        self.comment_reply_comment_content.text = dataDic[@"comment_reply"][@"comment_content"];
        [self.user_head_user_head sd_setImageWithURL:URL(dataDic[@"comment_reply"][@"user_head"]) placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
        self.comment_reply_height.constant  = comment_reply_user_name_height+30;
        self.commentView.hidden = NO;
        [self.comment_reply_comment_content rowSpace:2];
        [self.comment_reply_comment_content columnSpace:1];
    }else{
        self.comment_reply_height.constant  = 0;
        self.commentView.hidden = YES;
    }
    
   
    
    
}
- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    totalHeight+=48;
    totalHeight+=[self.dataDic[@"comment_content"] sizeWithFont:SYSTEMFONT(16) lineSpacing:6 withMax:UISCREEN_WIDTH-20];
    totalHeight+=self.comment_reply_height.constant;
    
       totalHeight+=48;
    if (self.dataDic[@"comment_reply"]) {
      totalHeight+=10;
    }
    return CGSizeMake(size.width, totalHeight);
}
@end
