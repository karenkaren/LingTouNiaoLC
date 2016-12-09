//
//  LTNSystemInfo.h
//  lingtouniao
//
//  Created by  mathe on 15/12/17.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTNSystemInfo : NSObject

/**
 *  app版本号
 */
+ (NSString *)appVersion;

/**
 *  app build号
 */
+ (NSString *)buildVersion;

/**
 *  appstore下载链接
 */
+ (NSString *)appDownloadUrl;



/**
 *  UA信息
 */
+ (NSDictionary *)analyticsInformation;

@end
