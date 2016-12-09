//
//  LTNUser.m
//  lingtouniao
//
//  Created by  mathe on 15/12/17.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNUser.h"


@implementation LTNUser

@synthesize userInfo = _userInfo;

- (UserInfoModel *)userInfo {
    if (!_userInfo) {
        if ([[CurrentUser mine] hasLogged]) {
            id data = [Utility getDataWithKey:kDefaultUserInfoKey];
            if (data) {
                UserInfoModel *tmpUser = (UserInfoModel *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
                NSString *mobile = tmpUser.mobile;
                NSString *userMobile = [[NSUserDefaults standardUserDefaults] valueForKey:kUserNameKey];
                if ([mobile isEqualToString:userMobile]) {
                    _userInfo = tmpUser;
                }
            }
        }
    }
    return _userInfo;
}


- (void)setUserInfo:(UserInfoModel *)userInfo {
    if (_userInfo != userInfo) {
        
        _userInfo = userInfo;
        
        
        id data = [NSKeyedArchiver archivedDataWithRootObject:_userInfo];
        [Utility saveDataWithKey:kDefaultUserInfoKey ofValue:data];
        
        [PiwikTracker sharedInstance].userID = _userInfo.mobile;
        [PiwikTracker sharedInstance1].userID = _userInfo.mobile;
    }
}

@end
