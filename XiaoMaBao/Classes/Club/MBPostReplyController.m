//
//  MBPublishedViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBPostReplyController.h"
#import "PhotoCollectionViewCell.h"
#import "LGPhotoPickerViewController.h"
#import "LGPhoto.h"
@interface MBPostReplyController ()<UIWebViewDelegate,
UINavigationControllerDelegate,LGPhotoPickerViewControllerDelegate,UIImagePickerControllerDelegate>
{
    /**
     *   图片数据
     */
    NSMutableArray *_photoArray;
    /**
     *  图片选择类
     */
    SDPhotoBrowser *browser;
    
    
    NSString *_htmlString;//保存输出的富文本
    BOOL _photoUPSuccess;
    UIButton *_btn;
    NSInteger _imageCount;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;

/**
 *  回复textView
 */
@property (weak, nonatomic) IBOutlet UITextView *textView;
/**
 *  没有回复内容提示
 */
@property (weak, nonatomic) IBOutlet UILabel *lable;
/**
 *  图片展示CollectionView
 */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/**
 *  CollectionView的长度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;


@property (nonatomic, assign) LGShowImageType showType;

@end

@implementation MBPostReplyController
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //Add observers for keyboard showing or hiding notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

#pragma mark - View Will Disappear Section
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    //Remove observers for keyboard showing or hiding notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _photoUPSuccess = true;
    self.webView.backgroundColor = [UIColor whiteColor];
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *indexFileURL = [bundle URLForResource:@"richTextEditor" withExtension:@"html"];
    
    [self.webView setKeyboardDisplayRequiresUserAction:NO];
    [self.webView loadRequest:[NSURLRequest requestWithURL:indexFileURL]];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, UISCREEN_HEIGHT, 44, 44);
    [btn setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(setCamera) forControlEvents:UIControlEventTouchUpInside];
    _btn = btn;

    
    
    
}


-(NSString *)titleStr{
    return self.title?:@"";
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    
    [self.view endEditing:NO];
    return [super popViewControllerAnimated:animated];
    
}
- (void)KeyboardAvoidingkeyboardWillHide:(NSNotification *)note
{
    
    
    [UIView animateWithDuration:0.25 animations:^{
        _btn.ml_y = UISCREEN_HEIGHT;
    }];
    
    
}
- (void)keyboardWillShowOrHide:(NSNotification *)notification
{
    
    // Orientation
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    // User Info
    NSDictionary *info = notification.userInfo;
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    int curve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    CGRect keyboardEnd = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat keyboardHeight = UIInterfaceOrientationIsLandscape(orientation) ? ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.000000) ? keyboardEnd.size.height : keyboardEnd.size.width : keyboardEnd.size.height;
    
    UIViewAnimationOptions animationOptions = curve << 16;
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        
        UIView *view = [UIApplication   sharedApplication].windows.lastObject;
        if (view&&!_btn.superview) {
            [view addSubview:_btn];
        }
        [UIView animateWithDuration:duration delay:0 options:animationOptions animations:^{
            _btn.ml_y = UISCREEN_HEIGHT - keyboardHeight ;
        } completion:nil];
        
    }else{
        
        [UIView animateWithDuration:duration delay:0 options:animationOptions animations:^{
            _btn.ml_y = UISCREEN_HEIGHT;
        } completion:nil];
        
        
    }
    
    
    
}
-(NSString *)rightStr{
    return @"发表";
}
- (void)rightTitleClick{
    [self printHTML];
}
- (void)printHTML
{
    if (!_photoUPSuccess) {
        [self show:@"请等待上传图片" time:1];
        return;
    }
    
    
    NSString *html2 = [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('content').innerHTML"];
   
    NSString *script1 = [self.webView stringByEvaluatingJavaScriptFromString:@"window.alertHtml()"];
    [self.webView stringByEvaluatingJavaScriptFromString:script1];
    
   
    
    
    if (html2.length == 0)
    {
        [self show:@"请输入回复内容" time:.8];
        return ;
    }
    
    [self getsubDataPostContent:html2];
    
    
}
/**
 *  上传图片获取图片url
 */
-(void)getsubData:(NSArray *)imageArr imageName:(NSArray *)imageStr;
{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    _photoUPSuccess = false;
    
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/userCircle/upload_img"] parameters:@{@"session":sessiondict} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
        for (int i = 0; i<imageArr.count; i++) {
            
            NSData * data = UIImageJPEGRepresentation(imageArr[i],1);
            if(data != nil){
                [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"photo[]"] fileName:[NSString stringWithFormat:@"%@.jpg",imageStr[i]]mimeType:@"image/jpeg"];
                
            }
            
        }
        
        
        
    } progress:^(NSProgress *progress) {
        
        MMLog(@"%f",progress.fractionCompleted);
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        MMLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 1) {
            if (responseObject[@"data"]&&[responseObject[@"data"] count] == imageStr.count) {
                
                for (NSInteger i = 0 ; i<imageStr.count; i++) {
                    NSString *key = imageStr[i];
                    NSString *url = responseObject[@"data"][i];
                    
                    NSString *script = [NSString stringWithFormat:@"window.updateImageURL('%@', '%@')", key, url];
                    [self.webView stringByEvaluatingJavaScriptFromString:script];
                }
            }
            
            
            _photoUPSuccess = true;
        }else{
            [self show:responseObject[@"info"] time:1];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败！" time:1];
    }];
    
    
}
//发布帖子
-(void)getsubDataPostContent:(NSString *)post_content
{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    [self show];
    [MBNetworking POSTOrigin:string(BASE_URL_root, @"/UserCircle/add_comment") parameters:@{@"session":sessiondict,@"post_content":post_content,@"post_id":self.post_id,@"comment_reply_id":self.comment_reply_id,@"comment_content":post_content} success:^(id responseObject) {
        [self dismiss];
        MMLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 1) {
            
            self.successEvaluation();
            [self popViewControllerAnimated:true];
        }else{
            [self show:@"发表失败!" time:.8];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败!" time:.8];
    }];
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --相册多选
/**
 *  初始化相册选择器
 */
- (void)presentPhotoPickerViewControllerWithStyle:(LGShowImageType)style {
    LGPhotoPickerViewController *pickerVc = [[LGPhotoPickerViewController alloc] initWithShowType:style];
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.maxCount = 5;   // 最多能选5张图片
    pickerVc.delegate = self;
    
    [pickerVc showPickerVc:self];
}
/**
 *  初始化自定义相机（连拍）
 */
- (void)presentCameraContinuous {
    ZLCameraViewController *cameraVC = [[ZLCameraViewController alloc] init];
    // 拍照最多个数
    cameraVC.maxCount = 4;
    // 连拍
    cameraVC.cameraType = ZLCameraContinuous;
    WS(weakSelf)
    cameraVC.callback = ^(NSArray *cameras){
        //在这里得到拍照结果
        //数组元素是ZLCamera对象
        NSMutableArray *arr = [NSMutableArray array];
        NSMutableArray *strArr = [NSMutableArray array];
        for (ZLCamera *canamerPhoto in cameras) {
            UIImage *image = canamerPhoto.photoImage;
            [strArr addObject:[self insertImage]];
            [arr addObject:image];
        }
        [weakSelf getsubData:[arr copy] imageName:[strArr copy]];
        
    };
    [cameraVC showPickerVc:self];
}
- (void)pickerViewControllerDoneAsstes:(NSArray *)assets isOriginal:(BOOL)original{
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *strArr = [NSMutableArray array];
    for ( LGPhotoAssets *photo in assets) {
        UIImage *image = photo.originImage;
        [strArr addObject:[self insertImage]];
        [arr addObject:image];
        
    }
    [self getsubData:[arr copy] imageName:[strArr copy]];
    
}
- (NSString *)stringFromDate
{
    
    NSString *timeString = [NSString stringWithFormat:@"photo%ld", _imageCount];
    _imageCount ++;
    return timeString;
}
- (NSString *)insertImage{
    UIImage *image = [UIImage imageNamed:@"img_default"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *imageName = [NSString stringWithFormat:@"%@", [self stringFromDate]];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    if (image) {
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        [imageData writeToFile:imagePath atomically:YES];
    }
    NSString *script = [NSString stringWithFormat:@"window.insertImage('%@', '%@')", imageName, imagePath];
    
    [self.webView stringByEvaluatingJavaScriptFromString:script];
    return imageName;
}
#pragma maek -- 拍照或从相机获取图片
- (void)setCamera{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 7.99) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                       
                                                             handler:^(UIAlertAction * action) {}];
        UIAlertAction* fromPhotoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action) {
            
            [self presentPhotoPickerViewControllerWithStyle:LGShowImageTypeImagePicker];
        }];
        UIAlertAction* fromCameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault                                                             handler:^(UIAlertAction * action) {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                
                [self presentCameraContinuous];
                //                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                //                imagePicker.delegate = self;
                //                imagePicker.allowsEditing = false;
                //                imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                //                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                //                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:fromCameraAction];
        [alertController addAction:fromPhotoAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
- (void)webViewDidFinishLoad:(UIWebView*)webView{
    self.webView.keyboardDisplayRequiresUserAction = NO;
    
    
    NSString *script1 = [self.webView stringByEvaluatingJavaScriptFromString:@"window.editableContentFocus()"];
    [self.webView stringByEvaluatingJavaScriptFromString:script1];
    
    
}



@end
