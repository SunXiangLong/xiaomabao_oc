//
//  MBVideoPlaybackViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/8/18.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBVideoPlaybackViewController.h"
#import <ZFPlayer/ZFPlayer.h>
@interface MBVideoPlaybackViewController ()<ZFPlayerDelegate>
@property (weak, nonatomic) IBOutlet ZFPlayerView *playerView;
@end

@implementation MBVideoPlaybackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
    self.playerView.delegate = self;
    playerModel.videoURL = self.videoURL;
    [self.playerView playerModel:playerModel];
    // 返回按钮事件

}
-(void)zf_playerBackAction{
   [self popViewControllerAnimated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
