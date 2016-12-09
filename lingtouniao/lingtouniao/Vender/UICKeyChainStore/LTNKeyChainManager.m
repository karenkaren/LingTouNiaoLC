//
//  LTNKeyChainManager.m
//  lingtouniao
//
//  Created by  mathe on 15/12/17.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNKeyChainManager.h"


#define kStubService @"com.liaozi"
#define kUsername @"kUsername"
#define kPassword @"kPassword"

@implementation LTNKeyChainManager

+ (instancetype)defaultManager
{
    static LTNKeyChainManager *_defaultManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultManager = [[self alloc] init];
    });
    return _defaultManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSString *serviceName = kStubService;
        [UICKeyChainStore setDefaultService:serviceName];
    }
    return self;
}

//TODO:保存读取放在非主线程

+(NSString *)keychainUUID
{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:kStubService];
    NSString *strUUID = [store stringForKey:@"uuid"];
    if([strUUID length]==0)
    {
        strUUID = [[UIDevice currentDevice].identifierForVendor UUIDString];
        [store setString:strUUID forKey:@"uuid"];
    }
    return strUUID;
}

+(void)storeUsername:(NSString *)username password:(NSString *)password
{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:kStubService];
    [store removeItemForKey:kUsername];
    [store removeItemForKey:kPassword];
    [store setString:username forKey:kUsername];
    [store setString:password forKey:kPassword];
}

+(NSDictionary *)getUsernameAndPassword
{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:kStubService];
    NSString *username=[store stringForKey:kUsername];
    NSString *password=[store stringForKey:kPassword];
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    if(username)
        [dic setObject:username forKey:@"username"];
    if(password)
        [dic setObject:password forKey:@"password"];
    return dic;
}


@end
