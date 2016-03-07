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
#import "LVSeeBigPictureController.h"

@interface LVTopicPictureView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigPictureBTN;

@end

@implementation LVTopicPictureView

//初始化
- (void)awakeFromNib
{
    self.imageView.userInteractionEnabled = YES;
    
    //给图片添加手势从而有监听手势
    
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPicture)]];
}

#pragma mark - 手势点击
- (void)seeBigPicture
{
    LVSeeBigPictureController *SeeBigPictureController = [[LVSeeBigPictureController alloc]init];
    
    SeeBigPictureController.topic = self.topic;
    //因为要用modal出来的控制器 所以要用一个控制器来modal---一般用keyWindow的根控制器
    UIViewController *rootVC =[UIApplication sharedApplication].keyWindow.rootViewController;
    
    [rootVC presentViewController:SeeBigPictureController animated:YES completion:nil];
  
}


- (void)setTopic:(LVTopic *)topic
{
    _topic = topic;
    
    [self.imageView LV_setLargeImageUrl:topic.image1 smallImageUrl:topic.image0 placeholder:nil];
    
    self.gifView.hidden = !topic.is_gif;
    
    if (topic.isBigPicture)//长图
    {
        self.seeBigPictureBTN.hidden = NO;
        self.imageView.contentMode = UIViewContentModeTop;
        self.imageView.clipsToBounds = YES;
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.image1] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            // 目标图片大小
            CGFloat imageW = LVScreenW - 2 * LVMargin;
            CGFloat imageH = imageW * topic.height / topic.width;
            
            // 开启上下文
            UIGraphicsBeginImageContext(CGSizeMake(imageW, imageH));
            
            // 绘制图片到矩形框
            [image drawInRect:CGRectMake(0, 0, imageW, imageH)];
            
            // 获得图片
            self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            
            // 关闭上下文
            UIGraphicsEndImageContext();
        }];
        
        
        
    }else//非长图
    {
        self.seeBigPictureBTN.hidden = YES;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.imageView.clipsToBounds = NO;
        
    }
}

@end
