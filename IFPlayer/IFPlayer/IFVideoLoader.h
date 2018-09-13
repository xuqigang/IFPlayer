//
//  IFVideoLoader.h
//  IFPlayer
//
//  Created by Xuqigang on 2018/9/10.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class IFVideoLoader;
@protocol IFVideoLoaderDelegate <NSObject>



- (void)videoLoaderSuccessed:(IFVideoLoader*)videoLoader;
- (void)videoLoaderFailed:(IFVideoLoader*)videoLoader;
- (void)videoLoaderStartPlayback:(IFVideoLoader*)videoLoader;
- (void)videoLoaderPlaybackFinished:(IFVideoLoader*)videoLoader;
- (void)videoLoader:(IFVideoLoader*)videoLoader currentPlayProgress:(CGFloat)seconds;

@end

@interface IFVideoLoader : NSObject

@property (nonatomic, weak) id<IFVideoLoaderDelegate> delegate;


/**
 返回全局是否有播放器正在播放视频

 @return NO表示无 YES表示有
 */
+ (BOOL)isPlaying;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign,readonly) BOOL isPlaying;
/**
 创建播放器
 
 @return 返回播放器实例
 */
+ (instancetype)defaultPlayer;

/**
 加载视频资源
 
 @param url 本地和网络URL
 */
- (void)loadVideoUrl:(NSURL*)url;

/**
 添加视频预览View
 
 @param view 视频预览view
 */
- (void)addVideoPreview:(UIView*)view;

/**
 跳跃到指定时刻

 @param time 秒
 @param completionHandler 快进完成后的回调
 */
- (void)seekToTime:(CGFloat)time completionHandler:(void (^)(BOOL finished))completionHandler;
///**
// 更新视频预览Layer布局
// */
//- (void)updateVideoLayerLayout;

/**
 播放视频
 */
- (void)play;

/**
 暂停视频
 */
- (void)pause;

/**
 停止
 */
- (void)stop;

@end
