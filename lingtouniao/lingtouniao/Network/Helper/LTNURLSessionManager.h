//
//  LTNURLSessionManager.h
//  lingtouniao
//
//  Created by zhangtongke on 16/7/26.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface LTNURLSessionManager : NSObject

@property (nonatomic,strong)AFURLSessionManager *sessionManager;

-(void)downLoadRescources:(NSArray *)imageUrlList;

@end
