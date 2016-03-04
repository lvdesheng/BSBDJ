//
//  LVFriendTrendController.m
//  BSBDJ
//
//  Created by lvdesheng on 16/2/18.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

#import "LVFriendTrendController.h"
#import "LVLoginViewController.h"

@interface LVFriendTrendController ()

@end

@implementation LVFriendTrendController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavigationBar];
    
    
}

#pragma mark - 点击注册界面调用
- (IBAction)loginBtnClick:(id)sender {
    // 进入登录注册界面
    LVLoginViewController *loginVC = [[LVLoginViewController alloc]initWithNibName:@"LVLoginViewController" bundle:nil];
    // modal
    [self presentViewController:loginVC animated:YES completion:nil];
    
}

#pragma mark - 设置导航条内容
- (void)setNavigationBar
{
    //设置左边图标
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"friendsRecommentIcon"] highImage:[UIImage imageNamed:@"friendsRecommentIcon-click"] addTarget:nil action:nil];
    
    //设置中间标题
    
    self.navigationItem.title = @"我的关注";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
