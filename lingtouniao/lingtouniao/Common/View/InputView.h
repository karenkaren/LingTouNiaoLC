//
//  LoginView.h
//  haowan
//
//  Created by wupeijing on 3/27/15.
//  Copyright (c) 2015 iyaya. All rights reserved.
//

typedef enum : NSUInteger {
    InPutPageStlyeNormal
} InPutPageStlye;

@interface InputView : UIView

@property (nonatomic)UITextField *usernameTextField;
@property (nonatomic)UITextField *passwordTextField;
@property (nonatomic)UIButton *commitBtn;

- (instancetype)initWithStyle:(InPutPageStlye)style;

@end
