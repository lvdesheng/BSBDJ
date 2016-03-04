//
//  LVWebViewController.m
//  BSBDJ
//
//  Created by lvdesheng on 16/2/23.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

#import "LVWebViewController.h"
#import <WebKit/WebKit.h>

@interface LVWebViewController ()
@property (weak, nonatomic) IBOutlet UIProgressView *progressLine;
@property (weak, nonatomic) IBOutlet UIView *conentView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwarditem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshItem;
/**WKWebView*/
@property (nonatomic, weak)  WKWebView *webView;
@end

@implementation LVWebViewController

- (IBAction)backClick:(UIBarButtonItem *)sender {
    [self.webView goBack];
}

- (IBAction)forwardClick:(id)sender {
    [self.webView goForward];
}
- (IBAction)refreshClick:(id)sender {
    [self.webView reload];
}

// WKWebView:UIWebView升级版本,比UIWebView功能更加多,条件:iOS8以上
// 1.#import <WebKit/WebKit.h>  2.需要手动把WebKit框架编译
- (void)viewDidLoad {
    [super viewDidLoad];

//    WKWebView *WebView =[[WKWebView alloc]initWithFrame:CGRectMake(0, 0, LVScreenW, LVScreenH)];
    
    WKWebView *WebView =[[WKWebView alloc]init];
    [self.conentView addSubview:WebView];
    
    self.webView = WebView;
    
    // 添加底部额外滚动区域
//    WebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    
    //展示网页
    NSURLRequest *url = [NSURLRequest requestWithURL:_url];
    [WebView loadRequest:url];
    
    // 前进,后退,刷新,进度条
    // KVO监听属性
    // Observer:观察者
    // KeyPath:监听哪个属性
    // options:NSKeyValueObservingOptionNew,监听新值改变
    
    
    [WebView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
     [WebView addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew context:nil];
    [WebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [WebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];



}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    WKWebView *webView = _conentView.subviews[0];
    webView.frame = _conentView.bounds;
}


//监听属性有新值得时候回调用
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{

    self.backItem.enabled = self.webView.canGoBack;
    self.forwarditem.enabled = self.webView.canGoForward;
    self.progressLine.progress = self.webView.estimatedProgress;
    self.progressLine.hidden = self.webView.estimatedProgress >= 1;
    self.title = self.webView.title;
    
}

// 对象即将销毁,移除观察者
- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
    [self.webView removeObserver:self forKeyPath:@"canGoForward"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    
}


@end
