//
//  MBabyRecordController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/3.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBabyRecordController.h"
#import "MBabyRecordOneCell.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "STPhotoKitController.h"
#import "UIImagePickerController+ST.h"
#import "STConfig.h"
#import "MBabyRecordHeadView.h"
#import "MBabyRecordTwoCell.h"
#import "MBabyRecordThreeCell.h"
#import "MBabyRecordFourCell.h"
@interface MBabyRecordController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, STPhotoKitDelegate>
{

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  记录上传宝宝墙图片是第几个；
 */
@property (assign, nonatomic) NSInteger num;
@property (copy, nonatomic) NSMutableArray *imageArr;;
@end

@implementation MBabyRecordController
- (NSMutableArray *)imageArr {
    
    if (!_imageArr) {
        
        _imageArr = [NSMutableArray array];
    }
    
    return _imageArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    for (NSInteger i = 0; i<5; i++) {
        [self.imageArr addObject:@(1)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }
    
    return 10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 48 + (UISCREEN_WIDTH -30 )/3*435/212;
    }

    
    if (indexPath.row == 0) {
        return 80;
    }

    if (indexPath.row%2 == 0) {
        
        NSString *str = @"我们激光头去了哪个世界爽爽爽爽爽副驾驶飞机上就放假考试放假时间放松就放松空军飞机上看风景时口角是非家居服";
        
          return 115 + [str sizeWithFont:SYSTEMFONT(14) withMaxSize:CGSizeMake(UISCREEN_WIDTH-60, MAXFLOAT)].height;
    }
      return 110+(UISCREEN_WIDTH - 50 )/2;

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 40);
    
    MBabyRecordHeadView *headView = [MBabyRecordHeadView instanceView];
    headView.frame =  CGRectMake(0, 0, UISCREEN_WIDTH, 40);
    [view addSubview:headView];
    
    return view;
   
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        MBabyRecordOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBabyRecordOneCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MBabyRecordOneCell"owner:nil options:nil]firstObject];
        }
        
        cell.image0.image = [_imageArr[0] isKindOfClass:[NSNumber class ]]?[UIImage imageNamed:@"placeholder_num2"]:_imageArr[0];
        
        
        cell.image1.image = [_imageArr[1] isKindOfClass:[NSNumber class ]]?[UIImage imageNamed:@"placeholder_num2"]:_imageArr[1];
        cell.image2.image = [_imageArr[2] isKindOfClass:[NSNumber class ]]?[UIImage imageNamed:@"placeholder_num2"]:_imageArr[2];
        cell.image3.image = [_imageArr[3] isKindOfClass:[NSNumber class ]]?[UIImage imageNamed:@"placeholder_num2"]:_imageArr[3];
        cell.image4.image = [_imageArr[4] isKindOfClass:[NSNumber class ]]?[UIImage imageNamed:@"placeholder_num2"]:_imageArr[4];
        @weakify(self);
        [[cell.myCircleViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *num) {
            @strongify(self);
            self.num = [num integerValue];
            [self editImageSelected];
            
        }];
        return cell;
    }
    
    
    if (indexPath.row == 0) {
        MBabyRecordTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBabyRecordTwoCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MBabyRecordTwoCell"owner:nil options:nil]firstObject];
        }
        return cell;
    }

    if (indexPath.row%2 == 0) {
        MBabyRecordFourCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBabyRecordFourCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MBabyRecordFourCell"owner:nil options:nil]firstObject];
        }
        return cell;
    }
    MBabyRecordThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBabyRecordThreeCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBabyRecordThreeCell"owner:nil options:nil]firstObject];
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)photoKitController:(STPhotoKitController *)photoKitController resultImage:(UIImage *)resultImage
{
    _imageArr[self.num] = resultImage;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}
#pragma mark - 2.UIImagePickerController的委托

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *imageOriginal = [info objectForKey:UIImagePickerControllerOriginalImage];
        STPhotoKitController *photoVC = [STPhotoKitController new];
        [photoVC setDelegate:self];
        [photoVC setImageOriginal:imageOriginal];

        if (self.num !=2) {
          [photoVC setSizeClip:CGSizeMake((UISCREEN_WIDTH -40)/3 *2, (UISCREEN_WIDTH -40)/3 *2)];
        }else{
        
        [photoVC setSizeClip:CGSizeMake((UISCREEN_WIDTH -40)/3 *2,(UISCREEN_WIDTH -40)/3*2*435/212)];
        }
        
        [self presentViewController:photoVC animated:YES completion:nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
        
    }];
}

#pragma mark - --- event response 事件相应 ---
- (void)editImageSelected
{
    UIAlertController *alertController = [[UIAlertController alloc]init];
    
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *controller = [UIImagePickerController imagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        
        if ([controller isAvailableCamera] && [controller isSupportTakingPhotos]) {
            [controller setDelegate:self];
            [self presentViewController:controller animated:YES completion:nil];
        }else {
            NSLog(@"%s %@", __FUNCTION__, @"相机权限受限");
        }
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"从相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *controller = [UIImagePickerController imagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [controller setDelegate:self];
        if ([controller isAvailablePhotoLibrary]) {
            [self presentViewController:controller animated:YES completion:nil];
        }    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:action0];
    [alertController addAction:action1];
    [alertController addAction:action2];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
