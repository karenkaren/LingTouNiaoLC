//
//  LTNKeyChainManager.h
//  lingtouniao
//
//  Created by  mathe on 15/12/17.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UICKeyChainStore.h"

@interface LTNKeyChainManager : NSObject
+ (instancetype)defaultManager;

+(NSString *)keychainUUID;
+(void)storeUsername:(NSString *)username password:(NSString *)password;
+(NSDictionary *)getUsernameAndPassword;

@end
