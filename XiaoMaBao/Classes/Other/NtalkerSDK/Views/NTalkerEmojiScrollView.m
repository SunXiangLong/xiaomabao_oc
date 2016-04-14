//
//  UIXNEmojiScrollView.m
//  CustomerServerSDK2
//
//  Created by NTalker on 15/4/13.
//  Copyright (c) 2015年 NTalker. All rights reserved.
//

#import "NTalkerEmojiScrollView.h"

#define kFWFullScreenHeight     [UIScreen mainScreen].bounds.size.height
#define kFWFullScreenWidth      [UIScreen mainScreen].bounds.size.width

@interface NTalkerEmojiScrollView ()
{
    UIButton *sendBtn;
}
@end
@implementation NTalkerEmojiScrollView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        float autoSizeScaleX=kFWFullScreenHeight>480?kFWFullScreenWidth/320:1.0;
        float iconScale=kFWFullScreenWidth<414?kFWFullScreenWidth/414:1.0;
        
        [self setBackgroundColor:[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0]];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFWFullScreenWidth, 0.5)];
        [lineView setBackgroundColor:[UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0]];
        [self addSubview:lineView];
        
        self.scrollEnabled = NO;
        NSArray *facesArray = [NTalkerEmojiScrollView getAllEmoji];
        //表情大小
        CGFloat faceIconW = 30*iconScale;
        CGFloat faceIconH = 30*iconScale;
        CGFloat gapH = 20;
        CGFloat gapW = (kFWFullScreenWidth-30-6*faceIconW)/5;
        
        for (int i=0; i<20; i++) {
            UIButton *faceBtn = [[UIButton alloc] init];
            faceBtn.tag=i;
            int line = i/6;
            int location = i%6;
            CGFloat faceIconX = location*(faceIconW+gapW)+15;
            CGFloat faceIconY = line*(faceIconH+gapH)+18;
            [faceBtn setFrame:CGRectMake(faceIconX,faceIconY , faceIconW, faceIconH)];
            NSString *emojiPng = [NSString stringWithFormat:@"%@.png",[facesArray objectAtIndex:i]];
            
            [faceBtn setBackgroundImage:[UIImage imageNamed:[@"NTalkerUIKitResource.bundle" stringByAppendingPathComponent:emojiPng]] forState:UIControlStateNormal];
            [faceBtn addTarget:self action:@selector(faceButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:faceBtn];
        }
        //表情发送按钮
        sendBtn = [[UIButton alloc] init];
        sendBtn.tag=20;
        sendBtn.enabled=NO;
        CGFloat sendBtnW = 60*autoSizeScaleX;
        CGFloat sendBtnH = 30*autoSizeScaleX;
        [sendBtn setFrame:CGRectMake(kFWFullScreenWidth-15-sendBtnW, 3*(faceIconH+gapH)+18, sendBtnW, sendBtnH)];
        [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        sendBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0*autoSizeScaleX];
        [sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [sendBtn setBackgroundColor:[UIColor whiteColor]];
        //设置边框
        sendBtn.layer.borderWidth = 0.5f;
        sendBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        //圆角
        sendBtn.layer.cornerRadius = 2.0f;
        [sendBtn addTarget:self action:@selector(faceButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendBtn];
        
        //表情删除按钮
        UIButton *deleteBtn = [[UIButton alloc] init];
        deleteBtn.tag=21;
        [deleteBtn setFrame:CGRectMake(2*(faceIconW+gapW)+15,3*(faceIconH+gapH)+18 , faceIconW, faceIconH)];
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/emoji_cancel.png"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(faceButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
        
        CGRect emojiFrame = self.frame;
        emojiFrame.size.height = CGRectGetMaxY(sendBtn.frame) + 10;
        self.frame = emojiFrame;
        
    }
    return self;
}
+ (NSArray *)getAllEmoji {
    return [NSArray arrayWithObjects:@"[wx]",@"[tx]",@"[hx]",@"[dy]",@"[ll]",@"[sj]",@"[dk]",@"[jy]",@"[zj]",@"[gg]",@"[kx]",@"[zb]",@"[yw]",@"[dn]",@"[sh]",@"[ku]",@"[fn]",@"[ws]",@"[ok]",@"[xh]",nil];
}

- (void)faceButton:(UIButton *)sender {
    if(sender.tag<20&&_emojiDelegate && [_emojiDelegate respondsToSelector:@selector(selectedEmoji:)]) {
        NSArray *facesArray = [NTalkerEmojiScrollView getAllEmoji];
        [_emojiDelegate selectedEmoji:[facesArray objectAtIndex:sender.tag]];
    }
    else if(sender.tag==20&& _emojiDelegate && [_emojiDelegate respondsToSelector:@selector(sendEmoji)]) {
        [_emojiDelegate sendEmoji];
    }
    else {
        [_emojiDelegate selectedEmoji:nil];
    }
}
-(void)setSendBtnStatus:(BOOL)enable{
    sendBtn.enabled=enable;
    if (enable) {
        [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendBtn setBackgroundColor:[UIColor colorWithRed:76/255.0 green:118/255.0 blue:253/255.0 alpha:1.0]];
        sendBtn.layer.borderWidth = 0.0f;
    } else {
        [sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [sendBtn setBackgroundColor:[UIColor whiteColor]];
        sendBtn.layer.borderWidth = 0.5f;
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
