//
//  LVRefreshHearder.m
//  BSBDJ
//
//  Created by lvdesheng on 16/3/7.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

#import "LVRefreshHearder.h"

@interface LVRefreshHearder ()


@property (nonatomic, weak)  UIImageView *logo;

@end

@implementation LVRefreshHearder

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //自动切换透明度
        self.automaticallyChangeAlpha = YES;
        //隐藏时间
        self.lastUpdatedTimeLabel.hidden = YES;
        //修改状态文字
        self.stateLabel.textColor = [UIColor redColor];
        //设置文字状态
        [self setTitle:@"赶紧下拉刷新吧" forState:MJRefreshStateIdle];
        [self setTitle:@"松开🐴上可以刷新" forState:MJRefreshStatePulling];
        [self setTitle:@"姐正在帮你刷新..." forState:MJRefreshStateRefreshing];
        
        UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
        [self addSubview:logo];
        self.logo = logo;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.logo.center = CGPointMake(self.width * 0.5, 0);
    self.logo.y = - self.logo.height;
}

@end
