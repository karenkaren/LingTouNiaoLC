//
//  BaseDataEngine.h
//  mmbang
//
//  Created by 肖信波 on 13-8-30.
//  Copyright (c) 2013年 iyaya. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPostMethod @"POST"
#define kGetMethod @"GET"

@interface BaseDataEngine : NSObject

+ (void)apiForPath:(NSString *)path method:(NSString *)method parameter:(NSMutableDictionary *)parameters responseModelClass:(Class)class onComplete:(APIComletionBlock)block;

#pragma mark - Response Process

+ (NSSet *)silentAPIs;
+ (BOOL)isSilentApi:(NSString *)path;
+ (NSMutableDictionary *)rebuildParameter:(NSDictionary *)parameters;

@end
