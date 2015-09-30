//
//  YKTAudio.m
//
//
//  Created by on 9/11/15.
//  Copyright (c) 2015 All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "YKTAudio.h"

@interface YKTAudio ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *backgroundMusicPlayer;
@property (nonatomic, strong) AVAudioPlayer *soundEffectPlayer;

@end

@implementation YKTAudio

- (void)right:(completeBlock)block
{
    [self playSoundEffect:[[NSBundle mainBundle] URLForResource:@"right" withExtension:@"mp3"] done:block];
}

- (void)wrong:(completeBlock)block
{
    [self playSoundEffect:[[NSBundle mainBundle] URLForResource:@"wrong" withExtension:@"mp3"] done:block];
}

- (void)playBackgroundMusic:(NSURL *)url_ done:(completeBlock)block
{
    NSError *error;
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url_ error:&error];
    if (self.backgroundMusicPlayer == nil)
    {
        NSLog(@"Could not create audio player: %@", error);
        return;
    }
    
    _blcok = block;
    self.backgroundMusicPlayer.delegate = self;
    self.backgroundMusicPlayer.numberOfLoops = -1;
    [self.backgroundMusicPlayer prepareToPlay];
    [self.backgroundMusicPlayer play];
}

- (void)pauseBackgroundMusic
{
    if (self.backgroundMusicPlayer.playing)
    {
        [self.backgroundMusicPlayer pause];
    }
}

- (void)resumeBackgroundMusic
{
    if (!self.backgroundMusicPlayer.playing)
    {
        [self.backgroundMusicPlayer play];
    }
}

- (void)playSoundEffect:(NSURL *)url_ done:(completeBlock)block
{
    NSError *error;
    self.soundEffectPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url_ error:&error];
    if (self.soundEffectPlayer == nil)
    {
        NSLog(@"Could not create audio player: %@", error);
        if(block != nil)
        {
            block();
        }
        return;
    }
    
    _blcok = block;
    self.soundEffectPlayer.delegate = self;
    self.soundEffectPlayer.numberOfLoops = 0;
    [self.soundEffectPlayer prepareToPlay];
    [self.soundEffectPlayer play];
}

- (void)playRemoteSoundEffect:(NSURL *)url_
{
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url_];
 
    _player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
  
    [self addProgressObserver];
    [_player play];
}

- (void)dealloc
{
    _player = nil;
}

/**
 *  给播放器添加进度更新
 */
-(void)addProgressObserver
{
    AVPlayerItem *playerItem = self.player.currentItem;
    //这里设置每0.1秒执行一次
    
    __weak __typeof(self) weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 10.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        CGFloat current=CMTimeGetSeconds(time);
        CGFloat total=CMTimeGetSeconds([playerItem duration]);
        if (current)
        {
            CGFloat progress = (current / total);
            if ([weakSelf.delegate respondsToSelector:@selector(setProgress:)])
            {
                [weakSelf.delegate setProgress:progress];
            }
        }
    }];
}

#pragma makr - AVAudioPlayerDelegate

///* audioPlayerDidFinishPlaying:successfully: is called when a sound has finished playing. This method is NOT called if the player is stopped due to an interruption. */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self triggerFinish];
}

///* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    [self triggerFinish];
}

/* audioPlayerBeginInterruption: is called when the audio session has been interrupted while the player was playing. The player will have been paused. */
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    [self triggerFinish];
}

- (void)triggerFinish
{
    if(_blcok != nil)
    {
        _blcok();
    }
}

///* audioPlayerEndInterruption:withOptions: is called when the audio session interruption has ended and this player had been interrupted while playing. */
///* Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume. */
//- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags {
//
//}
//
//- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags {
//
//}
//
///* audioPlayerEndInterruption: is called when the preferred method, audioPlayerEndInterruption:withFlags:, is not implemented. */
//- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player NS_DEPRECATED_IOS(2_2, 6_0) {
//    
//}

@end
