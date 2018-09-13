//
//  VideoCell.h
//  IFPlayer
//
//  Created by Xuqigang on 2018/9/11.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"
#import "IFPlayer.h"
@class VideoCell;

//cell里面的点击事件，强烈建议用代理，不要用block
@protocol VideoCellDelegate <NSObject>

- (void)videoCell:(VideoCell*)videoCell didVideoStateChanged:(BOOL)isPlay;

@end

@interface VideoCell : UITableViewCell

@property (nonatomic, weak) id<VideoCellDelegate> delegate;

- (void)setupCell:(VideoModel*)model;

- (void)stopVideo;

@end
