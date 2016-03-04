//
//  LVNewViewController.m
//  BSBDJ
//
//  Created by lvdesheng on 16/2/18.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

#import "LVNewViewController.h"
#import "LVsubTagTableController.h"


@interface LVNewViewController ()

@end

@implementation LVNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setNavigationBar];
    

    
}
#pragma mark - 设置导航条内容
- (void)setNavigationBar
{
    //设置左边的图标
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"MainTagSubIcon"] highImage:[UIImage imageNamed:@"MainTagSubIconClick"] addTarget:self action:@selector(subTag)];
    
    //设置中间的图片
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
   
}

#pragma mark - 点击订阅按钮
- (void)subTag
{
    LVsubTagTableController *subTagVC = [[LVsubTagTableController alloc]init];
    
    [self.navigationController pushViewController:subTagVC animated:YES];
}
@end
