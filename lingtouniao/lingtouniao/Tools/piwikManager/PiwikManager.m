//
//  PiwikManager.m
//  lingtouniao
//
//  Created by zhangtongke on 16/8/26.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "PiwikManager.h"

@implementation PiwikManager
singleton_implementation(PiwikManager)





void piwikEvent(NSString *action,NSArray *customVariables){
    
    for(int i=0;i<[customVariables count];i++){
        NSArray *arr=customVariables[i];
        [[PiwikTracker sharedInstance] setCustomVariableForIndex:i+1 name:arr[0] value: arr[1] scope:ScreenCustomVariableScope];
    }
    
    
    [[PiwikTracker sharedInstance] sendEventWithCategory:@"ios" action:action name:@"" value:@(0)];
    
    //[[PiwikTracker sharedInstance] dispatch];
    
}





/*
 
 @{
 @"result":
 @"source":
 @"reason":
 
 }


 
 
 */


@end
