//
//  KeyValueStoreManager.m
//  lingtouniao
//
//  Created by zhangtongke on 16/6/15.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "KeyValueStoreManager.h"

@implementation KeyValueStoreManager

#define KeyValueName @"LingTouNiao.db"
#define TipsTable @"TipsTable"


#define StaticStringsTable @"StaticStringsTable"


static KeyValueStoreManager *_sharedKeyValueStoreManager = nil;
+ (KeyValueStoreManager *)shareManager
{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        _sharedKeyValueStoreManager = [[self alloc] init];
    });
    return _sharedKeyValueStoreManager;
}

-(instancetype)init
{
    if(self=[super init])
    {
        _store = [[YTKKeyValueStore alloc] initDBWithName:KeyValueName];
        [_store createTableWithName:TipsTable];
        
        [_store createTableWithName:StaticStringsTable];
        
        
    }
    return self;
    
}


-(void)putTipsIntoDB:(NSArray *)tipsArray{
    [_store putObject:tipsArray withId:@"tips" intoTable:TipsTable];

}

-(NSArray *)getTips{
    return [_store getObjectById:@"tips" fromTable:TipsTable];
}


//BIRD_TIP  NOPWD_TIP

+(NSString *)tipWithKey:(NSString *)tipKey{
    NSArray *tips= [[KeyValueStoreManager shareManager] getTips];
    if( isArray(tips)&& [tips count]>0){
        for (NSDictionary *tipDic in tips){
            if([tipDic[@"itemName"] isEqualToString:tipKey]){
                return tipDic[@"itemDescribe"];
            }
        }
    }
    
    return @"";
}







//静态资源
+(NSDictionary *)getStaticStrings{
    NSDictionary *dic=[[KeyValueStoreManager shareManager].store getObjectById:@"staticSourceList" fromTable:StaticStringsTable];
    if(isDictionary(dic))
        return dic;
    return nil;
    
}


//静态资源版本
+(NSString *)getStaticVersion{
    NSString *staticVersion=[[KeyValueStoreManager shareManager].store getStringById:@"staticVersion" fromTable:StaticStringsTable];
    return staticVersion;
    
}



+(NSString *)locationStringFromDB:(NSString *)key{
    NSString *locationString=[[KeyValueStoreManager shareManager].store getObjectById:key fromTable:StaticStringsTable];
    return locationString;
}

//静态资源
+(void)putStaticStrings:(NSDictionary *)staticDic{
    
    
    if(!isDictionary(staticDic))
        return;
    NSArray *staticSourceList=staticDic[@"staticSourceList"];
    
    NSString *staticVersion= esString(staticDic[@"staticVersion"]);
    
    if([staticVersion length]==0){
        [[KeyValueStoreManager shareManager].store clearTable:StaticStringsTable];
        return;
    }
    
    NSString *currentVersion=[KeyValueStoreManager getStaticVersion];
    if([currentVersion isEqualToString:staticVersion])
        return;
    
    if(!isArray(staticSourceList))
        return;
   
    
    NSMutableDictionary *tempDic=[NSMutableDictionary dictionary];
    
    
    [staticSourceList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //
        
        NSDictionary *staticSource=(NSDictionary *)obj;
        if(isDictionary(staticSource)){
            
            NSString *sourceEN=esString(staticSource[@"sourceEN"]);
            
            
            NSString *sourceDetail=esString(staticSource[@"sourceDetail"]);
            sourceDetail = [self checkout:sourceDetail];
            if([sourceEN length]>0&&[sourceDetail length]>0){
                
                [tempDic setObject:sourceDetail forKey:sourceEN];
                
             }
            
        }
    }];
    
    if([[tempDic allKeys] count]>0){
        
        [[KeyValueStoreManager shareManager].store putObject:tempDic withId:@"staticSourceList" intoTable:StaticStringsTable];
        [[KeyValueStoreManager shareManager].store putString:staticVersion withId:@"staticVersion" intoTable:StaticStringsTable];
        
    }
    /*
    [stringsDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [_store putObject:obj withId:key intoTable:StringsTable];
    }];
     */

}


+(NSString *)checkout:(NSString *)originalString{
    originalString = [originalString stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    return originalString;
}


//-(NSString *)tipWithKey:(NSString *)tipKey{
//    NSArray *tips=[self getTips];
//    
//    return
//}

@end
