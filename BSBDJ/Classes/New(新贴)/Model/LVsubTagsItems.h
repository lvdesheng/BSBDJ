//
//  LVsubTagsItems.h
//  BSBDJ
//
//  Created by lvdesheng on 16/2/21.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LVsubTagsItems : NSObject


/**
 *  is_sub	int	是否含有子标签
    theme_id	string	此标签的id
    theme_name	string	标签名称
    sub_number	string	此标签的订阅量
    is_default	int	是否是默认的推荐标签
    image_list	string	推荐标签的图片url地址
 */

/**标签名称*/
@property (nonatomic, strong)  NSString *theme_name;
/**推荐标签的图片url地址*/
@property (nonatomic, strong)  NSString *image_list;
/**此标签的订阅量*/
@property (nonatomic, strong)  NSString *sub_number;

@end
