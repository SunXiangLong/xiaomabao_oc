//
//  MBReleaseTopicViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/9.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBReleaseTopicViewController.h"
#import "LGPhotoPickerViewController.h"
#import "PhotoCollectionViewCell.h"
#import "LGPhotoPickerViewController.h"
#import "LGPhoto.h"
@interface MBReleaseTopicViewController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SDPhotoBrowserDelegate,UICollectionViewDelegate,LGPhotoPickerViewControllerDelegate,PhotoCollectionViewCellDelegate>
{

    /**
     *  图片选择类
     */
    SDPhotoBrowser *browser;

    
}
/**
 *  选取图片视图
 */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/**
 *  发表内容
 */
@property (weak, nonatomic) IBOutlet UITextView *textView;
/**
 *  没有发表内容的placeholder
 */
@property (weak, nonatomic) IBOutlet UILabel *lable;
/**
 *  图片显示器分类
 */
@property (nonatomic, assign) LGShowImageType showType;
/**
 *   发表话题的标题
 */
@property (weak, nonatomic) IBOutlet UITextField *textField;
/**
 *  collectionView距离底部的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
/**
 *  存放图片数组
 */
@property (copy, nonatomic) NSMutableArray  *photoArray;;
@end

@implementation MBReleaseTopicViewController
-(NSMutableArray *)photoArray{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

 
    [self.photoArray addObject:[UIImage imageNamed:@"postCamera_image"]];
    
    
    UICollectionViewFlowLayout *flowLayout = ({
        UICollectionViewFlowLayout *flowLayout =  [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout;
    });
    
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [ self.collectionView registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCollectionViewCell"];
    
    @weakify(self);
    // 把监听到的通知转换信号
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
         @strongify(self);
    
        //获取键盘的高度
        NSDictionary *userInfo = [x userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        CGFloat height = keyboardRect.size.height;
        [UIView animateWithDuration:.3 animations:^{
          self.bottom.constant = height;
        }];
      
        
    }];
    
    // 把监听到的通知转换信号
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidHideNotification object:nil] subscribeNext:^(id x) {
      
         @strongify(self);
        if (self.bottom.constant != 0  ) {
            [UIView animateWithDuration:.3 animations:^{
                   self.bottom.constant = 0;
            }];
         
        }
    
    }];

    
}
- (NSString *)rightStr{
    
   return @"发送";

}
- (NSString *)titleStr{
    
   return @"发布话题";
}
- (void)rightTitleClick{
    
    if (_textField.text.length ==0 ) {
        [self show:@"请输入标题" time:1];
        return;
    }
    if (_textView.text.length ==0) {
        [self show:@"输入内容不能为空" time:1];
        return;
    }
    
    [self getsubData];
    
}
/**
 *  提交数据（图片和文字）
 */
-(void)getsubData
{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    
    [self show];
    
    
    
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/UserCircle/add_post"] parameters:@{@"session":sessiondict,@"post_content":_textView.text,@"circle_id":self.circle_id,@"post_title":_textField.text} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        UIImage *image = [[UIImage alloc] init];
        if (_photoArray.count>1) {
            for (int i = 0; i<_photoArray.count-1; i++) {
                if ([_photoArray[i]isKindOfClass:[UIImage class]]) {
                    image = _photoArray[i];
                }else{
                    LGPhotoAssets *photo = _photoArray [i];
                    image = photo.originImage;
                }
                
                NSData * data = UIImageJPEGRepresentation(image,0.5);
                if(data != nil){
                    [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"photo[]"] fileName:[NSString stringWithFormat:@"photo%d.jpg",i]mimeType:@"image/jpeg"];
                }
                
            }
            
            
        }
    } progress:^(NSProgress *progress) {
//        self.progress = progress.fractionCompleted;
//        MMLog(@"%f",progress.fractionCompleted);
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [self dismiss];
        if ([[responseObject valueForKeyPath:@"status"]isEqualToNumber:@1]) {
           
            
            
            [self popViewControllerAnimated:YES];
        }else{
            
            [self show:@"保存失败" time:1];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败！" time:1];
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
    pickerVc.maxCount = 7-_photoArray.count;   // 最多能选6张图片
    pickerVc.delegate = self;
    self.showType = style;
    [pickerVc showPickerVc:self];
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
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:fromCameraAction];
        [alertController addAction:fromPhotoAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
- (void)pickerViewControllerDoneAsstes:(NSArray *)assets isOriginal:(BOOL)original{
  for ( LGPhotoAssets *photo in assets) {
         
         [_photoArray insertObject:photo atIndex:0];
     }
    
    
    
    [self.collectionView reloadData];
    
}

#pragma mark --UITextViewDelegate
- (void)textViewDidChange:(UITextView*)textView{
    
    
    if (textView.text.length>0) {
        self.lable.text  = @"";
        
    }else{
        self.lable.text  = @"内容，好内容上头条～";
    }
    
    
    
}

#pragma mark ---UICollectionViewDelegate
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
    return insets;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(70,70);
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell" forIndexPath:indexPath];
    
    
    if ([_photoArray[indexPath.row]isKindOfClass:[UIImage class]]) {
        cell.image.image = _photoArray[indexPath.item];
    }else{
        
        LGPhotoAssets *photo = [_photoArray objectAtIndex:indexPath.item];
        cell.image.image = photo.thumbImage;
        
    }
    
    cell.image .contentMode =  UIViewContentModeScaleAspectFill;
    cell.image .autoresizingMask = UIViewAutoresizingFlexibleHeight;
    cell.image .clipsToBounds  = YES;
    
    cell.dalegate = self;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.textView resignFirstResponder];
    if (_photoArray.count-1 == indexPath.item) {
        if ([_photoArray[indexPath.row]isKindOfClass:[UIImage class]]) {
            [self setCamera];
            return;
        }
    }
    
    
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = indexPath.item;
    photoBrowser.imageCount = _photoArray.count-1;
    photoBrowser.sourceImagesContainerView = self.collectionView;
    
    [photoBrowser show];
    
    
};

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.textView resignFirstResponder];
    
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    // MMLog(@"%@",image);
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (image) {
            [_photoArray insertObject:image atIndex:0 ];
            [self.collectionView reloadData];
        }
        
    }];
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SDPhotoBrowserDelegate
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    if ([_photoArray[index]isKindOfClass:[UIImage class]]) {
        return _photoArray[index];
    }else{
        
        LGPhotoAssets *photo = [_photoArray objectAtIndex:index ];
        UIImage *image =  photo.thumbImage;
        return image;
    }
    
}
-(void)photoNum:(NSInteger)index{
    
    
    
    [_photoArray removeObjectAtIndex:index];
    
    [self show:@"删除成功" time:1];
    NSIndexPath *indexpath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView deleteItemsAtIndexPaths:@[indexpath]];
    
}
-(void)setDeletePicture:(NSIndexPath *)indexpate{
    
    NSInteger num1 = _photoArray.count-1;
    if (indexpate.item == num1) {
        
        return;
        
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                             message:@"是否删除图片"
                                                                      preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *delete  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [_photoArray removeObjectAtIndex:indexpate.item];
        NSIndexPath *indexpath = [NSIndexPath indexPathForItem:indexpate.item inSection:0];
        [self.collectionView deleteItemsAtIndexPaths:@[indexpath]];
        
        
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:delete];
    [self presentViewController:alertController animated:YES completion:nil];
    
}



@end
