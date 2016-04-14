//
//  MBCameraViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

//
//  PhotoCameraViewController.m
//  自定义相机
//
//  Created by corepass on 15/12/28.
//  Copyright © 2015年 corepass. All rights reserved.
//

#import "MBCameraViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MBEditPicturesViewController.h"
@interface MBCameraViewController ()
{
    UIView * view;
    UIImageView * imageView;
    UIView * aview;
    BOOL isBulkPaste;//判断是否添加大头贴
    UIView * flashView;
    UIView * view1;
    NSInteger _biaoshi;
    
}

@property(nonatomic,strong) AVCaptureSession * capturesession;//控制输入和输出设备之间的数据传递
@property(nonatomic,strong)AVCaptureVideoPreviewLayer *preViewLayer;//镜头捕捉到得预览图层
@property(nonatomic,strong)AVCaptureDeviceInput  *videoDeviceInput;//调用所有的输入硬件。例如摄像头和麦克风
@property (nonatomic, strong) AVCaptureStillImageOutput* stillImageOutput;//用于输出图像
@property (nonatomic,strong)NSMutableArray * files;
@end

@implementation MBCameraViewController{
    
    BOOL isUsingFrontFacingCamera;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isBulkPaste = NO;
    self.navBar.hidden = YES;
    // Do any additional setup after loading the view.
    [self setPhotoCameraIsView];
}
#pragma mark 初始化方法
-(void)setPhotoCameraIsView{
    self.capturesession = [[AVCaptureSession alloc]init];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    [device lockForConfiguration:nil];
    [device setFlashMode:AVCaptureFlashModeAuto];//设置闪光灯为自动
    [device unlockForConfiguration];
    self.videoDeviceInput = [[AVCaptureDeviceInput alloc]initWithDevice:device error:&error];
    if (error) {
        NSLog(@"error= %@",error);
    }
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc]init];
    NSDictionary * outputSettings = [[NSDictionary alloc]initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    ////输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    [self.stillImageOutput setOutputSettings:outputSettings];
    if ([self.capturesession canAddInput:self.videoDeviceInput]) {
        [self.capturesession addInput:self.videoDeviceInput];
    }
    if ([self.capturesession canAddOutput:self.stillImageOutput]) {
        [self.capturesession addOutput:self.stillImageOutput];
    }
    self.preViewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.capturesession];
    [self.preViewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    self.preViewLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    view1.layer.masksToBounds = YES;
    [view1.layer addSublayer:self.preViewLayer];
    UIImageView * imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    imageView3.contentMode = UIViewContentModeScaleAspectFit;
    imageView3.image = [UIImage imageNamed:@"one"];
    
    if (isBulkPaste == NO) {
        
    }else{
        [view1 addSubview:imageView3];
    }
    
    [self.view addSubview:view1];
    [self photoEvent:view1];
    //NSLog(@"self.stillImageOutput= %@",self.stillImageOutput);
}
#pragma mark 照相机的UI界面
-(void)photoEvent:(UIView *)backView{
    //拍照
    UIView  *view111 = [[UIView alloc] initWithFrame:CGRectMake(0,0, UISCREEN_WIDTH, (UISCREEN_HEIGHT-UISCREEN_WIDTH)/2)];
    view111.backgroundColor = [UIColor blackColor];
    view111.alpha = 0.8;
    [backView addSubview:view111];
    
    
    UIView  *view1111 = [[UIView alloc] initWithFrame:CGRectMake(0,UISCREEN_HEIGHT-(UISCREEN_HEIGHT-UISCREEN_WIDTH)/2, UISCREEN_WIDTH, (UISCREEN_HEIGHT-UISCREEN_WIDTH)/2)];
    view1111.backgroundColor = [UIColor blackColor];
    view1111.alpha = 0.8;
    [backView addSubview:view1111];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(UISCREEN_WIDTH/2-50, UISCREEN_HEIGHT-100, 100, 100);
    [btn setImage:[UIImage imageNamed:@"PZ"] forState:UIControlStateNormal];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btn addTarget:self action:@selector(buttonP:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    //切换镜头
    UIButton * cameraLensBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraLensBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-50, 3, 50, 50);
    //[cameraLensBtn setTitle:@"镜头" forState:UIControlStateNormal];
    [cameraLensBtn setImage:[UIImage imageNamed:@"SwitchCamera"] forState:UIControlStateNormal];
    //btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //[cameraLensBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cameraLensBtn addTarget:self action:@selector(cameraLensBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:cameraLensBtn];
    
    UIButton * flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    flashBtn.frame = CGRectMake(0, 0, 60, 60);
    [flashBtn setImage:[UIImage imageNamed:@"sd"] forState:UIControlStateNormal];
    //    [flashBtn setTitle:@"开启" forState:UIControlStateNormal];
    //    [flashBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [flashBtn addTarget:self action:@selector(flashEventBtn: UIView:) forControlEvents:UIControlEventTouchUpInside];
    [flashBtn setImage:[UIImage imageNamed:@"SwitchFlash_auto"] forState:UIControlStateNormal];
    [backView addSubview:flashBtn];
}
#pragma mark 改变图片的方向
- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation{
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}
#pragma mark 相机的闪光灯事件
- (void)flashEventBtn:(UIButton *)btn UIView:(UIView *)v{//闪光灯选择
    //    flashView = [[UIView alloc]init];
    //    flashView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
    //    NSArray * arr = @[@"开启",@"关闭",@"自动"];
    //    for (int i = 0; i < 3; i++) {
    //        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        btn.frame = CGRectMake(0, i*40+40, 60, 30);
    //        btn.tag = i+1;
    //        [btn setTitle:arr[i] forState:UIControlStateNormal];
    //        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //        [btn addTarget:self action:@selector(flashBtn:) forControlEvents:UIControlEventTouchUpInside];
    //        [UIView animateWithDuration:5 animations:^{
    //            [flashView addSubview:btn];
    //        }];
    //
    //    }
    //    [UIView animateWithDuration:0.7 animations:^{
    //        flashView.frame = CGRectMake(0, 0, 70, 210);
    //
    //    }];
    //    [view1 addSubview:flashView];
    AVCaptureDevice * captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [captureDevice lockForConfiguration:nil];
    _biaoshi ++;
    if ([captureDevice hasFlash]) {
        switch (_biaoshi) {
            case 0:  {[btn setImage:[UIImage imageNamed:@"SwitchFlash_auto"] forState:UIControlStateNormal]; [captureDevice setFlashMode:AVCaptureFlashModeAuto];}   break;
            case 1:  [btn setImage:[UIImage imageNamed:@"SwitchFlash_on"] forState:UIControlStateNormal]; [captureDevice setFlashMode:AVCaptureFlashModeOn];     break;
            case 2:  [btn setImage:[UIImage imageNamed:@"SwitchFlash_off"] forState:UIControlStateNormal]; [captureDevice setFlashMode:AVCaptureFlashModeOff];  break;
            default:  _biaoshi =0; [btn setImage:[UIImage imageNamed:@"SwitchFlash_auto"] forState:UIControlStateNormal];  break;
        }
    }else{
        
        NSLog(@"闪关灯不可用");
    }
}
#pragma mark 调换摄像头事件
- (void)cameraLensBtn:(UIButton *)btn{//摄像头调换
    AVCaptureDevicePosition desiredPosition;
    if (isUsingFrontFacingCamera){
        desiredPosition = AVCaptureDevicePositionBack;
        //[btn setTitle:@"后置" forState:UIControlStateNormal];
    }else{
        desiredPosition = AVCaptureDevicePositionFront;
        //[btn setTitle:@"前置" forState:UIControlStateNormal];
    }
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == desiredPosition) {
            [self.preViewLayer.session beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
            for (AVCaptureInput *oldInput in self.preViewLayer.session.inputs) {
                [[self.preViewLayer session] removeInput:oldInput];
            }
            [self.preViewLayer.session addInput:input];
            [self.preViewLayer.session commitConfiguration];
            break;
        }
    }
    isUsingFrontFacingCamera = !isUsingFrontFacingCamera;
}
#pragma mark 拍照按钮的点击事件
-(void)buttonP:(UIButton *)btn{//拍照按钮的点击事件
    AVCaptureConnection *stillImageConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                
                stillImageConnection = connection;
                break;
            }
        }
    }
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice]orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    [stillImageConnection setVideoScaleAndCropFactor:1.0];
    NSLog(@"stillImageOutput= %@",self.stillImageOutput);
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage * image = [UIImage imageWithData:jpegData];
       
        MBEditPicturesViewController * filter = [[MBEditPicturesViewController alloc]init];
    
            
            filter.image = [self cropImageWithImage:image proportion:1];;
        
        [self pushViewController:filter Animated:YES];
        //        NSData * data = UIImageJPEGRepresentation(image3, 1);
        //
        //        CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault,
        //                                                                    imageDataSampleBuffer,
        //                                                                    kCMAttachmentMode_ShouldPropagate);
        //
        //        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        //        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
        //            //无权限
        //            return ;
        //        }
        //        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        //        [library writeImageDataToSavedPhotosAlbum:data metadata:(__bridge id)attachments completionBlock:^(NSURL *assetURL, NSError *error) {
        //            //UISaveVideoAtPathToSavedPhotosAlbum([UIImage imageWithData:], self, nil, nil);
        //
        //        }];
        
    }];
}
#pragma mark 大头贴图片的合成
- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 {
    UIGraphicsBeginImageContext(self.view.frame.size);
    CGFloat CGx = ([UIScreen mainScreen].bounds.size.width-image2.size.width)/2;
    // Draw image1
    [image1 drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    // Draw image2
    
    [image2 drawInRect:CGRectMake(CGx, 0, image2.size.width, image2.size.height)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

#pragma mark 对图形操作后改变图形的方向
- (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    
    long double rotate = 0.0;
    
    CGRect rect;
    
    float translateX = 0;
    
    float translateY = 0;
    
    float scaleX = 1.0;
    
    float scaleY = 1.0;
    
    
    
    switch (orientation) {
            
        case UIImageOrientationLeft:
            
            rotate = M_PI_2;
            
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            
            translateX = 0;
            
            translateY = -rect.size.width;
            
            scaleY = rect.size.width/rect.size.height;
            
            scaleX = rect.size.height/rect.size.width;
            
            break;
            
        case UIImageOrientationRight:
            
            rotate = 3 * M_PI_2;
            
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            
            translateX = -rect.size.height;
            
            translateY = 0;
            
            scaleY = rect.size.width/rect.size.height;
            
            scaleX = rect.size.height/rect.size.width;
            
            break;
            
        case UIImageOrientationDown:
            
            rotate = M_PI;
            
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            
            translateX = -rect.size.width;
            
            translateY = -rect.size.height;
            
            break;
            
        default:
            
            rotate = 0.0;
            
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            
            translateX = 0;
            
            translateY = 0;
            
            break;
            
    }
    
    
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //做CTM变换
    
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextRotateCTM(context, rotate);
    
    CGContextTranslateCTM(context, translateX, translateY);
    
    
    
    CGContextScaleCTM(context, scaleX, scaleY);
    
    //绘制图片
    
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    
    
    return newPic;
    
}
#pragma mark 开启相机的输入数据与输出数据的交互
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (self.capturesession) {
        [self.capturesession startRunning];
    }
}
#pragma mark 关闭相机的输入数据与输出数据的交互
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    if (self.capturesession) {
        [self.capturesession stopRunning];
    }
}
- (UIView *)UIview:(UIView *)view1
{
    return view1;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 根据比例裁剪图片
- (UIImage*) cropImageWithImage:(UIImage*) image proportion:(CGFloat)proportion  {
    
    CGSize newSize = [self sizeWithSize:image.size poportion:proportion];
    
    CGRect rect = CGRectMake(image.scale * (image.size.height / 2 - newSize.height / 2),
                             image.scale * (image.size.width / 2 - newSize.width / 2),
                             image.scale * newSize.height,
                             image.scale * newSize.width);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    
    CGImageRelease(imageRef);
    
    return newImage;
}
#define UISCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define UISCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
// 按照 size 缩放图片
- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
// 根据比例获得缩小后的 size
- (CGSize) sizeWithSize:(CGSize) size poportion:(CGFloat) proportion{
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat screenProportion = screenSize.width / screenSize.height;
    
    CGSize newSize;
    if (proportion > screenProportion) {
        newSize.width  = size.width;
        newSize.height = size.width / proportion;
    } else {
        newSize.height = size.height;
        newSize.width  = size.height * proportion;
    }
    
    return newSize;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
