//
//  BaseDataEngine.m
//  mmbang
//
//  Created by 肖信波 on 13-8-30.
//  Copyright (c) 2013年 iyaya. All rights reserved.
//

#import "BaseDataEngine.h"
#import "UrlParamUtil.h"
#import "LTNNetHelper.h"
#import "ServerEnvironmentConstants.h"
#import "DtoContainer.h"
#import "LTNServerConstant.h"

#define kApiCode @"resultCode"
#define kApiMsg @"resultMessage"
#define kApiData @"data"

#define kDataParseError @"Data parse error"
#define API_ERROR_CODE_JSONMODEL_ERROR 10000

@interface BaseDataEngine ()


+ (void)onComplete:(void (^)(id responseObj, NSError *error))block
         operation:(NSURLSessionDataTask *)operation
              json:(id)JSON
responseModelClass:(Class)responseModelClass
             error:(NSError **)outError;

@end

@implementation BaseDataEngine

+ (void)apiForPath:(NSString *)path method:(NSString *)method parameter:(NSMutableDictionary *)parameters responseModelClass:(Class)class onComplete:(APIComletionBlock)block {
    void (^resultBlock)(NSDictionary *data, NSError *error) = ^(NSDictionary *data, NSError *error) {
        if (block) {
            if (class) {
                DtoContainer *resp = (DtoContainer *)data;
                id dataContent = nil;
                if ([resp isKindOfClass:[DtoContainer class]]) {
                    dataContent = resp.data;
                }
                block(resp, dataContent, error);
            } else {
                block(data, [data valueForKey:@"data"], error);
            }
        }
    };

    NSString *fullPath=absolutePath(path);
    if([path hasPrefix:@"http"])
        fullPath=path;
    else{
        fullPath = [NSString stringWithFormat:@"%@%@", API_BASE_URL, path];
    }
   

    if ([[method uppercaseString] isEqualToString:kGetMethod]) {
        [self getPath:fullPath param:parameters responseModelClass:class onComplete:resultBlock];
    } else {
        [self postPath:fullPath param:parameters responseModelClass:class onComplete:resultBlock];
    }
}

+ (NSURLSessionDataTask *)getPath:(NSString *)path param:(NSDictionary *)parameters responseModelClass:(Class)responseClass onComplete:(void (^)(id, NSError *))block
{

    NSMutableDictionary *dict = [self rebuildParameter:parameters];

    __block NSURLSessionDataTask *op;
    op = [LTNNetHelper getWithPath:path params:dict success:^(id response) {
        [self onComplete:block operation:op json:response responseModelClass:responseClass error:nil];
    } failure:^(NSError * error) {
        if (block) {
            block(nil, error);
        }
    }];

    return op;
}

+ (NSURLSessionDataTask *)postPath:(NSString *)path param:(NSDictionary *)parameters responseModelClass:(Class)responseClass
onComplete:(void (^)(id, NSError *))block
{
    NSMutableDictionary *dict = [self rebuildParameter:parameters];

    __block NSURLSessionDataTask *op;
    op = [LTNNetHelper postWithPath:path params:dict success:^(id response) {
        [self onComplete:block operation:op json:response responseModelClass:responseClass error:nil];
    } failure:^(NSError * error) {
        if (block) {
            block(nil, error);
        }
    }];

    return op;
}

+ (void)onComplete:(void (^)(id responseObj, NSError *error))block
         operation:(NSURLSessionDataTask *)operation
              json:(id)JSON
responseModelClass:(__unsafe_unretained Class)responseModelClass
             error:(NSError **)outError
{
    NSError *error;
    id data = JSON;
    DLog(@"服务器返回数据:%@", JSON);

    NSInteger errorcode = [[JSON valueForKey:kApiCode] integerValue];

    if (errorcode != 0) {

        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        id message = [JSON valueForKey:kApiMsg];

        if (message) {
            [userInfo setObject:message forKey:@"message"];
        }
        [userInfo setObject:@(errorcode) forKey:@"code"];

        error = [[NSError alloc] initWithDomain:kServerAPIErrorDomain
                                           code:errorcode
                                       userInfo:userInfo];
    } else if (responseModelClass) {
                DtoContainer *responseObj = [self modelObjectFromJSONDict:JSON withModelClass:responseModelClass error:&error];
                data = responseObj;
    }

    if (outError) {
        *outError = error;
    }

    if (error) {
        BOOL shouldAlert = [self shouldShowAlertForOperation:operation json:JSON error:error];
        if (shouldAlert) {
            
            
            [LTNUtilsHelper boxShowWithMessage:[error.userInfo objectForKey:@"message"]];
            
            /*
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[error.userInfo objectForKey:@"message"] delegate:nil cancelButtonTitle:locationString(@"know") otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {

            }];
             */
            
        }
    }

    if (block) {
        block(data, error);
    }
}


