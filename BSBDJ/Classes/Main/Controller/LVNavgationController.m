//
//  LVNavgationController.m
//  BSBDJ
//
//  Created by lvdesheng on 16/2/19.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

#import "LVNavgationController.h"

@interface LVNavgationController () <UIGestureRecognizerDelegate>

@end

@implementation LVNavgationController
// 自定义控制器:管理自己事情
// 这样做有什么好处?快速定位到对应类处理事情
+ (void)load
{
    // 获取导航条
    UINavigationBar *navbar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    // 设置导航条(我,关注)标题字体,由导航条决定
    // 总结:导航条标题字体,必须在显示之前设置.
    
    NSMutableDictionary *barTitleAtt = [NSMutableDictionary dictionary];
    
    barTitleAtt[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    
    
    [navbar setTitleTextAttributes:barTitleAtt];
    
    // 设置导航条背景图片
    
    [navbar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    
}


/*
    UIScreenEdgePanGestureRecognizer:边缘滑动手势
 
 <UIScreenEdgePanGestureRecognizer: 0x7f9141752120; state = Possible; delaysTouchesBegan = YES; view = <UILayoutContainerView 0x7f9143146b00>; target= <(action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x7f9141724940>)>>
 
    target=<_UINavigationInteractiveTransition 0x7f9141724940>)>>
 
    action=handleNavigationTransition:
 
 手势代理类型: <_UINavigationInteractiveTransition: 0x7fc92b7d90f0>
 */


// 重写系统底层方法

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 导航控制器自带滑动返回功能,iOS7
    // 只有非根控制才需要设置返回按钮
    if (self.childViewControllers.count > 0)
    {
        
        
        viewController.hidesBottomBarWhenPushed = YES;
        // 设置返回按钮,把系统的返回按钮覆盖,滑动返回功能就没有了
        // 恢复滑动返回功能 => 为什么滑动返回功能没有? 1.有个手势在处理,可能把手势清空 ×
        
        
        
        // 2.手势代理做了事情,导致手势失效,从而滑动返回功能没有
        
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithImage:[UIImage imageNamed:@"navigationButtonReturn"] highImage:[UIImage imageNamed:@"navigationButtonReturnClick"] addTarget:self action:@selector(back) title:@"返回"];
    }
    
   // 才是真正在执行跳转
    [super pushViewController:viewController animated:animated];
}

#pragma mark - 返回键点击
- (void)back
{
    [self popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 假死状态:程序在运行,但是界面操作不了
    
    // 全屏滑动:为什么我们只能边缘滑动
    // 搞一个Pan替换调系统边缘滑动手势
    self.interactivePopGestureRecognizer.enabled = NO;
    // 全屏手势,滑动返回功能 =>
    
   id target =  self.interactivePopGestureRecognizer.delegate ;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    
    [self.view addGestureRecognizer:pan];
    // 假死状态:程序在运行,但是界面操作不了
    pan.delegate = self;
}


#pragma mark -UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
     // 只有非根控制器才需要滑动返回功能
    return self.childViewControllers.count > 1;
}


@end
