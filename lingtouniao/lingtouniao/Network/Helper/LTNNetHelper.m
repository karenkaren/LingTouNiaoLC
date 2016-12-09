//
//  LTNNetHelper.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/11/11.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNNetHelper.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "LTNNetManager.h"
#import "LTNLoginController.h"
#import "JPUSHService.h"

#import "NetDataCacheManager.h"

#define private_key @"ltn$%^qpdhTH18"

@interface HttpRequestSerializer : AFHTTPRequestSerializer

@end

@implementation HttpRequestSerializer

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(id)parameters
                                     error:(NSError *__autoreleasing *)error {
    NSMutableURLRequest *request = [super requestWithMethod:method URLString:URLString parameters:parameters error:error];
    
    DLog(@"request url:%@   ----参数%@",request.URL, parameters);

    //default timeout is 10s
    request.timeoutInterval = 10.0;

    NSMutableDictionary *dict = [parameters mutableCopy];
    [dict setValue:private_key forKey:@"private_key"];
    NSString *sign = [Utility sign:dict];
    [request setValue:sign forHTTPHeaderField:@"header_sign"];

    return request;
}

@end

@implementation LTNNetHelper

+ (AFHTTPSessionManager *)manager {
    static dispatch_once_t onceToken;
    static AFHTTPSessionManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        
        NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
        [NSURLCache setSharedURLCache:URLCache];
    });
    return manager;
}

+ (void)configHttpManager {
    AFHTTPSessionManager * manager = [self manager];
    
    //config request Serializer which sets a default timeout
    manager.requestSerializer = [[HttpRequestSerializer alloc] init];
}

static NSString *pathKey(NSString *path, NSDictionary *parameters){
    if(parameters){
        return [path stringByAppendingFormat:@"?%@", AFQueryStringFromParameters(parameters)];
    }
    return path;
}

+ (NSURLSessionDataTask *)requestWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure method:(NSString *)method
{
    AFHTTPSessionManager * manager = [self manager];
    
    NSString *registrationID= [JPUSHService registrationID];
    if(registrationID){
        [manager.requestSerializer setValue:registrationID
                         forHTTPHeaderField:@"registration-id"];
    }
    
    
//    [manager.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];

    void (^block)(NSURLSessionDataTask * _Nonnull operation, id  _Nonnull responseObject) = ^(NSURLSessionDataTask * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@, %@", path, responseObject);
        if ([responseObject[@"resultCode"] integerValue] == 10000005 || [responseObject[@"resultCode"] integerValue] == 10000006) {
            success(nil);
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"hasPopAlert"]) {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hasPopAlert"];
                return;
            }
            
            [[CurrentUser mine] reset];
            [LTNCore popToRootControllers];
            //[[LTNCore globleCore] backToMainController];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_Exit_Success object:nil];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:locationString(@"login_status_error") delegate:nil cancelButtonTitle:locationString(@"reset_password") otherButtonTitles:locationString(@"login_again"), nil];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasPopAlert"];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hasPopAlert"];
                if(buttonIndex==0){
                    //密码重置
                    [LTNCore resetPassword];
                }else{
                    //登陆成功不会跳转我的帐户
                    [[LTNCore globleCore] loginController:nil];
                }
                
            }];
        } else {
            
            if(!esBool(params[@"isGetMore"])){
                if(shouldCache(path)){
                    [NetDataCacheManager saveCacheWithObject:responseObject forURLKey:pathKey(path, params) completion:nil];
                }
            }
            success(responseObject);
        }
    };
    
    
    if(![LTNNetManager sharedLTNNetManager].isAvailable) {
        if(shouldCache(path)){
            if(!esBool(params[@"isGetMore"])){
                NSString *responseCacheObject=[NetDataCacheManager readCacheWithURLKey:pathKey(path, params)];
                if(responseCacheObject){
                    success(responseCacheObject);
                    
                    return nil;
                }

            }
            
        }
    }

    NSURLSessionDataTask *op;
    if ([method isEqualToString:kPostMethod]) {

       op = [manager POST:path parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
           DLog(@"%@", path);
           block(task, responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            DLog(@"%@", path);
            failure(error);
        }];
        
    } else {
        op = [manager GET:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull operation, id  _Nonnull responseObject) {
            DLog(@"%@", path);
            block(operation, responseObject);
       } failure:^(NSURLSessionDataTask * _Nullable operation, NSError * _Nonnull error) {
           DLog(@"%@", path);
            failure(error);
        }];
    }
    return op;
}

+ (NSURLSessionDataTask *)postWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    return [self requestWithPath:path params:params success:success failure:failure method:kPostMethod];
}

+ (NSURLSessionDataTask *)getWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    return [self requestWithPath:path params:params success:success failure:failure method:kGetMethod];
}

+ (void)moniterNetworking
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [LTNNetManager sharedLTNNetManager].isAvailable = status ? YES : NO;
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

@end
