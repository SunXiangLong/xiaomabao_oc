//
//  MBBabyManagementViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/25.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBabyManagementViewController.h"
#import "MBBabyImageCollectionViewCell.h"
#import "MBBabysDiaryModel.h"
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCollerctonView];
    _dateLable.text = _model.group;
    _timeLable.text = _model.addtime;
    _textLable.text  = _model.content;
    

}
- (void)setCollerctonView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((UISCREEN_WIDTH-60)/3,(UISCREEN_WIDTH-60)/3);
    
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 15, 5, 15);
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
-(NSString *)titleStr{
return @"详情";
}
-(void)setDeleteRecords{

    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];

    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/athena/diarydel"];
    [self show];
    [MBNetworking POST:url parameters:@{@"session":sessiondict,@"id":_model.ID}
               success:^(NSURLSessionDataTask *operation, MBModel *responseObject) {
                      [self dismiss];
                   
                   if(1 == [[responseObject valueForKey:@"status"]  intValue]){
                    
                       NSDictionary *userData = [responseObject valueForKeyPath:@"status"];
                       MMLog(@"%@",userData);
                    
                       self.block(_model);
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
    return _model.photo.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        if (indexPath.section == 0) {
            UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView1" forIndexPath:indexPath];
            
            [reusableview addSubview:_headView];
      [_HeadPhotoImageView sd_setImageWithURL:[NSURL URLWithString:[MBSignaltonTool getCurrentUserInfo].header_img] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
            
            _nameLable.text = [MBSignaltonTool getCurrentUserInfo].nick_name;//userInfo.user_baby_info[@"nickname"];
            
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
    NSURL *url = [NSURL URLWithString: _model.photo[indexPath.item]];
    [cell.showImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder_num2"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cell.showImage.alpha = 0.3f;
        [UIView animateWithDuration:1
                         animations:^{
                             cell.showImage.alpha = 1.0f;
                         }
                         completion:nil];
    }];

    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
   
    SDPhotoBrowser *photoBrowser = [[SDPhotoBrowser alloc] init];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = indexPath.item;
    photoBrowser.imageCount =_model.photo.count;
    photoBrowser.sourceImagesContainerView = self.collectionView;
    [photoBrowser show];
}
- (NSMutableAttributedString*)getAttr:(NSString*)attributedString {
    NSMutableAttributedString * resultAttr = [[NSMutableAttributedString alloc] initWithString:attributedString];
    
    //对齐方式 这里是 两边对齐
    resultAttr.yy_alignment = NSTextAlignmentLeft;
    //设置行间距
    resultAttr.yy_lineSpacing = 1;
    
    //设置字体大小
    resultAttr.yy_font = YC_YAHEI_FONT(13);
    resultAttr.yy_color = UIcolor(@"575757");
    //可以设置某段字体的大小
    //[resultAttr yy_setFont:[UIFont boldSystemFontOfSize:CONTENT_FONT_SIZE] range:NSMakeRange(0, 3)];
    //设置字间距
    resultAttr.yy_kern = [NSNumber numberWithFloat:1.0];
    
    return resultAttr;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    YYTextContainer  *titleContarer = [YYTextContainer new];
    //限制宽度
    titleContarer.size             = CGSizeMake(UISCREEN_WIDTH - 30,CGFLOAT_MAX);
    NSMutableAttributedString  *titleAttr = [self getAttr:_model.content];
    YYTextLayout *titleLayout = [YYTextLayout layoutWithContainer:titleContarer text:titleAttr];
    CGFloat titleLabelHeight = titleLayout.textBoundingSize.height;
    ;

    
    return CGSizeMake( UISCREEN_WIDTH, 60 + titleLabelHeight);
 
    
}
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageName = _model.photo[index];
    NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = [[UIImageView alloc] init];
    NSString *urlstring = _model.photo[index];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", urlstring]]
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            
                        }];
    
    return imageView.image;
}



@end