+ (id)modelObjectFromJSONDict:(NSDictionary *)dict withModelClass:(Class)modelClass error:(NSError *__autoreleasing *)error{
    NSParameterAssert(error != nil);
    DtoContainer *aModel = [[DtoContainer alloc] init];
    aModel.resultCode = [dict[kApiCode] integerValue];
    aModel.resultMessage = dict[kApiMsg];
    aModel.totalCount = [[dict valueForKeyPath:@"data.totalCount"] integerValue];
    BaseModel *model = nil;

    @try {
        model = [(BaseModel *)[modelClass alloc] init];

        NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:dict];
        [model mj_setKeyValues:dictM[kApiData]];
    } @catch (NSException *exception) {
        NSLog(@"DataModel parse error: %@", exception);
        if (error) {
            *error = [NSError errorWithDomain:kDataParseError
                                         code:API_ERROR_CODE_JSONMODEL_ERROR
                                     userInfo:@{
                                                NSLocalizedDescriptionKey: locationString(@"analytical_data_type_mismatch_error"),
                                                @"message": locationString(@"analytical_error")
                                                }];
        }
    } @finally {

    }

    if (*error) {
        model = nil;
    }

    aModel.data = model;
    return aModel;
}

#pragma mark - silent api support
+ (NSSet *)silentAPIs{
    static NSSet *silentAPIs;
    static dispatch_once_t onceTokenSilentApi;
    dispatch_once(&onceTokenSilentApi, ^{
        silentAPIs = [NSSet setWithArray:@[
                                           kCheckUpdateUrl,
                                           kUserLogoutUrl,
                                           ]
                      ];
    });
    return silentAPIs;
}

+ (BOOL)isSilentApi:(NSString *)path {
    BOOL ret = NO;
    NSSet *silentAPIs = [self silentAPIs];
    if ([silentAPIs containsObject:path]) {
        ret = YES;
    }
    return ret;
}

+ (BOOL)shouldShowAlertForOperation:(NSURLSessionDataTask *)operation json:(id)JSON error:(NSError *)error
{
    NSString *urlString = [[[operation currentRequest] URL] path];
    return ![self isSilentApi:urlString];
}

+ (NSDictionary *)commonStaticParams {
    static dispatch_once_t onceTokenStaticData;
    static NSMutableDictionary *staticData;

    dispatch_once(&onceTokenStaticData, ^{
        staticData = [[NSMutableDictionary alloc] init];
        [staticData setObject:@"AppStore" forKey:@"channel"];
        [staticData setObject:[[UIDevice currentDevice] systemVersion] forKey:@"osVersion"];
        [staticData setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forKey:@"appVersion"];
        [staticData setObject:@"1" forKey:@"app_client_id"];
        [staticData setObject:@"I" forKey:@"clientType"];
    });

    return staticData;
}

+ (NSString *)screenSize:(BOOL)isWidth {

    CGSize size = [[UIScreen mainScreen] currentMode].size;
    NSString *width = [NSString stringWithFormat:@"%.0f", size.width];
    NSString *height = [NSString stringWithFormat:@"%.0f", size.height];

    if (isWidth) {
        return width;
    }
    return height;
}

+ (NSMutableDictionary *)rebuildParameter:(NSDictionary *)parameters
{
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:parameters];

    NSDictionary *staticData = [self commonStaticParams];
    [mutDict addEntriesFromDictionary:staticData];
    NSString * sessionKey = [CurrentUser mine].sessionKey;
    if (sessionKey) {
        [mutDict setValue:sessionKey forKey:@"sessionKey"];
    }
    return mutDict;
}

@end
