//
//  KeyValueStoreManager.h
//  lingtouniao
//
//  Created by zhangtongke on 16/6/15.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKKeyValueStore.h"
@interface KeyValueStoreManager : NSObject
@property (nonatomic,strong)YTKKeyValueStore *store;
+ (KeyValueStoreManager *)shareManager;


-(void)putTipsIntoDB:(NSArray *)tipsArray;
-(NSArray *)getTips;
+(NSString *)tipWithKey:(NSString *)tipKey;





//静态资源
+(NSString *)getStaticVersion;
+(NSString *)locationStringFromDB:(NSString *)key;
+(NSDictionary *)getStaticStrings;
+(void)putStaticStrings:(NSDictionary *)stringsDic;
@end
