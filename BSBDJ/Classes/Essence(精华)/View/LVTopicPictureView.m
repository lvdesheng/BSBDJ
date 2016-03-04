//
//  LVTopicPictureView.m
//  BSBDJ
//
//  Created by lvdesheng on 16/2/29.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

#import "LVTopicPictureView.h"
#import "LVTopic.h"
#import <UIImageView+WebCache.h>

@interface LVTopicPictureView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigPictureBTN;

@end

@implementation LVTopicPictureView

- (void)setTopic:(LVTopic *)topic
{

    [self.imageView LV_setLargeImageUrl:topic.image1 smallImageUrl:topic.image0 placeholder:nil];
    
    self.gifView.hidden = !topic.is_gif;
    
    if (topic.isBigPicture)//长图
    {
        self.seeBigPictureBTN.hidden = NO;
        self.imageView.contentMode = UIViewContentModeTop;
        self.imageView.clipsToBounds = YES;
    }else//非长图
    {
        self.seeBigPictureBTN.hidden = YES;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.imageView.clipsToBounds = NO;
        
    }
}

@end
