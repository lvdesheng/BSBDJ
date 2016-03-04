//
//  UIImage+XMG.m
//  小码哥彩票
//
//  Created by xiaomage on 16/1/4.
//  Copyright © 2016年 xiaomage. All rights reserved.
//

#import "UIImage+XMG.h"

@implementation UIImage (XMG)
+ (UIImage *)imageWithRenderingName:(NSString *)name{
    UIImage *image =  [UIImage imageNamed:name];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}
+ (UIImage *)stretchableImageWithName:(NSString *)name{
    UIImage *image = [UIImage imageNamed:name];
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5f topCapHeight:image.size.height * 0.5f];
    return image;
}


//self - > 圆形图片
- (instancetype)LV_circelImage
{
    //1.开启图形上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    
    //2.描述裁剪区域
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    //设置裁剪区域
    [clipPath addClip];
    
    //画图片
    [self drawAtPoint:CGPointZero];
    //从上下文取出图片
    UIImage *circleImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndImageContext();
    
    return circleImage;
    
}

+ (instancetype)LV_circleImageName:(NSString *)name
{
    return [[self imageNamed:name] LV_circelImage];
}

@end
