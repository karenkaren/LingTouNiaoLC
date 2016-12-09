//
//  PiwikManager.h
//  lingtouniao
//
//  Created by zhangtongke on 16/8/26.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PiwikManager : NSObject
singleton_interface(PiwikManager)


extern void piwikEvent(NSString *action,NSArray *customVariables);
@end
