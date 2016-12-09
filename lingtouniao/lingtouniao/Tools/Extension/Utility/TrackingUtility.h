//
//  TrackingUtility.h
//  mmbang
//
//  Created by wupeijing on 6/19/15.
//  Copyright (c) 2015 iyaya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackingUtility : NSObject

+ (void)startTracking;    //start tracking
+ (void)event:(NSString *)eventId;      //log event
+ (void)event:(NSString *)eventId label:(NSString *)label; //log event with label
+ (void)beginLogPageView:(NSString *)pageName;  //enter page
+ (void)endLogPageView:(NSString *)pageName;    //exit page
+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes;

@end
