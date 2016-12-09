//
//  MBNewReleaseTopicViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/12/6.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBNewReleaseTopicViewController.h"

@interface MBNewReleaseTopicViewController ()<UIWebViewDelegate,
UINavigationControllerDelegate,LGPhotoPickerViewControllerDelegate,UIImagePickerControllerDelegate
>
{
    
    NSString *_htmlString;//保存输出的富文本
    UIButton *_btn;
    BOOL _photoUPSuccess;
    NSInteger _imageCount;
    
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,copy) NSMutableArray *imageArr;
@property (copy, nonatomic) NSMutableArray  *photoArray;
@end

@implementation MBNewReleaseTopicViewController
-(NSMutableArray *)imageArr{
    if (!_imageArr) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}
#pragma mark - View Will Appear Section
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
- (NSString *)titleStr{
    return @"发布话题";
}
- (NSString *)rightStr{
    return @"发布";
}
- (void)rightTitleClick{
    [self printHTML];
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
//发布帖子
-(void)getsubData:(NSString *)post_title postContent:(NSString *)post_content
{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    [self show];
    [MBNetworking POSTOrigin:string(BASE_URL_root, @"/userCircle/add_post_v2") parameters:@{@"session":sessiondict,@"post_content":post_content,@"circle_id":self.circle_id,@"post_title":post_title} success:^(id responseObject) {
        [self dismiss];
        MMLog(@"%@",responseObject);
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
    
    
    
    
    
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
- (void)printHTML
{
    if (!_photoUPSuccess) {
        [self show:@"请等待上传图片" time:1];
        return;
    }
    
    
    NSString *html2 = [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('content').innerHTML"];
    NSString *html1 = [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('mytitle').innerHTML"];
    NSString *script1 = [self.webView stringByEvaluatingJavaScriptFromString:@"window.alertHtml()"];
    [self.webView stringByEvaluatingJavaScriptFromString:script1];
    
    MMLog(@"Inner HTML: %@", html1);
    MMLog(@"Inner HTML: %@", html2);
    
    if (html1.length == 0)
    {
        [self show:@"请输入标题" time:.8];
        return ;
    }
    if (html2.length == 0)
    {
        [self show:@"请输入内容" time:.8];
        return ;
    }
    
    [self getsubData:html1 postContent:html2];
    
    
}





- (void)saveText
{
    [self printHTML];
}


#pragma mark - Method
-(NSString *)changeString:(NSString *)str
{
    
    NSMutableArray * marr = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@"\""]];
    
    for (int i = 0; i < marr.count; i++)
    {
        NSString * subStr = marr[i];
        if ([subStr hasPrefix:@"/var"] || [subStr hasPrefix:@" id="])
        {
            [marr removeObject:subStr];
            i --;
        }
    }
    NSString * newStr = [marr componentsJoinedByString:@"\""];
    return newStr;
    
}

- (NSString *)stringFromDate
{
    
    NSString *timeString = [NSString stringWithFormat:@"photo%ld", _imageCount];
    _imageCount ++;
    return timeString;
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
    NSString *script = [self.webView stringByEvaluatingJavaScriptFromString:@"window.mytitleFocus()"];
    [self.webView stringByEvaluatingJavaScriptFromString:script];
}


@end
