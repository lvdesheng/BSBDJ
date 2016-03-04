//
//  LVSettingTableController.m
//  BSBDJ
//
//  Created by lvdesheng on 16/2/19.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

#import "LVSettingTableController.h"
#import "UIImageView+WebCache.h"
#import "XMGCacheManager.h"
#import "SVProgressHUD.h"


#define XMGCachePath (NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0])

@interface LVSettingTableController ()
@property (nonatomic, assign) NSInteger totalSize;
@end

@implementation LVSettingTableController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置界面的标题
    self.navigationItem.title = @"设置";

    //jump
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"jump" style:UIBarButtonItemStylePlain target:self action:@selector(jump)];
 
    [SVProgressHUD showWithStatus:@"正在加载"];
    
    [XMGCacheManager getCacheSizeWithDirectoryPath:XMGCachePath completion:^(NSInteger totalSize) {
        
        [SVProgressHUD dismiss];
        
        self.totalSize = totalSize;
        
        [self.tableView reloadData];
    }];
}

//转跳
- (void)jump
{
    UIViewController *Vc = [[UIViewController alloc] init];
    Vc.view.backgroundColor = [UIColor redColor];
    
    [self.navigationController pushViewController:Vc animated:YES];
    
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    // 获取cache缓存尺寸
    cell.textLabel.text = [self cacheStr];


    
    return cell;
}

// 获取缓存字符串
- (NSString *)cacheStr
{
    // 指定文件夹,获取这个文件夹尺寸,文件夹非常大,计算很久,会卡死界面
    NSInteger size =  _totalSize;
    
    NSString *cacheStr = @"清除缓存";

    if (size > 1000 * 1000) { // MB
        CGFloat sizeMB = size / (1000 * 1000);
        cacheStr = [NSString stringWithFormat:@"%@(%.1fMB)",cacheStr,sizeMB];
    } else if (size > 1000){ // KB
        CGFloat sizeKB = size / 1000;
        cacheStr = [NSString stringWithFormat:@"%@(%.1fKB)",cacheStr,sizeKB];
    } else if (size > 0) {
        cacheStr = [NSString stringWithFormat:@"%@(%ldB)",cacheStr,size];
    }
    
    return  [cacheStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
}




// 点击cell就会调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 清除缓存:删除cache文件夹中所有文件
    // 快速删除文件夹
    [XMGCacheManager removeDirectoryPath:XMGCachePath];
    
    self.totalSize = 0;
    
    [self.tableView reloadData];
    
    
}
@end
