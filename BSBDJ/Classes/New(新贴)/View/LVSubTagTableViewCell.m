//
//  LVSubTagTableViewCell.m
//  BSBDJ
//
//  Created by lvdesheng on 16/2/21.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

#import "LVSubTagTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "LVsubTagsItems.h"
#import "UIImage+Antialias.h"


@interface LVSubTagTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *subTagImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@end

@implementation LVSubTagTableViewCell


- (void)setItem:(LVsubTagsItems *)item
{
    _item = item;
    
    
    //显示头像,设置展位图片
    [_subTagImage LV_setHeaderImage:item.image_list];
    //名称
    
    _nameLabel.text = item.theme_name;
    
    //数字
    
    _numLabel.text = [NSString stringWithFormat:@"%@人订阅",item.sub_number];
    
    
    // iOS9可以使用cornerRadius,不会造成帧数杀手
    // 头像:圆角 方式:1.通过设置layer圆角半径 2.裁剪图片

    
    //处理数字
    
    NSInteger num = [item.sub_number integerValue];
    CGFloat numF = 0;
    if (num > 10000)
    {
        numF =  num / 10000.0;
        
        _numLabel.text = [NSString stringWithFormat:@"%.1f万人订阅",numF];
    }
   
}


#pragma mark - 设置cell 的frame
-(void)setFrame:(CGRect)frame
{
    frame.size.height -= 1;
    
    //真正给cell设置frame
    [super setFrame:frame];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
