//
//  LVAllViewController.m
//  BSBDJ
//
//  Created by lvdesheng on 16/2/25.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

#import "LVTopicViewController.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "LVTopic.h"
#import "SVProgressHUD.h"
#import "LVTopAndBottomCell.h"
#import "LVAllViewController.h"
#import "LVVideoViewController.h"
#import "LVVoiceViewController.h"
#import "LVPictureTableViewController.h"
#import "LVWordViewController.h"
#import "MJRefresh.h"
#import "LVRefreshHearder.h"





@interface LVTopicViewController ()

/**所有帖子数据*/
@property (nonatomic, strong) NSMutableArray <LVTopic *> *topics;

/**请求管理者*/
@property (nonatomic, strong) AFHTTPSessionManager *mgr;

/**当需要加载下一页时：需要传入加载上一页时返回值字段“maxtime”中的内容*/
@property (nonatomic, copy) NSString *maxtime;



@end

@implementation LVTopicViewController

static NSString * const LVTopAndBottomCellID = @"LVTopAndBottomCellID";


#pragma mark - 懒加载数据
- (AFHTTPSessionManager *)mgr
{
    if (!_mgr) {
        
        _mgr = [AFHTTPSessionManager manager];
        
    }
    return _mgr;
}


#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LVTopAndBottomCell class]) bundle:nil] forCellReuseIdentifier:LVTopAndBottomCellID];
    
    //    self.tableView.rowHeight = 200;
    self.tableView.estimatedRowHeight = 160;
    self.tableView.backgroundColor = LVColor(215, 215, 215);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    //设置让tableView的内边距,让他具有穿透效果
    self.tableView.contentInset = UIEdgeInsetsMake(LVNavBarMaxY + LVTitlesViewH, 0, LVTabBarH, 0);
    
    //让滚动条的初始滚动位置为内容相同
    self.tableView.scrollIndicatorInsets =UIEdgeInsetsMake(LVNavBarMaxY + LVTitlesViewH, 0, LVTabBarH, 0);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidReapetClick) name:LVTabBarButtonDidRepeatClickNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleButtonDidReapetClick) name:LVTitleButtonDidRepeatClickNotification object:nil];
    
    
    
    //刷新控件
    [self setupResh];
    
}

//刷新控件
- (void)setupResh
{

    //header下拉刷新加载数据
    
    self.tableView.mj_header = [LVRefreshHearder headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    //进入刷新状态
    [self.tableView.mj_header beginRefreshing];

    
  
    //foot -上啦加载更多
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];

    
}

#pragma mark - 加载网络数据
/**
 *  加载最新数据
 */
- (void)loadNewTopics
{
    //取消网络请求
    [self.mgr.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //添加参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //发送请求
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);
    
    
    [self.mgr GET:LVBaseUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        //字典数组转模型数组
        self.topics = [LVTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        //刷新表格
        [self.tableView reloadData];
        
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //AFN任务取消了也会来到failure这个block
        if (error.code == NSURLErrorCancelled)
        {
            //结束刷新
            [self.tableView.mj_header endRefreshing];
            LVLog(@"任务被取消了");
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"网络繁忙请稍后再试"];
        }
        
    }];
    
}


/**
 *  上拉加载更多oldTime数据
 *  maxtime	true	string
 */
- (void)loadMoreTopics
{
    //取消请求
    [self.mgr.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //添加参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //发送请求
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);
    parameters[@"maxtime"] = self.maxtime;
    
    
    [self.mgr GET:LVBaseUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //保存maxTime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        //字典数组转模型数组
        NSArray *moreTopics = [LVTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics addObjectsFromArray:moreTopics];
        
        //刷新数据
        [self.tableView reloadData];
        
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
        
        
    }];
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
    
    //进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    

}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView.mj_footer.hidden = (self.topics.count==0);
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LVTopAndBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:LVTopAndBottomCellID];
    
    //取出模型数组
    //    cell.topic = self.topics[indexPath.row];
    
    //传递模型数据
    LVTopic *topic = self.topics[indexPath.row];
    [topic cellHeight];
    cell.topic = topic;
    
    return cell;
}

#pragma mark - 代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [[SDImageCache sharedImageCache] clearMemory];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    //计算cell的高度
    
    return self.topics[indexPath.row].cellHeight;
    
}

@end


