//
//  MBBabyManagementViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/25.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBabyManagementViewController.h"
#import "MBBabyImageCollectionViewCell.h"
@interface MBBabyManagementViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SDPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *HeadPhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *textLable;

@end

@implementation MBBabyManagementViewController
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBBabyManagementViewController"];
    
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBBabyManagementViewController"];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCollerctonView];
    // Do any additional setup after loading the view from its nib.
    _nameLable.text = self.name;
    _dateLable.text = self.date;
    _timeLable.text = self.addtime;
    _textLable.text  = self.content;
    

}
- (void)setCollerctonView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((UISCREEN_WIDTH-60)/3,(UISCREEN_WIDTH-60)/3);
    
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 15, 5, 15);
//    flowLayout.minimumInteritemSpacing =5;
//    flowLayout.minimumLineSpacing =5;
    _collectionView.collectionViewLayout = flowLayout;
     _collectionView.alwaysBounceVertical = YES;
    _collectionView.delegate = self;
    _collectionView .dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerNib:[UINib nibWithNibName:@"MBBabyImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MBBabyImageCollectionViewCell"];
    [_collectionView    registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView1"];
   
    
}
-(NSString *)rightImage{

return @"dian_image";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)rightTitleClick{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定要删除这条记录吗？"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                   
                                                         handler:^(UIAlertAction * action) {}];
    UIAlertAction* fromPhotoAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive                                                                 handler:^(UIAlertAction * action) {
        [self setDeleteRecords];
        
    }];
  
    [alertController addAction:cancelAction];
    [alertController addAction:fromPhotoAction];
    [self presentViewController:alertController animated:YES completion:nil];

}
-(void)setDeleteRecords{

    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];

    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/athena/diarydel"];
    [self show];
    [MBNetworking POST:url parameters:@{@"session":sessiondict,@"id":self.ID}
               success:^(NSURLSessionDataTask *operation, MBModel *responseObject) {
                      [self dismiss];
                   
                   if(1 == [[responseObject valueForKey:@"status"]  intValue]){
                    
                       NSDictionary *userData = [responseObject valueForKeyPath:@"status"];
                       MMLog(@"%@",userData);
                    
                       self.block(self.indexPath);
                       [self popViewControllerAnimated:YES];
                   }
                   
               } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                   
                   [self show:@"请求失败 " time:1];
                   MMLog(@"%@",error);
                   
               }
     ];

}
#pragma mark --UICollectionViewdelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _photoArray.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        if (indexPath.section == 0) {
            UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView1" forIndexPath:indexPath];
            MBUserDataSingalTon  *userInfo = [MBSignaltonTool getCurrentUserInfo];
            [reusableview addSubview:_headView];
            if ([_image isKindOfClass:[NSString class]]) {
                [_HeadPhotoImageView sd_setImageWithURL:[NSURL URLWithString:_image] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
            }else {
            
                _HeadPhotoImageView.image = _image;
            }
            
            _nameLable.text = userInfo.user_baby_info[@"nickname"];
            
            [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
                make.right.mas_equalTo(0);
            }];
            return reusableview;
        }
      
    }
    return nil;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    MBBabyImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBBabyImageCollectionViewCell" forIndexPath:indexPath];
    cell.showImage.image = PLACEHOLDER_DEFAULT_IMG;
    NSURL *url = [NSURL URLWithString: _photoArray[indexPath.item]];
    [cell.showImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder_num2"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cell.showImage.alpha = 0.3f;
        [UIView animateWithDuration:1
                         animations:^{
                             cell.showImage.alpha = 1.0f;
                         }
                         completion:nil];
    }];
    cell.showImage.contentMode =  UIViewContentModeScaleAspectFill;
    cell.showImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    cell.showImage.clipsToBounds  = YES;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
   
    SDPhotoBrowser *photoBrowser = [[SDPhotoBrowser alloc] init];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = indexPath.item;
    photoBrowser.imageCount =_photoArray.count;
    photoBrowser.sourceImagesContainerView = self.collectionView;
    [photoBrowser show];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake( UISCREEN_WIDTH, 106);
 
    
}
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageName = _photoArray[index];
    NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = [[UIImageView alloc] init];
    NSString *urlstring = _photoArray[index];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", urlstring]]
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            
                        }];
    
    return imageView.image;
}



@end
