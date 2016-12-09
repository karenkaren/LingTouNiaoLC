//
//  ObjectManager.h
//  lingtouniao
//
//  Created by peijingwu on 12/30/15.
//  Copyright © 2015 lingtouniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectManager : NSObject {
    
}

+ (instancetype)sharedInstance;

- (void)sendSMSMsg:(NSString *)body recipients:(NSArray *)recipients onVC:(UIViewController *)vc;


@end
