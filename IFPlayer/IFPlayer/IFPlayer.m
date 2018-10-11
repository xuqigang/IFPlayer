//
//  IFPlayer.m
//  IFPlayer
//
//  Created by Xuqigang on 2018/9/10.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//

#import "IFPlayer.h"
#import "IFVideoLoader.h"
#import "IFPlayerInterface.h"
#import <AVFoundation/AVFoundation.h>
@interface IFPlayer () <IFPlayerInterfaceDelegate,IFVideoLoaderDelegate>
{
    IFVideoLoader * _videoLoader;
    UIView *_videoPreview;
    IFPlayerInterface * _playerInterface;
    
}
@property (nonatomic, strong) IFPlayerInterface *playerInterface;
@end

@implementation IFPlayer

+ (instancetype)defaultPlayer{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; //Get the notification centre for the app
        [nc addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        self.playerInterface.delegate = self;
    }
    return self;
}
- (void)loadVideoUrl:(NSURL*)url{
    _videoLoader = [IFVideoLoader defaultPlayer];
    _videoLoader.delegate = self;
    [_videoLoader loadVideoUrl:url];
    [_videoLoader addVideoPreview:self.playerInterface.contentView];
}

- (void)addVideoPreview:(UIView*)view{
    [self.playerInterface showInView:view];
}

- (void)updatePreview{
    UIView *view = [self.playerInterface superview];
    self.playerInterface.frame = view.bounds;
}

- (void)play{
    [_videoLoader play];
    self.playerInterface.isPlaying = YES;
}

- (void)stop{
    [_videoLoader stop];
    [self.playerInterface stop];
}
- (void)invalidate{
    [_videoLoader stop];
    [[NSNotificationCenter defaultCenter] removeObserver:_videoLoader];
    [self.playerInterface removeFromSuperview];
    [[self.playerInterface.contentView.layer sublayers] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    self.playerInterface = nil;
    _videoLoader = nil;
    self.delegate = nil;
}
#pragma mark - init
- (IFPlayerInterface*)playerInterface{
    if (!_playerInterface) {
        _playerInterface = [[[NSBundle mainBundle] loadNibNamed:@"IFPlayerInterface" owner:self options:nil] lastObject];
    }
    return _playerInterface;
}
#pragma mark -IFPlayerInterfaceDelegate
- (void)playerInterface:(IFPlayerInterface*)playerInterface videoProgressDidChanged:(CGFloat)seconds{
    //从指定时间开始播放视频
    [_videoLoader seekToTime:seconds completionHandler:^(BOOL finished) {
        if (finished) {
            [playerInterface updateCurrentTime:[NSString stringWithFormat:@"%.2f",seconds]];
        }
    }];
}

- (void)playerInterfaceDidPlayOrStop:(IFPlayerInterface*)playerInterface{
    if (_videoLoader.isPlaying) {
        [_videoLoader pause];
    } else {
        [_videoLoader play];
        
    }
    
    [playerInterface setIsPlaying:_videoLoader.isPlaying];
    if (_delegate && [_delegate respondsToSelector:@selector(player:playbackState:)]) {
        [_delegate player:self playbackState:_videoLoader.isPlaying];
    }
}

#pragma mark -IFVideoLoaderDelegate

- (void)videoLoaderSuccessed:(IFVideoLoader*)videoLoader{
    [self.playerInterface setupDuration:[NSString stringWithFormat:@"%.2f",videoLoader.duration]];
}
- (void)videoLoaderFailed:(IFVideoLoader*)videoLoader{
    //修改播放界面UI
    self.playerInterface.isPlaying = NO;
}
- (void)videoLoaderPlaybackFinished:(IFVideoLoader*)videoLoader{
    //修改播放界面UI
    self.playerInterface.isPlaying = NO;
    [self.playerInterface updateCurrentTime:[NSString stringWithFormat:@"%.2f",videoLoader.duration]];
}
- (void)videoLoader:(IFVideoLoader*)videoLoader currentPlayProgress:(CGFloat)seconds{
    [self.playerInterface updateCurrentTime:[NSString stringWithFormat:@"%.2f",seconds]];
}
#pragma mark - orientationChanged

//设备方向发生改变后的通知，如果是横屏状态，则进行全屏模式
- (void)orientationChanged:(NSNotification*)notification{
    
    UIDevice *device = [UIDevice currentDevice];
    switch (device.orientation) {
            
        case UIDeviceOrientationLandscapeLeft:
        {
            if ([_videoLoader isPlaying]) {
                self.playerInterface.fullScreen = YES;
            }
            
        }
            NSLog(@"螢幕向左橫置");
            break;
            
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"螢幕向右橫置");
        {
            
            //思路还没想好，暂时先不支持右全屏
//            if ([_videoLoader isPlaying]) {
//                self.playerInterface.fullScreen = YES;
//            }
        }
            break;
    
        case UIDeviceOrientationPortraitUpsideDown:
            self.playerInterface.fullScreen = NO;
            break;
        case UIDeviceOrientationPortrait:
            self.playerInterface.fullScreen = NO;
            break;
        default:
            
            NSLog(@"無法辨識");
            break;
    }
    
    
}
@end
