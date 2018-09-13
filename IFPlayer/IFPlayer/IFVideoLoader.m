//
//  IFVideoLoader.m
//  IFPlayer
//
//  Created by Xuqigang on 2018/9/10.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//

#import "IFVideoLoader.h"
static BOOL _isPlaying = NO;
@interface IFVideoLoader ()
{
    AVPlayer * _avplayer;
    UIView *_videoPreview;
    AVPlayerLayer *_playerLayer;
    NSTimer *_progressTimer;
    BOOL _fullScreen;
}
@end

@implementation IFVideoLoader

+ (instancetype)defaultPlayer{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)loadVideoUrl:(NSURL*)url{
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    _avplayer = [AVPlayer playerWithPlayerItem:playerItem];
    if (_playerLayer) {
        [_playerLayer removeFromSuperlayer];
        _playerLayer = nil;
    }
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_avplayer];
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    if (_videoPreview) {
        [_videoPreview.layer addSublayer:_playerLayer];
        _playerLayer.frame = _videoPreview.layer.bounds;
    }
    [_avplayer.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_avplayer.currentItem];
}

- (BOOL)isPlaying{
    if (_avplayer) {
        _isPlaying = _avplayer.rate > 0;
        return _avplayer.rate > 0 ;
    } else {
        _isPlaying = NO;
        return NO;
    }
}
- (void)addVideoPreview:(UIView*)view{
    _videoPreview = view;
    if (_playerLayer) {
        [_playerLayer removeFromSuperlayer];
        [_videoPreview.layer addSublayer:_playerLayer];
        _playerLayer.frame = _videoPreview.layer.bounds;
    }
}
- (void)seekToTime:(CGFloat)time completionHandler:(void (^)(BOOL finished))completionHandler{
    
    BOOL playState = self.isPlaying;
    //让视频从指定的CMTime对象处播放。
    CMTime startTime = CMTimeMakeWithSeconds(time, _avplayer.currentItem.currentTime.timescale);
    //让视频从指定处播放
    [_avplayer seekToTime:startTime completionHandler:^(BOOL finished) {
        if (completionHandler) {
            completionHandler(finished);
        }
        //调节进度前，如果是暂停状态，则继续暂停，否则继续播放
        if (playState == NO) {
            [self pause];
        }
    }];
}
- (void)updateVideoLayerLayout{
    _playerLayer.frame = _videoPreview.layer.bounds;
}

- (void)play{
    if (_avplayer) {
        [_avplayer play];
        _isPlaying = YES;
        __weak typeof(self) weakSelf = self;
        _progressTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(videoLoader:currentPlayProgress:)]) {
                CMTime time = self->_avplayer.currentItem.currentTime;
                [weakSelf.delegate videoLoader:weakSelf currentPlayProgress:time.value/time.timescale];
            }
        }];
        if (_delegate && [_delegate respondsToSelector:@selector(videoLoaderStartPlayback:)]) {
            [_delegate videoLoaderStartPlayback:self];
        }
    }
}

- (void)pause{
    if (_avplayer) {
        [_avplayer pause];
        [_progressTimer invalidate];
        _progressTimer = nil;
        _isPlaying = NO;
    }
}

- (void)stop{
    if (_avplayer) {
        [_avplayer pause];
        [_avplayer seekToTime:kCMTimeZero];
        [_progressTimer invalidate];
        _progressTimer = nil;
        _isPlaying = NO;
    }
}

- (CGFloat)duration{
    return _avplayer.currentItem.duration.value/_avplayer.currentItem.duration.timescale;
}

#pragma mark - observePlayItemStatus
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:
(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        //取出status的新值
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey]intValue];
        switch (status) {
            case AVPlayerItemStatusReadyToPlay:
                NSLog(@"准好播放了");
                if (self.delegate && [self.delegate respondsToSelector:@selector(videoLoaderSuccessed:)]) {
                    [self.delegate videoLoaderSuccessed:self];
                }
                break;
            default:
                if (self.delegate && [self.delegate respondsToSelector:@selector(videoLoaderFailed:)]) {
                    [self.delegate videoLoaderFailed:self];
                }
                break;
        }
        //移除监听（观察者）
        [object removeObserver:self forKeyPath:@"status"];
    }
    
}

- (void)playbackFinished:(NSNotification*)notification{
    //监听到播放完成后，关闭定时器
    [_progressTimer invalidate];
    _progressTimer = nil;
    _isPlaying = NO;
    if (_delegate && [_delegate respondsToSelector:@selector(videoLoaderPlaybackFinished:)]) {
        [_delegate videoLoaderPlaybackFinished:self];
    }
}
@end
