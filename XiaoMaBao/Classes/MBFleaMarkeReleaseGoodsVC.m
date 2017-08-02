//
//  MBFleaMarkeReleaseGoodsVC.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/7/3.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBFleaMarkeReleaseGoodsVC.h"
#import "MBFleaMarkeReleaseGoodsCell.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "MBSMCategoryHomeVC.h"
@interface MBFleaMarkeReleaseGoodsVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,SDPhotoBrowserDelegate,YYTextViewDelegate>
{

 SDPhotoBrowser *_browser;
}
@property (weak, nonatomic) IBOutlet YYTextView *goodsName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsNameHeight;
@property (weak, nonatomic) IBOutlet YYTextView *goodsContent;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionVieHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsContentHeight;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UIView *boottomView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet UITextField *pricetextField;
@property (weak, nonatomic) IBOutlet UITextField *originalPriceTextField;
@property (weak, nonatomic) IBOutlet UITextField *feeTextField;
@property (copy, nonatomic)  NSString *longitude;
@property (copy, nonatomic)  NSString *latitude;
@property (nonatomic,strong) NSMutableArray *photoArray;
@property (copy, nonatomic)  NSString *cat_id;
@end

@implementation MBFleaMarkeReleaseGoodsVC

-(NSMutableArray *)photoArray{
    if (!_photoArray) {
        _photoArray = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"fleaMarkeReleaseAddGoodsImage"], nil];
    }
    return _photoArray;


}
- (void) viewWillAppear: (BOOL)animated {
    [super viewWillAppear:animated];
    //打开键盘事件相应
//    [IQKeyboardManager sharedManager].enable = NO;
    
   
//    if (self.location.text.length > 2) {
//        return;
//    }
    WS(weakSelf)
    [DXLocationManager getlocationWithBlock:^(double longitude, double latitude) {
        weakSelf.longitude = [NSString stringWithFormat:@"%f",longitude];
        weakSelf.latitude = [NSString stringWithFormat:@"%f" , latitude];
        
        if (!(weakSelf.longitude&&weakSelf.latitude) ) {
          [weakSelf show:@"位置获取失败" time:1];
        }
    }];
    
}

- (void) viewWillDisappear: (BOOL)animated {
    [super viewWillDisappear:animated];
    //关闭键盘事件相应
    
//    [IQKeyboardManager sharedManager].enable = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}
- (void)setUI{
    
    _goodsName.returnKeyType = UIReturnKeyDone;
    _goodsContent.returnKeyType = UIReturnKeyDone;
    _tableView.tableFooterView = [[UIView alloc] init];
   
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 15;
    layout.minimumInteritemSpacing = 10;
    layout.itemSize = CGSizeMake((UISCREEN_WIDTH - 70) / 4  ,(UISCREEN_WIDTH - 70) / 4);
    _collectionView.collectionViewLayout = layout;
    self.collectionVieHeight.constant = (UISCREEN_WIDTH - 70) / 4 ;
    self.goodsName.scrollEnabled = false;
    self.goodsContent.scrollEnabled = false;
    
    [self.topView layoutIfNeeded];
    self.topView.ml_height = self.boottomView.ml_maxY;
    
    
    @weakify(self);
    [RACObserve(self.goodsName, text) subscribeNext:^(id x) {
        @strongify(self);
        if (self.goodsName.textLayout.textBoundingSize.height !=  self.goodsNameHeight.constant) {
            self.goodsNameHeight.constant = self.goodsName.textLayout.textBoundingSize.height;
            [self.topView layoutIfNeeded];
            self.topView.ml_height = self.boottomView.ml_maxY;
            self.tableView.tableHeaderView = self.topView;
           
        }
        
    }];
    
    [RACObserve(self.goodsContent, text) subscribeNext:^(id x) {
        @strongify(self);
        if (self.goodsContent.textLayout.textBoundingSize.height !=  self.goodsContentHeight.constant) {
            self.goodsContentHeight.constant = self.goodsContent.textLayout.textBoundingSize.height;
            [self.topView layoutIfNeeded];
            self.topView.ml_height = self.boottomView.ml_maxY;
            self.tableView.tableHeaderView = self.topView;
           
        }
        
    }];
    
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSNotification *value) {
         @strongify(self);
         if ([self.goodsContent isFirstResponder]||[self.goodsName isFirstResponder]) {
             return;
         }
         if (self.bottom.constant == 0) {
             self.bottomView.hidden = false;
             [UIView animateWithDuration:0.25 animations:^{
                 self.bottom.constant = [value.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
                 [self.view layoutIfNeeded];
             } completion:^(BOOL finished) {
                 
             }];
         }else{
             
             if ([self.goodsContent isFirstResponder]|| [self.goodsName isFirstResponder]) {
                 [UIView animateWithDuration:0.25 animations:^{
                     self.bottom.constant = 0 - self.bottomView.ml_height;
                     
                     [self.view layoutIfNeeded];
                 } completion:^(BOOL finished) {
                     self.bottomView.hidden = true;
                 }];
             }
             
         }
         
     }];
    
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSNotification *value) {
         @strongify(self);
         if (self.bottom.constant != 0) {
             [UIView animateWithDuration:0.25 animations:^{
                 self.bottom.constant = 0;
                 [self.view layoutIfNeeded];
             } completion:^(BOOL finished) {
                 self.bottomView.hidden = true;
                 
             }];
             
             
         }
         
         
     }];
    
    
    
}

