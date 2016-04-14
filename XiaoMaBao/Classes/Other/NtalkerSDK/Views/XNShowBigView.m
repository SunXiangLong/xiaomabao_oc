//
//
//
//  功能:展示图片
//  Created by Kevin on 15/5/12.
//
//

#import "XNShowBigView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"

@interface XNShowBigView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, assign) CGFloat ctrl;
@property (nonatomic, assign) CGRect imageFrames;
@property (nonatomic, assign) NSInteger imageIndex;
@property (nonatomic, copy) offsetBlock offsetBlock;

@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UIScrollView *scroll;

@property (nonatomic, assign) CGFloat endOffset;
@property (nonatomic, assign) CGFloat startOffset;
@property (nonatomic, assign) CGFloat willEndOffset;

@end

#define KSCREENSIZE [UIScreen mainScreen].bounds.size
#define IOS7DEVICE [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0

@implementation XNShowBigView

+ (void)showBigWithFrames:(CGRect)frames andCtrl:(CGFloat)ctrl andImageList:(NSArray *)images andClickedIndex:(NSInteger)index andOffsetBlock:(offsetBlock)offsetBlock
{
    if (IOS7DEVICE) {
        [UIApplication sharedApplication].statusBarHidden = YES;
    }
    UIWindow *picWindow = [UIApplication sharedApplication].keyWindow;
    XNShowBigView *bigView = [[XNShowBigView alloc] initWithFrame:CGRectMake(0, 0, KSCREENSIZE.width, KSCREENSIZE.height)];
    bigView.images = [NSMutableArray arrayWithArray:images];
    bigView.ctrl = ctrl;
    bigView.imageIndex = index;
    bigView.imageFrames = frames;
    bigView.offsetBlock = offsetBlock;
    bigView.backgroundColor = [UIColor blackColor];
    [picWindow addSubview:bigView];
    //
    [bigView initUI];
}

- (void)refreshByIndex:(NSInteger)index andPath:(NSString *)path
{
    if ([_images[index] isEqualToString:@""]) {
        [_images replaceObjectAtIndex:index withObject:path];
        UIImageView *imageView = (UIImageView *)[[self.subviews[0] subviews][index] subviews][0];
        UIImage *image = [UIImage imageWithContentsOfFile:_images[index]];
        imageView.image = image;
        [self hideActivityViewWithTag:1456 inView:imageView];
    }
}

//- (void)initUI
//{
//    AsyncImageView *currentImageView = [[AsyncImageView alloc] initWithFrame:self.imageFrame];
//    [currentImageView loadImageFromLocalPath:_images[_imageIndex]];
//    currentImageView.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [self addSubview:currentImageView];
//    [UIView animateWithDuration:0.3 animations:^{
//        CGRect rect = currentImageView.frame;
//        rect.size.width = self.frame.size.width;
//        currentImageView.frame = rect;
//        currentImageView.center = self.center;
//    } completion:^(BOOL finished) {
//        [currentImageView removeFromSuperview];
//        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
//        scrollView.backgroundColor = [UIColor clearColor];
//        scrollView.showsHorizontalScrollIndicator = NO;
//        scrollView.contentSize = CGSizeMake(_images.count*self.frame.size.width, 0);
//        [scrollView setContentOffset:CGPointMake(_imageIndex *self.frame.size.width, 0) animated:YES];
//        scrollView.pagingEnabled = YES;
//        scrollView.delegate = self;
//        //    scrollView.minimumZoomScale = 1.0;
//        //    scrollView.maximumZoomScale = 2.0;
//        for (int i = 0; i < _images.count; i++) {
//            AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*i, 0, self.frame.size.width, self.frame.size.height)];
//            imageView.tag = 1000 + i;
//            imageView.userInteractionEnabled = YES;
//            imageView.imageView.contentMode = UIViewContentModeScaleAspectFit;
//            imageView.delegate = self;
//            [imageView setDefaultImageNameString:@"xiangqingdefault.png"];
//            [imageView loadImageFromLocalPath:_images[i]];
//            [scrollView addSubview:imageView];
//        }
//        [self addSubview:scrollView];
//        self.scroll = scrollView;
//    }];
//    
//    [self addBotoomViewInView:self];
//}

