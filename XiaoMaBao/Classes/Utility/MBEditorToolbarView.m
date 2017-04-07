//
//  WPEditorToolbarView.m
//  Pods
//
//  Created by Jvaeyhcd on 27/12/2016.
//
//

#import "MBEditorToolbarView.h"

@interface MBEditorToolbarView()

@property (nonatomic, strong) UIButton *imageBtn;
@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) UILabel *postLbl;
@property (nonatomic, strong) UIImageView *arrowImg;

@end

@implementation MBEditorToolbarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit
{
    NSBundle* editorBundle = [NSBundle bundleForClass:[self class]];
    
    if (nil == _imageBtn) {
        _imageBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        
        UIImage* image = [UIImage imageNamed:@"publish_btn_pic" inBundle:editorBundle compatibleWithTraitCollection:nil];
        UIImage* buttonImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _imageBtn.tag = 1001;
        [_imageBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_imageBtn setImage:buttonImage forState: UIControlStateNormal];
        
        [self addSubview:_imageBtn];
    }
    
    if (nil == _cameraBtn) {
        _cameraBtn = [[UIButton alloc]initWithFrame:CGRectMake(44, 0, 44, 44)];
        UIImage* image = [UIImage imageNamed:@"publish_btn_camera" inBundle:editorBundle compatibleWithTraitCollection:nil];
        UIImage* buttonImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _cameraBtn.tag = 1002;
        [_cameraBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_cameraBtn setImage:buttonImage forState: UIControlStateNormal];
        
        [self addSubview:_cameraBtn];
    }
    
}

- (void)btnClicked: (UIButton *)button
{
    switch (button.tag) {
            case 1001:
            [self.delegate insertLibaryPhotoImage];
            break;
            case 1002:
            [self.delegate insterCameraPhotoImage];
            break;
        default:
            break;
    }
}

- (void)setItemTintColor:(UIColor *)itemTintColor
{
    _itemTintColor = itemTintColor;
    self.imageBtn.tintColor = _itemTintColor;
    self.cameraBtn.tintColor = _itemTintColor;
}
- (void)setToolBarEnable:(BOOL)enable
{
    self.imageBtn.enabled = enable;
    self.cameraBtn.enabled = enable;
}

@end
