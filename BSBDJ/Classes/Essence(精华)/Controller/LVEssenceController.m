//
//  LVEssenceController.m
//  BSBDJ
//
//  Created by lvdesheng on 16/2/18.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

/*
 1.参数名是Attributes，参数类型是NSDictionary。一般会有以下规律
 1> iOS7开始
 * 字典的key都来自NSAttributedString.h
 * 字典的key格式都是：NS***AttributeName
 
 2> iOS7之前
 * 字典的key都来自UIStringDrawing.h
 * 字典的key格式都是：UITextAttribute***
 
 
 */

#import "LVEssenceController.h"
#import "LVTitleButton.h"
#import "LVAllViewController.h"
#import "LVVideoViewController.h"
#import "LVVoiceViewController.h"
#import "LVPictureTableViewController.h"
#import "LVWordViewController.h"


@interface LVEssenceController ()<UIScrollViewDelegate>

/**标题栏*/
@property (nonatomic, weak)  UIView *titlesView;

/**被选中的按钮*/
@property (nonatomic, weak)  LVTitleButton *clickedTitlebutton;

/**标题下划线*/
@property (nonatomic, weak)  UIView *underLine;

/**用来显示所有子控制器的view*/
@property (nonatomic, weak)  UIScrollView *scrollView;

@end

@implementation LVEssenceController
#pragma mark -  生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置导航条内容 => navigationItem
    // UIBarButtonItem:决定导航条上按钮的内容
    // UINavigationItem:决定导航条有什么内容
    // UITabBarItem:决定tabBarButton的内容

  
    [self setNavigationBar];
    


    
    
    //添加子控制器
    
    [self setupChildControllers];
    
    
    //创建scrollView
    
    [self setupScrollView];
    
    
    //初始化标题栏
    
    [self setupTitleView];
    
    //默认显示第零个显示器
    [self addChildViewIntoScollView:0];
  

}

/**
 *  添加子控制器
 */
- (void)setupChildControllers
{

    [self addChildViewController:[[LVAllViewController alloc] init]];
    [self addChildViewController:[[LVVideoViewController alloc] init]];
    [self addChildViewController:[[LVVoiceViewController alloc] init]];
    [self addChildViewController:[[LVPictureTableViewController alloc] init]];
    [self addChildViewController:[[LVWordViewController alloc] init]];
    
}


/**
 *  设置scrollView
 */
- (void)setupScrollView
{
    //取消额外的滚动区域
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;

    // 点击状态栏的时候，不需要滚动到顶部
    scrollView.scrollsToTop = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    //取消弹簧效果
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    
    //设置 scrollView的代理 监听滑动
    scrollView.delegate = self;
    
    //添加对应子控制器的View到当前控制器的view中
    
//    for (NSInteger i = 0; i < 5 ; i++) {
//        
//        UIViewController *childVC =  self.childViewControllers[i];
//        
//        [scrollView addSubview:childVC.view];
//        
//        //位置和尺寸
//        
//        childVC.view.x = i * scrollView.width;
//        childVC.view.y = 0;
//        childVC.view.height = scrollView.height;
//    }
    
    //内容大小
    scrollView.contentSize = CGSizeMake(self.childViewControllers.count * scrollView.width, 0);
    
    
    
}

/**
 *  标题栏
 */
- (void)setupTitleView
{
    UIView *titlesView = [[UIView alloc]init];
    titlesView.frame = CGRectMake(0, 64, self.view.width, 35);
    titlesView.backgroundColor = [[UIColor whiteColor]  colorWithAlphaComponent:0.5];
    [self.view addSubview:titlesView];
    
    self.titlesView = titlesView;
    
    
    [self setuptitleButtons];
    
    [self setupUnerLine];
    
}

