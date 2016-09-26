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
@interface MBPostReplyController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SDPhotoBrowserDelegate,PhotoCollectionViewCellDelegate,LGPhotoPickerViewControllerDelegate>
{
    /**
     *   图片数据
     */
    NSMutableArray *_photoArray;
    /**
     *  图片选择类
     */
    SDPhotoBrowser *browser;
    
    
    
}


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
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBPostReplyController"];
    
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBPostReplyController"];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCollectionViewHeight];
    
    _photoArray = [NSMutableArray array];
    [_photoArray addObject:[UIImage imageNamed:@"addPhoto_image"]];

    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing =5;
    flowLayout.minimumLineSpacing = 5;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [ self.collectionView registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCollectionViewCell"];
    
    
    
}

#pragma mark --相册多选
/**
 *  初始化相册选择器
 */
- (void)presentPhotoPickerViewControllerWithStyle:(LGShowImageType)style {
    LGPhotoPickerViewController *pickerVc = [[LGPhotoPickerViewController alloc] initWithShowType:style];
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.maxCount = 6;   // 最多能选9张图片
    pickerVc.delegate = self;
    self.showType = style;
    [pickerVc showPickerVc:self];
}


#pragma mark --确定collectview的长度
- (void)setCollectionViewHeight{
    
    if (_photoArray.count>4) {
        _width.constant = ((UISCREEN_WIDTH-45)/4+5)*2;
    }  else{
        _width.constant = (UISCREEN_WIDTH-45)/4+5;
        
    }
}
-(NSString *)titleStr{
    return self.title?:@"";
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

-(NSString *)rightStr{
    return @"发表";
}
- (void)rightTitleClick{
    
    if (_textView.text.length ==0) {
        [self show:@"输入内容不能为空" time:1];
        return;
    }
    [self setreply:_textView.text];
}
- (void)setreply:(NSString *)comment_content{
    {
        NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
        NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
        
        NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
        
        NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/UserCircle/add_comment"];

        [self showProgress];
        
        [MBNetworking POST:url parameters:@{@"session":sessiondict,@"post_id":self.post_id,@"comment_reply_id":self.comment_reply_id,@"comment_content":comment_content} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            UIImage *image = [[UIImage alloc] init];
            if (_photoArray.count>1) {
                for (int i = 0; i<_photoArray.count-1; i++) {
                    if ([_photoArray[i]isKindOfClass:[UIImage class]]) {
                        image = _photoArray[i];
                    }else{
                        LGPhotoAssets *photo = _photoArray [i];
                        image = photo.thumbImage;
                    }
                    NSData *data = UIImageJPEGRepresentation(image, 0.5f);
                    if(data != nil){
                        [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"photo[]"] fileName:[NSString stringWithFormat:@"photo%d.jpg",i]mimeType:@"image/jpeg"];
                    }
                    
                }
                
                
            }
        } progress:^(NSProgress *progress) {
            self.progress = progress.fractionCompleted;
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([[responseObject valueForKeyPath:@"status"]isEqualToNumber:@1]) {
                
                [self dismiss];
                self.successEvaluation();
                [self popViewControllerAnimated:YES];
            }else{
                
                [self show:@"保存失败" time:1];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            MMLog(@"%@",error);
            [self show:@"请求失败！" time:1];
        }];
    
    
    
    
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)pickerViewControllerDoneAsstes:(NSArray *)assets isOriginal:(BOOL)original{
    
    
    for ( LGPhotoAssets *photo in assets) {
        
        [_photoArray insertObject:photo atIndex:0];
    }
    
    
    [self setCollectionViewHeight];
    [self.collectionView reloadData];
    
}

#pragma mark --UITextViewDelegate
- (void)textViewDidChange:(UITextView*)textView{
    
    
    if (textView.text.length>0) {
        self.lable.text  = @"";
        
    }else{
        self.lable.text  = @"回复内容...";
    }
    
    
    
}
#pragma mark ---UICollectionViewDelegate
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    return insets;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.item ==6) {
        return CGSizeMake(0, 0);
    }
    return CGSizeMake((UISCREEN_WIDTH-45)/4,(UISCREEN_WIDTH-45)/4);
    
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
    
    
    
    browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex =indexPath.row;
    browser.sourceImagesContainerView = _collectionView;
    browser.imageCount = _photoArray.count-1;
    browser.delegate = self;
    [browser show];
    
    
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
            [self setCollectionViewHeight];
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
    [self setCollectionViewHeight];
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
