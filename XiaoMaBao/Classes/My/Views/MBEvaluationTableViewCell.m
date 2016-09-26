//
//  MBEvaluationTableViewCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 15/12/30.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import "MBEvaluationTableViewCell.h"
#import "RatingBar.h"
#import "PhotoCollectionViewCell.h"
@interface MBEvaluationTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,RatingBarDelegate,SDPhotoBrowserDelegate,PhotoCollectionViewCellDelegate>
{
    RatingBar *_bar;
    NSMutableArray *_photoArray;
    NSMutableArray *_photo;
}
@end
@implementation MBEvaluationTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}
-(void)setinit{
    _bar = [[RatingBar alloc] initWithFrame:CGRectMake(UISCREEN_WIDTH-20-200, 0, 200,30)];
    _bar.delagate = self;
    _bar.starNumber = self.num;
    [self.View addSubview:_bar];
    
    
    if (self.photoArr) {
        _photoArray = [NSMutableArray arrayWithArray:self.photoArr];
        [_photoArray addObject:[UIImage imageNamed:@"refund_pictures"]];
    }else{
        
        _photoArray = [NSMutableArray array];
        [_photoArray addObject:[UIImage imageNamed:@"refund_pictures"]];
    }
    if (self.textView.text.length>0) {
        self.labeltext.text = nil;
    }
    self.textView.delegate = self;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((UISCREEN_WIDTH-45)/6,(UISCREEN_WIDTH-45)/6);
    flowLayout.minimumInteritemSpacing =5;
    self.CollectionView.collectionViewLayout = flowLayout;
    self.CollectionView.dataSource = self;
    self.CollectionView.delegate = self;
    [ self.CollectionView registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCollectionViewCell"];
    _photo = [NSMutableArray array];
    
    
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
    
    cell.image.image = _photoArray[indexPath.item];
    cell.dalegate = self;
    
    
    
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.textView resignFirstResponder];
    NSInteger num1 = _photoArray.count-1;
    if (indexPath.item == num1) {
        if (_photoArray.count<6) {
            [self setCamera];
        }else{
            
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多上传五张图片" delegate: self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [view show];
            
        }
        
    }else{

        
        SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
        photoBrowser.delegate = self;
        photoBrowser.currentImageIndex = indexPath.item;
        photoBrowser.imageCount = _photoArray.count;
        photoBrowser.sourceImagesContainerView = _CollectionView;
        [photoBrowser show];
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
   // MMLog(@"%@",image);
    
    [self.ViewControlle dismissViewControllerAnimated:YES completion:^{
        
        if (image) {
            if (_photoArray.count <6) {
                [_photoArray insertObject:image atIndex:0];
                [_photo insertObject:image atIndex:0];
                NSIndexPath *indexpath = [NSIndexPath indexPathForItem:0 inSection:0];
                NSArray *array = @[indexpath];
                [self.CollectionView insertItemsAtIndexPaths:array];
                
                if (self.delegate &&[self.delegate respondsToSelector:@selector(CommodityImages:row:)]) {
                    NSArray *arr = _photoArray;
                    NSMutableArray *muarr = [NSMutableArray arrayWithArray:arr];
                    [muarr removeLastObject];
                    [self.delegate CommodityImages:muarr row:self.row];
                }
            }
        }
        
    }];
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.ViewControlle dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(label:row:)]) {
        
        [self.delegate label:textView.text row:self.row];
    }
    self.labeltext.text = nil;
    
    return YES;
}
- (void)textViewDidChangeSelection:(UITextView *)textView{
    
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(label:row:)]) {
        
        [self.delegate label:textView.text row:self.row];
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView;{
    
    if (textView.text.length>0) {
        
        if (self.delegate &&[self.delegate respondsToSelector:@selector(CommodityGrade:row:)]) {
            
            [self.delegate ProductEvaluation:textView.text row:self.row];
        }
        
    }else{
        self.labeltext.text  = @"请写下对宝贝的感受吧，对他人的帮助很大哦";
    }
    
    
    return YES;
}
-(void)RatingBar_starNumber:(NSInteger)starNumber{
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(CommodityGrade:row:)]) {
        
        [self.delegate CommodityGrade:starNumber row:self.row];
    }
}
- (IBAction)submit:(UIButton *)sender {
    [self.textView resignFirstResponder];
    if (self.textView.text.length<1) {
        [self.ViewControlle show:@"请添加商品评价" time:1];
        return;
    }
    
    if (_bar.starNumber==0) {
         [self.ViewControlle show:@"请添加商品评分" time:1];
        return;
    }
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(SubmitEvaluation:)]) {
        
        [self.delegate SubmitEvaluation: self.row];
    }
}
#pragma mark - SDPhotoBrowserDelegate
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{

    return _photoArr[index];
}
#pragma mark - PhotoCollectionViewCellDelegate
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
                NSArray *array = @[indexpath];
                [self.CollectionView deleteItemsAtIndexPaths:array];
                
                if (self.delegate &&[self.delegate respondsToSelector:@selector(CommodityImages:row:)]) {
                    NSArray *arr = _photoArray;
                    NSMutableArray *muarr = [NSMutableArray arrayWithArray:arr];
                    [muarr removeLastObject];
                    [self.delegate CommodityImages:muarr row:self.row];
                }
                
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
            [alertController addAction:delete];
            [self.ViewControlle presentViewController:alertController animated:YES completion:nil];

}

@end
