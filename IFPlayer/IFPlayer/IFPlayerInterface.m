//
//  IFPlayerInterface.m
//  IFPlayer
//
//  Created by Xuqigang on 2018/9/10.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//

#import "IFPlayerInterface.h"
@interface IFPlayerInterface ()
{
    UIView *_containView; //非全屏时IFPlayerInterface 的父视图
    UIWindow *_window;    //全屏时，IFPlayerInterface的父视图
}
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@end
@implementation IFPlayerInterface

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self.slider addTarget:self action:@selector(avSliderAction:) forControlEvents:
     UIControlEventTouchUpInside|UIControlEventTouchCancel|UIControlEventTouchUpOutside];
    // Do any additional setup after loading the view from its nib.
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSArray<CALayer*> *subLayers = self.contentView.layer.sublayers;
    [subLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CALayer *superLayer = [obj superlayer];
        if (superLayer) {
            obj.frame = superLayer.bounds;
        }
    }];
}
- (void)updateCurrentTime:(NSString *)text{
    self.currentTimeLabel.text = text;
    self.slider.value = [text floatValue];
}

- (void)updateFrameWithSuperView{
    UIView *view = [self superview];
    self.frame = view.bounds;
}
- (void)setFullScreen:(BOOL)fullScreen{
    
    if (_fullScreen == NO && fullScreen) {
        _fullScreen = fullScreen;
        [self removeFromSuperview];
        //注意要隐藏状态栏， 需要再plist文件里面设置一下 View controller-based status bar appearance为NO
        UIApplication.sharedApplication.statusBarHidden = YES;
        _window = UIApplication.sharedApplication.delegate.window;
        [_window addSubview:self];
        [UIView animateWithDuration:0.35 animations:^{
            CGAffineTransform transform = CGAffineTransformMakeRotation(90 * M_PI/180.0);
            [self setTransform:transform];
            [self updateFrameWithSuperView];
        }];
    }else if (_fullScreen == YES && fullScreen == NO && _containView){
        _fullScreen = fullScreen;
        [self removeFromSuperview];
        [_containView addSubview:self];
        UIApplication.sharedApplication.statusBarHidden = NO;
        _window = nil;
        [UIView animateWithDuration:0.3 animations:^{
            CGAffineTransform transform = CGAffineTransformIdentity;
            [self setTransform:transform];
            [self updateFrameWithSuperView];
        }];
    }
}
- (void)showInView:(UIView*)view{
    _containView = view;
    [_containView addSubview:self];
    self.frame = _containView.bounds;
}
- (void)setIsPlaying:(BOOL)isPlaying{
    _isPlaying = isPlaying;
    self.playButton.selected = isPlaying;
}
- (void)stop{
    self.isPlaying = NO;
    self.slider.value = 0;
    [self updateCurrentTime:@"00:00"];
}
- (void)setupDuration:(NSString*)duration{
    self.slider.maximumValue = [duration floatValue];
    self.durationLabel.text = duration;
}

- (IBAction)playButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerInterfaceDidPlayOrStop:)]) {
        [self.delegate playerInterfaceDidPlayOrStop:self];
    }
}

- (IBAction)fullScreenButtonClicked:(UIButton *)sender {
    self.fullScreen = YES;
}
- (IBAction)cancleButtonClicked:(UIButton *)sender {
    self.fullScreen = NO;
}

- (void)avSliderAction:(UISlider*)slider{
    //slider的value值为视频的时间
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerInterface:videoProgressDidChanged:)]) {
        [self.delegate playerInterface:self videoProgressDidChanged:slider.value];
    }
}

- (void)rotateView{
    
    
}

@end