- (void)setuptitleButtons
{
    //数据
    
    NSArray *titles = @[@"全部", @"视频", @"声音", @"图片", @"段子"];
    
    NSUInteger count = titles.count;
    CGFloat titleButtonWith = self.titlesView.width / 5;
    CGFloat titleButtonHeight = self.titlesView.height;
    for (int i = 0 ; i < count; i++) {
        //创建
        LVTitleButton *titleButton =  [[LVTitleButton alloc] init];
        titleButton.tag = i;
        [titleButton addTarget:self action:@selector(titleBUttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titlesView addSubview:titleButton];
        
        //frame

        CGFloat x = i * titleButtonWith;
        CGFloat y = 0;
        
        titleButton.frame = CGRectMake(x, y, titleButtonWith, titleButtonHeight);
        
        //数据
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

//        titleButton.backgroundColor = XMGRandomColor;

        
    }
}

/**
 *  初始化下划线
 */
- (void)setupUnerLine
{
    //标题按钮
    LVTitleButton *firstTitlelButton = self.titlesView.subviews.firstObject;
    
    //下划线
    
    UIView *underLine = [[UIView alloc] init];
    
    CGFloat underLineW = 70;
    CGFloat underLineH = 2 ;
    CGFloat x = 0;
    CGFloat y = self.titlesView.height - underLineH;
    underLine.frame = CGRectMake(x, y, underLineW, underLineH);
    underLine.backgroundColor = [firstTitlelButton titleColorForState:UIControlStateSelected];
    
    [self.titlesView addSubview:underLine];
    
    self.underLine = underLine;
    
    //默认下划线大小
    [firstTitlelButton.titleLabel  sizeToFit];
    
    //切换按钮状态
    firstTitlelButton.selected = YES;
    self.clickedTitlebutton = firstTitlelButton;
    
    self.underLine.width = firstTitlelButton.titleLabel.width + LVMargin;
    self.underLine.centerX = firstTitlelButton.centerX;
    
}


- (void)setNavigationBar
{
    //设置左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"nav_item_game_icon"] highImage:[UIImage imageNamed:@"nav_item_game_click_icon"] addTarget:self action:@selector(game)];
    
    //设置中间图片
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    //设置右边图片
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"navigationButtonRandom"] highImage:[UIImage imageNamed:@"navigationButtonRandomClick"] addTarget:nil action:nil];

}


#pragma mark - 监听点击事件
/**
 *  点击游戏按钮
 */
- (void)game
{

}

/**
 *  标题按钮被点击了
 */
- (void)titleBUttonClick: (LVTitleButton *)titleButton
{
    //重复点击了某个标题按钮
    if (self.clickedTitlebutton == titleButton)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:LVTitleButtonDidRepeatClickNotification object:nil userInfo:nil];
    }
    
    [self dealTitleButtonClick:titleButton];
}


/**
 *  处理按钮点击时的动作
 *
 */

- (void)dealTitleButtonClick:(LVTitleButton *)titleButton
{

    // 切换按钮状态
    self.clickedTitlebutton.selected = NO;// UIControlStateNormal -> [UIColor darkGrayColor]
    
    titleButton.selected = YES;// UIControlStateSelected -> [UIColor redColor]
    
    self.clickedTitlebutton = titleButton;
    
    NSInteger index = titleButton.tag;
    
    // 下划线
    [UIView animateWithDuration:0.2 animations:^{
        
        self.underLine.width = titleButton.titleLabel.width + LVMargin;
        self.underLine.centerX = titleButton.centerX;
        
        //滚动scrollView
        
        self.scrollView.contentOffset = CGPointMake(index * self.scrollView.width, 0);
    }completion:^(BOOL finished) {
        //添加子控制器的View到ScrollView
        [self addChildViewIntoScollView:index];
    }];
    
    
    
    //处理tableView滚动
    for (NSInteger i = 0; i < self.childViewControllers.count ; i ++) {
        
        UIView *childVCView = self.childViewControllers[i].view;
        if ([childVCView isKindOfClass:[UIScrollView class]])
        {
            UIScrollView *scrollView = (UIScrollView *)childVCView;
            scrollView.scrollsToTop = i;
            
            if (i == index)
            {
                scrollView.scrollsToTop = YES;
            }else
            {
                scrollView.scrollsToTop = NO;
            }
            
        }
    }

}

#pragma mark - 其他方法
- (void)addChildViewIntoScollView: (NSInteger)index
{
    UIViewController *childVC = self.childViewControllers[index];
    [self.scrollView addSubview:childVC.view];
    
    //位置和尺寸
    childVC.view.frame = CGRectMake(index * self.scrollView.width, 0, self.scrollView.width, self.scrollView.height);
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{    //点击对应按钮
    NSInteger index = scrollView.contentOffset.x /scrollView.width;
    LVTitleButton *titleButton = self.titlesView.subviews[index];
    
    [self dealTitleButtonClick:titleButton];
    
}




@end
