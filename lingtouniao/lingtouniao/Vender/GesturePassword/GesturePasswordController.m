//
//  GesturePasswordController.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import <Security/Security.h>
#import <CoreFoundation/CoreFoundation.h>

#import "GesturePasswordController.h"
#import "KeychainItemWrapper/KeychainItemWrapper.h"
#import "UIBarButtonItem+ClearBackground.h"
#import "LTNLoginController.h"


#define CanVerifyGestureTime @"CanVerifyGestureTime"
#define RemainderNum @"RemainderNum"
#define GesturePassword @"GesturePassword"

typedef NS_ENUM(NSUInteger, GesturePasswordAction) {
    GesturePasswordCreate,//new password
    GesturePasswordVerify,// verify
    GesturePasswordModify,// modify
};

@interface GesturePasswordController ()
@property (nonatomic)GesturePasswordAction gesturePasswordAction;
@property (nonatomic,strong) GesturePasswordView * gesturePasswordView;
@property (nonatomic,strong)NSString *errorNotice;
@end

@implementation GesturePasswordController {
    NSString * previousString;
    NSString * password;
}

+(instancetype)createGesturePasswordController:(void (^)(void))dissmissBlock{
    
    if([GesturePasswordController existKeychainPassword])
        [GesturePasswordController clearKeychainPassword];
    
    GesturePasswordController *gesturePasswordController=[[GesturePasswordController alloc] init];
    gesturePasswordController.gesturePasswordAction=GesturePasswordCreate;
    gesturePasswordController.dissmissBlock=dissmissBlock;
    return gesturePasswordController;
}


+(instancetype)modifyGesturePasswordController{
    
    GesturePasswordController *gesturePasswordController=[[GesturePasswordController alloc] init];
    gesturePasswordController.gesturePasswordAction=GesturePasswordModify;
    //gesturePasswordController.dissmissBlock=dissmissBlock;
    return gesturePasswordController;

}



+(instancetype)gesturePasswordController:(void (^)(void))finishBlock{
    GesturePasswordController *gesturePasswordController=[[GesturePasswordController alloc] init];
    gesturePasswordController.gesturePasswordAction=GesturePasswordVerify;
    gesturePasswordController.finishBlock=finishBlock;
    return gesturePasswordController;
}

@synthesize gesturePasswordView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:HexRGB(0xFEFCF5) size:CGSizeMake(self.view.frame.size.width, 2)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self performSelector:@selector(initPasswordWithGesturePasswordAction) withObject:nil afterDelay:0.1];
    //[self initPasswordWithGesturePasswordAction];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, 2)] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(self.view.frame.size.width, 2)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

//    [[NSNotificationCenter defaultCenter] postNotificationName:@"GestureSuccessNotification"
//                                                        object:nil
//                                                      userInfo:nil];
}


//+ (UIView *) changeNavTitleByFontSize:(NSString *)strTitle
//{
//    //自定义标题
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
//    
//    titleLabel.backgroundColor = [UIColor clearColor];
//    [titleLabel setTextAlignment:NSTextAlignmentCenter];
//    [titleLabel setFont:[UIFont systemFontOfSize:17.f]];
//    [titleLabel setTextColor:kHexColor(@"#3a3a3a")];
//    titleLabel.text = strTitle;
//    return titleLabel;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=HexRGB(0xFEFCF5);
    
    if(_gesturePasswordAction == GesturePasswordModify){
        
        UIBarButtonItem *backButton = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"nav_return"] highlightImage:nil target:self action:@selector(back)];
        
        self.navigationItem.leftBarButtonItem = backButton;
        
    }
    
    UIImageView *backView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_shoushimim"]];
    [self.view addSubview:backView];
    backView.frame=self.view.frame;
    
    //self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_shoushimim"]];
    
    NSLog(@"%@====%@",self.view,[UIImage imageNamed:@"bg_shoushimim"]);
    // Do any additional setup after loading the view.
    previousString = [NSString string];
    
