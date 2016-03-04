//
//  LVPictureTableViewController.m
//  BSBDJ
//
//  Created by lvdesheng on 16/2/25.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

#import "LVPictureTableViewController.h"

@interface LVPictureTableViewController ()

@end

@implementation LVPictureTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = LVRandomColor;
    
    //设置让tableView的内边距,让他具有穿透效果
    self.tableView.contentInset = UIEdgeInsetsMake(LVNavBarMaxY + LVTitlesViewH, 0, LVTabBarH, 0);
    
    //让滚动条的初始滚动位置为内容相同
    self.tableView.scrollIndicatorInsets =UIEdgeInsetsMake(LVNavBarMaxY + LVTitlesViewH, 0, LVTabBarH, 0);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidReapetClick) name:LVTabBarButtonDidRepeatClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleButtonDidReapetClick) name:LVTitleButtonDidRepeatClickNotification object:nil];
    
}

#pragma mark - 监听点击
- (void)titleButtonDidReapetClick
{
    [self tabBarButtonDidReapetClick];
}

- (void)tabBarButtonDidReapetClick
{
    //如果当前控制器的view不在window上,就直接返回
    if (self.tableView.window == nil)return;
    //如果当前控制器的view没有跟window重叠
    if (self.tableView.scrollsToTop == NO) return;
    
    LVLog(@"%@ - 刷新数据",self.class);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = self.tableView.backgroundColor;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %zd", self.class, indexPath.row];
    
    return cell;
}
@end