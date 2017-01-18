//
//  ViewController.m
//  WordPress-iOS-Editor-Extension
//
//  Created by polesapp-hcd on 2016/11/11.
//  Copyright © 2016年 Jvaeyhcd. All rights reserved.
//

#import "MBEditorTopicViewController.h"
@import Photos;
@import AVFoundation;
@import MobileCoreServices;
#import <WordPressShared/WPStyleGuide.h>
#import <WordPressShared/WPFontManager.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "WPEditorField.h"
#import "WPEditorView.h"
#import "MBEditorToolbarView.h"
@interface MBEditorTopicViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, WPEditorViewDelegate, MBEditorToolbarViewDelegate,TZImagePickerControllerDelegate,UIScrollViewDelegate>
{
    
    UIButton *_btn;
    NSInteger _imageCount;
    
    UIWebView *_webView;
    BOOL *_isReplaceImage;
}
@property (nonatomic,copy) NSMutableArray *imageArr;
@property(nonatomic ,assign) float uploadPercent;
@property(nonatomic, strong) MBEditorToolbarView *hcdToolbarView;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong)  NSTimer  *timer;
@property (nonatomic, strong) NSMutableArray *imageIDArray;
@end

@implementation MBEditorTopicViewController
-(NSMutableArray *)imageArr{
    if (!_imageArr) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self show];
    [self setNavigationBar];
    //    self.fileRootPath = @"http://oce53xy92.bkt.clouddn.com/";
    //    self.uploadFileName = @"";
    self.uploadPercent = 1;
    self.delegate = self;
    self.hcdToolbarView = [[MBEditorToolbarView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    self.hcdToolbarView.delegate = self;
    self.hcdToolbarView.backgroundColor = [UIColor colorWithRed:247 / 255.0 green:247 / 255.0 blue:247 / 255.0 alpha:1.0];
    self.hcdToolbarView.itemTintColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1.0];
    self.hcdToolbarView.delegate = self;
    self.hcdToolbarView.selectedBBsCategory = @"";
    [self.hcdToolbarView setToolBarEnable:YES];
    self.toolbarView.hidden = YES;
    
    [self.editorView.titleField setMultiline:YES];
    self.editorView.sourceView.inputAccessoryView = self.hcdToolbarView;
    self.editorView.delegate = self;
    
    if (self.post_id) {
        UIWebView *webview = self.editorView.subviews.lastObject;
        webview.ml_y = -64;
        webview.scrollView.delegate = self;
       

    }
    
    
}
- (void)setNavigationBar{
    self.navigationController.navigationBar.shadowImage  = [[UIImage alloc] init];
    [self.navigationController.navigationBar setBackgroundColor:UIcolor(@"ffffff")];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"mm_navGroundImage"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = UIcolor(@"ffffff");
    NSDictionary* dict= @{NSForegroundColorAttributeName:UIcolor(@"ffffff"),NSFontAttributeName:YC_RTWSYueRoud_FONT(17)};
    self.navigationController.navigationBar.titleTextAttributes= dict;
    
    
    UIButton *backBut = [UIButton  buttonWithType:UIButtonTypeCustom];
    backBut.frame = CGRectMake(0, 0, 44, 44);
    backBut.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [backBut addTarget:self action:@selector(popViewControllerAnimated) forControlEvents:UIControlEventTouchUpInside];
    [backBut setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBut];
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
    rightButton.frame =CGRectMake(UISCREEN_WIDTH - NAV_BAR_W, NAV_BAR_Y, NAV_BAR_W, NAV_BAR_HEIGHT) ;
    rightButton.titleLabel.font = YC_RTWSYueRoud_FONT(16);
    [rightButton setTitle:@"发布" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(releaseTopic) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (void)customizeAppearance
{
    [super customizeAppearance];
    [WPFontManager merriweatherBoldFontOfSize:16.0];
    [WPFontManager merriweatherBoldItalicFontOfSize:16.0];
    [WPFontManager merriweatherItalicFontOfSize:16.0];
    [WPFontManager merriweatherLightFontOfSize:16.0];
    [WPFontManager merriweatherRegularFontOfSize:16.0];
    
    self.titlePlaceholderText = @"请输入标题";
    self.bodyPlaceholderText = @"请输入内容";
    if (self.post_id) {
        self.bodyPlaceholderText = @"请输入回复内容";
        self.titlePlaceholderText = @"";
    }
    self.placeholderColor = [WPStyleGuide grey];
    self.editorView.sourceViewTitleField.font = [WPFontManager merriweatherBoldFontOfSize:24.0];
    self.editorView.sourceContentDividerView.backgroundColor = [UIColor colorWithRed:233 / 256.0 green:239 / 256.0 blue:243 / 256.0 alpha:1.0];
    [self.toolbarView setBorderColor:[WPStyleGuide greyLighten10]];
    [self.toolbarView setItemTintColor: [WPStyleGuide greyLighten10]];
    
    [self.toolbarView setSelectedItemTintColor: [WPStyleGuide baseDarkerBlue]];
    [self.toolbarView setDisabledItemTintColor:[UIColor colorWithRed:0.78 green:0.84 blue:0.88 alpha:0.5]];
    [self.toolbarView setBackgroundColor: [UIColor colorWithRed:0xF9/255.0 green:0xFB/255.0 blue:0xFC/255.0 alpha:1]];
    
}
- (void)showPhotoPicker:(NSString *)imageID
{
    //    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //    picker.delegate = self;
    //    picker.allowsEditing = NO;
    //    picker.navigationBar.translucent = NO;
    //    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    //    picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
    //    [self.navigationController presentViewController:picker animated:YES completion:nil];
    NSInteger imageCount = 10;
    if (imageID) {
        imageCount = 1;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:imageCount columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    WS(weakSelf)
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        [weakSelf imageDealWith:photos :imageID];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    return;
    
    
}
- (void)imageDealWith:(NSArray *)photos :(NSString *)imageID{
    NSMutableArray *imageIDArray = [NSMutableArray array];
    if (imageID) {
        [imageIDArray addObject:imageID];
        NSData *imageData = UIImageJPEGRepresentation(photos[0], 1);
        NSString *path = [NSString stringWithFormat:@"%@/%@.jpg", NSTemporaryDirectory(), imageID];
        [imageData writeToFile:path atomically:YES];
        [self.editorView insertLocalImage:[[NSURL fileURLWithPath:path] absoluteString] uniqueId:imageID];
        
    }else{
        
        for (NSInteger i = photos.count - 1; i >= 0; i--) {
            NSData *imageData = UIImageJPEGRepresentation(photos[i], 1);
            NSString *imageID = [[NSUUID UUID] UUIDString];
            [imageIDArray addObject:imageID];
            NSString *path = [NSString stringWithFormat:@"%@/%@.jpg", NSTemporaryDirectory(), imageID];
            [imageData writeToFile:path atomically:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.editorView insertLocalImage:[[NSURL fileURLWithPath:path] absoluteString] uniqueId:imageID];
            });
            
        }
    }
    
    NSProgress *progress = [[NSProgress alloc] initWithParent:nil userInfo:@{ @"imageID": [imageIDArray copy]}];
    progress.cancellable = YES;
    progress.totalUnitCount = 100;
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                       target:self
                                                     selector:@selector(timerFireMethod:)
                                                     userInfo:progress
                                                      repeats:YES];
    self.timer = timer;
    [progress setCancellationHandler:^{
        [timer invalidate];
    }];
    self.imageIDArray = [NSMutableArray arrayWithArray:imageIDArray];
    
    [self getsubData:photos imageName:[imageIDArray copy]];
    
}
- (void)timerFireMethod:(NSTimer *)timer
{
    
    NSProgress *progress = (NSProgress *)timer.userInfo;
    progress.completedUnitCount++;
    NSString *imageID = [progress.userInfo[@"imageID"] firstObject];
    [_imageIDArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.editorView setProgress:self.uploadPercent onImage:obj];
    }];
    if (imageID) {
        if (self.uploadPercent == 1) {
            [timer invalidate];
        }
    }
    
}
/**
 *  上传图片获取图片url
 */
