//
//  UIXNEmojiScrollView.h
//  CustomerServerSDK2
//
//  Created by NTalker on 15/4/13.
//  Copyright (c) 2015年 NTalker. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIXNEmojiScrollViewDelegate<NSObject>
@optional
-(void)selectedEmoji:(NSString *)emoji;
-(void)sendEmoji;//发送表情

@end
@interface NTalkerEmojiScrollView : UIScrollView
@property (nonatomic, assign)id<UIXNEmojiScrollViewDelegate> emojiDelegate;

+(NSArray *)getAllEmoji;
-(void)setSendBtnStatus:(BOOL)enable;
@end
