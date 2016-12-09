//
//  NetDataCacheManager.m
//  lingtouniao
//
//  Created by zhangtongke on 16/3/2.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "NetDataCacheManager.h"
#include <sys/xattr.h>

@implementation NetDataCacheManager


// 读取缓存
+(id)readCacheWithURLKey:(NSString*)URLKey;
{
    BOOL exsit = [[NSFileManager defaultManager]fileExistsAtPath:[self cacheDirectory:URLKey]];
    if (!exsit) return nil;
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self cacheDirectory:URLKey]];
}

// 写入缓存
+(void)saveCacheWithObject:(id)object forURLKey:(NSString*)URLKey completion:(void (^)(BOOL success))completion;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *filepath = [self cacheDirectory:URLKey];
        BOOL success = [NSKeyedArchiver archiveRootObject:object toFile:filepath];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(success);
        });
    });
}

// 删除缓存
+ (void)removeCacheWithURLKey:(NSString*)URLKey;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* filePath = [self cacheDirectory:URLKey];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    });
}


// 计算缓存大小
+(unsigned long long)AllCacheSize:(NSString*) CachePath;
{
    unsigned long long size = 0;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray* allCache = [fileManager contentsOfDirectoryAtPath:CachePath error:nil];
    for(NSString* FileName in allCache)
    {
        NSString* fullFilePath = [CachePath stringByAppendingPathComponent:FileName];
        BOOL isDir;
        if ([fileManager fileExistsAtPath:fullFilePath isDirectory:&isDir])
        {
            NSDictionary* fileAtrribute = [fileManager attributesOfItemAtPath:fullFilePath error:nil];
            size += fileAtrribute.fileSize;
        }
    }
    return size;
}

// 清楚指定过期缓存
+(void)removeOutTimeCache:(NSTimeInterval)cacheTime;
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSLog(@"cache directory : %@",[self cacheDirectory]);
    NSArray* allCache = [fileManager contentsOfDirectoryAtPath:self.cacheDirectory error:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for(NSString* FileName in allCache)
        {
            NSString* fullFilePath = [self.cacheDirectory stringByAppendingPathComponent:FileName];
            NSDictionary* fileAtrribute = [fileManager attributesOfItemAtPath:fullFilePath error:nil];
            NSDate *modificationDate = [fileAtrribute objectForKey:NSFileModificationDate];
            if ([modificationDate timeIntervalSinceNow] > cacheTime) {
                [fileManager removeItemAtPath:fullFilePath error:nil];
            }
        }
    });
}




// 清空
+ (void)resetCache;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSFileManager defaultManager] removeItemAtPath:[NetDataCacheManager cacheDirectory] error:nil];
    });
}


/**************************************************************/


// 缓存路径
+(NSString*)cacheDirectory:(NSString*)URLKey;
{
    return [self.cacheDirectory stringByAppendingPathComponent:[Utility md5:URLKey]];
}


// 缓存路径
+(NSString*)cacheDirectory;
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"lingtouniao"];
    
    __block BOOL isDir = YES;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (![[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory isDirectory:&isDir])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory
                                      withIntermediateDirectories:NO
                                                       attributes:nil
                                                            error:nil];
        }
        NSString* iOSversion = [UIDevice currentDevice].systemName ;
        [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:cacheDirectory] iOSVersion:iOSversion];
    });
    
    return cacheDirectory;
}


//设置文件不备份扩展属性
+(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL iOSVersion:(NSString *)iOSVersion
{
    float version = [iOSVersion floatValue];
    if (version > 5.0 && [iOSVersion isEqualToString:@"5.0.1"]==NO)
    {
        assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
        NSError *error = nil;
        BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
        if(!success){
            NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        }
        return success;
    }
    else
    {
        const char* filePath = [[URL path] fileSystemRepresentation];
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result== 0;
    }
}







@end
