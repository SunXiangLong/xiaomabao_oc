//
//  MBPickerViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//
#define empty_width 3
#define maxnum_of_one_line 3
#define itemHeight ( CGRectGetWidth([UIScreen mainScreen].bounds) - (maxnum_of_one_line + 1) * empty_width ) / maxnum_of_one_line
#define item_Size CGSizeMake(itemHeight , itemHeight)
#define rightItemTitle [NSString stringWithFormat:@"完成 %ld/%ld",(long)choosenCount,(long)photoCount]
#define tableCellH 70
#define tableH MIN(CGRectGetWidth([UIScreen mainScreen].bounds) - 64, tableCellH * tableData.count);

#import "MBPickerViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "YBImgPickerViewCell.h"
#import "YBImgPickerTableViewCell.h"
#import "MBTailoringViewController.h"
#import "MBCameraViewController.h"
#import <Photos/Photos.h>
@interface MBPickerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    NSMutableArray * tableData;
    NSMutableArray * colletionData;
    NSMutableArray * originImgData;
    NSMutableDictionary * choosenImgArray;
    NSMutableDictionary * isChoosenDic;
    
    BOOL isShowTable;
    NSInteger isNum;
    UILabel *_lable;
    UIImageView *_imageView;
    dispatch_queue_t serialPGQueue;
    PHFetchResult * _fetchResult;
}

@property (nonatomic , strong) IBOutlet UICollectionView * myCollectionView;
@property (nonatomic , strong) IBOutlet UITableView * myTableView;
@property (nonatomic , strong) IBOutlet UIView * backView;
@property (nonatomic , strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic , strong) ALAssetsGroup * group;
@property (nonatomic , strong) UIButton * titleBtn;
@end

