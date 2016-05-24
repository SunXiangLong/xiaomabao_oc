//
//  MBAddIDCardView.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBAddIDCardView.h"
#import "PhotoCollectionViewCell.h"
#import "LGPhotoPickerViewController.h"
#import "LGPhoto.h"
#import "MBIDCardCell.h"
@interface MBAddIDCardView ()<LGPhotoPickerViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    
    
    SDPhotoBrowser  *browser;
    NSInteger _row;
    UIImage *_image;
    
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, assign) LGShowImageType showType;
@end
@implementation MBAddIDCardView

- (void)awakeFromNib {
    [super awakeFromNib];
     _image  = [UIImage imageNamed:@"addPhoto_image"];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 5;
    _collectionView.collectionViewLayout = flowLayout;

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerNib:[UINib nibWithNibName:@"MBIDCardCell" bundle:nil] forCellWithReuseIdentifier:@"MBIDCardCell"];
}
- (void)setPhotoArray:(NSMutableArray *)photoArray{
    _photoArray = photoArray;
    
    [_collectionView reloadData];
    
}
+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBAddIDCardView" owner:nil options:nil] lastObject];
}

#pragma mark --相册多选
/**
 *  初始化相册选择器
 */
- (void)presentPhotoPickerViewControllerWithStyle:(LGShowImageType)style {
    LGPhotoPickerViewController *pickerVc = [[LGPhotoPickerViewController alloc] initWithShowType:style];
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.maxCount = 1;   // 最多能选9张图片
    pickerVc.delegate = self;
    self.showType = style;
    [pickerVc showPickerVc:self.VC];
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
                [self.VC presentViewController:imagePicker animated:YES completion:nil];
            }
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:fromCameraAction];
        [alertController addAction:fromPhotoAction];
        [self.VC presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)getsubData
{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [self.VC showProgress];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/idcard/update"] parameters:@{@"session":sessiondict,@"real_name":self.name,@"identity_card":self.idCard,} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        UIImage *image = [[UIImage alloc] init];
        for (int i = 0; i<_photoArray.count-1; i++) {
            if ([_photoArray[i]isKindOfClass:[LGPhotoAssets class]]) {
                LGPhotoAssets *photo = _photoArray [i];
                image = photo.thumbImage;
            }else{
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                MBIDCardCell *cell = (MBIDCardCell *)[_collectionView cellForItemAtIndexPath:indexPath];
                image = cell.cardImage.image;
            }
            NSData * data = [UIImage reSizeImageData:image maxImageSize:800 maxSizeWithKB:800];
            if(data != nil){
                [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"photo[]"] fileName:[NSString stringWithFormat:@"photo%d.jpg",i]mimeType:@"image/jpeg"];
            }
            
        }
        
    } progress:^(NSProgress *progress) {
        self.VC.progress = progress.fractionCompleted;
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject valueForKeyPath:@"status"]isEqualToNumber:@1]) {
            
            [self.VC show:@"提交成功" time:1];
            self.block(YES);
            
        }else{
            self.block(NO);
            [self.VC show:@"保存失败" time:1];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.block(NO);
        [self.VC show:@"请求失败！" time:1];
    }];
    
    
}


- (void)pickerViewControllerDoneAsstes:(NSArray *)assets isOriginal:(BOOL)original{
    
    
    _photoArray[_row] = assets.firstObject;
    BOOL isAddPhoto = YES;
    for (id info in _photoArray) {
        
        if ([info isKindOfClass:[UIImage class]]) {
            isAddPhoto = NO;
        }
        
    }
    
    if (isAddPhoto) {
        [_photoArray addObject:[UIImage imageNamed:@"submit_image"]];
    }
    [_collectionView reloadData];
    
}

#pragma mark ---UICollectionViewDelegate
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 8, 0, 0);
    return insets;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return CGSizeMake(70,100);
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MBIDCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBIDCardCell" forIndexPath:indexPath];

    if ([_photoArray[indexPath.item] isKindOfClass:[NSString class]]) {
        [cell.cardImage sd_setImageWithURL:[NSURL URLWithString:_photoArray[indexPath.item]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
       
    }else if([_photoArray[indexPath.item] isKindOfClass:[UIImage class]]){
        
         cell.cardImage.image = _photoArray[indexPath.item];
         cell.deleLabel.hidden = YES;
        
       }else{
    
           LGPhotoAssets *photo = [_photoArray objectAtIndex:indexPath.item];
           cell.cardImage.image = photo.thumbImage;
           cell.deleLabel.hidden = NO;

    }
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_photoArray[indexPath.item] isKindOfClass:[UIImage class]]) {
        
        if (indexPath.item ==2) {
            [self getsubData];
        }else{
            _row = indexPath.row;
            [self setCamera];
            
        }
    }else{
        
        [self deletePhoto:indexPath];
    }
    
    
};
#pragma mark -- 删除图片
- (void)deletePhoto:(NSIndexPath *)indexPath{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                             message:@"是否删除图片"
                                                                      preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *delete  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (_photoArray.count ==3) {
            [_photoArray removeObjectAtIndex:2];
        }
        _photoArray[indexPath.item] = _image;
        self.block(NO);
        [_collectionView reloadData];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:delete];
    [self.VC presentViewController:alertController animated:YES completion:nil];
    
}
@end
