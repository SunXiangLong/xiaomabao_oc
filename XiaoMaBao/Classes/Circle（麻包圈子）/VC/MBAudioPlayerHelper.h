//
//  MBAudioPlayerHelper.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/8/25.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StreamingKit/STKAudioPlayer.h>
@protocol MBSTKDataSourceDelegate <NSObject>

@optional
- (void)didAudioPlayerBeginPlay:(STKAudioPlayer*)audioPlayer;
- (void)didAudioPlayerStopPlay:(STKAudioPlayer*)audioPlayer;
- (void)didAudioPlayerPausePlay:(STKAudioPlayer*)audioPlayer;

@end

@interface MBAudioPlayerHelper : NSObject<STKAudioPlayerDelegate>
@property (nonatomic, strong) STKAudioPlayer *player;

@property (nonatomic, copy) NSString *playingFileName;

@property (nonatomic, assign) id <MBSTKDataSourceDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *playingIndexPathInFeedList;//给动态列表用
+ (id)shareInstance;

- (STKAudioPlayer*)player;
- (void)managerAudioWithFileName:(NSString*)amrName toID:(NSString *)ID;
- (void)pausePlayingAudio;//暂停
- (void)stopAudio;//停止
@end
