//
//  AppDelegate.m
//  BSBDJ
//
//  Created by lvdesheng on 16/2/18.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

#import "AppDelegate.h"
#import "LVTabBarController.h"
#import "LVAdViewController.h"
#import "AFNetworkReachabilityManager.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


#pragma mark - 监听点击
/**
 *  AppDelegate的这个方法能够监听到状态栏的点击
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //除开状态栏以外的区域点击直接返回
    UITouch *touch = touches.anyObject;
    
    //nil 参数代表整个window的区域;
    CGPoint point = [touch locationInView:nil];
    
    if (point.y > 20) return;
}



// 程序启动完成 就会调用

static UIWindow *topWindow_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //1.创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //2.设置窗口根控制器-->tabBar
    UITabBarController *tabBarVc = [[LVTabBarController alloc]init];
    // 创建广告控制器
    
//    LVAdViewController *adVc = [[LVAdViewController alloc]init];
    // init => initWithNibName 1.首先判断有没有指定nibName 2.判断下有没有跟控制器类名同名的xib
    
    
    self.window.rootViewController = tabBarVc;
    
    //3.显示窗口
    [self.window makeKeyAndVisible];
    
    //4.开始监控网络环境
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma  接收内存警告的时候调用
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{

}

@end
