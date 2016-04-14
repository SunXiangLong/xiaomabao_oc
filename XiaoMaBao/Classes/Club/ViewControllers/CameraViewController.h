//
//  CameraViewController.h
//  XiaoMaBao
//
//  Created by liulianqi on 15/11/10.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef enum : NSUInteger {
    hcCameraMode1to1,
    hcCameraMode9to16,
    hcCameraMode3to4,
} hcCameraMode;

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic,retain) AVCaptureSession *session;
@property AVCaptureStillImageOutput *imageOutput;
@property AVCaptureVideoPreviewLayer *previewSubLayer;
@property hcCameraMode cameraMode;

#pragma mark Actions
- (IBAction)clickSnapImageButton:(id)sender;
- (IBAction)clickCameraRollButton:(id)sender;
- (IBAction)clickSwitchCameraButton:(id)sender;
- (IBAction)clickFlashlightButton:(id)sender;
- (IBAction)clickProportionButton:(id)sender;

@end