//- (void)setCommon{
//    [self show];
//    [MBNetworking   POSTOrigin:string(BASE_URL_root, @"/common/location") parameters:@{@"longitude":self.longitude,@"latitude":self.latitude} success:^(id responseObject) {
//        MMLog(@"%@",responseObject);
//        [self dismiss];
//        self.location.text = responseObject[@"data"];
//    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
//        [self show:@"请求失败" time:1];
//        MMLog(@"%@",error);
//    }];
//
//
//
//}
- (void)releaseGoods{
    [self show];
    [MBNetworking   POSTOrigin:string(BASE_URL_root, @"/secondary/publish") parameters:@{@"cat_id":self.cat_id,@"goods_name":self.goodsName.text,@"brief":self.goodsContent.text,@"fee":self.feeTextField.text,@"price":self.pricetextField.text,@"orininal_price":self.originalPriceTextField.text,@"latitude":self.latitude,@"longitude":self.longitude} success:^(id responseObject) {
        MMLog(@"%@",responseObject);
        [self dismiss];
        if ([responseObject[@"status"] integerValue] == 0) {
            [self uploadImages:responseObject[@"data"][@"goods_id"]];
        }else{
            [self show:responseObject[@"info"] time:1];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
         [self show:@"请求失败！" time:1];
    }];

}
- (void)uploadImages:(NSString *)token{

    [MBNetworking POST:string(BASE_URL_root, @"/secondary/photos") parameters:@{@"token":token} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [self.photoArray removeLastObject];
        [self.photoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             NSData * data =  UIImageJPEGRepresentation(obj, 1.0);
            [formData appendPartWithFileData:data name:@"photo" fileName:[NSString stringWithFormat:@"photo[%ld].jpg",idx] mimeType:@"image/jpeg"];
        }];
    } progress:^(NSProgress *progress) {
        MMLog(@"%@", progress)
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        MMLog(@"%@", responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        MMLog(@"%@",error);
         [self show:@"请求失败！" time:1];
    }];

}
-(NSString *)titleStr{
    return @"发布宝贝" ;
}
//-(NSString *)leftStr{
//    return @"取消" ;
//}
- (void)leftTitleClick{
    
    [self popViewControllerAnimated:true];
    
}
- (IBAction)releeaseGoods:(id)sender {
    
    if (self.goodsName.text.length < 1) {
        [self show:@"请输入商品名称" time:1];
        [self.goodsName becomeFirstResponder];
        return;
    }
    if (self.goodsContent.text.length < 1) {
        [self show:@"请输入商品描述" time:1];
         [self.goodsContent becomeFirstResponder];
        return;
    }
    
    if (self.photoArray.count < 2 ) {
        [self show:@"请上传商品图片" time:1];
        [self presentPhotoPickerViewController];
        return;
    }
    if (!self.cat_id) {
        [self show:@"请选择商品分类" time:1];
        [self performSegueWithIdentifier:@"MBSMCategoryHomeVC" sender:nil];
        return;
    }

    if (self.pricetextField.text.length < 1) {
        [self show:@"请输入商品售价" time:1];
         [self.pricetextField becomeFirstResponder];
        return;
    }
    if (self.originalPriceTextField.text.length < 1) {
        [self show:@"请输入商品原价" time:1];
//        [self.pricetextField becomeFirstResponder];
        [self.originalPriceTextField becomeFirstResponder];
        return;
    }
    if (self.feeTextField.text.length < 1) {
        [self show:@"请输入商品运费" time:1];
//        [self.pricetextField becomeFirstResponder];
        [self.feeTextField becomeFirstResponder];
        return;
    }

   
    [self releaseGoods];
}

