//
//  IFPlayerInterface.h
//  IFPlayer
//
//  Created by Xuqigang on 2018/9/10.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IFPlayerInterface;
@protocol IFPlayerInterfaceDelegate <NSObject>

- (void)playerInterface:(IFPlayerInterface*)playerInterface videoProgressDidChanged:(CGFloat)seconds;
- (void)playerInterfaceDidPlayOrStop:(IFPlayerInterface*)playerInterface;

@end

@interface IFPlayerInterface : UIView

@property (nonatomic, assign) BOOL fullScreen;
@property (weak, nonatomic) id<IFPlayerInterfaceDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, assign) BOOL isPlaying;

- (void)stop;
- (void)showInView:(UIView*)view;
- (void)updateCurrentTime:(NSString *)text;
- (void)setupDuration:(NSString*)duration;

@end
