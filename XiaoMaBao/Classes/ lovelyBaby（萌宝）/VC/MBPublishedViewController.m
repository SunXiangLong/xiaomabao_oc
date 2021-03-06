//
//  MBPublishedViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBPublishedViewController.h"
#import "PhotoCollectionViewCell.h"

@interface MBPublishedViewController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SDPhotoBrowserDelegate>
{
    
    SDPhotoBrowser *browser;
    UIImage *_image;

}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *lable;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;

/**
 *  精度
 */
@property (nonatomic,strong) NSString *longitude;
/**
 *   纬度
 */
@property (nonatomic,strong) NSString *latitude;
@property (copy, nonatomic) NSMutableArray *photoArray;
@end

@implementation MBPublishedViewController
-(NSMutableArray *)photoArray{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    [DXLocationManager getlocationWithBlock:^(double longitude, double latitude) {
        weakSelf.longitude = [NSString stringWithFormat:@"%f",longitude];
        weakSelf.latitude = [NSString stringWithFormat:@"%f" , latitude];
        
        if (weakSelf.longitude) {
            
        }else{
            [self show:@"位置获取失败" time:1];
        }
        
    }];
 
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCollectionViewHeight];

    _bottom.constant = UISCREEN_HEIGHT-TOP_Y-75;
    _textView.delegate = self;
    _image = [UIImage imageNamed:@"addPhoto_image"];
    _photoArray = [NSMutableArray array];
    [_photoArray addObject:_image];
    // Do any additional setup after loading the view from its nib.
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing =5;
    flowLayout.minimumLineSpacing = 5;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.itemSize = CGSizeMake((UISCREEN_WIDTH-45)/4,(UISCREEN_WIDTH-45)/4);
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [ self.collectionView registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCollectionViewCell"];
    
 

}


#pragma mark --相册多选
/**
 *  初始化相册选择器
 */
- (void)presentPhotoPickerViewController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:10 - self.photoArray.count  columnNumber:4 delegate:nil pushPhotoPickerVc:YES];
    WS(weakSelf)
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        for ( UIImage *image in photos) {
            
            [weakSelf.photoArray insertObject:image atIndex:0];
        }
        
        
        [weakSelf setCollectionViewHeight];
        [weakSelf.collectionView reloadData];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark --确定collectview的长度
- (void)setCollectionViewHeight{
    
    if (_photoArray.count > 7) {
           _width.constant = ((UISCREEN_WIDTH-45)/4+5)*3;
    }else  if(_photoArray.count > 4){
         _width.constant = ((UISCREEN_WIDTH-45)/4+5)*2;
        
    }else{
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
            
          [self presentPhotoPickerViewController];
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
-(NSString *)titleStr{
    return  self.title?:@"记录宝宝";

}
-(NSString *)rightStr{
    return @"发表";
}
- (void)rightTitleClick{

    if (_textView.text.length == 0) {
        [self show:@"输入内容不能为空" time:1];
        return;
    }
   
    if (_latitude&&_longitude) {
        
        [self getsubData];
    }
 

  
}
-(void)getsubData
{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [self show];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/athena/diaryadd"] parameters:@{@"session":sessiondict,@"content":_textView.text,@"longitude":_longitude,@"latitude":_latitude} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        UIImage *image = [[UIImage alloc] init];
        if (_photoArray.count>1) {
            for (int i = 0; i<_photoArray.count-1; i++) {
                image = _photoArray[i];
                NSData * data = [UIImage reSizeImageData:image maxImageSize:800 maxSizeWithKB:800];
                if(data != nil){
                    [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"photo[]"] fileName:[NSString stringWithFormat:@"photo%d.jpg",i]mimeType:@"image/jpeg"];
                }
                
            }
            
            
        }
        
    } progress:^(NSProgress *progress) {
        
//        self.progress = progress.fractionCompleted;
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [self dismiss];
        if ([[responseObject valueForKeyPath:@"status"]isEqualToNumber:@1]) {
            
            [self show:@"发表成功" time:1];
            
            self.releaseTheLog();

            [self popViewControllerAnimated:YES];
            
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败！" time:1];
    }];

    
}
-(void)deleteTheImage:(UIImage *)image{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                             message:@"是否删除图片"
                                                                      preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *delete  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSIndexPath *indexpath =  [NSIndexPath indexPathForItem:[_photoArray indexOfObject:image] inSection:0];
        [_photoArray removeObject:image];
        [self.collectionView deleteItemsAtIndexPaths:@[indexpath]];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:delete];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _photoArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell" forIndexPath:indexPath];
    cell.img = _photoArray[indexPath.item];
    
    WS(weakSelf)
    cell.deleteTheImage = ^(UIImage *image) {
        if ([image isEqual:_image]) {
            return ;
        }
        
        [weakSelf deleteTheImage:image];
    };
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    [self.textView resignFirstResponder];
    if (indexPath.item == 9) {
        [self show:@"最多上传9张图片" time:1];
         return;
    }
    
    if (_photoArray.count - 1 == indexPath.item) {
        if ([_photoArray[indexPath.row]isKindOfClass:[UIImage class]]) {
            [self setCamera];
            return;
        }
    }
    
        browser = [[SDPhotoBrowser alloc] init];
        browser.currentImageIndex =indexPath.row;
        browser.sourceImagesContainerView = collectionView;
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
   
    return _photoArray[index];
   
}

@end
