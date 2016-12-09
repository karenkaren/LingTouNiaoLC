//
//  NetDataCacheManager.h
//  lingtouniao
//
//  Created by zhangtongke on 16/3/2.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetDataCacheManager : NSObject

// 读取缓存
+(id)readCacheWithURLKey:(NSString*)URLKey;

// 写入缓存
+(void)saveCacheWithObject:(id)object forURLKey:(NSString*)URLKey completion:(void (^)(BOOL success))completion;

// 删除缓存
+ (void)removeCacheWithURLKey:(NSString*)URLKey;


// 清楚指定过期缓存
+(void)removeOutTimeCache:(NSTimeInterval) cacheTime;

// 清空
+ (void)resetCache;

// 计算缓存大小
+(unsigned long long)AllCacheSize:(NSString*) CachePath;

// 缓存路径
+(NSString*)cacheDirectory;

@end