-(void)getsubData:(NSArray *)imageArr imageName:(NSArray *)imageStr;
{
    self.uploadPercent = 0.0;
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/userCircle/upload_img"] parameters:@{@"session":sessiondict} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (NSInteger i = imageArr.count - 1; i >= 0; i--) {
            NSData * data = UIImageJPEGRepresentation(imageArr[i],1);
            if(data != nil){
                [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"photo[]"] fileName:[NSString stringWithFormat:@"%@.jpg",imageStr[i]]mimeType:@"image/jpeg"];
            }
            
        }
    } progress:^(NSProgress *progress) {
        self.uploadPercent = progress.fractionCompleted;
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        MMLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 1) {
            if (responseObject[@"data"]&&[responseObject[@"data"] count] == imageStr.count) {
                WS(weakSelf)
                [imageStr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    [weakSelf.editorView replaceLocalImageWithRemoteImage:responseObject[@"data"][idx] uniqueId:obj mediaId:[@(arc4random()) stringValue]];
                }];
                
            }
            
        }else{
            
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self show:@"图片上传失败" time:.5];
        [_timer invalidate];
    }];
    
    
}
#pragma mark - Navigation Bar
- (void)popViewControllerAnimated{
    
    [_timer invalidate];
    [self.view endEditing:false];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)releaseTopic{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    if (self.post_id) {
        if (self.bodyText.length < 1) {
            [self show:@"请输入内容" time:.8];
            return;
        }
        if (self.uploadPercent != 1) {
            [self show:@"请等待上传图片" time:1];
            return;
        }
        [self show];
        [MBNetworking POSTOrigin:string(BASE_URL_root, @"/UserCircle/add_comment") parameters:@{@"session":sessiondict,@"post_content":self.bodyText,@"post_id":self.post_id,@"comment_reply_id":self.comment_reply_id,@"comment_content":self.bodyText} success:^(id responseObject) {
            [self dismiss];
            //            MMLog(@"%@",responseObject);
            if ([responseObject[@"status"] integerValue] == 1) {
                
                self.releaseSuccess();
                [self popViewControllerAnimated];
            }else{
                [self show:@"发表失败!" time:.8];
            }
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            [self show:@"请求失败!" time:.8];
        }];
        
        
        return;
    }
    if (self.titleText.length < 1) {
        [self show:@"请输入标题" time:.8];
        return;
    }
    if (self.bodyText.length < 1) {
        [self show:@"请输入内容" time:.8];
        return;
    }
    if (self.uploadPercent != 1) {
        [self show:@"请等待上传图片" time:1];
        return;
    }
    
    
    [self show];
    [MBNetworking POSTOrigin:string(BASE_URL_root, @"/userCircle/add_post_v2") parameters:@{@"session":sessiondict,@"post_content":self.bodyText,@"circle_id":self.circle_id,@"post_title":self.titleText} success:^(id responseObject) {
        [self dismiss];
        MMLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 1) {
            [self show:responseObject[@"info"] time:.8];
            self.releaseSuccess();
            [self popViewControllerAnimated];
        }else{
            [self show:@"发表失败!" time:.8];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败!" time:.8];
    }];
    
    
}
//- (void)editTouchedUpInside
//{
//    if (self.isEditing) {
//        [self stopEditing];
//    } else {
//        [self startEditing];
//    }
//}
#pragma mark -滚动相关
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.post_id) {
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        if (contentOffsetY < 0) {
            [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
        }
        
    }
    
}

