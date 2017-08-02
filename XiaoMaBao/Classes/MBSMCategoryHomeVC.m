//
//  MBSMCcategoryHomeVC.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/6/28.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBSMCategoryHomeVC.h"
#import "MBSearchSecondaryMarketVC.h"
#import "MBSMCategoryModel.h"
#import "MBSMCategoryOneVC.h"
#import "MBSMCategoryTwoVC.h"
@interface MBSMCategoryHomeVC ()
{
    NSString *_filePath;
}
@property(nonatomic,strong) MBSMCategoryDataModel *model;
@end

@implementation MBSMCategoryHomeVC
-(void)setModel:(MBSMCategoryDataModel *)model{
    _model = model;
    
    MBSMCategoryOneVC *oneVc = self.childViewControllers.firstObject;
    
    MBSMCategoryTwoVC *twoVc = self.childViewControllers.lastObject;
    if (_isReturn) {
        twoVc.backCatID = ^(NSString *catID) {
            self.backCatID(catID);
            [self popViewControllerAnimated:true];
        };
    }
    twoVc.catListsArray = self.model.data[0].cat_lists;
    
    oneVc.model = _model;
    
    oneVc.selectRow = ^(NSArray<catListsModel *> *cat_lists) {
        twoVc.catListsArray = cat_lists;
        [twoVc.collectionView reloadData];
    };
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIcolor(@"E9ECEC");
    [self charmVersion];
    
   
    // Do any additional setup after loading the view.
}

- (void)charmVersion{
  
    [MBNetworking   newGET:string(BASE_URL_root, @"/secondary/cat_version") parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        id version = [User_Defaults objectForKey:@"secondaryCatVersion"];
       
        if ([User_Defaults objectForKey:@"MBSMCategoryDataModel"]&&version&&[responseObject[@"version"] integerValue] == [version integerValue]) {
            
           
            self.model = [MBSMCategoryDataModel yy_modelWithDictionary: [User_Defaults objectForKey:@"MBSMCategoryDataModel"]];
      
            
        }else{
            [User_Defaults setObject:responseObject[@"version"] forKey:@"secondaryCatVersion"];
            [User_Defaults synchronize];
            [self requestData];
        }
       
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self show:@"请求失败，请检查网络连接" time:1];
    }];
    
    
}

- (void)requestData{
    [self show];
    [MBNetworking   newGET:string(BASE_URL_root, @"/secondary/category") parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self dismiss];
        self.model = [MBSMCategoryDataModel yy_modelWithDictionary:responseObject];
       
        if (![User_Defaults objectForKey:@"MBSMCategoryDataModel"]) {
           
           
            [User_Defaults setObject:responseObject forKey:@"MBSMCategoryDataModel"];
            [User_Defaults synchronize];
        }
        
        
     
        

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self show:@"请求失败，请检查网络连接" time:1];
    }];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString *)titleStr{
  return @"商品分类";
}
//- (NSString *)rightImage{
//    return @"search_image";
//}
//- (void)rightTitleClick{
//    
//    
//    MBSearchSecondaryMarketVC *searchViewController = [[MBSearchSecondaryMarketVC alloc] init:PYSearchResultShowModeSecondaryMarket];
//    searchViewController.hotSearches = @[@"电视机",@"山地车",@"床头柜",@"电风扇",@"空调",@"电脑",@"夏天衣服"];
//    searchViewController.baseSearchTableView.hidden = false;
//    searchViewController.hotSearchStyle =  PYHotSearchStyleColorfulTag;
//    searchViewController.searchBar.placeholder = @"输入你正在找的宝贝";
//    searchViewController.hotSearchHeader.text = @"大家都在搜";
//    MBNavigationViewController *nav = [[MBNavigationViewController alloc] initWithRootViewController:searchViewController];
//    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"mm_navGroundImage"] forBarMetrics:UIBarMetricsDefault];
//    
//    nav.navigationBar.tintColor = [UIColor whiteColor];
//    [self presentViewController:nav  animated:NO completion:nil];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
