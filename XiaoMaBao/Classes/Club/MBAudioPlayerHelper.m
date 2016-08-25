//
//  MBAudioPlayerHelper.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/8/25.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBAudioPlayerHelper.h"
#import <AVFoundation/AVAudioSession.h>

@implementation MBAudioPlayerHelper
- (void)managerAudioWithFileName:(NSString*)amrName toID:(NSString *)ID {
    
    [self playAudioWithFileName:amrName];
    [self loadData:ID];
    
}

//暂停
- (void)pausePlayingAudio {
    if (_player) {
        [_player pause];
        if ([self.delegate respondsToSelector:@selector(didAudioPlayerPausePlay:)]) {
            [self.delegate didAudioPlayerPausePlay:_player];
        }
    }
}

- (void)stopAudio {
    [self setPlayingFileName:@""];
    [self setPlayingIndexPathInFeedList:nil];
    if (_player && _player.muted) {
        [_player stop];
    }
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    if ([self.delegate respondsToSelector:@selector(didAudioPlayerStopPlay:)]) {
        [self.delegate didAudioPlayerStopPlay:_player];
    }
}

#pragma mark - action

//播放转换后wav
- (void)playAudioWithFileName:(NSString*)fileName {
    if (fileName.length > 0) {
        
        //不随着静音键和屏幕关闭而静音。code by Aevit
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        
//        if (_playingFileName && [fileName isEqualToString:_playingFileName]) {//上次播放的录音
//            if (_player) {
//                [_player resume];
//                [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
//                if ([self.delegate respondsToSelector:@selector(didAudioPlayerBeginPlay:)]) {
//                    [self.delegate didAudioPlayerBeginPlay:_player];
//                }
//            }
//        } else {//不是上次播放的录音
            if (_player) {
                [_player stop];
                self.player = nil;
            }
            _player =[[STKAudioPlayer alloc]init];
            [_player play:fileName];
            _player.delegate = self;

            [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
        
//        }
        self.playingFileName = fileName;
    }
}



#pragma mark - Getter





#pragma mark - Setter

- (void)setDelegate:(id<MBSTKDataSourceDelegate>)delegate {
    if (_delegate != delegate) {
        _delegate = delegate;
        
        if (_delegate == nil) {
            [self stopAudio];
        }
    }
}

#pragma mark - Life Cycle

+ (id)shareInstance {
    static MBAudioPlayerHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MBAudioPlayerHelper alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        [self changeProximityMonitorEnableState:YES];
        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    }
    return self;
}

- (void)dealloc {
    [self changeProximityMonitorEnableState:NO];
}
- (void)loadData:(NSString *)ID{
    
    [MBNetworking POSTOrigin:string(BASE_URL_root, @"/index.php/voice/voice_click/") parameters:@{@"id":ID} success:^(id responseObject) {
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
    
}
#pragma mark - audio delegate

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId{
    NSLog(@"%@",@"开始111");
}
/// Raised when an item has finished buffering (may or may not be the currently playing item)
/// This event may be raised multiple times for the same item if seek is invoked on the player
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId{
NSLog(@"%@",@"开始33333");
}
/// Raised when the state of the player has changed
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState{
NSLog(@"%@",@"结束");
}
/// Raised when an item has finished playing
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration{

    if ([self.delegate respondsToSelector:@selector(didAudioPlayerPausePlay:)]) {
        [self.delegate didAudioPlayerPausePlay:_player];
    }
}
/// Raised when an unexpected and possibly unrecoverable error has occured (usually best to recreate the STKAudioPlauyer)
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode{

}


#pragma mark - 近距离传感器

- (void)changeProximityMonitorEnableState:(BOOL)enable {
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    if ([UIDevice currentDevice].proximityMonitoringEnabled == YES) {
        if (enable) {
            
            //添加近距离事件监听，添加前先设置为YES，如果设置完后还是NO的读话，说明当前设备没有近距离传感器
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
            
        } else {
            
            //删除近距离事件监听
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
            [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        }
    }
}

- (void)sensorStateChange:(NSNotificationCenter *)notification {
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗
    if ([[UIDevice currentDevice] proximityState] == YES) {
        //黑屏
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
    } else {
        //没黑屏幕
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        if (!_player || !_player.muted) {
            //没有播放了，也没有在黑屏状态下，就可以把距离传感器关了
            [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        }
    }
}
@end
