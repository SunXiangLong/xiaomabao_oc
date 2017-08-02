//
//  YHSelectPhotoViewController.m
//  YHPhotoKit
//
//  Created by deng on 16/11/26.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "YHSelectPhotoViewController.h"
#import "YHPhotoModel.h"
#import "YHSelectPhotoCollectionViewCell.h"
#import "YHPhotoBrowserViewController.h"

#define kYHToolBarHeight 45
static NSString *kcellIdentifier = @"kYHSelectPhotosCell";

@interface YHSelectPhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout> {
    PHCachingImageManager *_imageManager;
    NSMutableDictionary *_selectedPhotos;
    NSMutableArray *_allPhoto;
}

@property(nonatomic, strong) UICollectionView *photoGridView;
@property(nonatomic, strong) UIView *toolBar;
@property(nonatomic, strong) UIButton *browsedButton;
@property(nonatomic, strong) UIButton *sendButton;


@end

@implementation YHSelectPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = [UIColor whiteColor];
    [self  prepareParameters];
    [self prepareNavigation];
    [self prepareToolBar];
    [self setupSubview];
    [self.photoGridView registerClass:[YHSelectPhotoCollectionViewCell class] forCellWithReuseIdentifier:kcellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.photoGridView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupSubview {
    self.toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.toolBar];
    [self.view addConstraints:@[
                                
                                [NSLayoutConstraint constraintWithItem:self.toolBar
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1.0
                                                              constant:0],
                                
                                [NSLayoutConstraint constraintWithItem:self.toolBar
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0
                                                              constant:0],
                                
                                [NSLayoutConstraint constraintWithItem:self.toolBar
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeWidth
                                                            multiplier:1.0
                                                              constant:0],
                                
                                [NSLayoutConstraint constraintWithItem:self.toolBar
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1.0
                                                              constant:kYHToolBarHeight]
                                ]];
    self.photoGridView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.photoGridView];
    [self.view addConstraints:@[
                                
                                [NSLayoutConstraint constraintWithItem:self.photoGridView
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1.0
                                                              constant:0],
                                
                                [NSLayoutConstraint constraintWithItem:self.photoGridView
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1.0
                                                              constant:0],
                                
                                [NSLayoutConstraint constraintWithItem:self.photoGridView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.toolBar
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.0
                                                              constant:0],
                                
                                [NSLayoutConstraint constraintWithItem:self.photoGridView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.0
                                                              constant:0]
                                ]];
}

- (void)prepareToolBar {
    [self.toolBar addSubview:self.browsedButton];
    [self.toolBar addSubview:self.sendButton];
}

- (void)prepareParameters {
    self.selectPhotosCount = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    _imageManager = [[PHCachingImageManager alloc] init];
    _selectedPhotos = @{}.mutableCopy;
    _allPhoto = @[].mutableCopy;
    [self getAllPhot];
}

- (void)prepareNavigation {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(cancel)];
}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getAllPhot {
    if (_allFetchResult == nil) {
        _allFetchResult = [PHAsset fetchAssetsInAssetCollection:(PHAssetCollection *)_photoCollection options:nil];
    }
    if (_photoCollection.localIdentifier == nil) {
        self.title = @"相机胶卷";
    } else {
        self.title = _photoCollection.localizedTitle;
    }
    
    PHFetchResult *allPhotoResult = _allFetchResult;
    for (int index = 0; index < [allPhotoResult count]; index ++) {
        PHAsset *asset = allPhotoResult[index];
        YHPhotoModel *model = [[YHPhotoModel alloc] init];
        [model setDataWithPhotoAsset:asset imageManager:_imageManager];
        [_allPhoto addObject:model];
    }
    [_photoGridView reloadData];
    [self performSelector:@selector(scrollPhotoGridToBottom) withObject:nil afterDelay:0.1];
}

