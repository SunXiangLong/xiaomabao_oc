//
//  MBEvaluationViewView.m
//  XiaoMaBao
//
//  Created by liulianqi on 15/12/29.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import "MBEvaluationViewView.h"
#import "RatingBar.h"
#import "PhotoCollectionViewCell.h"
@interface MBEvaluationViewView ()

{
    RatingBar *_bar;
    NSDictionary *_dic;
}

@end
@implementation MBEvaluationViewView



- (IBAction)submit:(UIButton *)sender {
    
    
    
    
    
    [sender setTitle:@"已评价" forState:UIControlStateNormal];
    
//    sender.selected = YES;
     sender.enabled = NO;
    [self submitInformation];
}
- (void)submitInformation{
    
    
    
    
        
    
    
}

+ (instancetype)viewFromNIB {
   // 这个xib文件必须只拥有一个视图，并且该视图的class为本类
    MBEvaluationViewView *cell = [[[NSBundle mainBundle]loadNibNamed:@"MBEvaluationViewView" owner:self options:nil] firstObject];
  
    return cell;
}
-(void)dic:(NSDictionary *)dic{

    self.shopName.text = dic[@"name"];
    _dic = dic;
    NSString *urlstr = dic[@"img"];
    NSURL *url = [NSURL URLWithString:urlstr];
    [self.UIimageview sd_setImageWithURL:url];

}
- (void)awakeFromNib {
    [super awakeFromNib];
   _bar = [[RatingBar alloc] initWithFrame:CGRectMake(0, 0, 100, self.view.ml_height)];
    [self.view addSubview:_bar];
    
    _photoArray = [NSMutableArray array];
    [_photoArray addObject:[UIImage imageNamed:@"refund_pictures"]];

    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((UISCREEN_WIDTH-45)/6,(UISCREEN_WIDTH-45)/6);
    flowLayout.minimumInteritemSpacing =5;
    self.evaluationCollectionView.collectionViewLayout = flowLayout;
    self.evaluationCollectionView.dataSource = self;
    self.evaluationCollectionView.delegate = self;
    [ self.evaluationCollectionView registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCollectionViewCell"];
    
}
#pragma mark ---UICollectionViewDelegate
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    return insets;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell" forIndexPath:indexPath];
    id order = _photoArray[indexPath.item];
    
    if ([order isKindOfClass:[NSString class]] ) {
        cell.urlImg = URL(order);
    }else{
        cell.img = order;
    }

    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger num1 = _photoArray.count-1;
    if (indexPath.item == num1) {
        if (_photoArray.count<6) {
            [self setCamera];
        }else{
            
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多上传五张图片" delegate: self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [view show];
            
        }
        
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                 message:@"是否删除图片"
                                                                          preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *delete  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [_photoArray removeObjectAtIndex:indexPath.item];
            [self.evaluationCollectionView reloadData];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [alertController addAction:delete];
        [self.ViewControlle presentViewController:alertController animated:YES completion:nil];
        
        
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
        UIAlertAction* fromPhotoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action) {                                                                     UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            //imagePicker.allowsEditing = YES;
            imagePicker.delegate = self;
            [self.ViewControlle presentViewController:imagePicker animated:YES completion:nil];
            
        }];
        UIAlertAction* fromCameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault                                                             handler:^(UIAlertAction * action) {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                //imagePicker.allowsEditing = YES;
                imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self.ViewControlle presentViewController:imagePicker animated:YES completion:nil];
            }
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:fromCameraAction];
        [alertController addAction:fromPhotoAction];
        [self.ViewControlle presentViewController:alertController animated:YES completion:nil];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                 message:@"你的系统版本版本过低，最低支持8.0以上"
                                                                          preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self.ViewControlle presentViewController:alertController animated:YES completion:nil];
    }
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    
    [self.ViewControlle dismissViewControllerAnimated:YES completion:^{
        
        if (image) {
            if (_photoArray.count <6) {
                [_photoArray insertObject:image atIndex:0];
                [self.evaluationCollectionView reloadData];
                
            }
        }
        
    }];
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.ViewControlle dismissViewControllerAnimated:YES completion:nil];
}





@end