- (void)initUI
{
    //
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.tag = 4567;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(_images.count*self.frame.size.width, 0);
    [scrollView setContentOffset:CGPointMake(_imageIndex *self.frame.size.width, 0) animated:YES];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    UITapGestureRecognizer *tapRemove = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelfFromSuperView:)];
    [scrollView addGestureRecognizer:tapRemove];
    //
    for (int i = 0; i < _images.count; i++) {
        
        UIScrollView *zoomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.size.width*i, 0, self.frame.size.width, self.frame.size.height)];
        zoomScrollView.minimumZoomScale = 1.0;
        zoomScrollView.maximumZoomScale = 2.0;
        zoomScrollView.delegate = self;
        //
        
        UIImageView *imageView = [[UIImageView alloc] init];
        
        UIImage *image = nil;
        NSString *path = _images[i];
        if ([path hasPrefix:@"http:"]) {
            image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:path];
            NSString *imagePath = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *URLPath = [NSURL URLWithString:imagePath];
            if (!image) {
                [[SDWebImageManager sharedManager] downloadImageWithURL:URLPath
                                                                options:SDWebImageRetryFailed
                                                               progress:nil
                                                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                                  if (finished) {
                                                                      imageView.image = image;
                                                                  }
                                                              }];
            } else {
                imageView.image = image;
            }
        } else {
            image = [UIImage imageWithContentsOfFile:_images[i]];
            imageView.image = image;
        }
        //
//        PZLWJSBridgeImageData *data = _imageFrames.imageList[i];
//        CGRect frame = _images.frame;
//        CGSize size = CGSizeMake(KSCREENSIZE.width, (KSCREENSIZE.width/image.size.width) * image.size.height);
        if (image.size.width > KSCREENSIZE.width) {
            CGSize size = CGSizeMake(KSCREENSIZE.width, (KSCREENSIZE.width/_imageFrames.size.width) * _imageFrames.size.height);
            CGRect imageFrame = imageView.frame;
            imageFrame.size = size;
            imageView.frame = imageFrame;
            imageView.center = self.center;
            imageView.tag = 1000 + i;
            imageView.userInteractionEnabled = YES;
            //        imageView.contentMode = UIViewContentModeScaleAspectFit;
            //        [self showActivityViewWithFrame:CGRectMake((KSCREENSIZE.width - 25)/2, 300, 25, 25) andTag:i inView:imageView];
            zoomScrollView.contentSize = CGSizeMake(imageView.frame.size.width, imageView.frame.size.height);
        } else {
            CGRect imageFrame = imageView.frame;
            imageFrame.size = _imageFrames.size;
            imageView.frame = imageFrame;
            imageView.center = self.center;
            imageView.tag = 1000 + i;
            imageView.userInteractionEnabled = YES;
            //        imageView.contentMode = UIViewContentModeScaleAspectFit;
            //        [self showActivityViewWithFrame:CGRectMake((KSCREENSIZE.width - 25)/2, 300, 25, 25) andTag:i inView:imageView];
        }
        [scrollView addSubview:zoomScrollView];
        [zoomScrollView addSubview:imageView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelf:)];
        singleTap.numberOfTapsRequired = 1;
        [imageView addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTaped:)];
        doubleTap.numberOfTapsRequired = 2;
        [imageView addGestureRecognizer:doubleTap];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
    }
    [self addSubview:scrollView];
    self.scroll = scrollView;
    [self addBotoomViewInView:self];
    //
//    PZLWJSBridgeImageData *data = _imageFrames.imageList[_imageIndex];
    UIImageView *currentImageView = [[UIImageView alloc] initWithFrame:_imageFrames];
    CGRect Cframe = currentImageView.frame;
    Cframe.origin.y = _imageFrames.origin.y - _ctrl + 64;
    currentImageView.frame = Cframe;
    
    UIImage *currentImage = nil;
    NSString *currentPath = _images[_imageIndex];
    if ([currentPath hasPrefix:@"http:"]) {
        currentImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:currentPath];
        if (!currentImage) {
            
        } else {
            currentImageView.image = currentImage;
        }
    } else {
        currentImage = [UIImage imageWithContentsOfFile:_images[_imageIndex]];
        currentImageView.image = currentImage;
    }
//    currentImageView.contentMode = UIViewContentModeScaleAspectFit;
    UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor blackColor];
    [self addSubview:backView];
    [backView addSubview:currentImageView];
    __block CGRect rect = currentImageView.frame;
    CGFloat ratio = self.frame.size.width/_imageFrames.size.width;
    [UIView animateWithDuration:0.3 animations:^{
        if (currentImage.size.width > CGRectGetWidth(self.frame)) {
            rect.size.width = self.frame.size.width;
            rect.size.height = currentImageView.frame.size.height * ratio;
        } else {
            rect = _imageFrames;
        }
        currentImageView.frame = rect;
        currentImageView.center = self.center;
    } completion:^(BOOL finished) {
        
        [backView removeFromSuperview];
    }];
}

