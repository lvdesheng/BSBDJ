//
//  LVTabBar.m
//  BSBDJ
//
//  Created by lvdesheng on 16/2/19.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

#import "LVTabBar.h"

@interface LVTabBar ()


@property (nonatomic, weak)  UIButton *pluseButton;

/**记录上一次被点击的tag*/
@property (nonatomic, assign) NSInteger previousClickedTabBarButtonTag;

@end

@implementation LVTabBar

//懒加载
- (UIButton *)pluseButton
{
    if (!_pluseButton) {
        
        UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [plusButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        
        [plusButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        
        //根据按钮自适应
        
        [plusButton sizeToFit];
        
        _pluseButton = plusButton;
        
        [self addSubview:plusButton];
        
    }
    return _pluseButton;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger count = self.items.count + 1;
    
    CGFloat btnW = self.width / count;
    CGFloat btnH = self.height;
    
    CGFloat btnX = 0;
    
    // 布局tabBarButton
    NSInteger i = 0;
    for (UIControl *tabBarButton in self.subviews) {
        
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]){
            
            if (i == 2)
            {
                i = i + 1;
            }
            
            btnX = i * btnW;
            
            tabBarButton.frame = CGRectMake(btnX, 0, btnW, btnH);
            tabBarButton.tag = i;
            
            i++;
            
            //监听tabBarButton的点击
            [tabBarButton addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    
    // 设置加号按钮center
    self.pluseButton.center = CGPointMake(self.width * 0.5, self.height * 0.5);
    
}

#pragma mark - 监听按钮点击
- (void)tabBarButtonClick:(UIControl *)tabBatButton
{
    if (self.previousClickedTabBarButtonTag == tabBatButton.tag)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:LVTabBarButtonDidRepeatClickNotification object:nil];
    }
    
    //记录点击
    self.previousClickedTabBarButtonTag = tabBatButton.tag;
    
    
}

@end
