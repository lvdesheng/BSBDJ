//
//  LVFastLoginButton.m
//  BSBDJ
//
//  Created by lvdesheng on 16/2/23.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

#import "LVFastLoginButton.h"

@implementation LVFastLoginButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //设置imageView
    self.imageView.y = 0;
    self.imageView.centerX = self.width * 0.5;
    
    // 设置label
    // 计算label宽度 => 重新给label宽度赋值
    // 让label自适应
    
    [self.titleLabel sizeToFit];
    
    self.titleLabel.y = self.height - self.titleLabel.height;
    self.titleLabel.centerX = self.width * 0.5;
    
    
    
}
@end
