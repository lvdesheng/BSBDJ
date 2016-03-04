//
//  LVAdViewController.m
//  BSBDJ
//
//  Created by lvdesheng on 16/2/20.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

#import "LVAdViewController.h"
#import "AFNetworking.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "LVadItem.h"
#import "LVTabBarController.h"



#define LVCode2 @"phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam"

@interface LVAdViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *launchImagie;

@property (weak, nonatomic) IBOutlet UIView *adView;


@property (nonatomic, weak)  UIImageView *adImageView;

@property (nonatomic, strong) LVadItem *item;


@property (nonatomic, weak)  NSTimer *time;
@property (weak, nonatomic) IBOutlet UIButton *jumpButton;

@end


@implementation LVAdViewController

- (UIImageView *)adImageView
{
    if (!_adImageView) {
        
        UIImageView *adImageView = [[UIImageView alloc] init];
        [_adView addSubview:adImageView];
        _adImageView = adImageView;
        
        // 添加点按手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        
        [_adImageView addGestureRecognizer:tap];
        // 允许用户交互
        
        _adImageView.userInteractionEnabled = YES;
        

        
    }
    return _adImageView;
}

#pragma mark - 点击广告页面调用
- (void)tap
{
    //跳转广告页面
    
     NSURL *url = [NSURL URLWithString:_item.ori_curl];
    
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
       
        [[UIApplication sharedApplication] openURL:url];
    }
    

    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置启动图片
    [self setUpLaunchImage];
    
    // 加载广告界面:向服务器请求数据 => 查看接口文档 => 测试下接口有没有问题 => 查看下哪些数据是自己想要的数据(w_picurl:广告图片 ori_curl:点击广告界面,进入广告,w,h)=> 请求数据 => 解析数据(写成plist) => 解析Plist文件 => 设计模型 => 字典转模型 => 把模型展示到界面上
    // 返回json数据,json字典:{ json数组:[
    // 如何查看接口文档 1.请求方式,get,post 2.请求参数 3.请求结果
    
    //发送广告请求
    
    [self loadAdData];
    
    //设置时间
    _time = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
                               
}

#pragma mark - 点击跳过广告
- (IBAction)clickJump{
    
    //修改窗口根控制器
    LVTabBarController *tabBarVC = [[LVTabBarController alloc]init];
    
    [UIApplication sharedApplication].keyWindow.rootViewController =tabBarVC;
    
    [_time invalidate];
    
}

#pragma mark - 每隔1秒调用
- (void)timeChange
{
    
    static NSInteger i = 3;
    
    if (i == -1)
    {

        [self clickJump];
            
            return;

    }
    
    //设置文字 跳过(3)
    NSString *str = [NSString stringWithFormat:@"跳过(%ld)",i];
    
    [_jumpButton setTitle:str forState:UIControlStateNormal];
    
    i--;
}


- (void)setUpLaunchImage
{
    if (iPhone6P)
    {
        _launchImagie.image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h@3x"];
    }else if (iPhone6)
    {
        _launchImagie.image = [UIImage imageNamed:@"LaunchImage-800-667h"];
    }else if (iPhone5)
    {
        _launchImagie.image = [UIImage imageNamed:@"LaunchImage-700-568h"];
    }else if(iPhone4)
    {
        _launchImagie.image = [UIImage imageNamed:@"LaunchImage-700"];
    }


}

#pragma mark - 发送广告请求
- (void)loadAdData
{
    // Request failed: unacceptable content-type: text/html"
    // 看见错误:接口错误 还是 AFN报错
    // 1.创建请求会话管理者
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 2.拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"code2"] = LVCode2;
    // 3.发送请求
    // 请求完整路径:基本URL + 请求参数
    // 第一个参数:基本URL
    
    [mgr GET:@"http://mobads.baidu.com/cpro/ui/mads.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        
        //获取广告字典
        NSDictionary *adDict = [responseObject[@"ad"] lastObject];
        
        //广告字典转换成模型
        _item =[LVadItem mj_objectWithKeyValues:adDict];
       
        //展示广告图片
        // 开发习惯:每次创建控件,一定要考虑要创建多少次,只要创建一次,采用懒加载
        CGFloat adW = LVScreenW;
        CGFloat adH = LVScreenW / _item.w * _item.h;
        if (adH > 557) {
            adH = 557;
        }
        
        self.adImageView.frame = CGRectMake(0, 0, adW, adH);
        
        //设置图片
        
         // 处理广告界面业务逻辑 => 跳转到广告界面 => safari
        
        [self.adImageView sd_setImageWithURL:[NSURL URLWithString:_item.w_picurl]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
        NSLog(@"%@",error);
    }];
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
