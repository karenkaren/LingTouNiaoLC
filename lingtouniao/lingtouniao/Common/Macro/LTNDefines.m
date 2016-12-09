//
//  LTNDefines.m
//  lingtouniao
//
//  Created by  mathe on 15/12/17.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNDefines.h"
#import "KeyValueStoreManager.h"


#pragma mark notification key
NSString *const NotificationMsg_Land_Sucess=@"NotificationMsg_Land_Sucess";
NSString *const NotificationMsg_Exit_Success=@"NotificationMsg_Exit_Success";
NSString *const NotificationMsg_Update_UserInfo=@"NotificationMsg_Update_UserInfo";
NSString * const Notification_Select_Coupon = @"Notification_Selected_Coupon";

NSString *const Exchange_copoun = @"Exchange_copoun";



#pragma mark end

#pragma mark common key
NSString *const kStaticVersion=@"kStaticVersion";



#pragma mark end


#pragma mark ---frame transform

float DimensionBaseIphone6(float aHeight){
    return aHeight*kScreenWidth/375.0f;//base iphone 6
}
#pragma mark ---bank icon
NSString * bankIcon(NSString *bankName){
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:kBankListAndBankIntroduction];
    NSArray *arr = dic[@"list"];
    for (NSDictionary *dict in arr) {
        if ([bankName isEqualToString: dict[@"bankName"]])return dict[@"logoUrl"];
    }
    return @"";

}

#pragma mark ---location string




NSString * locationString(NSString *key){
        
    static NSDictionary *_staticStrings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _staticStrings = [KeyValueStoreManager getStaticStrings];
    });

    //NSString *stringValue=[KeyValueStoreManager locationStringFromDB:key];
//    if(stringValue)
//        return stringValue;
    if(_staticStrings){
        NSString *stringValue=_staticStrings[key];
        if([stringValue length]>0)
            return stringValue;
    }
    return NSLocalizedString(key, nil);
}

#pragma mark trans a num to "万"
NSString *transToMill(double aNum){
    return [NSString stringWithFormat:@"%.2f",aNum/10000];
}

#pragma mark trans a int num to string
NSString * transIntToString(NSInteger aInt){
    return [@(aInt) stringValue];
}

#pragma mark statis time format

//统计埋点时间
NSString * timeForStatistics(void){
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [fmt stringFromDate:[NSDate date]];
    
}

#pragma mark - Path

NSString *ESPathForBundleResource(NSBundle *bundle, NSString *relativePath, ...)
{
    NSBundle *b = bundle ?: [NSBundle mainBundle];
    NSString *filePath = [b resourcePath];
    if (relativePath) {
        va_list args;
        va_start(args, relativePath);
        NSString *path = [[NSString alloc] initWithFormat:relativePath arguments:args];
        va_end(args);
        filePath = [filePath stringByAppendingPathComponent:path];
    }
    return filePath;
}

NSString *ESPathForMainBundleResource(NSString *relativePath, ...)
{
    NSString *path = nil;
    if (relativePath) {
        va_list args;
        va_start(args, relativePath);
        path = [[NSString alloc] initWithFormat:relativePath arguments:args];
        va_end(args);
    }
    return ESPathForBundleResource([NSBundle mainBundle], path);
}

NSString *ESPathForDocuments(void)
{
    static NSString *docs = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    });
    return docs;
}

NSString *ESPathForDocumentsResource(NSString *relativePath, ...)
{
    NSString *filePath = @"";
    if (relativePath) {
        va_list args;
        va_start(args, relativePath);
        filePath = [[NSString alloc] initWithFormat:relativePath arguments:args];
        va_end(args);
    }
    return [ESPathForDocuments() stringByAppendingPathComponent:filePath];
}

NSString *ESPathForLibrary(void)
{
    static NSString *lib = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lib = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    });
    return lib;
}

NSString *ESPathForLibraryResource(NSString *relativePath, ...)
{
    NSString *filePath = @"";
    if (relativePath) {
        va_list args;
        va_start(args, relativePath);
        filePath = [[NSString alloc] initWithFormat:relativePath arguments:args];
        va_end(args);
    }
    return [ESPathForLibrary() stringByAppendingPathComponent:filePath];
}

NSString *ESPathForCaches(void)
{
    static NSString *caches = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        caches = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    });
    return caches;
}

NSString *ESPathForCachesResource(NSString *relativePath, ...)
{
    NSString *filePath = @"";
    if (relativePath) {
        va_list args;
        va_start(args, relativePath);
        filePath = [[NSString alloc] initWithFormat:relativePath arguments:args];
        va_end(args);
    }
    return [ESPathForCaches() stringByAppendingPathComponent:filePath];
}

NSString *ESPathForTemporary(void)
{
    return NSTemporaryDirectory();
}

NSString *ESPathForTemporaryResource(NSString *relativePath, ...)
{
    NSString *filePath = @"";
    if (relativePath) {
        va_list args;
        va_start(args, relativePath);
        filePath = [[NSString alloc] initWithFormat:relativePath arguments:args];
        va_end(args);
    }
    return [ESPathForTemporary() stringByAppendingPathComponent:filePath];
}

BOOL ESTouchDirectory(NSString *dir)
{
    if (![dir isKindOfClass:[NSString class]] || 0 == dir.length) {
        return NO;
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    if (![fm fileExistsAtPath:dir isDirectory:&isDirectory] || !isDirectory) {
        if (![fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:NULL]) {
            return NO;
        }
    }
    return YES;
}

NSString *ESTouchFilePath(NSString *filePath, ...)
{
    NSString *path = @"";
    if ([filePath isKindOfClass:[NSString class]]) {
        va_list args;
        va_start(args, filePath);
        path = [[NSString alloc] initWithFormat:filePath arguments:args];
        va_end(args);
    }
    NSString *dir = [path stringByDeletingLastPathComponent];
    if (!ESTouchDirectory(dir)) {
        return nil;
    }
    return path;
}






#pragma mark - Dispatch
void ESDispatchSyncOnMainThread(dispatch_block_t block)
{
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

void ESDispatchAsyncOnMainThread(dispatch_block_t block)
{
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

void ESDispatchOnGlobalQueue(dispatch_queue_priority_t priority, dispatch_block_t block)
{
    dispatch_async(dispatch_get_global_queue(priority, 0), block);
}

void ESDispatchOnDefaultQueue(dispatch_block_t block)
{
    ESDispatchOnGlobalQueue(DISPATCH_QUEUE_PRIORITY_DEFAULT, block);
}
void ESDispatchOnHighQueue(dispatch_block_t block)
{
    ESDispatchOnGlobalQueue(DISPATCH_QUEUE_PRIORITY_HIGH, block);
}
void ESDispatchOnLowQueue(dispatch_block_t block)
{
    ESDispatchOnGlobalQueue(DISPATCH_QUEUE_PRIORITY_LOW, block);
}
void ESDispatchOnBackgroundQueue(dispatch_block_t block)
{
    ESDispatchOnGlobalQueue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, block);
}

void ESDispatchAfter(NSTimeInterval delayTime, dispatch_block_t block)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)),
                   dispatch_get_main_queue(),
                   block);
}


