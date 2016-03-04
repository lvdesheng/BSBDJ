//
//  LVsubTagTableController.m
//  BSBDJ
//
//  Created by lvdesheng on 16/2/21.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

#import "LVsubTagTableController.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "LVsubTagsItems.h"
#import "LVSubTagTableViewCell.h"
#import <SVProgressHUD.h>

static NSString * const ID = @"cell";

@interface LVsubTagTableController ()


@property (nonatomic, strong) NSArray *subTags;

@property (nonatomic, weak)  AFHTTPSessionManager *mgr;

@end

@implementation LVsubTagTableController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置订阅的中间的文字
    self.title = @"推荐标签";
    
    // 请求业务逻辑:请求数据,给用户提示,当前正在加载ing...
    // 显示提示框
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    // 显示多少行cell => 有多少个标签模型 => 请求服务器数据 => 查看接口 => 请求数据(AFN) => 解析数据(image_list,theme_name,sub_number) => 设计模型 => 字典转模型 => 把模型展示到界面
    
    [self laodData];
    
    // cell加载xib方式:NSBundle 2.注册cell(最常见)
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LVSubTagTableViewCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
    // 让cell的分割线宽度占据全部屏幕宽度:1.搞一个UIView 2.通过设置系统的属性也是达到这个目的(弊端:只支持8.0) 3.setFrame 3.重写cell的setFrame(万能) 1.取消系统的分割线 2.设置tableView背景色为分割线颜色
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = LVColor(184, 184, 184);


}

- (void)viewWillDisappear:(BOOL)animated
{
    //隐藏提示框
    [SVProgressHUD dismiss];
    
    //取消所有请求
    [_mgr.tasks makeObjectsPerformSelector:@selector(cancel)];
    
}

- (void)laodData
{
    
    //创建管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    _mgr = mgr;

    /**
     *  a		string	tag_recommend
        action		string	sub
        c		string	topic
     */
    
    //填入参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"tag_recommend";
    parameters[@"action"] = @"sub";
    parameters[@"c"] = @"topic";
    //发送网络请求
    
    [mgr GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray * _Nullable responseObject) {
   
        
        // 字典数组转模型数组
        _subTags = [LVsubTagsItems mj_objectArrayWithKeyValuesArray:responseObject];
        
        //刷新表格
        [self.tableView reloadData];
        
        //隐藏提示框
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        LVLog(@"%@", error);
        
        //隐藏提示框
        [SVProgressHUD dismiss];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _subTags.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

     // cell从xib加载,一定要记得循环利用
    LVSubTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    //展示数据
    cell.item = _subTags[indexPath.row];
    

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

@end
