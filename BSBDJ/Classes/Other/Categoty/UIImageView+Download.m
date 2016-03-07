//
//  UIImageView+Download.m
//  BSBDJ
//
//  Created by lvdesheng on 16/3/3.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

#import "UIImageView+Download.h"
#import "AFNetworking.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (Download)


- (void)LV_setLargeImageUrl:(NSString *)largeImageUrl smallImageUrl:(NSString *)smallImageUrl placeholder:(UIImage *)placeholder
{
    //真机调试才有效
    UIImage *largeImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:largeImageUrl];
    if (largeImage) {
        self.image = largeImage;
    } else {
        AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
        if (mgr.isReachableViaWiFi) { // WIFI
            [self sd_setImageWithURL:[NSURL URLWithString:largeImageUrl] placeholderImage:placeholder];
        } else if (mgr.isReachableViaWWAN) { // 手机自带网络
            [self sd_setImageWithURL:[NSURL URLWithString:smallImageUrl] placeholderImage:placeholder];
        } else { // 没有网络
            self.image = placeholder; // 或者显示占位图片
        }
    }

    
}
/**
 *  下载图片并且裁剪成圆形
 */
- (void)LV_setHeaderImage:(NSString *)url
{
    
    UIImage *placeholder = [UIImage LV_circleImageName:@"defaultUserIcon"];
    
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image == nil) return ;
        self.image = [image LV_circelImage];
    }];
}

@end
