//
//  MBBabysDiaryViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/6/8.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBBabysDiaryViewController.h"
#import "MBBabysDiaryModel.h"
#import "MBBabysDiaryTableViewCell.h"
#import "MBPublishedViewController.h"
#import "STPhotoKitController.h"
#import "UIImagePickerController+ST.h"
#import "MBBabyManagementViewController.h"
#import "MBRecordTheBabyHeadView.h"
#import <SDWebImage/UIButton+WebCache.h>
@interface MBBabysDiaryViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, STPhotoKitDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _page;
    BOOL _isNewDiary;
    
    MBRecordTheBabyHeadView *_headView;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;


/***  记录上传宝宝墙图片是第几个*/
@property (assign, nonatomic) NSInteger photoWallIndex;

/***  宝宝日志数组*/
@property (copy, nonatomic) NSMutableArray<Result *> *resultArray;
@end

@implementation MBBabysDiaryViewController

-(NSMutableArray<Result *> *)resultArray{
    if (!_resultArray) {
        
        _resultArray = [NSMutableArray array];
        
    }
    return _resultArray;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    _page = 1;
    _headView = [MBRecordTheBabyHeadView instanceView];
     _headView.ml_width = UISCREEN_WIDTH;
    [_headView layoutIfNeeded];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, _headView.todayView.ml_maxY)];
    headView.backgroundColor = [UIColor redColor];
    headView.clipsToBounds = true;
    [headView addSubview:_headView];
    _tableView.tableHeaderView = headView;
    [self.view bringSubviewToFront:self.navBar];
    _tableView.tableFooterView = [[UIView alloc] init];
   @weakify(self);
    _headView.blcok = ^(NSInteger tag) {
        @strongify(self);
            if (tag < 5) {
                self.photoWallIndex = tag;

                [self editImageSelected];
            }else{
                [self theRefreshData];
                
            }

    };
    
    [self getBabyImage];
    
}

- (void)theRefreshData{
    WS(weakSelf)
    MBPublishedViewController *VC = [[MBPublishedViewController alloc] init];
    VC.releaseTheLog = ^{
        _isNewDiary = true;
     [weakSelf toGetTheBabyADiaryData];
    };
    
    [self pushViewController:VC Animated:YES];
    
}
- (IBAction)setThePhotoWallOrReleaseTheBaby:(UIButton *)sender {
    
    if (sender.tag < 5) {
        self.photoWallIndex = sender.tag;
        
        [self editImageSelected];
    }else{
        [self theRefreshData];
        
    }
}
- (NSString *)titleStr{
    
    return self.title?:@"宝宝动态";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)configureCell:(MBBabysDiaryTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = YES;
    cell.model = self.resultArray[indexPath.row];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
       return self.resultArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     @weakify(self);
    return [tableView fd_heightForCellWithIdentifier:@"MBBabysDiaryTableViewCell" cacheByIndexPath:indexPath configuration:^(MBBabysDiaryTableViewCell *cell) {
        @strongify(self);
        [self configureCell:cell atIndexPath:indexPath];
        
    }];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MBBabysDiaryTableViewCell *cell =   [tableView dequeueReusableCellWithIdentifier:@"MBBabysDiaryTableViewCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MBBabyManagementViewController *VC = [[MBBabyManagementViewController alloc] init];
    VC.model = _resultArray[indexPath.row];

    @weakify(self);
    VC.block = ^(Result * model){
        @strongify(self);
        [self.resultArray removeObject:model];
        
        [self.tableView reloadData];

    };
    [self pushViewController:VC Animated:YES];


}

- (void)photoKitController:(STPhotoKitController *)photoKitController resultImage:(UIImage *)resultImage
{
    _headView.photoWallimageArr[self.photoWallIndex] = resultImage;
    [_headView.buttonArray[self.photoWallIndex] setImage:resultImage forState:UIControlStateNormal];
    
    
    [self setBabyImage:self.photoWallIndex];
    
    
}
#pragma mark - 2.UIImagePickerController的委托

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *imageOriginal = [info objectForKey:UIImagePickerControllerOriginalImage];
        STPhotoKitController *photoVC = [STPhotoKitController new];
        [photoVC setDelegate:self];
        [photoVC setImageOriginal:imageOriginal];
        
        if (self.photoWallIndex !=2) {
            [photoVC setSizeClip:CGSizeMake((UISCREEN_WIDTH -40)/3 *2, (UISCREEN_WIDTH -40)/3 *2)];
        }else{
            
            [photoVC setSizeClip:CGSizeMake((UISCREEN_WIDTH -40)/3 *2,(UISCREEN_WIDTH -40)/3*2*218/105)];
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
- (void)toGetTheBabyADiaryData{
    [self show];
    
    if (_isNewDiary) {
        _page = 1;
        [_resultArray    removeAllObjects];
    }
    [MBNetworking POSTOrigin:string(BASE_URL_root, @"/athena/diarylistng") parameters:@{@"session":[MBSignaltonTool getCurrentUserInfo].sessiondict,@"page":s_Integer(_page)} success:^(id responseObject) {
        
        [self dismiss];
        MBBabysDiaryModel *model =   [MBBabysDiaryModel yy_modelWithJSON:responseObject];
        if (_page == 1&&!_isNewDiary) {
            
            MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(toGetTheBabyADiaryData)];
            footer.refreshingTitleHidden = YES;
            self.tableView.mj_footer = footer;
        }else{
            [_tableView.mj_footer endRefreshing];
        }
        
      
        if (model.data.result.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else{
            
            [self.resultArray addObjectsFromArray:model.data.result];
            [_tableView reloadData];
            _page ++;

        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败 " time:1];
        
    }];
    
}
- (void)getBabyImage{

 
    [MBNetworking  POSTOrigin:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/mengbao/get_pic_wall"] parameters:@{@"session":[MBSignaltonTool getCurrentUserInfo].sessiondict} success:^(id responseObject) {
        MMLog(@"%@",responseObject);
        
        _headView.photoWallimageArr = [@[[responseObject valueForKeyPath:@"data"][@"pic1"][@"photo"],[responseObject valueForKeyPath:@"data"][@"pic2"][@"photo"],[responseObject valueForKeyPath:@"data"][@"pic3"][@"photo"],[responseObject valueForKeyPath:@"data"][@"pic4"][@"photo"],[responseObject valueForKeyPath:@"data"][@"pic5"][@"photo"]] mutableCopy];
        
        [ _headView.photoWallimageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = _headView.buttonArray[idx];
            [btn sd_setImageWithURL:URL(obj) forState:UIControlStateNormal placeholderImage:V_IMAGE(@"amengBaoLeft")];
            
            
        }];
        
        
        
        
       
        
        
         [self toGetTheBabyADiaryData];
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败！" time:1];
    }];
    
}

- (void)setBabyImage:(NSInteger )index{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [self show];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/athena/set_pic_wall"] parameters:@{@"session":sessiondict,@"img_index":s_Integer(index +1)} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData * data =  UIImageJPEGRepresentation(_headView.photoWallimageArr[index], 1.0);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
