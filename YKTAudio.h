//
//  YKTAudio.h
//
//
//  Created by on 9/11/15.
//  Copyright (c) 2015 All rights reserved.
//

/**
 *  远程音频设置播放进度的代理
 */
@protocol RemotePlayProgressDelegate <NSObject>

- (void)setProgress:(CGFloat)progress;

@end

typedef void (^completeBlock)(void);//播放完成的回调
@class AVPlayer;

@interface YKTAudio : NSObject

@property (nonatomic, strong) AVPlayer *player;//用于播放网络音频
@property (weak, nonatomic) id<RemotePlayProgressDelegate> delegate;
@property (strong, nonatomic) completeBlock blcok;

- (void)right:(completeBlock)block;//正确提示的音效
- (void)wrong:(completeBlock)block;//错误提示的音效

- (void)playBackgroundMusic:(NSURL *)url_ done:(completeBlock)block;//播放背景音乐
- (void)pauseBackgroundMusic;//暂停
- (void)resumeBackgroundMusic;//恢复

- (void)playSoundEffect:(NSURL *)url_ done:(completeBlock)block;//播放本地音效
- (void)playRemoteSoundEffect:(NSURL *)url_;//播放网络音频

@end
