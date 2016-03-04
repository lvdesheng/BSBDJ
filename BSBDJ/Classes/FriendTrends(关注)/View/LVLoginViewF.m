//
//  LVLoginViewF.m
//  BSBDJ
//
//  Created by lvdesheng on 16/2/22.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

#import "LVLoginViewF.h"

@interface LVLoginViewF ()

@property (weak, nonatomic) IBOutlet UIButton *loginBTN;

@end

@implementation LVLoginViewF

// 把对象所有在xib中属性全部加载完
- (void)awakeFromNib
{
    UIImage *image = self.loginBTN.currentBackgroundImage;
    image =  [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    [self.loginBTN setBackgroundImage:image forState:UIControlStateNormal];
}

+ (instancetype)LoginViewF
{
    return [[NSBundle mainBundle] loadNibNamed:@"LVLoginViewF" owner:nil options:nil][0];
}

+ (instancetype)registerFeildView
{
    return [[NSBundle mainBundle] loadNibNamed:@"LVLoginViewF" owner:nil options:nil][1];
}

@end
