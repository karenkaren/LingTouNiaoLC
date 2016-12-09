//
//  LTNNetHelper.h
//  lingtouniao
//
//  Created by LiuFeifei on 15/11/11.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"


@interface LTNNetHelper : NSObject

typedef void (^HttpSuccessBlock)(id response);
typedef void (^HttpFailureBlock)(NSError * error);

//config AFHTTPRequestOperationManager
+ (void)configHttpManager;

/**
 *  GET请求接口
 *
 *  @param path    接口路径，可传完整的url
 *  @param params  接口中所需的参数
 *  @param success 接口成功请求到数据的回调
 *  @param failure 接口请求数据失败的回调
 */
+ (NSURLSessionDataTask *)getWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;

/**
 *  POST请求接口
 *
 *  @param path    接口路径，可传完整的url
 *  @param params  接口中所需的参数
 *  @param success 接口成功请求到数据的回调
 *  @param failure 接口请求数据失败的回调
 */
+ (NSURLSessionDataTask *)postWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;

+ (void)moniterNetworking;

@end