@implementation MBPickerViewController
@synthesize myTableView,myCollectionView,backView;
@synthesize assetsLibrary,group,titleBtn;
static NSString * const colletionReuseIdentifier = @"collectionCell";
static NSString * const tableReuseIdentifier = @"tableCell";
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    colletionData = [NSMutableArray array];
    tableData = [[NSMutableArray alloc]init];
    serialPGQueue = dispatch_queue_create("com.rylan", DISPATCH_QUEUE_SERIAL);
    originImgData = [[NSMutableArray alloc]init];
    assetsLibrary = [[ALAssetsLibrary alloc]init];
    choosenImgArray = [[NSMutableDictionary alloc]init];
    isChoosenDic = [[NSMutableDictionary alloc]init];
    if (iOS_8) {
        [self getPhotoTableDate];
    }else{
        
        [self getTableDate];
    }
    
    
    [myCollectionView registerNib:[UINib nibWithNibName:@"YBImgPickerViewCell" bundle:nil] forCellWithReuseIdentifier:colletionReuseIdentifier];
    [myTableView registerNib:[UINib nibWithNibName:@"YBImgPickerTableViewCell" bundle:nil] forCellReuseIdentifier:tableReuseIdentifier];
    
    UILabel *lable = [[UILabel alloc] init];
    lable.font = [UIFont systemFontOfSize:14];
    lable.text = @"相册胶卷" ;
    lable.textColor= [UIColor whiteColor];
    [self.navBar addSubview:_lable = lable];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"arrow"];
    [self.navBar addSubview:_imageView = imageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(showTableView) forControlEvents:UIControlEventTouchUpInside]
    ;
    [self.navBar addSubview:button];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.navBar.mas_centerX);
        make.centerY.equalTo(self.navBar.mas_centerY).offset(10);
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar.mas_centerY).offset(10);
        make.left.equalTo(lable.mas_right).offset(5);
        make.height.equalTo(lable.mas_height).offset(-6);
        make.width.equalTo(lable.mas_height).offset(0);
    }];
    
    [button  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.navBar.mas_centerX);
        make.centerY.equalTo(self.navBar.mas_centerY).offset(10);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(100);
    }];
    
    
    
    //tableView
    
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.hidden = YES;
    //collectionView
    UICollectionViewFlowLayout * mycollectionViewLayout = [[UICollectionViewFlowLayout alloc]init];
    mycollectionViewLayout.minimumInteritemSpacing = empty_width;
    mycollectionViewLayout.minimumLineSpacing = empty_width + 2;
    mycollectionViewLayout.itemSize = item_Size;
    mycollectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    mycollectionViewLayout.sectionInset = UIEdgeInsetsMake(empty_width + 2, empty_width , empty_width + 2, empty_width);
    myCollectionView.collectionViewLayout = mycollectionViewLayout;
    myCollectionView.delegate = self;
    myCollectionView.dataSource = self;
    myCollectionView.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
    //backView
    isShowTable = NO;
    backView.alpha = 0;
    UITapGestureRecognizer * backViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showTableView)];
    [backView addGestureRecognizer:backViewTap];
    
    
    
}
#pragma mark --- ios8 以上的相册框架
- (void)getPhotoTableDate{
    [self show];
    dispatch_async(serialPGQueue, ^{
        PHFetchOptions *option   = [[PHFetchOptions alloc] init];
        option.predicate         = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeImage];
        option.sortDescriptors   = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate"
                                                                   ascending:NO]];
        PHFetchResult  *cameraRo = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum  subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
        
        PHAssetCollection *colt  = [cameraRo lastObject];
        PHFetchResult *fetchR    = [PHAsset fetchAssetsInAssetCollection:colt
                                                                 options:option];
        
       
        [tableData addObject:colt];
        PHAssetCollectionSubtype tp = PHAssetCollectionSubtypeAlbumRegular | PHAssetCollectionSubtypeAlbumSyncedAlbum;
        PHFetchResult *albums       = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:tp options:nil];
        
        
        
        
        for (PHAssetCollection *col in albums)
        {
            @autoreleasepool
            {
                PHFetchResult *fRes = [PHAsset fetchAssetsInAssetCollection:col
                                                                    options:option];
                
                if (fRes.count > 0) [tableData addObject:col]; // drop empty album
            }
        }

        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [self dismiss];
                           [myTableView reloadData];
                           [self getCollectionDataIos8:fetchR];
                       });
        
        
    });
    
    
    
    
}
#pragma mark --- ios8 以下的相册框架
- (void)getTableDate {
    
    void (^assetsGroupsEnumerationBlock)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *assetsGroup, BOOL *stop) {
        
        if(assetsGroup) {
            [assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
            NSMutableArray * isChoosenArray = [[NSMutableArray alloc]init];
            if(assetsGroup.numberOfAssets > 0) {
                [tableData addObject:assetsGroup];
                
                if (isNum==0) {
                    
                    [self getCollectionData:0];
                }
                
                
                for (int i = 0; i<assetsGroup.numberOfAssets; i++) {
                    [isChoosenArray addObject:[NSNumber numberWithBool:NO]];
                }
                [isChoosenDic setObject:isChoosenArray forKey:[assetsGroup valueForProperty:ALAssetsGroupPropertyName]];
                [self setTableViewHeight];
                
            }
        }
        
        
        
        
        [myTableView reloadData];
        isNum++;
        
        [myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    };
    
    void (^assetsGroupsFailureBlock)(NSError *) = ^(NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    };
    
    // Enumerate Camera Roll
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Photo Stream
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupPhotoStream usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Album
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Event
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupEvent usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Faces
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupFaces usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
}
- (void)setTableViewHeight {
    for(NSLayoutConstraint * constraint in myTableView.constraints){
        if (constraint.firstItem == myTableView && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = tableH;
        }
    }
    for(NSLayoutConstraint * constraint in myTableView.superview.constraints){
        if (constraint.firstItem == myTableView && constraint.firstAttribute == NSLayoutAttributeTop) {
            constraint.constant = -tableH;
        }
    }
    [self.view layoutIfNeeded];
}
- (void)getCollectionDataIos8:( PHFetchResult *)fetchR{
    _fetchResult = fetchR;
    [self show:@"获取照片..."];
    dispatch_async(serialPGQueue, ^{
        if (colletionData.count) {
            [colletionData removeAllObjects];
        }
        if (originImgData.count) {
            [originImgData removeAllObjects];
        }
        [colletionData addObject:[UIImage imageNamed:@"takePicture"]];
        for ( PHAsset *asset in fetchR) {
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.resizeMode = PHImageRequestOptionsResizeModeExact;
            options.networkAccessAllowed = NO;
            if ([asset isKindOfClass:[PHAsset class]])
            {
               CGFloat dimension = 70.0f;
                CGFloat aspectRatio = asset.pixelWidth / (CGFloat)asset.pixelHeight;
                CGFloat multiple = [UIScreen mainScreen].scale;
                CGFloat pixelWidth = dimension * multiple;
                CGFloat pixelHeight = pixelWidth / aspectRatio;
                CGSize  size  = CGSizeMake(pixelWidth, pixelHeight);
                [options setSynchronous:YES]; // called exactly once
                PHImageManager *manager = [[PHImageManager alloc] init];
                [manager requestImageForAsset:asset
                                   targetSize:size
                                  contentMode:PHImageContentModeAspectFit
                                      options:options
                                resultHandler:^(UIImage *result, NSDictionary *info)
                 {
                     [colletionData addObject:result];
                     
                 }];
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                       
                            [self dismiss];
                           [myCollectionView reloadData];
                       });
        
        
    });
    
 
    
    
}
- (void)getCollectionData:(NSInteger)tag {
    if (colletionData.count) {
        [colletionData removeAllObjects];
    }
    if (originImgData.count) {
        [originImgData removeAllObjects];
    }
    [colletionData addObject:[UIImage imageNamed:@"takePicture"]];
    if (tableData.count) {
        group = [tableData objectAtIndex:tag];
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                NSString *type=[result valueForProperty:ALAssetPropertyType];
                
                
                if ([type isEqualToString:ALAssetTypePhoto]) {
                    
                    [colletionData addObject:[UIImage imageWithCGImage:[result aspectRatioThumbnail]]];
                    [originImgData addObject:result];
                }
                [myCollectionView reloadData];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return colletionData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YBImgPickerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:colletionReuseIdentifier forIndexPath:indexPath];
    
    cell.contentImg = [colletionData objectAtIndex:indexPath.item];
    [cell.mainImageView setContentMode:UIViewContentModeScaleAspectFill];
    NSArray * isChoosenArray = [isChoosenDic objectForKey:[group valueForProperty:ALAssetsGroupPropertyName]];
    if (indexPath.item != 0) {
        cell.isChoosenImgHidden = NO;
        cell.isChoosen = [[isChoosenArray objectAtIndex:indexPath.item - 1]boolValue];
        
    }else {
        cell.isChoosenImgHidden = YES;
    }
    // Configure the cell
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        MBCameraViewController  *VC= [[MBCameraViewController alloc] init];
        [self pushViewController:VC Animated:YES];
        //        UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
        //        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //        imagePicker.delegate = self;
        //        imagePicker.showsCameraControls  = YES;
        //        [self presentViewController:imagePicker animated:YES completion:nil];
        
        
    }else {
        
        if (iOS_8) {
            
            PHAsset *asset = [_fetchResult objectAtIndex:indexPath.item-1];
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            
            PHImageManager *manager = [[PHImageManager alloc] init];
            [manager requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                MBTailoringViewController *VC = [[MBTailoringViewController alloc] init];
                VC.image = [UIImage imageWithData:imageData];
                
                if (self.isBack  == 0) {
                        self.block(VC.image);
                       [self popViewControllerAnimated:YES];
                }else{
                    
                      [self pushViewController:VC Animated:YES];
                }
             
                
            }];
            
            
        }else{
            NSInteger  tag = indexPath.item - 1;
            ALAsset * asset = [originImgData objectAtIndex:tag];
            
            if ([asset isKindOfClass:[ALAsset class]]) {
                UIImage * image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                
                MBTailoringViewController *VC = [[MBTailoringViewController alloc] init];
                VC.image = image;
                if (self.isBack  == 0) {
                    self.block(image);
                    [self popViewControllerAnimated:YES];
                }else{
                    
                    [self pushViewController:VC Animated:YES];
                }
                

                
                
            }
            
        }
    }
    
    
    
}
#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return   tableCellH;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YBImgPickerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:tableReuseIdentifier forIndexPath:indexPath];
    if (iOS_8) {
        PHFetchOptions *option   = [[PHFetchOptions alloc] init];
        PHAssetCollection *col =[tableData objectAtIndex:indexPath.row];
        PHFetchResult *fRes = [PHAsset fetchAssetsInAssetCollection:col
                                                            options:option];
        
        cell.albumTitle = col.localizedTitle;
        cell.photoNum = fRes.count;
        
        PHAsset *asset = [fRes firstObject];
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        
        CGFloat scale = [UIScreen mainScreen].scale; CGFloat dimension = 60.f;
        CGSize  size  = CGSizeMake(dimension * scale, dimension * scale);
        PHImageManager *manager = [[PHImageManager alloc] init];
        [manager requestImageForAsset:asset
                           targetSize:size
                          contentMode:PHImageContentModeAspectFill
                              options:options
                        resultHandler:^(UIImage *result, NSDictionary *info)
         {
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                cell.albumImg = result;
                            });
             
         }];
        
        if (!cell.albumImg) {
            cell.albumImg = [UIImage imageNamed:@"placeholder_num2"];
        }
        
    }else{
        ALAssetsGroup * assetsGroup = [tableData objectAtIndex:indexPath.row];
        cell.albumTitle = [NSString stringWithFormat:@"%@", [assetsGroup valueForProperty:ALAssetsGroupPropertyName]];
        cell.photoNum = assetsGroup.numberOfAssets;
        cell.albumImg = [UIImage imageWithCGImage:assetsGroup.posterImage];
        
    }
    
    cell.backgroundColor = tableView.backgroundColor;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (iOS_8) {
        PHFetchOptions *option   = [[PHFetchOptions alloc] init];
        PHAssetCollection *col =[tableData objectAtIndex:indexPath.row];
        PHFetchResult *fRes = [PHAsset fetchAssetsInAssetCollection:col
                                                            options:option];
        
        _lable.text = col.localizedTitle;
        [self getCollectionDataIos8:fRes];
        
        
        
    }else{
        [self getCollectionData:indexPath.row];
        ALAssetsGroup * assetsGroup = [tableData objectAtIndex:indexPath.row];
        NSString *str = [NSString stringWithFormat:@"%@", [assetsGroup valueForProperty:ALAssetsGroupPropertyName]];
        _lable.text = str;
        
        
    }
    
    [self showTableView];
}
- (void)showTableView {
    myTableView.hidden = NO;
    backView.userInteractionEnabled = YES;
    if (isShowTable) {
        [UIView animateWithDuration:0.1 animations:^{
            for(NSLayoutConstraint * constraint in myTableView.superview.constraints){
                if (constraint.firstItem == myTableView && constraint.firstAttribute == NSLayoutAttributeTop) {
                    constraint.constant += 5;
                    
                }
            }
            backView.alpha = 0;
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            _imageView.transform = CGAffineTransformMakeRotation(0);
            [UIView animateWithDuration:0.35 animations:^{
                for(NSLayoutConstraint * constraint in myTableView.superview.constraints){
                    if (constraint.firstItem == myTableView && constraint.firstAttribute == NSLayoutAttributeTop) {
                        if (iOS_8) {
                            constraint.constant=-370;
                            
                        }else{
                            constraint.constant = -tableH;
                        }
                        
                    }
                }
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                backView.userInteractionEnabled = NO;
                isShowTable = !isShowTable;
            }];
        }];
    }else {
        [UIView animateWithDuration:0.1 animations:^{
            for(NSLayoutConstraint * constraint in myTableView.superview.constraints){
                if (constraint.firstItem == myTableView && constraint.firstAttribute == NSLayoutAttributeTop) {
                    constraint.constant = 64 + 5;
                }
            }
            backView.alpha = 1;
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            _imageView.transform = CGAffineTransformMakeRotation(M_PI);
            [UIView animateWithDuration:0.1 animations:^{
                for(NSLayoutConstraint * constraint in myTableView.superview.constraints){
                    if (constraint.firstItem == myTableView && constraint.firstAttribute == NSLayoutAttributeTop) {
                        constraint.constant = 64;
                    }
                }
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                backView.userInteractionEnabled = YES;
                isShowTable = !isShowTable;
            }];
        }];
    }
}

@end
