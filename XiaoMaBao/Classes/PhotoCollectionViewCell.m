//
//  PhotoCollectionViewCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 15/12/1.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

- (void)awakeFromNib {
    
    self.image.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress)];
    longPress.minimumPressDuration = 0.8;
    [self.image addGestureRecognizer:longPress];
}
-(void)handleLongPress{
   
    
    if (self.dalegate &&[self.dalegate respondsToSelector:@selector(setDeletePicture:)]) {
        [self.dalegate setDeletePicture:self.indexpate];
    }

}
@end
