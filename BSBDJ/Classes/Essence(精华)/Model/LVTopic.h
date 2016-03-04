//
//  LVTopic.h
//  BSBDJ
//
//  Created by lvdesheng on 16/2/28.
//  Copyright © 2016年 lvdesheng. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, LVTopicType){
    /**
     *  全部
     */
    LVTopicTypeAll = 1,
    /**
     *  视频
     */
    LVTopicTypeVideo = 41,
    /**
     *  声音
     */
    LVTopicTypeVoice = 31,
    /**
     *  图片
     */
    LVTopicTypePicture = 10,
    /**
     *  段子
     */
    LVTopicTypeWord = 29
};

@interface LVTopic : NSObject


/**cai	string	踩的人数*/
@property (nonatomic, assign) NSInteger cai;

/**passtime	string	帖子通过的时间*/
@property (nonatomic, copy) NSString *passtime;


/**text	string	帖子的内容*/
@property (nonatomic, copy) NSString *text;

/** repost	string	转发的数量*/
@property (nonatomic, assign) NSInteger repost;

/**name	string	发帖人的昵称*/
@property (nonatomic, copy) NSString *name;

/** 用户的头像 */
@property (nonatomic, copy) NSString *profile_image;

/**comment	string	帖子的被评论数量*/
@property (nonatomic, assign) NSInteger comment;
 
/** 顶数量 */
@property (nonatomic, assign) NSInteger ding;
 
/**帖子类型*/
@property (nonatomic, assign)LVTopicType type;

/**图片宽度*/
@property (nonatomic, assign)CGFloat width;
/**图片高度*/
@property (nonatomic, assign)CGFloat height;
/**playcount播放次数*/
@property (nonatomic, assign)NSInteger playcount;
/**voicetime  音频和视频播放此时*/
@property (nonatomic, assign)NSInteger voicetime;
/** 视频时长 */
@property (nonatomic, assign) NSInteger videotime;
/** 小图 */
@property (nonatomic, copy) NSString *image0;
/** 中图 */
@property (nonatomic, copy) NSString *image2;
/** 大图 */
@property (nonatomic, copy) NSString *image1;
/**is_gif是否是gif动画*/
@property (nonatomic, assign)BOOL is_gif;
/** 最热评论 */
@property (nonatomic, strong) NSArray *top_cmt;



/****** 额外增加的属性（为了方便开发，并非服务器返回的数据） ******/
/** 根据当前模型数据计算出来的cell高度 */
@property (nonatomic, assign) CGFloat cellHeight;
/** 中间内容的frame */
@property (nonatomic, assign) CGRect mindlleFrame;

/**是否是超长图片*/
@property (nonatomic, assign , getter=isBigPicture)BOOL BigPicture;

@end
