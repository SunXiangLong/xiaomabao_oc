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
#import "MBabyRecordHeadView.h"
#import "MBabyRecordTwoCell.h"
#import "MBabyRecordThreeCell.h"
#import "MBabyRecordFourCell.h"
#import "MBPublishedViewController.h"
#import "MBBabyManagementViewController.h"
#import "MBabyRecordFiveCell.h"
@interface MBabyRecordController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, STPhotoKitDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _page;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  记录上传宝宝墙图片是第几个；
 */
@property (assign, nonatomic) NSInteger num;
@property (copy, nonatomic) NSMutableArray *imageArr;
/**
 *  宝宝日志数组
 */
@property (copy, nonatomic) NSMutableArray *resultArray;
@end

@implementation MBabyRecordController
-(NSMutableArray *)resultArray{
    if (!_resultArray) {
        
        _resultArray = [NSMutableArray array];
     
        
    }
    return _resultArray;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(setData:)];
    footer.refreshingTitleHidden = YES;
    self.tableView.mj_footer = footer;
    [self getBabyImage];
}
/**
 *  请求日志列表
 */
- (void)setData:(BOOL)addNewDynamic{
    if (addNewDynamic) {
        _page =1;
        [_resultArray removeAllObjects];
        [_tableView.mj_footer resetNoMoreData];
    }
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page];
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/athena/diarylistng"];
    if (! sid) {
        return;
    }
  
    [MBNetworking POSTOrigin:url parameters:@{@"session":sessiondict,@"page":page} success:^(id responseObject) {
        
         [self dismiss];
         [_tableView.mj_footer endRefreshing];
          MMLog(@"%@",responseObject);
        if ([[responseObject valueForKeyPath:@"data"][@"result"] count] == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];

        }else{
            /**
             *  发表了一个新的说说
             */
            if (addNewDynamic) {
                
               [self.resultArray addObjectsFromArray:[responseObject valueForKeyPath:@"data"][@"result"]];
               
//                [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:1 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
                 [_tableView reloadData];
                 _page ++;
              
            }else{
                [self.resultArray addObjectsFromArray:[responseObject valueForKeyPath:@"data"][@"result"]];
      
                _page ++;
                
                [_tableView reloadData];

            
            }
          
        
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败 " time:1];
        MMLog(@"%@",error);
    }];
    
}
- (void)getBabyImage{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [self show];
    [MBNetworking  POSTOrigin:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/mengbao/get_pic_wall"] parameters:@{@"session":sessiondict} success:^(id responseObject) {
//      MMLog(@"%@",responseObject);
        
        _imageArr = [@[[responseObject valueForKeyPath:@"data"][@"pic1"][@"photo"],[responseObject valueForKeyPath:@"data"][@"pic2"][@"photo"],[responseObject valueForKeyPath:@"data"][@"pic3"][@"photo"],[responseObject valueForKeyPath:@"data"][@"pic4"][@"photo"],[responseObject valueForKeyPath:@"data"][@"pic5"][@"photo"]] mutableCopy];
        
        
        [self setData:NO];
    
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败！" time:1];
    }];

}
/**
 *  设置照片墙上的数据
 *
 *  @param index 第几个图片
 */
- (void)setBabyImage:(NSInteger )index{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [self show];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/athena/set_pic_wall"] parameters:@{@"session":sessiondict,@"img_index":s_Integer(index +1)} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData * data =  UIImageJPEGRepresentation(_imageArr[index], 1.0);
        if(data != nil){
            [formData appendPartWithFileData:data name:@"pic_wall_img" fileName:[NSString stringWithFormat:@"pic_wall_img%ld.jpg",index] mimeType:@"image/jpeg"];
        }
        
    } progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, MBModel *responseObject) {
        [self dismiss];
        
       [self show:@"设置成功" time:1];
  
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败！" time:1];
    }];
}
- (NSString *)titleStr{

    return self.title?:@"宝宝动态";
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
  
    return _resultArray.count+1;
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
     NSDictionary *dic = _resultArray[indexPath.row -1];
    if ([dic[@"photo"] count] == 1) {
    
    return 110+(UISCREEN_WIDTH - 40 )/2;
    }
   
    if ([dic[@"photo"] count] == 0) {
        NSString *str = dic[@"content"];
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
        cell.dataArr = _imageArr;
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

    NSDictionary *dic = _resultArray[indexPath.row -1];
    if ([dic[@"photo"] count] == 0) {
        
        MBabyRecordFourCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBabyRecordFourCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MBabyRecordFourCell"owner:nil options:nil]firstObject];
        }
        
        cell.dataDic = dic;
        return cell;
    }
    if ([dic[@"photo"] count] == 1) {
        
        
        MBabyRecordFiveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBabyRecordFiveCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MBabyRecordFiveCell"owner:nil options:nil]firstObject];
        }
        
        cell.dataDic = dic;
        return cell;
    }
    
    MBabyRecordThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBabyRecordThreeCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBabyRecordThreeCell"owner:nil options:nil]firstObject];
    }
    cell.dataDic = dic;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section != 0) {
        
        if (indexPath.row == 0) {
            MBPublishedViewController *VC = [[MBPublishedViewController alloc] init];
            
            
            @weakify(self);
            [[VC.myCircleViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *num) {
                @strongify(self);
              
                [self setData:YES];
            }];
            

            
            [self pushViewController:VC Animated:YES];
        }else {
            NSDictionary *dic = _resultArray[indexPath.row -1];
            MBBabyManagementViewController *VC = [[MBBabyManagementViewController alloc] init];
            VC.ID = dic[@"id"];
            VC.photoArray = dic[@"photo"];
            VC.date       = dic[@"group"];
            VC.addtime    = dic[@"addtime"];
            VC.content    = dic[@"content"];
            VC.indexPath = indexPath;
            VC.image  = self.image;
            __unsafe_unretained __typeof(self) weakSelf = self;
            VC.block = ^(NSIndexPath *indexPath){
            [_resultArray removeObjectAtIndex:indexPath.row -1];
            [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
                
            };
            [self pushViewController:VC Animated:YES];
        }
        
        
        
       
    }
    
}
- (void)photoKitController:(STPhotoKitController *)photoKitController resultImage:(UIImage *)resultImage
{
     _imageArr[self.num] = resultImage;
    [self setBabyImage:self.num];
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
            MMLog(@"%s %@", __FUNCTION__, @"相机权限受限");
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
