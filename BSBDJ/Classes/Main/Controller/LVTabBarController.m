
//
//  LVTabBarController.m
//  BSBDJ
//
//  Created by lvdesheng on 16/2/18.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

#import "LVTabBarController.h"
#import "LVEssenceController.h"
#import "LVFriendTrendController.h"
#import "LVMeTableController.h"
#import "LVNewViewController.h"
#import "LVPublishViewController.h"
#import "UIImage+XMG.h"
#import "LVTabBar.h"
#import "LVNavgationController.h"


@interface LVTabBarController ()

@end

@implementation LVTabBarController

#pragma mark - 只会调用一次,类加载内存的时候就会调用
+ (void)load
{
    
    // 自己的事情自己管理,不需要管理其他类事情
    // 获取全局UITabBarItem
    // UIAppearance注意点:
    // 1.谁能使用appearance,只有遵守了<UIAppearance>
    // 2.appearance:获取整个应用程序下所有的东西
    
    // 3.只有属性被UI_APPEARANCE_SELECTOR宏修饰,才能使用UIAppearance统一设置
    // 获取当前类下面所有的UITabBarItem
    UITabBarItem *item =   [UITabBarItem appearanceWhenContainedIn:self, nil];
    
    // 富文本属性:描述文本的字体,颜色,阴影,空心,图文混排
    // 模型都是通过富文本属性设置
    
    NSMutableDictionary *attSel = [NSMutableDictionary dictionary];
    attSel[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    [item setTitleTextAttributes:attSel forState:UIControlStateSelected];
    

    // 正常状态:tabBar按钮字体大小,由正常状态决定
    //更改tabBar字体大小
    NSMutableDictionary *attNor =  [NSMutableDictionary dictionary];
    attNor[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    
    [item setTitleTextAttributes:attNor forState:UIControlStateNormal];

}
// 如何查找插件安装在哪? 1.打开插件工程 2.点击放大镜,搜索plug 3.查看工程文件文件,install Path
#pragma mark - 控制器生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];

    // 2.1 添加所有子控制器
    [self addAllChildViewControllers];
    
    // 2.2 设置对应按钮内容
    [self addAllTabBarButton];
    
    // 2.3 自定义tabBar
    [self setupTabBar];
    
    
    
    // 1.问题:选中图片被渲染 解决:1.直接操作图片 2.通过代码
    // 2.选中文字颜色也不需要渲染 分析:1.按钮由谁决定 tabBarItem
    
    // 3.发布按钮显示不出来,位置也不对,分析:1.有没有文字,图片的位置都固定 2.加号的图片比其他图片大 因此就会超出tabBar 3.不想要超出,让加号的图片垂直居中 => 修改加号按钮位置 => tabBar上按钮位置由系统决定,我们自己不能决定 => 系统的tabBarButton没有提供高亮图片状态,因此做不了实例程序效果 => 加号,应该是普通按钮,高亮状态 => 发布控制器不是tabBarContoller子控制器
    
    // 4.最终方案:调整系统TaBBar上按钮位置,平均分成5等分,在把加号按钮显示在中间就好了
    // 调整系统自带控件的子控件的位置 => 自定义tabBar => 使用tabBar
    // 研究下,系统的tabBarButton什么时候添加到self.tabBar,在viewWillAppear
    
}


#pragma mark - 自定义tabBar
- (void)setupTabBar
{
    LVTabBar *tabBar = [[LVTabBar alloc] init];
    
//    self.tabBar = tabBar;
    
    [self setValue:tabBar forKeyPath:@"tabBar"];
    
//    NSLog(@"%@",self.tabBar);

}

#pragma mark - 添加所有按钮的标题
- (void)addAllTabBarButton
{
    //精华
    UINavigationController *nav1 = self.childViewControllers[0];
    
    nav1.tabBarItem.title = @"精华";
    
    nav1.tabBarItem.selectedImage = [UIImage imageWithRenderingName:@"tabBar_essence_click_icon"];
    
    nav1.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
    
    NSMutableDictionary *attSel = [[NSMutableDictionary alloc] init];
    attSel[NSForegroundColorAttributeName] = [UIColor blackColor];

    //另一种方法
    
//    [attSel setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    
//    [nav1.tabBarItem setTitleTextAttributes:attSel forState:UIControlStateSelected];
    
    
    // 新帖
    UINavigationController *nav2 = self.childViewControllers[1];
    
    nav2.tabBarItem.title = @"新帖";
    
    nav2.tabBarItem.selectedImage = [UIImage imageWithRenderingName:@"tabBar_new_click_icon"];
    
    nav2.tabBarItem.image = [UIImage imageNamed:@"tabBar_me_icon"];

    
    //方法一 ,设置中间button的位置.
//    publishVc.tabBarItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
    
    
    // 关注
    UINavigationController *nav4 = self.childViewControllers[2];
    
    nav4.tabBarItem.title = @"关注";
    
    nav4.tabBarItem.selectedImage = [UIImage imageWithRenderingName:@"tabBar_friendTrends_click_icon"];
    nav4.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_icon"];
    // 我
    UINavigationController *nav5 = self.childViewControllers[3];
    
    nav5.tabBarItem.title = @"我";
    
    nav5.tabBarItem.selectedImage = [UIImage imageWithRenderingName:@"tabBar_me_click_icon"];
    
    nav5.tabBarItem.image = [UIImage imageNamed:@"tabBar_me_icon"];

    
    
}
#pragma mark - 添加所有的子控制器
- (void)addAllChildViewControllers
{
    //2.1添加根控制器
    
    //精华
    LVEssenceController *newVc = [[LVEssenceController alloc]init];

    
    UINavigationController *nav2 = [[LVNavgationController alloc]initWithRootViewController:newVc];
    
    [self addChildViewController:nav2];
    
    //新帖
    LVNewViewController *essenceVc = [[LVNewViewController alloc]init];

    
    UINavigationController *nav1 = [[LVNavgationController alloc]initWithRootViewController:essenceVc];
    
    [self addChildViewController:nav1];

    //关注
    LVFriendTrendController *friendTrendsVc = [[LVFriendTrendController alloc]init];

    
    UINavigationController *nav4 = [[LVNavgationController alloc]initWithRootViewController:friendTrendsVc];
    
    [self addChildViewController:nav4];
    
    //我
    
    
    UIStoryboard *storyboar = [UIStoryboard storyboardWithName:NSStringFromClass([LVMeTableController class]) bundle:nil];
    
    //加载箭头指向的控制器
    LVMeTableController *meVC= [storyboar instantiateInitialViewController];
    
    LVNavgationController *nav5 = [[LVNavgationController alloc] initWithRootViewController:meVC];
    
    [self addChildViewController:nav5];

}





@end
