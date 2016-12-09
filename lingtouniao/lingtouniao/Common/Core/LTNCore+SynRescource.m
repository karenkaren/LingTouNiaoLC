//
//  LTNCore+SynRescource.m
//  lingtouniao
//
//  Created by zhangtongke on 16/6/22.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNCore.h"
#import "ZipArchive.h"
#import "SplashModel.h"
#import "UIDevice+ESInfo.h"
#import "UIImageView+WebCache.h"

@implementation LTNCore (SynRescource)

-(void)synRescource{
    
    //合法域名
    [BaseDataEngine apiForPath:kLegalDomain method:kPostMethod parameter:nil responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        
        if (!error&&[response[@"resultCode"] integerValue] == 0) {
            
            if(data && isDictionary(data)){
                NSDictionary *legalDomainDic=data[@"mobileDomain"];
                if(legalDomainDic&& isDictionary(legalDomainDic)){
                    NSString *domainString=legalDomainDic[@"domainUrl"];
                    if(domainString&&[domainString length]>0){
                        NSArray *array = [domainString componentsSeparatedByString:@","];
                        [[NSUserDefaults standardUserDefaults] setObject:array forKey:kLegalDomains];
                    }
                    
                }
            }
            
        }
        
    }];

    //tips
    [BaseDataEngine apiForPath:kSysConfig method:kPostMethod parameter:nil responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        
        if (!error&&[response[@"resultCode"] integerValue] == 0) {
            if(data && isDictionary(data)){
                
                NSArray *dictItems=data[@"dictItems"];
                if(dictItems && isArray(dictItems)){
                    [[KeyValueStoreManager shareManager] putTipsIntoDB:dictItems];
                }
                
            }
        }
        
    }];
    
    
    
    NSString *currentStaticVersion=[KeyValueStoreManager getStaticVersion];
    
    NSMutableDictionary *parameter= [NSMutableDictionary dictionaryWithDictionary:@{@"sourceVersion":esString(currentStaticVersion)}];
    
   
    //静态资源
    [BaseDataEngine apiForPath:kStaticSource method:kGetMethod parameter:parameter responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        
        if (!error&&[response[@"resultCode"] integerValue] == 0) {
            
            ESDispatchOnDefaultQueue(^{
                [KeyValueStoreManager putStaticStrings:response[@"data"]];
            });
        }
    }];

       
    // 获取银行列表
    [LTNServerHelper retrieveBankListWithFinishBlock:nil];
    // 获取banner列表
    [LTNServerHelper retrieveBannerListWithFinishBlock:nil];
    
    // 更新启动页
    [self updateLaunch];
    
    //同步资源
   // [self createDictionary];
   // [self test];
    
}

- (void)updateLaunch
{
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    [parameter setObject:[UIDevice deviceString] forKey:@"scale"];
    NSString * version = [SplashModel sharedSplash].version ? : @"";
    [parameter setObject:version forKey:@"version"];
    [BaseDataEngine apiForPath:kFirstPage method:kGetMethod parameter:parameter responseModelClass:[SplashModel class] onComplete:^(id response, id data, NSError *error) {
        if (!error) {
            SplashModel * splashModel = (SplashModel *)data;
            // 如果版本号不一致，保存新数据
            if (![splashModel.version isEqualToString:[SplashModel sharedSplash].version]) {
                if ([splashModel.version isEqualToString:@""]) {
                    // 如果version为空，直接保存相关数据
                    [NSKeyedArchiver archiveRootObject:splashModel toFile:kSplashModelPath];
                    return;
                }
                // 下载图片
                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:splashModel.splash.pageUrl] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    if (finished) {
                        // 写入成功再保存相关数据
                        [NSKeyedArchiver archiveRootObject:splashModel toFile:kSplashModelPath];
                    }
                }];
            }
        }
    }];
}

/**
 *   生成文件目录
 */
-(void)createDictionary{
    ESTouchDirectory(ESPathForTemporaryResource(@"ltn_rescource"));
}
/**
 *   请求服务器看是否有新的资源
 */
-(void)requestIfShouldSyn{
    
}

/**
 *   下载最新资源,下载成功后，删除原有资源，解压最新资源，
 */

-(void)downloadNewRescource{
    
}


+(void)addchangeableImageView:(UIView *)view{
    [[LTNCore globleCore].changeableImageViews addObject:view];
}


/**
 *   测试
 */

-(void)test{
//    NSString *origalPath=ESPathForMainBundleResource(@"rescource.zip");
    NSString *origalPath=[[NSBundle mainBundle] pathForResource:@"rescource" ofType:@"zip"];
//    BOOL success=[[NSFileManager defaultManager] copyItemAtPath:origalPath toPath:[ESPathForTemporaryResource(@"ltn_rescource") stringByAppendingPathComponent:[origalPath lastPathComponent]] error:NULL];
    
    
    BOOL success=[self  copyMissingFile:origalPath toPath:ESPathForTemporaryResource(@"ltn_rescource")];
    
    
    NSLog(@"subpahts==%@  ,%d",[[NSFileManager defaultManager] subpathsAtPath:ESPathForTemporaryResource(@"ltn_rescource")],success);
    
    
    
    
    //解压
    
    
    NSString *rescourcePath=ESPathForTemporaryResource(@"ltn_rescource") ;
    NSString *zipPath=[rescourcePath stringByAppendingPathComponent:@"rescource.zip"];
    ZipArchive *za = [[ZipArchive alloc] init];
    
    
    
    if ([za UnzipOpenFile: zipPath]) {
        BOOL ret = [za UnzipFileTo: rescourcePath overWrite: YES];
        if (NO == ret){} [za UnzipCloseFile];
    }
    
    
    
    
    
}


- (BOOL)copyMissingFile:(NSString *)sourcePath toPath:(NSString *)toPath

{
    
    BOOL retVal = YES; // If the file already exists, we'll return success…
    
    NSString * finalLocation = [toPath stringByAppendingPathComponent:[sourcePath lastPathComponent]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:finalLocation])
        
    {
        
        retVal = [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:finalLocation error:NULL];
        
    }
    
    return retVal;
    
}


@end
