//
//  DownloadManager.m
//  lingtouniao
//
//  Created by zhangtongke on 16/5/24.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "DownloadManager.h"

@implementation DownloadManager

/**
 *  @author Jakey
 *
 *  @brief  下载文件
 *
 *  @param paramDic   附加post参数
 *  @param requestURL 请求地址
 *  @param savedPath  保存 在磁盘的位置
 *  @param success    下载成功回调
 *  @param failure    下载失败回调
 *  @param progress   实时下载进度回调
 */
//- (void)downloadFileWithOption:(NSDictionary *)paramDic
//                 withInferface:(NSString*)requestURL
//                     savedPath:(NSString*)savedPath
//               downloadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
//               downloadFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
//                      progress:(void (^)(float progress))progress
//
//{
//    
//    //沙盒路径    //NSString *savedPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/xxx.zip"];
//    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
//    NSMutableURLRequest *request =[serializer requestWithMethod:@"POST" URLString:requestURL parameters:paramDic error:nil];
//  
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
//    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:savedPath append:NO]];
//    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//        float p = (float)totalBytesRead / totalBytesExpectedToRead;
//        progress(p);
//        NSLog(@"download：%f", (float)totalBytesRead / totalBytesExpectedToRead);
//        
//    }];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        success(operation,responseObject);
//        NSLog(@"下载成功");
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        success(operation,error);
//        
//        NSLog(@"下载失败");
//        
//    }];
//    
//    [operation start];
//    
//}
@end
