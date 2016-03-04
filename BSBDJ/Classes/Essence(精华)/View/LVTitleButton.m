//
//  LVTitleButton.m
//  BSBDJ
//
//  Created by lvdesheng on 16/2/25.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

#import "LVTitleButton.h"

@implementation LVTitleButton

/*
 1.initializer : 构造方法(构造器)
 
 2.Designated initializer : 指定构造方法
 1> 带有NS_DESIGNATED_INITIALIZER的构造方法就是指定构造方法
 2> 如果子类重写了指定构造方法，那么必须用super调用父类的指定构造方法
 
 3.【Designated initializer】 missing a 'super' call to a 【designated initializer】 of 【the super class】
 指定构造方法里面缺少super去调用父类的指定构造方法
 */

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    }
    return self;
}


/**
 *  重写这个方法的目的:去除高亮状态下的任何操作
 */

- (void)setHighlighted:(BOOL)highlighted{}
@end
