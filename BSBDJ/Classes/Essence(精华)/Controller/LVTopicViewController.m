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



@interface LVTopicViewController ()

/**所有帖子数据*/
@property (nonatomic, strong) NSMutableArray <LVTopic *> *topics;

/**请求管理者*/
@property (nonatomic, strong) AFHTTPSessionManager *mgr;

/**当需要加载下一页时：需要传入加载上一页时返回值字段“maxtime”中的内容*/
@property (nonatomic, copy) NSString *maxtime;


/********footer*****/
@property (nonatomic, weak)  UIView *footer;
@property (nonatomic, weak)  UILabel *footLabel;
/**是否正在上拉刷新*/
@property (nonatomic, assign,getter=isFooterRefeshing)BOOL footerRefeshing;

/********header**********/
@property (nonatomic, weak)  UIView *header;
@property (nonatomic, weak)  UILabel *headerLabel;
/**是否正在下拉刷新*/
@property (nonatomic, assign,getter=isHeaderRefeshing)BOOL headerRefeshing;


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
    UIView *header = [[UIView alloc]init];
    header.frame = CGRectMake(0, -50, self.tableView.width, 50);
    [self.tableView addSubview:header];
    self.header = header;
    
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.frame = header.bounds;
    headerLabel.backgroundColor = [UIColor redColor];
    headerLabel.text = @"下拉可以刷新";
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:headerLabel];
    self.headerLabel = headerLabel;
    
    //header自动刷新
    [self headerBeginRefreshing];
    
    
    
    //foot -上啦加载更多
    UIView *footer = [[UIView alloc]init];
    footer.frame = CGRectMake(0, 0, self.tableView.width, 35);
    footer.backgroundColor = [UIColor redColor];
    self.tableView.tableFooterView = footer;
    self.footer = footer;
    
    UILabel *footLabel = [[UILabel alloc] init];
    footLabel.frame = footer.bounds;
    footLabel.text = @"上拉加载更多";
    footLabel.textAlignment = NSTextAlignmentCenter;
    footLabel.textColor = [UIColor whiteColor];
    [footer addSubview:footLabel];
    self.footLabel = footLabel;
    
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
        [self headerEndRefrshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //AFN任务取消了也会来到failure这个block
        if (error.code == NSURLErrorCancelled)
        {
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
        [self footerEndRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //结束刷新
        [self footerEndRefreshing];
        
        
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
    
    [self headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.footer.hidden = (self.topics.count == 0);
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
    //处理header
    [self dealHeader];
    //处理footer
    [self dealFooter];
    
    [[SDImageCache sharedImageCache] clearMemory];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    //计算cell的高度
    
    LVTopic *topic =  self.topics[indexPath.row];
    
    return topic.cellHeight;
    
    
}


/**
 *手松开时调用这个方法
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //如果正在刷新刷新直接退出
    if(self.isHeaderRefeshing) return;
    
    // 如果偏移量 <= offsetY, 就说明header已经完全出现
    CGFloat offsetY = - (self.tableView.contentInset.top + self.header.height);
    if (self.tableView.contentOffset.y <= offsetY) {
        [self headerBeginRefreshing];
    }
    
}

- (void)dealHeader
{
    // header还没有创建，直接返回
    if (self.header == nil) return;
    // 如果正在刷新
    if (self.isHeaderRefeshing) return;
    
    // 如果偏移量 <= offsetY, 就说明header已经完全出现
    CGFloat offsetY = - (self.tableView.contentInset.top + self.header.height);
    if (self.tableView.contentOffset.y <= offsetY) {
        self.headerLabel.text = @"松开立即刷新";
        self.headerLabel.backgroundColor = [UIColor blueColor];
    } else {
        self.headerLabel.text = @"下拉可以刷新";
        self.headerLabel.backgroundColor = [UIColor redColor];
    }
}

- (void)dealFooter
{
    // 如果没有数据，就直接返回
    if (self.topics.count == 0) return;
    // 如果正在刷新
    if (self.isFooterRefeshing) return;
    
    // 如果偏移量 >= offsetY, 就说明footer已经完全出现
    CGFloat offsetY = self.tableView.contentSize.height + self.tableView.contentInset.bottom - self.tableView.height;
    
    if (self.tableView.contentOffset.y >= offsetY) {
        [self footerBeginRefreshing];
    }
}

#pragma mark - header
/**
 *  让header进入刷新状态
 */
- (void)headerBeginRefreshing
{
    // 这句代码是防止【上拉】和【下拉】同时执行
    //    if (self.isFooterRefreshing) return;
    if (self.isHeaderRefeshing) return;
    
    // 进入刷新状态
    self.headerLabel.text = @"正在刷新数据...";
    self.headerLabel.backgroundColor = [UIColor orangeColor];
    self.headerRefeshing = YES;
    
    // 增大内边距
    [UIView animateWithDuration:0.25 animations:^{
        UIEdgeInsets inset = self.tableView.contentInset;
        inset.top += self.header.height;
        self.tableView.contentInset = inset;
        
        self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x,  - inset.top);
    }];
    
    // 加载最新的帖子数据
    [self loadNewTopics];
}

/**
 *  让header结束刷新状态
 */
- (void)headerEndRefrshing
{
    self.headerRefeshing = NO;
    
    // 恢复内边距
    [UIView animateWithDuration:0.25 animations:^{
        UIEdgeInsets inset = self.tableView.contentInset;
        inset.top -= self.header.height;
        self.tableView.contentInset = inset;
    }];
}

#pragma mark - footer
/**
 *  让footer进入刷新状态
 */
- (void)footerBeginRefreshing
{
    // 这句代码是防止【上拉】和【下拉】同时执行
    //    if (self.isHeaderRefreshing) return;
    if (self.isFooterRefeshing) return;
    
    // 修改文字
    self.footLabel.text = @"正在加载更多数据...";
    
    // 记录一下正在加载更多数据
    self.footerRefeshing = YES;
    
    [self loadMoreTopics];
}

/**
 *  让footer结束刷新状态
 */
- (void)footerEndRefreshing
{
    self.footerRefeshing = NO;
    self.footLabel.text = @"上拉可以加载更多";
}
@end


