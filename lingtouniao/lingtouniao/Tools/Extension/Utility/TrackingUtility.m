//
//  TrackingUtility.m
//  mmbang
//
//  Created by wupeijing on 6/19/15.
//  Copyright (c) 2015 iyaya. All rights reserved.
//

//#import "MobClick.h"
#import "TalkingData.h"
#import "ServerEnvironmentConstants.h"

@implementation TrackingUtility

+ (void)startTracking {
    for (id cls in [self trackingCls]) {
//        if ([cls isEqual:[MobClick class]]) {
//            //umeng configure
//            [self umengTrack];
//        }
        if ([cls isEqual:[TalkingData class]]) {
            [self tdTrack];
        }
    }
}

+ (void)event:(NSString *)eventId {
    for (id cls in [self trackingCls]) {
        if ([cls respondsToSelector:@selector(event:)]) {
            [cls  event:eventId];
        } else if([cls respondsToSelector:@selector(trackEvent:)]) {
            [cls trackEvent:eventId];
        }
    }
}

+ (void)event:(NSString *)eventId label:(NSString *)label {
    for (id cls in [self trackingCls]) {
        if ([cls respondsToSelector:@selector(event:label:)]) {
            [cls  event:eventId label:label];
        } else if([cls respondsToSelector:@selector(trackEvent:label:)]) {
            [cls trackEvent:eventId label:label];
        }
    }
}

+ (void)beginLogPageView:(NSString *)pageName {
    for (id cls in [self trackingCls]) {
        if ([cls respondsToSelector:@selector(beginLogPageView:)]) {
            [cls  beginLogPageView:pageName];
        } else if([cls respondsToSelector:@selector(trackPageBegin:)]) {
            [cls trackPageBegin:pageName];
        }
    }
}

+ (void)endLogPageView:(NSString *)pageName {
    for (id cls in [self trackingCls]) {
        if ([cls respondsToSelector:@selector(endLogPageView:)]) {
            [cls  endLogPageView:pageName];
        } else if([cls respondsToSelector:@selector(trackPageEnd:)]) {
            [cls trackPageEnd:pageName];
        }
    }
}

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes {
    for (id cls in [self trackingCls]) {
        if ([cls respondsToSelector:@selector(event:attributes:)]) {
            [cls event:eventId attributes:attributes];
        } else if([cls respondsToSelector:@selector(trackEvent:label:parameters:)]) {
            [cls trackEvent:eventId label:eventId parameters:attributes];
        }
    }
}

+ (NSArray *)trackingCls {
    static NSArray *trackingClsNames;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        trackingClsNames = @[[TalkingData class]];
    });
    return trackingClsNames;
}

#pragma mark - UMeng V 3.4.6
+ (void)umengTrack {
//    //    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行,SDK默认是开启crash收集功能
//
//    NSString *channel = nil;
//#if defined MMB_BUILD_FOR_RELEASE
//    [MobClick setLogEnabled:NO];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
//#else
//    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
//    channel = @"91mobile";
//#endif
//
//    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
//    //
//    [MobClick startWithAppkey:APP_KEY reportPolicy:(ReportPolicy) SENDWIFIONLY channelId:channel];
//    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
//    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
//
//    //      [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
//    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
//
//    [MobClick updateOnlineConfig];  //在线参数配置
//
//    //    1.6.8之前的初始化方法
//    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
}

+ (void)onlineConfigCallBack:(NSNotification *)note {
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}

+ (void)tdTrack {
    NSString *channel = @"AppStore";
#ifndef BUILD_FOR_RELEASE
    channel = @"TestChannel";
#endif
    [TalkingData sessionStarted:@"347A57A4BC8EA90EB44C6A4BD48E0F27" withChannelId:channel];
    [TalkingData setExceptionReportEnabled:YES];
    [TalkingData setSignalReportEnabled:YES];
}

@end