#pragma mark - WPEditorViewControllerDelegate

- (void)editorDidBeginEditing:(WPEditorViewController *)editorController
{
    
    if (self.post_id) {
        [self.view    endEditing:false];
    }
    [self dismiss];
    MMLog(@"Editor did begin editing.");
}

- (void)editorDidEndEditing:(WPEditorViewController *)editorController
{
    
    MMLog(@"Editor did end editing.");
}

- (void)editorDidFinishLoadingDOM:(WPEditorViewController *)editorController
{
    
}

- (BOOL)editorShouldDisplaySourceView:(WPEditorViewController *)editorController
{
    [self.editorView pauseAllVideos];
    
    
    return YES;
}

- (void)editorDidPressMedia:(WPEditorViewController *)editorController
{
    MMLog(@"Pressed Media!");
    //    [self showPhotoPicker];
}

- (void)editorTitleDidChange:(WPEditorViewController *)editorController
{
    MMLog(@"Editor title did change: %@", self.titleText);
    
}

- (void)editorTextDidChange:(WPEditorViewController *)editorController
{
    
    MMLog(@"Editor body text changed: %@", self.bodyText);
    
}

- (void)editorViewController:(WPEditorViewController *)editorViewController fieldCreated:(WPEditorField*)field
{
    
    MMLog(@"Editor field created: %@", field.nodeId);
    
}