#pragma mark --相册多选
/**
 *  初始化相册选择器
 */
- (void)presentPhotoPickerViewController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:7 - self.photoArray.count  columnNumber:4 delegate:nil pushPhotoPickerVc:YES];
    WS(weakSelf)
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        for ( UIImage *image in photos) {
            
            [weakSelf.photoArray insertObject:image atIndex:0];
        }
        if (weakSelf.photoArray.count > 4) {
            weakSelf.collectionVieHeight.constant = (UISCREEN_WIDTH - 70) * 0.5 + 15;
            [weakSelf.topView layoutIfNeeded];
            weakSelf.topView.ml_height = weakSelf.boottomView.ml_maxY;
            weakSelf.tableView.tableHeaderView = weakSelf.topView;
        }
        
        
//        [weakSelf setCollectionViewHeight];
        [weakSelf.collectionView reloadData];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"MBSMCategoryHomeVC"]) {
        
        MBSMCategoryHomeVC *VC = (MBSMCategoryHomeVC  *)segue.destinationViewController;
        VC.isReturn = true;
        weakifySelf
        VC.backCatID = ^(NSString *caatID) {
            weakSelf.cat_id = caatID;
        };
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 1) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBFleaMarkeReleaseGoodsTabCellTo" forIndexPath:indexPath];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBFleaMarkeReleaseGoodsTabCell" forIndexPath:indexPath];
    
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 1) {
        
        [_pricetextField becomeFirstResponder];
        
        
    }else{
    
//        MBSMCategoryHomeVC *VC  = (MBSMCategoryHomeVC *) [[UIStoryboard storyboardWithName:@"secondaryMarket" bundle:nil] instantiateViewControllerWithIdentifier:@"MBSMCategoryHomeVC"];
//        VC.backCatID = ^(NSString *caatID) {
//            self.cat_id = caatID;
//        };
//        VC.isBack = true;
       
        [self performSegueWithIdentifier:@"MBSMCategoryHomeVC" sender:nil];
    }
}
#pragma mark --UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.photoArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MBFleaMarkeReleaseGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBFleaMarkeReleaseGoodsCell" forIndexPath:indexPath];
    cell.image = _photoArray[indexPath.item];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.photoArray.count - 1) {
         [self presentPhotoPickerViewController];
    }else{
        _browser = [[SDPhotoBrowser alloc] init];
        _browser.currentImageIndex =indexPath.row;
        _browser.sourceImagesContainerView = _collectionView;
        _browser.imageCount = _photoArray.count-1;
        _browser.delegate = self;
        [_browser show];
    }
    
}
-(BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    [textView resignFirstResponder];
    if([text isEqualToString:@"\n"]){
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    
  
    return true;
}



- (BOOL)textViewShouldEndEditing:(YYTextView *)textView{
//    [textView becomeFirstResponder];
    return true;
}




#pragma mark - SDPhotoBrowserDelegate
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    
    return _photoArray[index];
    
}

@end
