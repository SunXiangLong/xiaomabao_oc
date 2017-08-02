//
//  YHAlbumViewController.m
//  YHPhotoKit
//
//  Created by deng on 16/11/26.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "YHAlbumViewController.h"
#import "YHAlbumTableViewCell.h"
#import "YHAlbumModel.h"

@interface YHAlbumViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property(nonatomic, strong) UITableView *albumTableView;
@property (strong, nonatomic) NSMutableArray * assetsGroups;
@property (strong, nonatomic)NSMutableArray *albums;

@end

@implementation YHAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self  prepareParameters];
    
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        [self prepareAlbums];
    }
    
    [self prepareNavigation];
    [self setupSubview];
    
    
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self prepareAlbums];
                [self.albumTableView reloadData];
            } else {
                [self showAuthorizationInfo];
            }
        }];
    } else if ([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized){
        [self showAuthorizationInfo];
    }
    YHSelectPhotoViewController *vc = [[YHSelectPhotoViewController alloc] init];
    YHAlbumModel *model = _albums.firstObject;
    vc.allFetchResult = model.albumFetchResult;
    vc.pickerDelegate = self.pickerDelegate;
    vc.maxPhotosCount = self.maxPhotosCount;
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark prepare Method

- (void)prepareParameters {
    _albums = @[].mutableCopy;
}

- (void)prepareNavigation {
    self.title = @"相簿";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(cancel)];
}

- (void)showAuthorizationInfo {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请在设备的设置-隐私-照片中允许访问照片。"delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)setupSubview {
    [self.view addSubview:self.albumTableView];
}

- (void)prepareAlbums {
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    YHAlbumModel *albumModel = [[YHAlbumModel alloc] init];
    [albumModel setDataWithAlbumResult:allPhotos];
    [self.albums addObject:albumModel];
    
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    for (PHAssetCollection *enumCollection in smartAlbums) {
        PHFetchResult *albumImagaAssert = [PHAsset fetchAssetsInAssetCollection:enumCollection options:nil];
        if (albumImagaAssert.count == 0) {
            continue;
        }
        YHAlbumModel *model = [[YHAlbumModel alloc] init];
        [model setDataWithAlbumCollection:enumCollection];
        [self.albums addObject:model];
    }
    
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    for (PHAssetCollection *enumCollection in topLevelUserCollections) {
        PHFetchResult *albumImagaAssert = [PHAsset fetchAssetsInAssetCollection:enumCollection options:nil];
        if (albumImagaAssert.count == 0) {
            continue;
        }
        YHAlbumModel *model = [[YHAlbumModel alloc] init];
        [model setDataWithAlbumCollection:enumCollection];
        [self.albums addObject:model];
    }
}

#pragma mark click Method
- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albums.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        PHFetchResult *albumResult = self.albums[indexPath.section];
        PHFetchResult *allPhotoInCollection  = [PHAsset fetchAssetsInAssetCollection:(PHAssetCollection *)albumResult[indexPath.row] options:nil];
        if (allPhotoInCollection.count == 0) {
            return 0;
        }
    }
    return 55;
}

#pragma mark alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self cancel];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"kYHAlbumCell";
    YHAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[YHAlbumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell bindDataWithAlbumModel:self.albums[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YHSelectPhotoViewController *selectPhotoVC = [[YHSelectPhotoViewController alloc] init];
    YHAlbumModel *model = self.albums[indexPath.row];
    
    if (indexPath.row == 0) {
        selectPhotoVC.allFetchResult = model.albumFetchResult;
    } else {
        selectPhotoVC.photoCollection = model.albumCollection;
    }
    selectPhotoVC.maxPhotosCount = self.maxPhotosCount;
    selectPhotoVC.pickerDelegate = self.pickerDelegate;
    [self.navigationController pushViewController:selectPhotoVC animated:YES];
}


#pragma mark setter
- (UITableView *)albumTableView {
    if (!_albumTableView) {
        _albumTableView = [[UITableView alloc] init];
        _albumTableView.frame  = self.view.frame;
        _albumTableView.delegate = self;
        _albumTableView.dataSource = self;
    }
    return _albumTableView;
}

@end
