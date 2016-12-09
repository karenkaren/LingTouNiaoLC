//
//  UrlParamUtil.m
//  EInsuranceIphone
//
//  Created by yang on 13-3-25.
//
//

#import "UrlParamUtil.h"

@implementation UrlParamUtil

+ (NSString *)baseURLFromURL:(NSURL *)url
{
    NSMutableString *baseStr = [[NSMutableString alloc] init];
    if (url) {
        if ([url scheme]) {
            [baseStr appendFormat:@"%@://",[url scheme]];
        }
        if ([url host]) {
            [baseStr appendFormat:@"%@",[url host]];
        }
        if ([url port]) {
            [baseStr appendFormat:@":%@",[url port]];
        }
        if ([url path]) {
            [baseStr appendFormat:@"%@/",[url path]];
        }
    }
    return baseStr;
}

+ (NSDictionary *)getParamsFromUrl:(NSURL *)url
{
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    
    NSString *requestURLString = [NSString stringWithFormat:@"%@",url];
    NSRange range = [requestURLString rangeOfString:@"?"];

    NSArray *urlArray = [NSArray array];
    if (range.length == 1) {
        NSString * firstStr = [requestURLString substringToIndex:range.location];
        NSString * secondStr = [requestURLString substringFromIndex:range.location + range.length];
        urlArray = @[firstStr, secondStr];
    } else {
        urlArray = @[requestURLString];
    }
    
    if (urlArray.count < 2) {
        return paramsDict;
    }
    
    //默认method= 第一个 而且必须有的
    
    
    NSString *paras=[urlArray objectAtIndex:1];
    
    
    NSRange kMethodRange;
    kMethodRange = [paras rangeOfString:@"method="];
    
    NSRange kCallbackRange;
    kCallbackRange = [paras rangeOfString:@"&callback="];
    
    NSRange kParamRange;
    kParamRange = [paras rangeOfString:@"&param="];
    
    
    
    CFIndex parasLen=[paras length];
    CFIndex methodLocation=kMethodRange.location+kMethodRange.length;
    CFIndex callbackLocation=kCallbackRange.location+kCallbackRange.length;
    CFIndex paramLocation=kParamRange.location+kParamRange.length;
    
    NSRange methodRange=NSMakeRange(0, 0);
    NSRange callbackRange=NSMakeRange(0, 0);
    NSRange paramRange=NSMakeRange(0, 0);
    
    
    if(kMethodRange.location==NSNotFound){
        return paramsDict;
    }
    
    if(kCallbackRange.location == NSNotFound&&kParamRange.location == NSNotFound){
        methodRange =NSMakeRange(methodLocation, parasLen-methodLocation);
        
    }else if(kCallbackRange.location != NSNotFound&&kParamRange.location == NSNotFound){
        methodRange =NSMakeRange(methodLocation, kCallbackRange.location-methodLocation);
        callbackRange = NSMakeRange(callbackLocation, parasLen-callbackLocation);
        
    }else if(kCallbackRange.location == NSNotFound&&kParamRange.location != NSNotFound){
        methodRange =NSMakeRange(methodLocation, kParamRange.location-methodLocation);
        paramRange = NSMakeRange(paramLocation, parasLen-paramLocation);
        
    }else if(kCallbackRange.location != NSNotFound&&kParamRange.location != NSNotFound){
        if(callbackLocation<paramLocation){
            methodRange =NSMakeRange(methodLocation, kCallbackRange.location-methodLocation);
            callbackRange = NSMakeRange(callbackLocation, kParamRange.location-callbackLocation);
            paramRange = NSMakeRange(paramLocation, parasLen-paramLocation);
            
        }else{
            methodRange =NSMakeRange(methodLocation, kParamRange.location-methodLocation);
            paramRange = NSMakeRange(paramLocation, kCallbackRange.location-paramLocation);
            callbackRange = NSMakeRange(callbackLocation, parasLen-callbackLocation);
            
        }
    }else {
        
    }
    
    
    NSString *method = esString([esString([paras substringWithRange:methodRange]) stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    [paramsDict setObject:method forKey:@"method"];
    
    NSString *callback = esString([esString([paras substringWithRange:callbackRange]) stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    [paramsDict setObject:callback forKey:@"callback"];

    
    
    NSString *param = esString([esString([paras substringWithRange:paramRange]) stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    [paramsDict setObject:param forKey:@"param"];


    return paramsDict;
}

+ (NSDictionary*)paramsFromURL:(NSURL*)url
{
    return [self paramsFromURL:url usingEncoding:NSUTF8StringEncoding];
}

+ (NSDictionary*)paramsFromURL:(NSURL*)url usingEncoding:(NSStringEncoding)encoding {
    NSString *query = [url query];
    
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:query];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSString* value = [[kvPair objectAtIndex:1]
                               stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSString* decodeValue = [self decodeURLString:value];
            
            [pairs setObject:decodeValue forKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}


+ (NSURL *)urlWithUrlString:(NSString *)url withParams:(NSDictionary *)params
{
    NSString *requestURLString = [NSString stringWithFormat:@"%@",url];
    if ([requestURLString rangeOfString:@"?"].location != NSNotFound) {
        requestURLString = [requestURLString stringByAppendingString:@"?"];
    } else {
        requestURLString = [requestURLString stringByAppendingString:@"&"];
    }
    
    for (NSString *key in params.allKeys) {
        requestURLString = [requestURLString stringByAppendingFormat:@"%@=%@", key, [params objectForKey:key]];
        
        if ([params.allKeys indexOfObject:key] != params.allKeys.count - 1) {
            requestURLString = [requestURLString stringByAppendingString:@"&"];
        }
    }
    
    return [NSURL URLWithString:requestURLString];
}

// url 编码
CFStringRef nonAlphaNumValidChars = CFSTR("!$&'()*+,-./:;=?@_~");

+ (NSString *)encodeURLString:(NSString *)text
{
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                        (__bridge CFStringRef)text, NULL,
                                                                        nonAlphaNumValidChars,
                                                                        kCFStringEncodingUTF8);
}

+ (NSString *)decodeURLString:(NSString *)urlString
{
    
    return (__bridge NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                        (__bridge CFStringRef)urlString,
                                                                        CFSTR(""),
                                                                        kCFStringEncodingUTF8);
}

#pragma mark - 收到 url 打开app
+ (NSDictionary *)getParamsFromOtherApp:(NSURL *)url
{
//    return nil;
//    NSString *original = @"com.iyaya.mmbang://app/hospital/topics/shanghai%2Fguojifuyoubaojianyuan/国妇婴/1/";
//    original = [original stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *originalURL = [NSURL URLWithString:original];
//    DLog(@" %@ ",originalURL);
//    NSMutableArray *pathComponents = [[originalURL pathComponents] mutableCopy];
    
    // 不能用 [url path] 是因为会先decode
    NSArray *array = [[url absoluteString] componentsSeparatedByString:@"/"];
    NSMutableArray *pathComponents = [array mutableCopy];
    
    if (pathComponents.count >= 4) {
        // 删除 前面的 com.iyaya.mmbang://app
        [pathComponents removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];
        // 删除最后的 空字符串
        if ([pathComponents.lastObject isKindOfClass:[NSString class]] &&
            [pathComponents.lastObject isEqualToString:@""]) {
            [pathComponents removeLastObject];
        }
    }
    
    if (pathComponents.count <1) {
        return nil;
    }
    
    // 去掉 编码
    for (int i = 0; i < pathComponents.count; i++) {
        id content = pathComponents[i];
        if ([content isKindOfClass:[NSString class]]) {
            NSString *newContent = [content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [pathComponents replaceObjectAtIndex:i withObject:newContent];
        }
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *target = pathComponents[0];
    params[@"target"] = target; // 赋值 target
    if ([target isEqualToString:@"shop"])
    {
        if (pathComponents.count >= 3) {
            NSInteger index = [pathComponents[2] integerValue];
            params[@"item_id"] = [NSString stringWithFormat:@"%@",@(index)];
        }
        
    } else if ([target isEqualToString:@"user"])
    {
        if (pathComponents.count >= 4) {
            params[@"subTarget"] = pathComponents[1];
            params[@"order_id"] = pathComponents[2];
            NSInteger index = [pathComponents[3] integerValue];
            params[@"status"] = [NSNumber numberWithInteger:index];
        }else if (pathComponents.count >= 2) {
            params[@"subTarget"] = pathComponents[1];
        }
    }else if([target isEqualToString:@"webview"]) {
        if (pathComponents.count >= 3) {
            if ([pathComponents[1] isEqualToString:@"navigate"]) {
                params[@"hasNav"] = [NSNumber numberWithBool:YES];
                params[@"link"] = pathComponents[2];
                }
            } else if (pathComponents.count >= 2) {
                params[@"hasNav"] = [NSNumber numberWithBool:NO];
                params[@"link"] = pathComponents[1];
            }
    }
    
    return params;
}

@end
