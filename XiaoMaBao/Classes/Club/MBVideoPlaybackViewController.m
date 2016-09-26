//
//  MBVideoPlaybackViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/8/18.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBVideoPlaybackViewController.h"
#import "ZFPlayer.h"
@interface MBVideoPlaybackViewController ()
@property (weak, nonatomic) IBOutlet ZFPlayerView *playerView;
@end

@implementation MBVideoPlaybackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playerView.videoURL = self.videoURL;
    // 返回按钮事件
    __weak typeof(self) weakSelf = self;
    self.playerView.goBackBlock = ^{
        [weakSelf popViewControllerAnimated:YES];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
