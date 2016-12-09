//
//  CurrentUser.m
//  lingtouniao
//
//  Created by  mathe on 15/12/17.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "CurrentUser.h"
#import "NSStringUtil.h"
#import "NetDataCacheManager.h"
#import "JPUSHService.h"

#import "LTNKeyChainManager.h"

@implementation CurrentUser



static CurrentUser *_currentUser = nil;
+ (instancetype)mine
{
    if (nil == _currentUser) {
        _currentUser=[[super alloc] initMine];
        
    }
    
    return _currentUser;
}

-(NSString *)sessionKey{
    if(!_sessionKey)
        return @"";
    return _sessionKey;
}

- (instancetype)initMine
{
    self = [super init];
    if (self) {
        /*
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKey_Mine];
        if(userInfo&&isDictionary(userInfo))
        {
            [self mj_setKeyValues:userInfo];
        }*/
        
        
        //TODO:是否登录相关
        NSString * sessionKey = [[NSUserDefaults standardUserDefaults] objectForKey:kUserSessionKey_Mine];
        if(ESIsStringWithAnyText(sessionKey)){
            self.sessionKey=sessionKey;
        }else{
            [PiwikTracker sharedInstance].userID = [LTNKeyChainManager keychainUUID];
            [PiwikTracker sharedInstance1].userID = [LTNKeyChainManager keychainUUID];
        }
        
    }
    return self;
}

- (void)reset
{
    if (_currentUser) {
        
        //[[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsKey_Mine];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserSessionKey_Mine];
        [[NSUserDefaults standardUserDefaults] synchronize];
        /* Clear cookies */
        [LTNCore deleteAllHTTPCookies];
        [NetDataCacheManager resetCache];
        _currentUser = nil;
        [[self class] mine];
        
        [PiwikTracker sharedInstance].userID = [LTNKeyChainManager keychainUUID];
        [PiwikTracker sharedInstance1].userID = [LTNKeyChainManager keychainUUID];
    }
}

MJExtensionCodingImplementation
- (void)save
{
    ESWeak(self, _self);
    ESDispatchOnBackgroundQueue(^{
        [NSThread sleepForTimeInterval:1.0f];
        //[[NSUserDefaults standardUserDefaults] setObject:_self.mj_keyValues forKey:kUserDefaultsKey_Mine];
        [[NSUserDefaults standardUserDefaults] setObject:_self.sessionKey forKey:kUserSessionKey_Mine];
        
    });
}


+(void)loginSuccess:(NSString *)sessionKey
{
    [NetDataCacheManager resetCache];
    [[CurrentUser mine]  setDtUrl:nil];
    [[CurrentUser mine]  setSessionKey:sessionKey];
    [[CurrentUser mine] save];
    [CurrentUser mine].haveNotShowEggToday=NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_Land_Sucess
                                                        object:nil
                                                      userInfo:nil];
    
    [JPUSHService setAlias:[CurrentUser mine].sessionKey callbackSelector:nil object:nil];
    
    
}




- (BOOL)hasLogged
{
    
#if AlwaysHasLogin
    return YES;
#else
    return ESIsStringWithAnyText(self.sessionKey);
#endif
    
}

- (BOOL)isExpired{
    /*
    NSDate *expiredDate=[NSDate dateFromString:self.expire withFormat:@"yyyy-MM-dd HH:mm"];
    return [expiredDate compare:[NSDate date]]!=NSOrderedDescending;
     */
    return YES;
}

+ (NSString *)urlForShare {
//    NSString * phoneNo = [CurrentUser mine].userInfo.mobile ? [CurrentUser mine].userInfo.mobile : [[NSUserDefaults standardUserDefaults] valueForKey:@"SBFormattedPhoneNumber"];
    NSString *url = [NSString stringWithFormat:@"%@%@?mobile=%@", kBaseUrl, kH5ShareUrl, safeEmpty([CurrentUser mine].userInfo.mobile)];
    return url;
}

@end
