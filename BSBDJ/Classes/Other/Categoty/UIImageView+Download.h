//
//  UIImageView+Download.h
//  BSBDJ
//
//  Created by lvdesheng on 16/3/3.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Download)

/**
 *  判断下载图片的网路环境和图片大小
 *
 *  @param largeImageUrl 大图
 *  @param smallImageUrl 小图
 *  @param placeholder   占位图
 */
- (void)LV_setLargeImageUrl:(NSString *)largeImageUrl smallImageUrl:(NSString *)smallImageUrl placeholder:(UIImage *)placeholder;

/**
 *  下载图片并且裁剪成圆形
 */
- (void)LV_setHeaderImage:(NSString *)url;


@end