- (void)editorViewController:(WPEditorViewController*)editorViewController
                 imageTapped:(NSString *)imageId
                         url:(NSURL *)url
                   imageMeta:(WPImageMeta *)imageMeta
{
    
    
    if (imageId.length == 0) {
    } else {
        [self replaceImageWithID:imageId];
    }
}

- (void)editorViewController:(WPEditorViewController*)editorViewController
                 videoTapped:(NSString *)videoId
                         url:(NSURL *)url
{
}

- (void)editorViewController:(WPEditorViewController *)editorViewController imageReplaced:(NSString *)imageId
{
    //    [self.mediaAdded removeObjectForKey:imageId];
}

- (void)editorViewController:(WPEditorViewController *)editorViewController imagePasted:(UIImage *)image
{
    //    NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
    
    //    [self addImageDataToContent:imageData];
}

- (void)editorViewController:(WPEditorViewController *)editorViewController videoReplaced:(NSString *)videoId
{
    //    [self.mediaAdded removeObjectForKey:videoId];
}

- (void)editorViewController:(WPEditorViewController *)editorViewController videoPressInfoRequest:(NSString *)videoID
{
    
}

- (void)editorViewController:(WPEditorViewController *)editorViewController mediaRemoved:(NSString *)mediaID
{
    //    NSProgress * progress = self.mediaAdded[mediaID];
    //    [progress cancel];
    MMLog(@"Media Removed: %@", mediaID);
}

- (void)editorFormatBarStatusChanged:(WPEditorViewController *)editorController
                             enabled:(BOOL)isEnabled
{
    //    DDLogInfo(@"Editor format bar status is now %@.", (isEnabled ? @"enabled" : @"disabled"));
}
#pragma mark - replaceImage
- (void)replaceImageWithID:(NSString *)imageId{
    if (imageId.length == 0){
        return;
    }
    if (self.uploadPercent != 1) {
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"加载图片中" preferredStyle:UIAlertControllerStyleActionSheet];
        WS(weakSelf)
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *cancleUpdata = [UIAlertAction actionWithTitle:@"取消上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf.imageIDArray removeObject:imageId];
            if (weakSelf.imageIDArray.count == 0) {
                
                [weakSelf.timer invalidate];
            }
            
            [weakSelf.editorView removeImage:imageId];
        }];
        [alertVC addAction:cancle];
        [alertVC addAction:cancleUpdata];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    
    
    
}
#pragma mark - UIImagePickerControllerDelegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
        UIImage  *image = info[UIImagePickerControllerOriginalImage];
        [self imageDealWith:@[image] :nil];
        
    }];
    
}


#pragma mark - WPImageMetaViewControllerDelegate

- (void)editorView:(WPEditorView*)editorView
      fieldCreated:(WPEditorField*)field
{
    if (field == self.editorView.titleField) {
        field.inputAccessoryView = self.hcdToolbarView;
        
        [field setMultiline:NO];
        [field setPlaceholderColor:self.placeholderColor];
        [field setPlaceholderText:self.titlePlaceholderText];
        self.editorView.sourceViewTitleField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.titlePlaceholderText
                                                                                                     attributes:@{NSForegroundColorAttributeName: self.placeholderColor}];
    } else if (field == self.editorView.contentField) {
        field.inputAccessoryView = self.hcdToolbarView;
        
        [field setMultiline:YES];
        [field setPlaceholderText:self.bodyPlaceholderText];
        [field setPlaceholderColor:self.placeholderColor];
    }
    
    if ([self.delegate respondsToSelector:@selector(editorViewController:fieldCreated:)]) {
        [self.delegate editorViewController:self fieldCreated:field];
    }
}

- (void)editorView:(WPEditorView*)editorView
      fieldFocused:(WPEditorField*)field
{
    
}

- (void)editorView:(WPEditorView*)editorView sourceFieldFocused:(UIView*)view
{
    
}

#pragma mark - WPEditorToolbarViewDelegate

- (void)insertLibaryPhotoImage
{
    if (self.editorView.isInVisualMode) {
        [self showPhotoPicker:nil];
    }
}

- (void)insterCameraPhotoImage
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.navigationBar.translucent = NO;
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
    [self.navigationController presentViewController:picker animated:YES completion:nil];
    
}

- (void)selectBBSCategory
{
    
}
-(void)dealloc{
    MMLog(@"%@",@"释放成功");
}
@end
