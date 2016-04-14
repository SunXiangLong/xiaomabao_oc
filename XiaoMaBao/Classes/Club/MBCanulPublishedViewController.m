//
//  MBCanulPublishedViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/4.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBCanulPublishedViewController.h"
#import "PhotoCollectionViewCell.h"
#import "LGPhotoPickerViewController.h"
#import "LGPhoto.h"
#import "MBWeatherTableViewCell.h"
#import "MBWeatherAndMoodViewController.h"
#import "MBPersonalCanulaCircleViewController.h"
#import "UIImage+Size.h"
@interface MBCanulPublishedViewController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SDPhotoBrowserDelegate,PhotoCollectionViewCellDelegate,LGPhotoPickerViewControllerDelegate>
{
    NSMutableArray *_photoArray;
    SDPhotoBrowser *browser;
    
    NSArray *_array;
    
    NSString *_quanzhi;
    
    
}
@property (nonatomic, assign) LGShowImageType showType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *lable;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  经度
 */
@property (nonatomic,strong) NSString *longitude;
/**
 *   纬度
 */
@property (nonatomic,strong) NSString *latitude;
/**
 *  分类ID
 */
@property (nonatomic,strong) NSString *cat_id;
@end

@implementation MBCanulPublishedViewController

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBCanulPublishedViewController"];
    
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBCanulPublishedViewController"];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCollectionViewHeight];
    
    _bottom.constant = UISCREEN_HEIGHT-TOP_Y-75;
    _textView.delegate = self;
    
    _photoArray = [NSMutableArray array];
    [_photoArray addObject:[UIImage imageNamed:@"addPhoto_image"]];
    // Do any additional setup after loading the view from its nib.
    
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
    if (_photoArray.count<2) {
       [self show:@"输选择要分享的图片" time:1];
         return;
    }
    
    if (!self.cat_id) {
        [self show:@"请选择要分享的圈子" time:1];
        return;
    }
    [self show];
    __unsafe_unretained __typeof(self) weakSelf = self;
    [DXLocationManager getlocationWithBlock:^(double longitude, double latitude) {
        
        
        weakSelf.longitude = [NSString stringWithFormat:@"%f",longitude];
        weakSelf.latitude = [NSString stringWithFormat:@"%f" , latitude];
        if (weakSelf.longitude) {
            [self getsubData];
        }else{
            [self show:@"位置获取失败" time:1];
        }
        
    }];
    
}
-(void)getsubData
{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
   
    

    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/communicate/talkadd"]
            parameters:@{@"session":sessiondict,@"content":_textView.text,@"longitude":_longitude,@"latitude":self.latitude,@"cat_id":self.cat_id}
     
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    UIImage *image = [[UIImage alloc] init];
    if (_photoArray.count>1) {
        for (int i = 0; i<_photoArray.count-1; i++) {
            if ([_photoArray[i]isKindOfClass:[UIImage class]]) {
                image = _photoArray[i];
            }else{
                LGPhotoAssets *photo = _photoArray [i];
                image = photo.originImage;
            }
           NSData * data = [UIImage reSizeImageData:image maxImageSize:800 maxSizeWithKB:800];  //
//             NSData * data = UIImageJPEGRepresentation(image,1);
            if(data != nil){
                [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"photo[]"] fileName:[NSString stringWithFormat:@"photo%d.jpg",i]mimeType:@"image/jpeg"];
            }
            
        }
        
        
    }
    
}
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   NSLog(@"success:%@",[responseObject valueForKeyPath:@"status"]);
                   if ([[responseObject valueForKeyPath:@"status"]isEqualToNumber:@1]) {
                       [self show:@"发表成功" time:1];
                       
                       MBPersonalCanulaCircleViewController *VC = [[MBPersonalCanulaCircleViewController alloc] init];
                       VC.popHome = @"yes";
                       [self pushViewController:VC Animated:YES];
                       
//                       [self popViewControllerAnimated:YES];
                   }else{
                       
                       [self show:@"保存失败" time:1];
                   }
                   
                   
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   NSLog(@"%@",error);
                   [self show:@"请求失败！" time:1];
               }
     ];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)pickerViewControllerDoneAsstes:(NSArray *)assets isOriginal:(BOOL)original{
    /*
     //assets的元素是LGPhotoAssets对象，获取image方法如下:
     NSMutableArray *thumbImageArray = [NSMutableArray array];
     NSMutableArray *originImage = [NSMutableArray array];
     NSMutableArray *fullResolutionImage = [NSMutableArray array];
     
     for (LGPhotoAssets *photo in assets) {
     //缩略图
     [thumbImageArray addObject:photo.thumbImage];
     //原图
     [originImage addObject:photo.originImage];
     //全屏图
     [fullResolutionImage addObject:fullResolutionImage];
     }
     */for ( LGPhotoAssets *photo in assets) {
         
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
        self.lable.text  = @"这一刻的想法...";
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
    // NSLog(@"%@",image);
    
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MBWeatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBWeatherTableViewCell"];
    
    if (indexPath.row==0) {
        static NSString *idfent = @"ssss";
        UITableViewCell *sss = [tableView dequeueReusableCellWithIdentifier:idfent];
        if (!cell) {
            sss = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idfent];
        }
        return sss;
        
    }
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBWeatherTableViewCell" owner:nil options:nil]firstObject];
    }
    
    if (_quanzhi) {
        cell.showImageView.image = [UIImage imageNamed:@"mCircle_image"];
        cell.labletext.text = @"分享到那个圈子？";
        [cell.biaoziImageView sd_setImageWithURL:[NSURL URLWithString:_quanzhi] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
        
    }else{
        cell.showImageView.image = [UIImage imageNamed:@"mCircle_image"];
        cell.labletext.text = @"分享到那个圈子？";;
        
        
    }
    
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    MBWeatherAndMoodViewController *VC = [[MBWeatherAndMoodViewController alloc] init];
    VC.circleBlock = ^(NSDictionary *dic){
        _quanzhi = dic[@"cat_icon"];
        _cat_id = dic[@"cat_id"];
        [self.tableView reloadData];
    };
    
    [self pushViewController:VC Animated:YES];
    
    VC.title = @"发帖子";
    VC.type = MBcircleType ;
    
    
}


@end
