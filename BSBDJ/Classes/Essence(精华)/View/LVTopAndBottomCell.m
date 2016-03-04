//
//  LVTopAndBottomCell.m
//  BSBDJ
//
//  Created by lvdesheng on 16/2/29.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//  test

#import "LVTopAndBottomCell.h"
#import "UIImageView+WebCache.h"
#import "LVTopic.h"
#import "LVTopicPictureView.h"
#import "LVTopicVideoView.h"
#import "LVTopicVoiceView.h"


@interface LVTopAndBottomCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageview;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passTimelabel;
@property (weak, nonatomic) IBOutlet UILabel *text_label;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
/**
 *  最热评论整体
 */
@property (weak, nonatomic) IBOutlet UIView *topcmtView;
/**
 *  最热评论内容
 */
@property (weak, nonatomic) IBOutlet UILabel *topcmtLabel;


    /******************中间控件***************************/
/**图片控件*/
@property (nonatomic, weak)  LVTopicPictureView *pictureView;
/**声音控件*/
@property (nonatomic, weak)  LVTopicVoiceView *voiceView;
/**视频控件*/
@property (nonatomic, weak)  LVTopicVideoView *videoView;

@end

@implementation LVTopAndBottomCell

#pragma mark - 懒加载
- (LVTopicPictureView *)pictureView
{
    if (!_pictureView) {
        
        LVTopicPictureView *pictureView = [LVTopicPictureView viewForXib];

        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}
- (LVTopicVoiceView *)voiceView
{
    if (!_voiceView) {
        
        LVTopicVoiceView *voiceView = [LVTopicVoiceView viewForXib];
        
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}
- (LVTopicVideoView *)videoView
{
    if (!_videoView) {
        
        LVTopicVideoView *videoView = [LVTopicVideoView viewForXib];
        
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}


#pragma mark - 初始化
- (void)awakeFromNib
{
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setTopic:(LVTopic *)topic
{
    _topic = topic;
    
    [self.profileImageview LV_setHeaderImage:topic.profile_image];
    self.nameLabel.text = topic.name;
    self.passTimelabel.text = topic.passtime;
    self.text_label.text = topic.text;

    
    //设置底部工具条按钮文字
    [self setupButton:self.dingButton number:topic.ding placeholder:@"顶"];
    [self setupButton:self.caiButton number:topic.cai placeholder:@"踩"];
    [self setupButton:self.repostButton number:topic.repost placeholder:@"分享"];
    [self setupButton:self.commentButton number:topic.comment placeholder:@"评论"];
    
    //设置中间内容
    
    if (topic.type == LVTopicTypePicture)
    {
        self.pictureView.hidden = NO;
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
        self.pictureView.topic = topic;
    }else if (topic.type == LVTopicTypeVideo)
    {
        self.pictureView.hidden = YES;
        self.videoView.hidden = NO;
        self.voiceView.hidden = YES;
        self.videoView.topic = topic;
    
    }else if (topic.type == LVTopicTypeVoice)
    {
        self.pictureView.hidden = YES;
        self.videoView.hidden = YES;
        self.voiceView.hidden = NO;
        self.voiceView.topic = topic;
    
    }else if (topic.type == LVTopicTypeWord)
    {
        self.pictureView.hidden = YES;
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
    }
    
    //最热评论
    if (topic.top_cmt.count){//有评论
        self.topcmtView.hidden = NO;
        
        NSDictionary *dict = topic.top_cmt.firstObject;
        
        NSString *content = dict[@"content"];
        
        if (content.length == 0){//语音评论
            content = @"[语音评论]";
        }
        
        NSString *username = dict[@"user"][@"username"];
        self.topcmtLabel.text = [ NSString stringWithFormat:@"%@ : %@",username,content];
    }else{
        self.topcmtView.hidden = YES;
    }
    

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.topic.type == LVTopicTypePicture)
    {
        self.pictureView.frame = self.topic.mindlleFrame;

    }else if (self.topic.type == LVTopicTypeVideo)
    {
        self.videoView.frame = self.topic.mindlleFrame;
        
    }else if (self.topic.type == LVTopicTypeVoice)
    {
        self.voiceView.frame = self.topic.mindlleFrame;
        
    }

    
}


- (void)setupButton:(UIButton *)button number:(NSUInteger )number placeholder:(NSString *)placeholder
{
    if (number >= 10000)
    {
        [button setTitle:[NSString stringWithFormat:@"%.1f万", number/10000.0] forState:UIControlStateNormal];
    }else if (number > 0)
    {
        [button setTitle:[NSString stringWithFormat:@"%zd", number] forState:UIControlStateNormal];
    }else
    {
        [button setTitle:placeholder forState:UIControlStateNormal];
    }
    
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height -= LVMargin;
    
//    frame.size.width -= 2 *LVMargin;
//    frame.origin.x += LVMargin;
    
    [super setFrame:frame];
}


@end
