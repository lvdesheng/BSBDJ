//
//  LVTopAndBottomCell.h
//  BSBDJ
//
//  Created by lvdesheng on 16/2/29.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LVTopic;

@interface LVTopAndBottomCell : UITableViewCell

/**View拥有模型属性*/
@property (nonatomic, strong) LVTopic *topic;

@end
