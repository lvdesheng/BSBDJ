//
//  LVadItem.h
//  BSBDJ
//
//  Created by lvdesheng on 16/2/21.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

#import <Foundation/Foundation.h>
//w_picurl:广告图片 ori_curl:点击广告界面,进入广告,w,h
@interface LVadItem : NSObject

/**
 *  广告图片
 */
@property (nonatomic, strong) NSString *w_picurl;

/**点击广告界面*/
@property (nonatomic, strong) NSString *ori_curl;

/**广告尺寸*/
@property (nonatomic, assign) CGFloat w;

@property (nonatomic, assign) CGFloat h;

@end
