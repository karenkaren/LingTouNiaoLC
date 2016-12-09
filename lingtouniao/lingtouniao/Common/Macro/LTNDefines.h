//
//  LTNDefines.h
//  lingtouniao
//
//  Created by  mathe on 15/12/17.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import <Foundation/Foundation.h>


//========渠道

#define CLIENT_CHANNEL_APPSTORE


//企业版暂时不考虑推送
//#define CLIENT_CHANNEL_ENTERPRISE




//====================测试宏

#define AlwaysShowGuide 0 // 引导页
#define AlwaysHasLogin 0 //总是登录状态
#define ALWAYS_SHOW_GUIDE_SHADE 0 //遮罩
#define HaveIntroduction 1 //是否有引导页


//////////////////////////////////////////////////////
#define kThisApp @"1073508943"
#define kUpdateUrl [NSString stringWithFormat: @"https://itunes.apple.com/cn/app/ling-tou-niao-li-cai/id%@?mt=8", kThisApp]
#define kRatingUrl [NSString stringWithFormat: @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8", kThisApp]

#define APP_DELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)

//////////////////////////////////////////////////////
// 常用KEY
#define kNewHandTaskChanged @"NewHandTaskChanged"
#define kCompleteNewHandTask @"CompleteNewHandTask"
#define kNeedToRefreshInvestPage @"needToRefreshInvestPage"
#define kNeedToRefreshHomePage @"needToRefreshHomePage"
#define kNeedToRefreshProducts @"needToRefreshProducts"
#define kNeedToRefreshAccountInfo @"needToRefreshAccountInfo"
#define kNeedToRefreshCrowfundingList @"needToRefreshCrowfundingList"

#define kBankListAndBankIntroduction @"BankListAndBankIntroduction"
#define kBannerHomeAndBannerIntroduction @"BannerHomeAndBannerIntroduction"
#define kBannerMutualAndBannerIntroduction @"BannerMutualAndBannerIntroduction"
#define kBannerCrowdingAndBannerIntroduction @"BannerCrowdingAndBannerIntroduction"
#define kBannerLoanAndBannerIntroduction @"BannerLoanAndBannerIntroduction"
#define kBannerTaskAndBannerIntroduction @"BannerTaskAndBannerIntroduction"

#define kHomeModel @"HomeModel"

//////////////////////////////////////////////////////

#define kDefaultLinkUrl @""

#define kIS_NILSTR(X)  [Utility isEmpty:X]

//umeng
#define UMENG_APP_KEY @"566a7baee0f55a8393000146"

//wechat
#define WECHAT_APP_ID @"wx48dd00fc989b7326"
#define WECHAT_APP_KEY @"97ff25e9b9389470fbc0470727ed1de6"
//#define REDIRECT_URI @""
#define WECHAT_APP_SECRET @"97ff25e9b9389470fbc0470727ed1de6"

//sina weibo
//#define APPKEY @"2130967206"
//#define APPSECRET @"12726406159b3a564821b18b57de11eb"

#define SINA_APP_KEY @"1395891233"
#define SINA_APP_SECRET @"68ece3a3b91bc4cd169ae131ea52301e"
#define SINA_APP_REDIRECT_URL @"http://sns.whalecloud.com/sina2/callback"

//Tencent
//#define QQKEY @"1105016856"
#define QQ_APP_ID @"1105016856"
#define QQ_APP_KEY @"4cpjC8bbJeWHKw6q"

#define kCommentMaxInputLength 500


/* 存储在 defaults中 的 网络接口地址 */
#define kDefaults_NetAddress @"kDefaults_NetAddress"
#define kDefaults_POST_ADDR @"kDefaults_POST_ADDR"
#define kServerAPIErrorDomain @"LTNErrorDomain"

#define kLegalDomains @"kLegalDomains"

// 可运营启动页MODEL保存路径
#define kSplashModelPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/splashModel.data"]
//////////////////////////////////////////////////////


#define IS_FIRST_SHOW @"isFirstShow"


#define kAutoClick @"needAutoClick"

#define kIsIOS9 [[UIDevice currentDevice].systemVersion doubleValue] > 8.9
#define VERSION_7_0_EARLIER ([[UIDevice currentDevice].systemVersion doubleValue] < 7.0f)


//版本比较
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)



//////////////////////////////////////////////////////



//目标屏幕的宽
#define kScreenWidth        [UIScreen mainScreen].bounds.size.width
//目标屏幕的高
#define kScreenHeight       [UIScreen mainScreen].bounds.size.height
//目标屏幕尺寸
#define ScreenBounds         [[UIScreen mainScreen] bounds]    
//通用高度
#define kGeneralHeight      44.0


#define StatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
#define NavigationBarHeight self.navigationController.navigationBar.height
#define kHorizontalMargin 15.0
#define SYSTEM_NAVIGATION_HEIGHT 44
extern float DimensionBaseIphone6(float aHeight);


extern NSString * bankIcon(NSString *bankName);
extern NSString * locationString(NSString *key);

extern NSString * transToMill(double aNum);
extern NSString * transIntToString(NSInteger aInt);

//统计埋点时间
extern NSString * timeForStatistics(void);



// 验证码位数
#define CAPTCHA_LIMIT 4

//验证
#define IDENTITY_LIMIT 18
#define IDCARDONLY @"xX0123456789"