//    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
//    password = [keychin objectForKey:(__bridge id)kSecValueData];
    
    password = [[NSUserDefaults standardUserDefaults] objectForKey:GesturePassword];
    
    
    /*
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    password = [keychin objectForKey:(__bridge id)kSecValueData];
    if ([password isEqualToString:@""]) {
        
        [self reset];
    }
    else {
        [self verify];
    }
     */
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[PiwikTracker sharedInstance] sendViews:NSStringFromClass([self class]), self.title, nil];
}
-(void)back{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)setState:(NSString *)stateNSString{
    [gesturePasswordView setStateText:stateNSString];
    //[gesturePasswordView.state setText:stateNSString];
}

-(void)setErrorShow:(NSString *)errorString{
    if(errorString&&[errorString length]>0)
        [gesturePasswordView.error setText:errorString];
    else
        [gesturePasswordView.error setText:@""];
   // [gesturePasswordView.error setText:@"dfgdfgdfgdf"];
}

-(void)initPasswordWithGesturePasswordAction{
    
    switch (_gesturePasswordAction) {
        case GesturePasswordCreate:
        {
            self.title=@"";
            [self reset];
        }
            break;
        case GesturePasswordVerify:
        {
            self.title=@"";
            [self verify];
        }
            break;

        case GesturePasswordModify:
        {
            self.title=@"";
            if([GesturePasswordController existKeychainPassword]){
                [self verify];
                
            }else{
                [self reset];
            }
            
            
        }
            break;

        default:
            break;
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 验证手势密码
- (void)verify{
    
    if(gesturePasswordView){
        [gesturePasswordView removeFromSuperview];
        gesturePasswordView=nil;
        
    }

    gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:CGRectMake(0,0,self.view.width,self.view.height)];
    [gesturePasswordView.tentacleView setRerificationDelegate:self];
    [gesturePasswordView.tentacleView setStyle:1];
    [gesturePasswordView setGesturePasswordDelegate:self];
    [self.view addSubview:gesturePasswordView];
    
    //显示状态
    switch (_gesturePasswordAction) {
        case GesturePasswordCreate:
            break;
        case GesturePasswordVerify:
        {
            [self setState:[NSString stringWithFormat:locationString(@"unlock_gesture_welcome2"),[[CurrentUser mine] userNameForGesturePassword]]];
            [gesturePasswordView showOtherAccountButton];
            
            [self setErrorShow:self.errorNotice];
            
        }
            break;
            
        case GesturePasswordModify:
        {
            [self setState:locationString(@"modify_gesture_original")];
            [self setErrorShow:self.errorNotice];
        }
            break;
            
        default:
            break;
    }

}

#pragma mark - 重置手势密码
- (void)reset{
    
    if(gesturePasswordView){
        [gesturePasswordView removeFromSuperview];
        gesturePasswordView=nil;
        
    }
        
    gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:CGRectMake(0,0,self.view.width,self.view.height)];
    [gesturePasswordView.tentacleView setResetDelegate:self];
    [gesturePasswordView.tentacleView setStyle:2];
    //[gesturePasswordView.imgView setHidden:YES];
    [gesturePasswordView.forgetButton setHidden:YES];
    //[gesturePasswordView.changeButton setHidden:YES];
    [self.view addSubview:gesturePasswordView];
    
    
    //显示状态
    switch (_gesturePasswordAction) {
        case GesturePasswordCreate:
        {
            [self setState:locationString(@"modify_gesture_new")];
            [self setErrorShow:self.errorNotice];
        }
            break;
        case GesturePasswordVerify:
        {
            [self setState:locationString(@"setup_gesture_code_new")];
            [self setErrorShow:self.errorNotice];
        }
            break;
            
        case GesturePasswordModify:
        {
            [self setState:locationString(@"setup_gesture_code_new")];
            [self setErrorShow:self.errorNotice];
        }
            break;
            
        default:
            break;
    }

}

#pragma mark - 错误手势密码

