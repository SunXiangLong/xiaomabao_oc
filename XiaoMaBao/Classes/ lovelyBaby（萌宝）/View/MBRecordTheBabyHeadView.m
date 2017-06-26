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
@property (weak, nonatomic) IBOutlet UIView *tapVIew;

@end
@implementation MBRecordTheBabyHeadView
-(void)awakeFromNib{
    [super awakeFromNib];
    [_tapVIew addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recordTheBaby:)]];

   _buttonArray = @[_photoWallOne,_photoWallTwo,_photoWallThree,_photoWallFour,_photoWallFive];
}

+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBRecordTheBabyHeadView" owner:nil options:nil] lastObject];
}
- (void)recordTheBaby:(id)sender {
    self.blcok(5);
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