- (void)savePic:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

- (void)addBotoomViewInView:(UIView *)superView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, KSCREENSIZE.height - 50, KSCREENSIZE.width, 50)];
    view.backgroundColor = [UIColor clearColor];
//    self.indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 23)];
//    self.indexLabel.text = [NSString stringWithFormat:@"%ld/%lu",_imageIndex+1,(unsigned long)_images.count];
//    self.indexLabel.textColor = [UIColor lightGrayColor];
//    self.indexLabel.textAlignment = NSTextAlignmentLeft;
//    self.indexLabel.font = [UIFont systemFontOfSize:20.0];
//    [view addSubview:_indexLabel];
    [superView addSubview:view];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(KSCREENSIZE.width - 42, 0, 30, 30);
    [button setBackgroundImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_image_download.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(downloadImage:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
}

- (void)downloadImage:(UIButton *)sender
{
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    switch (status) {
        case ALAuthorizationStatusNotDetermined:{
            
            break;
        }
//        case ALAuthorizationStatusRestricted:{
//            
//            break;
//        }
//        case ALAuthorizationStatusDenied:{
//            
//            break;
//        }
        case ALAuthorizationStatusAuthorized:{
            UIScrollView *scrollView = self.subviews[0];
            NSInteger idx = scrollView.contentOffset.x/KSCREENSIZE.width;
            UIImageView *imageView = (UIImageView *)([scrollView.subviews[idx] subviews][0]);
            UIImageWriteToSavedPhotosAlbum(imageView.image, nil, nil, nil);
            [self showToastWithContent:@"成功保存图片到相册" andRect:CGRectMake((KSCREENSIZE.width - 200)/2, (KSCREENSIZE.height - 90 - 20)/2, 200, 50) andTime:1 inView:self];
            break;
        }
        default:{
            [self showToastWithContent:@"未能成功保存图片,请检查权限设置" andRect:CGRectMake((KSCREENSIZE.width - 200)/2, (KSCREENSIZE.height - 90 - 20)/2, 200, 50) andTime:1 inView:self];
            break;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 4567) {
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == 4567) {
        NSInteger index = scrollView.contentOffset.x / self.frame.size.width;
        self.indexLabel.text = [NSString stringWithFormat:@"%ld/%lu",index+1,(unsigned long)_images.count];
        self.offsetBlock(index);
        
        _endOffset = scrollView.contentOffset.x;
        if (_startOffset < _willEndOffset && _willEndOffset < _endOffset) {
            //向右
//            NSLog(@"rightIndex:%ld",(long)index);
            UIScrollView *sc = scrollView.subviews[index - 1];
            if (sc.zoomScale > 1.0) {
                [sc setZoomScale:1.0 animated:YES];
            }
        } else if (_startOffset > _willEndOffset && _willEndOffset > _endOffset) {
            //向左
//            NSLog(@"leftIndex:%ld",(long)index);
            UIScrollView *sc = scrollView.subviews[index + 1];
            if (sc.zoomScale > 1.0) {
                [sc setZoomScale:1.0 animated:YES];
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.tag == 4567) {
        _willEndOffset = scrollView.contentOffset.x;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView.tag == 4567) {
        _startOffset = scrollView.contentOffset.x;
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView.tag != 4567) {
        UIImageView *imageView = scrollView.subviews[0];
        return imageView;
    }
    return nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView.tag != 4567) {
//        if (scrollView.zoomScale <= 1.0) {
//            scrollView.zoomScale = 1.0;
//        } else {
            CGFloat xcenter = self.center.x , ycenter = self.center.y;
            
            xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
            
            ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
            
            [scrollView.subviews[0] setCenter:CGPointMake(xcenter, ycenter)];
//        }
    }
}

- (void)removeSelf:(UITapGestureRecognizer *)sender
{
    if (IOS7DEVICE) {
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
    if (_images[sender.view.tag - 1000]) {
        [self animatedRemoveWithIndex:0 andImageView:(UIImageView *)sender.view];
    } else {
        [self removeFromSuperview];
    }
}

- (void)removeSelfFromSuperView:(UITapGestureRecognizer *)sender
{
    if (IOS7DEVICE) {
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
    UIScrollView *scrollView = (UIScrollView *)sender.view;
    NSUInteger index = scrollView.contentOffset.x/KSCREENSIZE.width;
    UIScrollView *subScroll = scrollView.subviews[index];
    if (_images[index]) {
        [self animatedRemoveWithIndex:0 andImageView:(UIImageView *)subScroll.subviews[0]];
    } else {
        [self removeFromSuperview];
    }
}

- (void)animatedRemoveWithIndex:(NSUInteger)index andImageView:(UIImageView *)imageView
{
    UIView *view = self.subviews[1];
    view.hidden = YES;
    UIScrollView *sc = (UIScrollView *)imageView.superview;
    sc.contentOffset = CGPointMake(0, 0);
    
    self.backgroundColor = [UIColor clearColor];
//    PZLWJSBridgeImageData *data = _imageFrames.imageList[imageView.tag - 1000];
    CGRect frame = _imageFrames;
    frame.origin.y = frame.origin.y - _ctrl + 64;
    if (frame.origin.y > CGRectGetHeight(self.frame)) {
        frame.origin.y = CGRectGetHeight(self.frame) + 20;
    } else if (frame.origin.y + frame.size.height < 64) {
        frame.origin.y = 64 - frame.size.height;
    }
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)doubleTaped:(UITapGestureRecognizer *)sender
{
    UIScrollView *sc = (UIScrollView *)sender.view.superview;
    if (sc.zoomScale <= 1.0) {
        [sc setZoomScale:2.0 animated:YES];
    } else {
        [sc setZoomScale:1.0 animated:YES];
    }
}

- (void)showToastWithContent:(NSString *)content andRect:(CGRect)rect andTime:(float)time inView:(UIView *)superView
{
    if ([superView viewWithTag:1234554321]) {
        UIView *view = [superView viewWithTag:1234554321];
        [view removeFromSuperview];
    }
    UIImageView * toastView = [[UIImageView alloc] initWithFrame:rect];
    
    [toastView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.75f]];
    
    [toastView.layer setCornerRadius:5.0f];
    [toastView.layer setMasksToBounds:YES];
    [toastView setAlpha:1.0f];
    [toastView setTag:1234554321];
    [superView addSubview:toastView];
    
    CGSize labelSize = CGSizeMake(0, 0);
    if (IOS7DEVICE) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17.0],NSFontAttributeName,nil];
        labelSize = [content boundingRectWithSize:CGSizeMake(rect.size.width ,MAXFLOAT)
                                            options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                         attributes:dict
                                            context:nil].size;
    } else {
        labelSize = [content sizeWithFont:[UIFont systemFontOfSize:17.0f]
                               constrainedToSize: CGSizeMake(rect.size.width ,MAXFLOAT)
                                   lineBreakMode: NSLineBreakByWordWrapping];
    }
    if (labelSize.height > rect.size.height) {
        [toastView setFrame:CGRectMake(toastView.frame.origin.x, (KSCREENSIZE.height - 20 - 44 * 2- labelSize.height)/2, toastView.frame.size.width, labelSize.height)];
    }
    
    UILabel * contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, toastView.frame.size.width - 20, toastView.frame.size.height)];
    [contentLabel setText:content];
    [contentLabel setTextColor:[UIColor whiteColor]];
    [contentLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [contentLabel setTextAlignment:NSTextAlignmentCenter];
    [contentLabel setBackgroundColor:[UIColor clearColor]];
    [contentLabel setNumberOfLines:0];
    [contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [toastView addSubview:contentLabel];
    
    if (time>0.01) {
        [self performSelector:@selector(removeToastView:) withObject:superView afterDelay:time];
    }
}

- (void)removeToastView:(UIView *)superView
{
    UIView *view = [superView viewWithTag:1234554321];
    [view removeFromSuperview];
    view = nil;
}

- (void)showActivityViewWithFrame:(CGRect)rect andTag:(NSInteger)tag inView:(UIView *)superView
{
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithFrame:rect];
    activityView.center = CGPointMake((superView.frame.size.width - 25)/2, (superView.frame.size.height - 25)/2);
    activityView.tag = 1456;
    activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [activityView startAnimating];
    [superView addSubview:activityView];
}

- (void)hideActivityViewWithTag:(NSInteger)tag inView:(UIView *)superView
{
    UIActivityIndicatorView *view = (UIActivityIndicatorView *)[superView viewWithTag:tag];
    [view stopAnimating];
    [view removeFromSuperview];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    
}

@end