//TODO valueForKey
-(BOOL)canVerifyGesture{
    NSDate *canVerifyGestureTime=[[NSUserDefaults standardUserDefaults] objectForKey:CanVerifyGestureTime];
    if(canVerifyGestureTime){
        
        NSDate *nowDate=[NSDate date];
        if([canVerifyGestureTime compare:nowDate]!=NSOrderedDescending)
            return YES;
        else{
            
            NSTimeInterval timeInterval=[canVerifyGestureTime timeIntervalSinceNow];
            
            NSString *alertString;
            if(timeInterval>60)
                alertString=[NSString stringWithFormat:locationString(@"setup_gesture_souping"),@((int)timeInterval/60)];
            else
                alertString=locationString(@"locked_should_wait");
            
            //self.errorNotice=@"很抱歉，密码错误，还有0次机会";
            self.errorNotice=alertString;
//            [LTNUtilsHelper boxShowWithMessage:alertString
//                                      duration:2.0f];
            return NO;
            
        }
        
    }
    return YES;
}

-(void)minusEffectiveTime{
    NSNumber *remainderNum=[[NSUserDefaults standardUserDefaults] objectForKey:RemainderNum];
    int remainderTime = [remainderNum intValue];
    if(remainderTime==0)
        remainderTime=5;
    remainderTime--;
    if(remainderTime==0){
        NSDate *nowDate=[NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:[nowDate dateByAddingTimeInterval:30*60]
                                                  forKey:CanVerifyGestureTime];
        
        [[NSUserDefaults standardUserDefaults] setObject:@(5) forKey:RemainderNum];
        
        //不能再尝试
        //[LTNUtilsHelper boxShowWithMessage:@"请等待30分钟再次尝试" duration:2.0f];
        self.errorNotice=locationString(@"gesture_code_error_no_chance");
        
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@(remainderTime) forKey:RemainderNum];
        
        NSString *errorString=[NSString stringWithFormat:locationString(@"setup_gesture_error_pass"),@(remainderTime)];
//        [LTNUtilsHelper boxShowWithMessage:errorString
//                                  duration:2.0f];
        self.errorNotice=errorString;
    }
    
}

-(void)resetVerifyGesture{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CanVerifyGestureTime];
    [[NSUserDefaults standardUserDefaults] setObject:@(5) forKey:RemainderNum];
}


#pragma mark - 判断是否已存在手势密码
+ (BOOL)existKeychainPassword{
    
//    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
//    NSString *password = [keychin objectForKey:(__bridge id)kSecValueData];
    
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:GesturePassword];
    if ([esString(password) isEqualToString:@""])
        return NO;
    return YES;
}

#pragma mark - 清空记录
+ (void)clearKeychainPassword{
    ESDispatchOnBackgroundQueue(^{
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:GesturePassword];
//        KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
//        [keychin resetKeychainItem];
        
    });
}

#pragma mark - 改变手势密码
- (void)change{


}


#pragma mark - 改变手势密码
- (void)otherAccountLogin{
    
    LTNLoginController * loginController = [LTNLoginController loginControllerWithFinishBlock:^{
        //[self performSelector:@selector(back) withObject:nil afterDelay:0.1];
       //[self back];
        [self reset];
    }];
    loginController.ShouldSetGesturePassword=YES;
    
//    GestureNavigationController * navController = [[GestureNavigationController alloc] initWithRootViewController:loginController];
//    [self presentViewController:navController animated:YES completion:nil];
    
    
                                                                                                                                                                                            self.navigationController.finishBlock=^(void){
        
        [[LTNCore globleCore] backToMainController];
    };
    [self.navigationController pushViewController:loginController animated:YES];

    //[self.navigationController pushViewController:loginController animated:YES];
}

#pragma mark - 忘记手势密码
- (void)forget{
    
    /// 登陆界面跳转 登陆成功，直接修改
    LTNLoginController * loginController = [LTNLoginController loginControllerWithFinishBlock:^{
        [self reset];
    }];
    
    
    self.navigationController.finishBlock=^(void){
        
        [[LTNCore globleCore] backToMainController];
    };
    loginController.ShouldSetGesturePassword=YES;
    
    [self.navigationController pushViewController:loginController animated:YES];
    
    
//    GestureNavigationController * navController = [[GestureNavigationController alloc] initWithRootViewController:loginController];
//    [self presentViewController:navController animated:YES completion:nil];
    
    
}

