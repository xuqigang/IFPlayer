//
//  VideoCell.m
//  IFPlayer
//
//  Created by Xuqigang on 2018/9/11.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//

#import "VideoCell.h"

@interface VideoCell () <IFPlayerDelegate>
{
    IFPlayer *_player;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (nonatomic, strong) UIView *videoPreview;
@end
@implementation VideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView addSubview:self.videoPreview];
    // Initialization code
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.videoPreview.frame = CGRectMake(16, 10, self.contentView.frame.size.width - 16 * 2, 180);
    if (_player) {
        [_player updatePreview];
    }
}
- (UIView *)videoPreview{
    if (!_videoPreview) {
        _videoPreview = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _videoPreview;
}
- (void)stopVideo{
    if (_player){
        [_player stop];
    }
}
- (void)setupCell:(VideoModel*)model{
    if (model) {
        //清空之前的所有子view
        
        if (_player){
            [_player invalidate];
            _player = nil;
        }
        [[self.videoPreview subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        _player = [IFPlayer defaultPlayer];
        _player.delegate = self;
        [_player addVideoPreview:self.videoPreview];
        [_player loadVideoUrl:[NSURL URLWithString:model.videoUrl]];
        [_player stop];
        self.titleLabel.text = model.title;
        self.desLabel.text = model.des;
    } else {
        self.titleLabel.text = nil;
        self.desLabel.text = nil;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark IFPlayerDelegate
- (void)player:(IFPlayer*)player playbackState:(BOOL)isPlay{
    if(_delegate && [_delegate respondsToSelector:@selector(videoCell:didVideoStateChanged:)]){
        [_delegate videoCell:self didVideoStateChanged:isPlay];
    }
}

@end