//////////////////////////////////////////////////////
//TODO://以下为两种weak方式都可以

// weakself
#pragma mark - weakSelf
#define kWeakSelf __weak typeof (self) weakSelf = self;
#define kStrongSelf __strong __typeof(&*weakSelf)strongSelf = weakSelf;
#define kWeakObj(obj)  __weak typeof(obj) weakObj = obj;

//-----------------------------------------------------//

#define __es_weak        __weak
#define es_weak_property weak

#define ESWeak(var, weakVar) __weak __typeof(&*var) weakVar = var
#define ESStrong_DoNotCheckNil(weakVar, _var) __typeof(&*weakVar) _var = weakVar
#define ESStrong(weakVar, _var) ESStrong_DoNotCheckNil(weakVar, _var); if (!_var) return;

#define ESWeak_(var) ESWeak(var, weak_##var);
#define ESStrong_(var) ESStrong(weak_##var, _##var);

/** defines a weak `self` named `__weakSelf` */
#define ESWeakSelf      ESWeak(self, __weakSelf);
/** defines a strong `self` named `_self` from `__weakSelf` */
#define ESStrongSelf    ESStrong(__weakSelf, _self);


/////////////////////////单例/////////////////////////////

#pragma mark 接口.h中的定义
#define singleton_interface(className) + (className *)shared##className;

#pragma mark 实现.m
#define singleton_implementation(className) \
static id  _instance;  \
+ (id)shared##className  \
{   \
if (_instance == nil) { \
_instance = [[self alloc] init];    \
}   \
return _instance;   \
}   \
+ (id)allocWithZone:(struct _NSZone *)zone  \
{   \
static dispatch_once_t once;    \
dispatch_once(&once, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance;   \
}

//////////////////////////////////////////////////////

// 1.日志输出宏定义
#if (ADHOC > 0 || DEBUG > 0)
#	define DLog(fmt, ...) NSLog((@"%s #%d " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#	define DLog(...)
#endif

//////////////////////////////////////////////////////

#if defined(__cplusplus)
#define ES_EXTERN extern "C"
#define ES_EXTERN_C_BEGIN extern "C" {
#define ES_EXTERN_C_END }
#else
#define ES_EXTERN extern
#define ES_EXTERN_C_BEGIN
#define ES_EXTERN_C_END
#endif

#define ES_INLINE       NS_INLINE


#define scaleRate


ES_INLINE BOOL ESIsStringWithAnyText(id object) {
    return ([object isKindOfClass:[NSString class]] && ![(NSString *)object isEqualToString:@""]);
}

#pragma mark notification key
extern NSString *const NotificationMsg_Land_Sucess;
extern NSString *const NotificationMsg_Exit_Success;
extern NSString *const NotificationMsg_Update_UserInfo;



extern NSString *const NotificationMsg_Update_UserInfo;
extern NSString *const Notification_Select_Coupon;

extern NSString *const Exchange_copoun;

#pragma mark end

#pragma mark common key

extern NSString *const kStaticVersion;




#pragma mark end






///=============================================
/// @name Path
///=============================================
#pragma mark - Path

ES_EXTERN NSString *ESPathForBundleResource(NSBundle *bundle, NSString *relativePath, ...);
ES_EXTERN NSString *ESPathForMainBundleResource(NSString *relativePath, ...);
ES_EXTERN NSString *ESPathForESFWBundleResource(NSString *relativePath, ...);
ES_EXTERN NSString *ESPathForDocuments(void);
ES_EXTERN NSString *ESPathForDocumentsResource(NSString *relativePath, ...);
ES_EXTERN NSString *ESPathForLibrary(void);
ES_EXTERN NSString *ESPathForLibraryResource(NSString *relativePath, ...);
ES_EXTERN NSString *ESPathForCaches(void);
ES_EXTERN NSString *ESPathForCachesResource(NSString *relativePath, ...);
ES_EXTERN NSString *ESPathForTemporary(void);
ES_EXTERN NSString *ESPathForTemporaryResource(NSString *relativePath, ...);
/// Create the `dir`  if it doesn't exist
ES_EXTERN BOOL ESTouchDirectory(NSString *dir);
/// Create directories if it doesn't exist, returns `nil` if failed.
ES_EXTERN NSString *ESTouchFilePath(NSString *filePath, ...);



///=============================================
/// @name Dispatch & Block
///=============================================
#pragma mark - Dispatch & Block

typedef void (^VoidBlock)(void);
typedef void (^ESErrorBlock)(NSError *error);
typedef void (^ESHandlerBlock)(id sender);

ES_EXTERN void ESDispatchSyncOnMainThread(dispatch_block_t block);
ES_EXTERN void ESDispatchAsyncOnMainThread(dispatch_block_t block);
ES_EXTERN void ESDispatchOnGlobalQueue(dispatch_queue_priority_t priority, dispatch_block_t block);
ES_EXTERN void ESDispatchOnDefaultQueue(dispatch_block_t block);
ES_EXTERN void ESDispatchOnHighQueue(dispatch_block_t block);
ES_EXTERN void ESDispatchOnLowQueue(dispatch_block_t block);
ES_EXTERN void ESDispatchOnBackgroundQueue(dispatch_block_t block);
/** After `delayTime`, dispatch `block` on the main thread. */
ES_EXTERN void ESDispatchAfter(NSTimeInterval delayTime, dispatch_block_t block);


