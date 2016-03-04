//
//  LVTopicVoiceView.m
//  BSBDJ
//
//  Created by lvdesheng on 16/2/29.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

#import "LVTopicVoiceView.h"
#import "UIImageView+WebCache.h"
#import "LVTopic.h"

@interface LVTopicVoiceView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *voicetimeLabel;

@end

@implementation LVTopicVoiceView

- (void)setTopic:(LVTopic *)topic
{
    _topic = topic;
    
    [self.imageView LV_setLargeImageUrl:topic.image1 smallImageUrl:topic.image0 placeholder:nil];
    
    if (topic.playcount>= 10000)
    {
        self.playcountLabel.text = [NSString stringWithFormat:@"%.1f万播放", topic.playcount /10000.0];
    }else
    {
        self.playcountLabel.text = [NSString stringWithFormat:@"%zd播放", topic.playcount];
    }
    
    // %02zd : 占据2位，多余的空位用0来填补
    NSInteger minutes =  topic.voicetime / 60;
    NSInteger secends = topic.voicetime % 60;
    self.voicetimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",minutes,secends];

}

@end
