//
//  IFPlayer.h
//  IFPlayer
//
//  Created by Hanxiaojie on 2018/9/10.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//  说明：该播放器不建议封装成单例

#import <UIKit/UIKit.h>

@interface IFPlayer : NSObject


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
 当外界父视图frame发生变化时，需要及时更新播放器界面UI
 */
- (void)updatePreview;

- (void)play;

- (void)stop;

//释放播放器资源
- (void)invalidate;

@end