-(void)verifySuccess{
    if(_gesturePasswordAction == GesturePasswordVerify){
        //验证完成直接跳出，不需要任何操作
        //[self dismissViewControllerAnimated:YES completion:nil];

        if(gesturePasswordView){
            [gesturePasswordView removeFromSuperview];
            gesturePasswordView=nil;
            
        }

       
        [[LTNAlertWindow sharedWindow] dismissRootController];
        if(_finishBlock)
            _finishBlock();

        //[self back];
        //[self.navigationController dismissViewControllerAnimated:YES completion:nil];
//        if(_dissmissBlock)
//            _dissmissBlock();
    
    }else if(_gesturePasswordAction == GesturePasswordModify){
        //验证成功后，重新设置新的密码
        //[GesturePasswordController clearKeychainPassword];
        [self reset];
        
    
    }

}

- (BOOL)verification:(NSString *)result{
    
    if(![self canVerifyGesture]){
        [self verify];
        return NO;
    }
    if ([result isEqualToString:password]) {
        //[gesturePasswordView.state setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
        //[gesturePasswordView.state setText:@"输入正确"];
        self.errorNotice=@"";
        [self resetVerifyGesture];
        //[self verifySuccess];
        
        [self performSelector:@selector(verifySuccess) withObject:nil afterDelay:0.0f];
        
        return YES;
    }
    
    //TODO:错误 错误几次？将停止绘制  多长时间 恢复重新绘制
    [self minusEffectiveTime];
    [self verify];
    
    
    return NO;
}

- (BOOL)resetPassword:(NSString *)result{
    if ([previousString isEqualToString:@""]) {
        
        if([result length]<4){
//            [LTNUtilsHelper boxShowWithMessage:@"手势密码至少要通过4个点！"
//                                      duration:2.0f];
            self.errorNotice=locationString(@"setup_gesture_error");
            [self reset];
            return NO;
        }
        self.errorNotice=@"";
        [self setErrorShow:self.errorNotice];
        previousString=result;
        [gesturePasswordView.tentacleView enterArgin];
        //[gesturePasswordView.state setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
        //显示状态
        switch (_gesturePasswordAction) {
            case GesturePasswordCreate:
            {
                [self setState:locationString(@"setup_gesture_code_again")];
            }
                break;
            case GesturePasswordVerify:
            {
                
            }
                break;
                
            case GesturePasswordModify:
            {
                [self setState:locationString(@"setup_gesture_code_new_again")];
            }
                break;
                
            default:
                break;
        }

        return YES;
    }
    else {
        if ([result isEqualToString:previousString]) {
//            KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
//            [keychin setObject:@"<帐号>" forKey:(__bridge id)kSecAttrAccount];
//            [keychin setObject:result forKey:(__bridge id)kSecValueData];
            
            self.errorNotice=locationString(@"setup_gesture_code_success");
            [self setErrorShow:self.errorNotice];
            [[NSUserDefaults standardUserDefaults] setObject:result forKey:GesturePassword];
            
//            [LTNUtilsHelper boxShowWithMessage:@"设置成功" duration:1.0f];
            [self resetVerifyGesture];
            //生成新的密码,修改完成密码
           // [self gesturePasswordSuccess];
            [self performSelector:@selector(gesturePasswordSuccess) withObject:nil afterDelay:0.0f];
            return YES;
        }
        else{
            previousString =@"";
            //[gesturePasswordView.state setTextColor:[UIColor redColor]];
            //[self setState:@"两次密码不一致，请重新输入"];
            self.errorNotice=locationString(@"wrong_gesture_pattern");
            [self reset];
            return NO;
        }
    }
}

-(void)gesturePasswordSuccess{
    if(_gesturePasswordAction == GesturePasswordCreate){
        
        
        if(_dissmissBlock)
            _dissmissBlock();
        else{
            if(self.navigationController.finishBlock)
                self.navigationController.finishBlock();
        }
        
        [self back];
        //验证完成直接跳出，不需要任何操作
        
        
    }else if(_gesturePasswordAction == GesturePasswordModify){
        
        [self back];
    }else if(_gesturePasswordAction == GesturePasswordVerify){
        
        [[LTNAlertWindow sharedWindow] dismissRootController];
        if(_finishBlock)
            _finishBlock();
    }

    
}



@end
