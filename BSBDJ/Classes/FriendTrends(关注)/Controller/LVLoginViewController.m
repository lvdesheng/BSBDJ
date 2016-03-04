//
//  LVLoginViewController.m
//  BSBDJ
//
//  Created by lvdesheng on 16/2/22.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

#import "LVLoginViewController.h"
#import "LVLoginViewF.h"
#import "LVFastLoginView.h"

@interface LVLoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftCons;
@property (weak, nonatomic) IBOutlet UIView *buttonView;

@end

@implementation LVLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建登录view
    LVLoginViewF *LoginViewF = [LVLoginViewF LoginViewF];
    // 添加登录view
    [self.middleView addSubview:LoginViewF];
    
    
    // 创建注册view
    LVLoginViewF *registerFView = [LVLoginViewF registerFeildView];
    // 添加注册view
    [self.middleView  addSubview:registerFView];
    
    //添加快速登陆View
    
    LVFastLoginView *fastLoginView = [LVFastLoginView viewForXib];
    [self.buttonView addSubview:fastLoginView];
    
    

}

// 1.为什么不需要设置尺寸,应不应该设置xib尺寸
// 2.以后只要想设置控制器中子控件的位置viewDidLayoutSubviews
// 不会执行约束,在viewDidLoad中控件的尺寸都不是最终尺寸
// 表示执行约束完成
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    //设置登陆尺寸
    UIView *loginView =  self.middleView.subviews[0];
    loginView.frame = CGRectMake(0, 0, self.middleView.width * 0.5, self.middleView.height);
    
    //设置注册尺寸
    UIView *registerView =  self.middleView.subviews[1];
    registerView.frame = CGRectMake(self.middleView.width * 0.5, 0, self.middleView.width * 0.5, self.middleView.height);

}

#pragma mark - 点击取消时调用
- (IBAction)cancelClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 注册账号时调用
- (IBAction)registClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    //平移midView
    
    self.leftCons.constant = self.leftCons.constant == 0 ? -LVScreenW :0;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
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
