//
//  LVTopic.m
//  BSBDJ
//
//  Created by lvdesheng on 16/2/28.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

#import "LVTopic.h"

@implementation LVTopic

- (CGFloat)cellHeight
{

    //如果_cellheight已经计算过了直接返回
    if (_cellHeight) return _cellHeight;
    
    /*******************cell的高度**************************/
    //头像
    _cellHeight += 55;
    
    //文字
    CGFloat textMaxW = LVScreenW - 2 * LVMargin;
    _cellHeight += [self.text boundingRectWithSize:CGSizeMake(textMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:15]} context:nil].size.height + LVMargin;
    
    //中间图片内容
    if (self.type != LVTopicTypeWord) //图片.声音.视频
    {
        CGFloat midlleW = textMaxW;
        CGFloat midlleH = midlleW * self.height / self.width;
        if (midlleH >= LVScreenH * 0.6){//超长图片
            midlleH = 200;
            
            self.BigPicture = YES;
        }
        CGFloat midlleX = LVMargin;
        CGFloat midlleY = _cellHeight;
        self.mindlleFrame = CGRectMake(midlleX, midlleY, midlleW, midlleH);
        
        _cellHeight += midlleH + LVMargin;
    }
    //最热评论
    if (self.top_cmt.count){//有最热评论
        _cellHeight += 18;
        
        NSDictionary *dict = self.top_cmt.firstObject;
        NSString *content =  dict[@"content"];
        if (content.length == 0){//语音评论
            content = @"语音评论";
        }
        NSString *usrname = dict[@"user"][@"username"];
        NSString *topcmtext = [ NSString stringWithFormat:@"%@ : %@",usrname,content];
        _cellHeight +=[topcmtext boundingRectWithSize:CGSizeMake(textMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
        _cellHeight += LVMargin;
    }
    

    
    //工具条
    _cellHeight += 35 + LVMargin;
    
    /*******************cell的高度**************************/
    
    return _cellHeight;
}

@end
