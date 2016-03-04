//
//  LVSquareCell.m
//  BSBDJ
//
//  Created by lvdesheng on 16/2/23.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

#import "LVSquareCell.h"
#import <UIImageView+WebCache.h>
#import "LVSquareItem.h"


@interface LVSquareCell ()
@property (weak, nonatomic) IBOutlet UIImageView *squarImageView;
@property (weak, nonatomic) IBOutlet UILabel *squarLabel;

@end

@implementation LVSquareCell

- (void)setItem:(LVSquareItem *)item
{
    _item = item;
    
    //设置头像
    [self.squarImageView sd_setImageWithURL:[NSURL URLWithString:item.icon]];
    
    //设置文字
    self.squarLabel.text = item.name;
    
    
}

@end