- (void)scrollPhotoGridToBottom {
    if (_allPhoto.count > 0) {
        [_photoGridView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_allPhoto.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

- (void)finshToSelectPhoto:(YHPhotoModel *)model {
    [self dismissViewControllerAnimated:YES completion:^{
        if (_selectedPhotos.count == 0) {
            if (model.photoAsset) {
                [_selectedPhotos setObject:model forKey:model.photoAsset];
            }
        }
        if ([self.pickerDelegate respondsToSelector:@selector(YHPhotoPickerViewController:selectedPhotos:)]){
            __block NSMutableArray *selectedImageArr = @[].mutableCopy;
            
            for (NSString *key in _selectedPhotos) {
                YHPhotoModel *photoModel = _selectedPhotos[key];
                
                if (photoModel.largeImage == nil) {
                    NSLog(@"fail to get large image");
                    break;
                }
                
                [selectedImageArr addObject:photoModel.largeImage];
            }
            [self.pickerDelegate YHPhotoPickerViewController:self selectedPhotos:selectedImageArr];
        }
    }];
}

- (void)didSelectStatusChange:(YHPhotoModel *)model {
    if (_selectedPhotos[model.photoAsset] == nil) {
        self.selectPhotosCount += 1;
        [_selectedPhotos setObject:model forKey:model.photoAsset];
    } else {
        self.selectPhotosCount -= 1;
        [_selectedPhotos removeObjectForKey:model.photoAsset];
    }
    
    if ([_selectedPhotos count] > 0) {
        self.browsedButton.enabled = YES;
//        selectedPhotoLabel.hidden = NO;
//        selectedPhotoLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)[selectedPhotoDic count]];
        self.sendButton.enabled = YES;
    } else {
        self.browsedButton.enabled = NO;
//        selectedPhotoLabel.hidden = YES;
        self.sendButton.enabled = NO;
    }
}

#pragma mark collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _allPhoto.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
     return CGSizeMake(100, 100);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YHSelectPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
    [cell setDataWithModel:_allPhoto[indexPath.item] withDelegate:self];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YHPhotoBrowserViewController *photoBrowserVC = [[YHPhotoBrowserViewController alloc] init];
    photoBrowserVC.maxPhotosCount = self.maxPhotosCount;
    photoBrowserVC.photoCollection = _photoCollection;
    photoBrowserVC.imageManager = _imageManager;
    photoBrowserVC.allFetchResult = _allFetchResult;
    photoBrowserVC.allPhotoArr = _allPhoto;
    photoBrowserVC.photoDelegate = _pickerDelegate;
    photoBrowserVC.currentIndex = indexPath;
    photoBrowserVC.selectPhotoVCDelegate = self;
    [self.navigationController pushViewController:photoBrowserVC animated:YES];
}

#pragma mark click event
- (void)browsedPhotos {
    YHPhotoBrowserViewController *photoBrowserVC = [[YHPhotoBrowserViewController alloc] init];
    photoBrowserVC.maxPhotosCount = _maxPhotosCount;
    photoBrowserVC.photoCollection = _photoCollection;
    photoBrowserVC.imageManager = _imageManager;
    photoBrowserVC.allFetchResult = _allFetchResult;
    photoBrowserVC.allPhotoArr = _allPhoto;
    photoBrowserVC.photoDelegate = _pickerDelegate;
    photoBrowserVC.currentIndex = [NSIndexPath indexPathForItem:0 inSection:0];;
    photoBrowserVC.selectPhotoVCDelegate = self;
    [self.navigationController pushViewController:photoBrowserVC animated:YES];
}

- (void)sendPhotos {
    [self finshToSelectPhoto:nil];
}

#pragma mark setter
- (UICollectionView *)photoGridView {
    if (!_photoGridView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _photoGridView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _photoGridView.collectionViewLayout = layout;
        _photoGridView.backgroundColor = [UIColor clearColor];
        _photoGridView.dataSource = self;
        _photoGridView.delegate = self;
    }
    return _photoGridView;
}

- (UIView *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIView alloc] init];
        _toolBar.backgroundColor = [[UIColor alloc] initWithWhite:0 alpha:0.8];
    }
    return _toolBar;
}

- (UIButton *)browsedButton {
    if (!_browsedButton) {
        _browsedButton = [[UIButton alloc]  initWithFrame:CGRectMake(10, 5, 50, 35)];
        [_browsedButton setTitle:@"预览" forState:UIControlStateNormal];
        [_browsedButton addTarget:self action:@selector(browsedPhotos) forControlEvents:UIControlEventTouchUpInside];
    }
    return _browsedButton;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [[UIButton alloc]  initWithFrame:CGRectMake(self.view.frame.size.width - 50, 5, 50, 35)];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendPhotos) forControlEvents:UIControlEventTouchUpInside];
        _sendButton.enabled = NO;
    }
    return _sendButton;
}

@end
