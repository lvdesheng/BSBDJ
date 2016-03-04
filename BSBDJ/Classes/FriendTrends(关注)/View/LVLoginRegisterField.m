//
//  LVLoginRegisterField.m
//  BSBDJ
//
//  Created by lvdesheng on 16/2/23.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

#import "LVLoginRegisterField.h"

@implementation LVLoginRegisterField

// 写代码步骤:1.明确写什么效果 2.明确在哪个类中做事情
// 1.光标变成白色
// 当文本框开始编辑的时候,2.占位文字颜色变成白色
// 当文本框结束编辑的时候,恢复占位文字颜色

// 在哪个方法去监听:考虑,需要监听多少次 1次,当控件一创建,就监听


- (void)awakeFromNib
{
    //设置光标颜色
    self.tintColor = [UIColor whiteColor];
    
    // 监听文本框开始编辑 1.代理(1对1) 2.通知(1对多) 3.target
    // 很少自己成为自己代理
    [self addTarget:self action:@selector(editBegin) forControlEvents:UIControlEventEditingDidBegin];
    
    [self addTarget:self action:@selector(editEnd) forControlEvents:UIControlEventEditingDidEnd];
    
    //设置占位文字图片
//    NSMutableDictionary *att = [NSMutableDictionary dictionary];
//    
//    att[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
//    
//    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:att];

    
    //  设置占位文字颜色:快速设置占位文字颜色
    // 猜测占位文字 是 UILabel => 验证:
    // 想办法拿到这个label => 得知道成员变量名 => runtime:可以遍历一个类中所有成员变量
    // 直接使用断点就能获取一个对象中所有成员变量名
    
    //设置占位文字颜色
    self.placeholderColor = [UIColor whiteColor];

    
}

- (void)editBegin
{
   // 设置占位文本框颜色为白色
    UILabel *placeHolderLabel = [self valueForKey:@"placeholderLabel"];
    
    placeHolderLabel.textColor = [UIColor whiteColor];
}
- (void)editEnd
{
    // 设置占位文本框颜色为恢复
    UILabel *placeHolderLabel = [self valueForKey:@"placeholderLabel"];
    
    placeHolderLabel.textColor = [UIColor grayColor];
}


@end
