//
//  YHPhotoBrowserViewController.m
//  YHPhotoKit
//
//  Created by deng on 16/11/26.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "YHPhotoBrowserViewController.h"
#import "YHPhotoBrowserCollectionViewCell.h"
#import "YHPhotoModel.h"
#import "YHPhotoBrowserCellLayout.h"

#define YHPhotoKitColor(rgbValue) [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static NSString *CellIdentifier = @"YHPhotoBrowserCollectionViewCell";

@interface YHPhotoBrowserViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UIView *bottomBar;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UIButton *selectOriginButton;
@property (nonatomic, strong) UIButton *sendButton;


@end

@implementation YHPhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = [UIColor whiteColor];
    [self  prepareParameters];
    [self prepareNavigation];
    [self setupSubview];
    [self addSubviewConstraint];
    [self addGesture];
    [self.collectionView registerClass:[YHPhotoBrowserCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view layoutIfNeeded];
    
    [self.collectionView scrollToItemAtIndexPath:_currentIndex
                                atScrollPosition:UICollectionViewScrollPositionLeft
                                        animated:NO];
    [self performSelector:@selector(updateSelectedBtn) withObject:nil afterDelay:0.1];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark prepare Mothed
- (void)prepareParameters {
    
}

- (void)prepareNavigation {
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark 添加手势识别器
- (void)addGesture {
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tap.numberOfTapsRequired=1;
    [self.collectionView addGestureRecognizer:tap];
}
#pragma mark 点击的方法
- (void)tapClick:(id)sender {
    self.topBar.hidden = !self.topBar.hidden;
    self.bottomBar.hidden = !self.bottomBar.hidden;
}


- (void)setupSubview {
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.topBar];
    [self.topBar addSubview:self.backButton];
    [self.topBar addSubview:self.selectButton];
    [self.view addSubview:self.bottomBar];
    [self.bottomBar addSubview:self.selectOriginButton];
    [self.bottomBar addSubview:self.sendButton];
    [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:0];
}

- (void)addSubviewConstraint {
    
    self.topBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:@[
                                       
                                       [NSLayoutConstraint constraintWithItem:self.topBar
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0
                                                                     constant:0],
                                       
                                       [NSLayoutConstraint constraintWithItem:self.topBar
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0
                                                                     constant:0],
                                       
                                       [NSLayoutConstraint constraintWithItem:self.topBar
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0
                                                                     constant:0],
                                       
                                       [NSLayoutConstraint constraintWithItem:self.topBar
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0
                                                                     constant:48]
                                       ]];
    
    self.bottomBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:@[
                                
                                [NSLayoutConstraint constraintWithItem:self.bottomBar
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0
                                                              constant:0],
                                
                                [NSLayoutConstraint constraintWithItem:self.bottomBar
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1.0
                                                             constant:0],
                                
                                [NSLayoutConstraint constraintWithItem:self.bottomBar
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1.0
                                                              constant:0],
                                
                                [NSLayoutConstraint constraintWithItem:self.bottomBar
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1.0
                                                              constant:48]
                                ]];
    
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:@[
                                
                                [NSLayoutConstraint constraintWithItem:self.collectionView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.topBar
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.0
                                                              constant:0],
                                
                                [NSLayoutConstraint constraintWithItem:self.collectionView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0
                                                              constant:0],
                                
                                [NSLayoutConstraint constraintWithItem:self.collectionView
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1.0
                                                              constant:0],
                                
                                [NSLayoutConstraint constraintWithItem:self.collectionView
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1.0
                                                              constant:0]
                                ]];
    
}

- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)updateSelectedBtn {
    NSIndexPath *currentIndex = [self getCurrentIndex];
    YHPhotoModel *currentPhotoModel = _allPhotoArr[currentIndex.item];
    self.selectButton.selected = currentPhotoModel.isSelected;
    self.selectOriginButton.selected = currentPhotoModel.isOriginPhoto;
    if (self.selectOriginButton.selected) {
        self.selectOriginButton.backgroundColor = YHPhotoKitColor(0xcc22c064);
    } else {
        self.selectOriginButton.backgroundColor = [UIColor clearColor];
    }
}

