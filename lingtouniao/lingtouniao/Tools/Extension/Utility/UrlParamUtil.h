//
//  UrlParamUtil.h
//  EInsuranceIphone
//
//  Created by yang on 13-3-25.
//
//

#import <Foundation/Foundation.h>

@interface UrlParamUtil : NSObject

+ (NSString *)baseURLFromURL:(NSURL *)url;

/**
 *  deprecated used + (NSDictionary*)paramsFromURL:(NSURL*)url
 *
 *  @param url <#url description#>
 *
 *  @return <#return value description#>
 */
+ (NSDictionary *)getParamsFromUrl:(NSURL *)url;

+ (NSDictionary*)paramsFromURL:(NSURL*)url;
+ (NSDictionary*)paramsFromURL:(NSURL*)url usingEncoding:(NSStringEncoding)encoding;

+ (NSURL *)urlWithUrlString:(NSString *)url withParams:(NSDictionary *)params;

/**
 *  url 编码 解码
 *
 *  @param text <#text description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)encodeURLString:(NSString *)text;
+ (NSString *)decodeURLString:(NSString *)urlString;


#pragma mark - 收到 url 打开app
+ (NSDictionary *)getParamsFromOtherApp:(NSURL *)url;

@end
