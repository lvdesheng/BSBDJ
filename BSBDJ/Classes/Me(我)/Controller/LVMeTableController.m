//
//  LVMeTableController.m
//  BSBDJ
//
//  Created by lvdesheng on 16/2/18.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

#import "LVMeTableController.h"
#import "LVSettingTableController.h"
#import "LVSquareCell.h"
#import <AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "LVSquareItem.h"
#import "LVWebViewController.h"



//间距
static CGFloat margin = 1;
//列数
static NSInteger cols = 4;

#define LVCellWH ((LVScreenW - (cols - 1) * margin ) / cols)
static NSString * const ID = @"LVSquareCell";
/*
 UICollectionView使用步骤:
 1.必须设置布局参数
 2.cell必须注册
 3.自定义cell
 */


@interface LVMeTableController () <UICollectionViewDataSource,UICollectionViewDelegate>

/**模型数组*/
@property (nonatomic, strong) NSMutableArray *squars;

@property (nonatomic, weak)  UICollectionView *collectionView;

@end

@implementation LVMeTableController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置导航条
    [self setNavgationBar];
    
    //设置方块视图
    [self setupFootView];
    
    //请求数据
    
    [self loadData];
    
    // 默认:分组样式的tableView都有组头部间距尾部间距
    
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 10;

     // 顶部间距:cellY
    self.tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);

}



#pragma mark - 处理数据
- (void)resolveData
{
    NSInteger count = self.squars.count;
    
    NSInteger extre = count % cols;
    
    if (extre) //补齐数据
    {
        extre = cols - extre;
        
        for (int i = 0; i < extre; i++) {
            //创建一个空的模型
            LVSquareItem *item = [[LVSquareItem alloc]init];
            
            [self.squars addObject:item];
            
        }
    }
}


#pragma mark - 请求数据
/**
 *  a	true	string	square
 
 c	true	string	topic
 */


- (void)loadData
{
    //创建回话管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    //拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"square";
    parameters[@"c"] = @"topic";
    
    //发送请求
    
    [mgr GET:LVBaseUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        
        [responseObject writeToFile:@"/Users/lvdesheng/Downloads/未命名文件夹/1.plist" atomically:YES];
        
        //字典数组转模型数组
       self.squars =  [LVSquareItem mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
       
        //处理额外方块
        [self resolveData];
        
        //刷新表格
        [self.collectionView reloadData];
        
        // 设置collectionView高度
        // count:5 cols:4 rows
        // 计算rows = (count - 1) / cols + 1
        
        NSInteger rows = (_squars.count - 1) / cols + 1;
        self.collectionView.height = rows * LVCellWH;
        

        
        // 设置tableView滚动范围:tableView滚动范围自己根据自己的内容去计算
        // 1.直接设置tableView滚动范围
        //        self.tableView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.collectionView.frame));
        // 2.重新设置tableView底部视图
        
        self.tableView.tableFooterView = self.collectionView;
       
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        LVLog(@"%@",error);
    }];
    
}

#pragma mark - 设置方块视图
- (void)setupFootView
{
    //创建流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    //*****设置cell 的尺寸*****//

    
    layout.itemSize = CGSizeMake(LVCellWH,LVCellWH);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing  = margin;
    //*********************//
    
    //创建UICollectionView
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 300) collectionViewLayout:layout];
    
    collectionView.backgroundColor = self.tableView.backgroundColor;
    

    _collectionView = collectionView;

    //设置tableView的底部视图
    
    self.tableView.tableFooterView = collectionView;
    //设置数据源
    collectionView.dataSource = self;
    
    // 设置代理
    
    collectionView.delegate = self;
    //注册cell
    
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LVSquareCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
    
    //不需要滚动
    collectionView.scrollEnabled = NO;
    
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LVWebViewController *WebViewController = [[LVWebViewController alloc]init];
    
    LVSquareItem *item = self.squars[indexPath.row];
    
    WebViewController.url = [NSURL URLWithString:item.url];
    
    [self.navigationController pushViewController:WebViewController animated:YES];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return self.squars.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    LVSquareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.item = _squars[indexPath.row];
    
    return cell;
    
}



#pragma mark - 设置导航条内容
- (void)setNavgationBar
{
    //设置按钮
    UIBarButtonItem *settingButton = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-setting-icon"] highImage:[UIImage imageNamed:@"mine-setting-icon-click"] addTarget:self action:@selector(setting)];
    
    //夜间模式按钮
    UIBarButtonItem *nightModeButton = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-moon-icon"] selImage:[UIImage imageNamed:@"mine-moon-icon-click"] addTarget:self action:@selector(moom:)];

    
    self.navigationItem.rightBarButtonItems = @[settingButton,nightModeButton];
    
    //设置中间文字
    
    self.navigationItem.title = @"我的";
}

#pragma mark - 点击月亮时调用
- (void)moom:(UIButton *)button
{
    button.selected = !button.selected;
}
#pragma mark - 点击设置时调用
- (void)setting
{
 
    //拿到setting控制器
    LVSettingTableController *settingVC = [[LVSettingTableController alloc] init];
    
    //取消显示tabBarView
    // 注意:一定要在Push之前设置
    settingVC.hidesBottomBarWhenPushed = YES;
    
    //通过navigationController转跳
    
    [self.navigationController pushViewController:settingVC animated:YES];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
