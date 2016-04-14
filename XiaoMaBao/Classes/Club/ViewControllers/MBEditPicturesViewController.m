//
//  MBEditPicturesViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBEditPicturesViewController.h"
#import "ImageUtil.h"
#import "ColorMatrix.h"
#import "YXLTagEditorImageView.h"
@interface MBEditPicturesViewController ()
{
    UIView *_lastView;
    YXLTagEditorImageView *_tagImageView;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation MBEditPicturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.hidden = YES;
    [self setScrollView];
    _tagImageView = [[YXLTagEditorImageView alloc] initWithImage:self.image];
    _tagImageView.frame = CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_WIDTH);
    _tagImageView.viewC = self;
    [self.view addSubview:_tagImageView];
    
}
- (void)setScrollView{
//    self.imageVIew.image = self.image;
    NSArray * arr = @[@"原图",@"LOMO",@"黑白",@"复古",@"哥特",@"锐化",@"淡雅",@"酒红",@"清宁",@"浪漫",@"光晕",@"蓝调",@"梦幻",@"夜色"];
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;//滚动条样式
    _scrollView.showsHorizontalScrollIndicator = YES;
    //显示横向滚动条
    _scrollView.showsVerticalScrollIndicator = NO;//关闭纵向滚动条
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    
    CGFloat width = UISCREEN_HEIGHT - UISCREEN_WIDTH-150-35;
    for(int i=0;i<arr.count;i++)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i*(width+10)+10, 0, width, width+35)];
        view.tag=i;
        view.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:view];
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoGesture:)];
        
        [view addGestureRecognizer:gesture];
        
        
        UIImageView  *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, width)];
        bgImageView.userInteractionEnabled = YES;
        bgImageView.image = self.image;
        [view addSubview:bgImageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, width, width, 35)];
        label.text = arr[i];
        label.textAlignment = 1;
        label.font = [UIFont systemFontOfSize:14];
        [view addSubview:label];
        
        if (i==0) {
            label.textColor = [UIColor colorWithHexString:@"2ba390"];
            view.layer.borderWidth = 3;
            view.layer.borderColor = [UIColor colorWithHexString:@"2ba390"].CGColor;
            _lastView = view;
        }else{
            [self imageNSinteger:view.tag image:bgImageView];

        }
        
        label.textColor = [UIColor blackColor];
        
    }
    _scrollView.contentSize = CGSizeMake(CGRectGetMaxX([[_scrollView.subviews lastObject] frame])+10, 30);
    
}
- (void)photoGesture:(UITapGestureRecognizer *)gesture{
    _lastView.layer.borderWidth = 0;
    
    UIView *view =  gesture.view;
    view.layer.borderWidth = 3;
    view.layer.borderColor = [UIColor colorWithHexString:@"2ba390"].CGColor;
    UILabel *lable = [view.subviews lastObject];
    lable.textColor = [UIColor colorWithHexString:@"2ba390"];
    _lastView = view;
    if (view.tag!=0) {
          [self imageNSinteger:view.tag image:_tagImageView.imagePreviews];
    }else{
       _tagImageView.imagePreviews.image= self.image;
    }
}
- (IBAction)back:(id)sender {
    [self popViewControllerAnimated:YES];
}
- (IBAction)next:(id)sender {
//    YXLTagEditorImageView *VC = [[YXLTagEditorImageView  alloc] initWithImage:self.imageVIew.image];
//    [self pushViewController:VC Animated:YES];
}
#pragma mark 为图片添加滤镜效果
-(void)imageNSinteger:(NSInteger)integer image:(UIImageView *)image{
    UIImage * imageq = nil;
    UIImage * imagea = nil;
    switch (integer) {
        case 1:
            imagea = [self imageWithImageSimple:self.image scaledToSize:image.frame.size];
            imageq = [ImageUtil imageWithImage:imagea withColorMatrix:colormatrix_danya];
            image.image = imageq;break;
        case 2:
            imagea = [self imageWithImageSimple:self.image scaledToSize:image.frame.size];            imageq = [ImageUtil imageWithImage:imagea withColorMatrix:colormatrix_gete];
            
            image.image = imageq;break;            break;
        case 3:
            
            imagea = [self imageWithImageSimple:self.image scaledToSize:image.frame.size];
            imageq = [ImageUtil imageWithImage:imagea withColorMatrix:colormatrix_guangyun];
            image.image = imageq;break;            break;
        case 4:
            
            imagea = [self imageWithImageSimple:self.image scaledToSize:image.frame.size];            imageq = [ImageUtil imageWithImage:imagea withColorMatrix:colormatrix_heibai];
            image.image = imageq;break;
            break;
        case 5:
            imagea = [self imageWithImageSimple:self.image scaledToSize:image.frame.size];            imageq = [ImageUtil imageWithImage:imagea withColorMatrix:colormatrix_huajiu];
            
            image.image = imageq;break;            break;
        case 6:
            imagea = [self imageWithImageSimple:self.image scaledToSize:image.frame.size];
            imageq = [ImageUtil imageWithImage:imagea withColorMatrix:colormatrix_jiuhong];
            image.image = imageq;break;
            break;
        case 7:
            imagea = [self imageWithImageSimple:self.image scaledToSize:image.frame.size];
            imageq = [ImageUtil imageWithImage:imagea withColorMatrix:colormatrix_landiao];
            image.image = imageq;break;            break;
        case 8:
            imagea = [self imageWithImageSimple:self.image scaledToSize:image.frame.size];
            imageq = [ImageUtil imageWithImage:imagea withColorMatrix:colormatrix_langman];
            
            image.image = imageq;
            break;
        case 9:
            imagea = [self imageWithImageSimple:self.image scaledToSize:image.frame.size];
            imageq = [ImageUtil imageWithImage:imagea withColorMatrix:colormatrix_lomo];
            image.image = imageq;            break;
        case 10:
            imagea = [self imageWithImageSimple:self.image scaledToSize:image.frame.size];
            imageq = [ImageUtil imageWithImage:imagea withColorMatrix:colormatrix_menghuan];
            image.image = imageq;            break;
        case 11:
            imagea = [self imageWithImageSimple:self.image scaledToSize:image.frame.size];
            imageq = [ImageUtil imageWithImage:imagea withColorMatrix:colormatrix_qingning];
            image.image = imageq;
            break;
        case 12:
            imagea = [self imageWithImageSimple:self.image scaledToSize:image.frame.size];
            imageq = [ImageUtil imageWithImage:imagea withColorMatrix:colormatrix_ruise];
            image.image = imageq;
            break;
        case 13:
            imagea = [self imageWithImageSimple:self.image scaledToSize:image.frame.size];            imageq = [ImageUtil imageWithImage:imagea withColorMatrix:colormatrix_yese];
            image.image = imageq;            break;
        default:
            break;
    }
}
-(UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    
    UIGraphicsBeginImageContext(self.view.frame.size);//根据当前大小创建一个基于位图图形的环境
    
    [image drawInRect:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];//根据新的尺寸画出传过来的图片
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();//从当前环境当中得到重绘的图片
    
    UIGraphicsEndImageContext();//关闭当前环境
    
    return newImage;
}

@end
