//
//  MBEditorToolbarView.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/1/13.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MBEditorToolbarViewDelegate <NSObject>
@required

- (void)insertLibaryPhotoImage;
- (void)insterCameraPhotoImage;
- (void)selectBBSCategory;

@end

@interface MBEditorToolbarView : UIView

#pragma mark - Properties: delegate

/**
 *  @brief      The toolbar delegate.
 */
@property (nonatomic, weak, readwrite) id<MBEditorToolbarViewDelegate> delegate;

@property (nonatomic, strong) UIColor *itemTintColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, copy) NSString *selectedBBsCategory;

- (void)setToolBarEnable:(BOOL)enable;

@end
