//
//  VideoCell.h
//  IFPlayer
//
//  Created by Hanxiaojie on 2018/9/11.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"
#import "IFPlayer.h"
@interface VideoCell : UITableViewCell

- (void)setupCell:(VideoModel*)model;

- (void)stopVideo;

@end