- (NSIndexPath *)getCurrentIndex {
    NSInteger itemIndex = self.collectionView.contentOffset.x / self.collectionView.frame.size.width;
    NSInteger sectionIndex = 0;
    _currentIndex = [NSIndexPath indexPathForItem:itemIndex inSection:sectionIndex];
    return _currentIndex;
}

#pragma mark collectionview delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _allPhotoArr.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [[UIScreen mainScreen] bounds].size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YHPhotoBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    YHPhotoModel *currentPhotoModel = _allPhotoArr[indexPath.item];
    [cell setDataWithModel:currentPhotoModel];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSIndexPath *currentIndex = [self getCurrentIndex];
    YHPhotoModel *currentPhotoModel = _allPhotoArr[currentIndex.item];
    self.selectButton.selected = currentPhotoModel.isSelected;
}

#pragma mark click event
- (void)backButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)selectButtonClick:(id)sender {
    UIButton *selectBtn = (UIButton *)sender;
    int maxCount = _maxPhotosCount == 0 ? 6 : _maxPhotosCount;
    if (_selectPhotoVCDelegate.selectPhotosCount >= maxCount && !selectBtn.selected) {
        if (_photoDelegate && [_photoDelegate respondsToSelector:@selector(selectedPhotoBeyondLimit:currentView:)]) {
            [_photoDelegate selectedPhotoBeyondLimit:maxCount currentView:self.view];
        }
        return;
    }
    YHPhotoModel *currentPhotoModel = _allPhotoArr[[self currentIndex].item];
    currentPhotoModel.isSelected = !currentPhotoModel.isSelected;
    selectBtn.selected = currentPhotoModel.isSelected;
    [_selectPhotoVCDelegate didSelectStatusChange:currentPhotoModel];
}

- (void)selectOriginButtonClick:(id)sender {
    UIButton *selectOriginImageBtn = sender;
    YHPhotoModel *currentPhotoModel = self.allPhotoArr[[self currentIndex].item];
    currentPhotoModel.isOriginPhoto = !currentPhotoModel.isOriginPhoto;
    selectOriginImageBtn.selected = currentPhotoModel.isOriginPhoto;
    if (self.selectOriginButton.selected) {
        self.selectOriginButton.backgroundColor = YHPhotoKitColor(0xcc22c064);
    } else {
        self.selectOriginButton.backgroundColor = [UIColor clearColor];
    }
}

- (void)sendButtonClick {
    NSIndexPath *currentIndex = [self currentIndex];
    YHPhotoModel *currentPhotoModel = self.allPhotoArr[currentIndex.item];
    currentPhotoModel.isSelected = YES;
    [self.selectPhotoVCDelegate finshToSelectPhoto:currentPhotoModel];
}

#pragma mark setter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

- (UIView *)topBar {
    if (!_topBar) {
        _topBar = [[UIView alloc] init];
        _topBar.backgroundColor = [[UIColor alloc] initWithWhite:0 alpha:0.8];
    }
    return _topBar;
}

- (UIView *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [[UIView alloc] init];
        _bottomBar.backgroundColor = [[UIColor alloc] initWithWhite:0 alpha:0.8];
    }
    return _bottomBar;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 60, 32)];
        [_backButton setTitle:@"返回" forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 42, 12.5, 23, 23)];
        [_selectButton setBackgroundImage:[UIImage imageNamed:@"yh_image_no_picked"] forState:UIControlStateNormal];
        [_selectButton setBackgroundImage:[UIImage imageNamed:@"yh_image_picked"] forState:UIControlStateSelected];
        [_selectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}

- (UIButton *)selectOriginButton {
    if (!_selectOriginButton) {
        _selectOriginButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 60, 32)];
        [_selectOriginButton setTitle:@"原图" forState:UIControlStateNormal];
        _selectOriginButton.layer.cornerRadius = 5;
        [_selectOriginButton addTarget:self action:@selector(selectOriginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectOriginButton;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 70, 10, 60, 32)];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

@end
