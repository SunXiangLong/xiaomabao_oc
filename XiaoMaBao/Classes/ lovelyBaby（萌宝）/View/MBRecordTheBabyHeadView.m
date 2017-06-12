//
//  MBRecordTheBabyHeadView.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/6/9.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBRecordTheBabyHeadView.h"
@interface MBRecordTheBabyHeadView ()

@property (weak, nonatomic) IBOutlet UIButton *photoWallOne;
@property (weak, nonatomic) IBOutlet UIButton *photoWallTwo;
@property (weak, nonatomic) IBOutlet UIButton *photoWallThree;
@property (weak, nonatomic) IBOutlet UIButton *photoWallFour;
@property (weak, nonatomic) IBOutlet UIButton *photoWallFive;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addImageHeight;
@end
@implementation MBRecordTheBabyHeadView
-(void)awakeFromNib{
    [super awakeFromNib];
    
    _addImageHeight.constant = (UISCREEN_WIDTH - 60)/3 *227/124;
   
   _buttonArray = @[_photoWallOne,_photoWallTwo,_photoWallThree,_photoWallFour,_photoWallFive];
}

+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBRecordTheBabyHeadView" owner:nil options:nil] lastObject];
}

- (IBAction)setThePhotoWallOrReleaseTheBaby:(UIButton *)sender {
    self.blcok(sender.tag);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
