//
//  XMGCacheManager.h
//  BuDeJie
//
//  Created by xiaomage on 16/2/22.
//  Copyright © 2016年 xiaomage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGCacheManager : NSObject
// AFN
+ (void)getCacheSizeWithDirectoryPath:(NSString *)directoryPath completion:(void(^)(NSInteger totalSize))completionBlock;

// 删除文件夹
+ (void)removeDirectoryPath:(NSString *)directoryPath;

@end
