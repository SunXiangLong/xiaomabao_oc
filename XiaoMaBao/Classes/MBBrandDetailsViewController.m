//
//  MBBrandDetailsViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 16/9/19.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBrandDetailsViewController.h"
#import "MBBrandDetailsCollectionViewController.h"
@interface MBBrandDetailsViewController ()

@end

@implementation MBBrandDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    MBBrandDetailsCollectionViewController *VC =   [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MBBrandDetailsCollectionViewController"];
    VC.type = _type;
    VC.ID = _ID;
    [self addChildViewController:VC];

    VC.view.frame = CGRectMake(0, TOP_Y, UISCREEN_WIDTH, UISCREEN_HEIGHT - TOP_Y);
    [self.view addSubview:VC.view];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
