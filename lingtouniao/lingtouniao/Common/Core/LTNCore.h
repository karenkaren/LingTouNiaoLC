//
//  LTNCore.h
//  lingtouniao
//
//  Created by  mathe on 15/12/15.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTNConfigModel.h"

@class AppDelegate;
@class LTNTabBarController;

@interface LTNCore : NSObject



@property (nonatomic) LTNTabBarController *tabbarController;
@property (nonatomic) LTNConfigModel *configData;
@property (nonatomic) BOOL haveShowEvaluateAlertView;
@property (nonatomic) BOOL goldenEggsWindowIsShowing;
@property (nonatomic) BOOL shouldNotShowTeachingView;

@property (nonatomic,copy)NSString *tempAmt;

@property (nonatomic,strong)NSMutableArray *changeableImageViews;

+ (LTNCore *)globleCore;
+ (AppDelegate *)appDelegate;
+ (UIWindow *)mainWindow;
+ (UIViewController *)appRootViewController;
- (void)initializeGlobleApprence;


@end

@interface LTNCore (Helper)
+ (BOOL)isFreshLaunch:(NSString **)previousAppVersion;
+ (void)deleteAllHTTPCookies;
-(void)initIQKeyboardManager;

+(BOOL)HaveGesturePassword;

+(void)popToRootControllers;

+(void)saveLastTimeWhenApplicationDidEnterBackground;
+(void)removeLastTimeWhenApplicationDidEnterBackground;
+(BOOL)shouldShowGesturePassword;
+(BOOL)shouldShowCurrentInvestment;
+(BOOL)shouldShowOfflineInvestment;
+(BOOL)hiddenKeyboard;
+(void)showEvaluateAlertView;


@end


@interface LTNCore (SwitchController)
- (void)firstLaunch;
-(void)loadMainTabbarController;
-(void)backToMainController;
-(void)loadMainTabbarControllerOne;
-(void)backToMoreController;
-(void)backToInvestmentListController;
- (void)backToDiscoverController;
-(void)backToRootController:(BOOL)animation;

-(void)jumpToProductDetailController:(NSString *)productID;
-(void)jumpToMyIncometSatement;
-(void)jumpToMyTicketList;
-(UIViewController *)jumpToDiscoverController;

/**
 *  借款
 */
-(void)jumpToLoan;
/**
 *  我的投资
 */
-(void)jumpToMyInvestment;
-(void)jumpToWebviewController:(NSString *)urlString;
/**
 *  我的众筹
 */
-(void)jumpToMyCrowdfunding;
/**
 *  我的互助
 */
-(void)jumpToMyCooperation;
/**
 *  项目列表
 */
-(UIViewController *)jumpToInvestmentController;
/**
 *  合伙人
 */
-(void)jumpToMyPartner;
/**
 *  我的任务
 */
-(UIViewController *)jumpToMyTask;
/**
 *  新手专区
 */
-(void)jumpToNewHandArea;
/**
 *  进阶专区
 */
-(void)jumpToStageArea;
/**
 *  活动专区
 */
-(void)jumpToLimitTimeArea;
// 跳转到众筹列表
- (void)jumpToCrowdfundingListController;
// 跳转到互助列表
- (void)jumpToCooperationListController;
/**
 *  互助下单准备
 *
 *  @param amount    投资金额
 *  @param productId 产品id
 */
- (void)jumpToCooperationConfirmInvestWithParams:(NSDictionary *)params fromController:(UIViewController *)vc;
/**
 *  众筹下单准备
 *
 *  @param amount    投资金额
 *  @param productId 产品id
 */
- (void)jumpToCrowdfundingConfirmInvestWithParams:(NSDictionary *)params fromController:(UIViewController *)vc;

+(void)presentViewController:(Class)controllerClass withFinishBlock:(VoidBlock)finishBlock;

+(void)presentViewController:(Class)controllerClass withFinishBlock:(VoidBlock)finishBlock animated:(BOOL)animated;
-(void)loginController:(VoidBlock)finishBlock;
+(void)resetPassword;
-(void)registerController:(VoidBlock)finishBlock;
+(void)verifyRealNameViewController:(VoidBlock)finishBlock;
+(void)boundBankCardViewController:(VoidBlock)finishBlock;
+(void)secondBoundBandCardViewController:(VoidBlock)finishBlock;
+(void)showBankInfoViewController:(VoidBlock)finishBlock;
+(void)rechargeViewController:(VoidBlock)finishBlock;
+(void)chargeViewController:(VoidBlock)finishBlock;

-(void)showMyAccountController:(BOOL)shouldShowMyAccount;

+(void)gesturePasswordController;
+(void)gesturePasswordControllerWithBlock:(VoidBlock)block;
+(void)poundGoldenEggsController:(NSString *)urlString;

@end


@interface LTNCore (SynRescource)
-(void)synRescource;
+(void)addchangeableImageView:(UIView *)view;
@end


