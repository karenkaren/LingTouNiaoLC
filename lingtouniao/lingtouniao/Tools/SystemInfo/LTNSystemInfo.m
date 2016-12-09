//
//  LTNSystemInfo.m
//  lingtouniao
//
//  Created by  mathe on 15/12/17.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNSystemInfo.h"
#import "UIDevice+ESInfo.h"
#import "LTNKeyChainManager.h"

@implementation LTNSystemInfo


+ (NSString *)displayName
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}


+ (NSString *)getCurrentLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    return currentLanguage;
    
}


+ (NSString *)appVersion
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return version;
}

+ (NSString *)buildVersion
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return version;
}

+ (NSString *)appDownloadUrl
{
    return @"";
}



+ (NSDictionary *)analyticsInformation
{
    NSDictionary *dict = @{
                           @"sys_name" : [UIDevice systemName],
                           @"sys_version" : [UIDevice systemVersion],
                           @"sys_platform" : [UIDevice platform],
                           @"carrier" : [UIDevice carrierString],
                           @"device_id" : [LTNKeyChainManager keychainUUID],
                           @"app_version" : [self appVersion],
                           @"app_lang" : [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode],
                           @"jailbro" : [NSNumber numberWithInt:([UIDevice isJailBroken] ? 1 : 0)]
                           };
    return dict;
}


@end
