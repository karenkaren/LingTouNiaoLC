//
//  Utility.h
//  haowan
//
//  Created by wupeijing on 3/12/15.
//  Copyright (c) 2015 iyaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKitBlockAdditions.h"
#import "UIAlertView+Block.h"

#define kfolderPath @"MMbang_CacheFolder"

typedef void (^Action)(void);
typedef void (^FunctionWithData)(id data);
typedef void(^ProcessStringBlock)(NSString *msg);

/**
 *    APICompletionBlock definition
      1) if it's a network error, response = data = nil, error contains the error message.
      2) if it's not a network error
        a) if error code is 0, error = nil,
            i) if don't use JSONModel, response is the raw data, data is response[@"data"]. 
            ii) if use JSONModel, response is the MMBWebServiceResponse, data is specific JSONModel instance
        b) if error code is not 0, 
            i) if don't use JSONModel, response is the raw data, data is response[@"data"].
            ii)if we use JSONModel to parse the data and the error is not caused by json parse, reponse is still raw data, and data is nil
            iii)if we use JSON Model and the error is caused when we parse jsonmode, response is the MMBWebServiceResponse, but the data in it is nil.
 *
 *
 *    @param response
 *    @param data
 *    @param error    errors
 */
typedef void (^APIComletionBlock)(id response, id data, NSError *error);


@interface Utility : NSObject

/**
 *    a simple way to show a msg with UIAlert View
 *
 *    @param msg msg to be shown
 */
+ (void)showSimpleMessage:(NSString *)msg;

/**
 *    create a mask view with 0.5 alpha, black color
 *
 *    @param frame
 *    @param action tap actions
 *    @param target actions's target
 *
 *    @return the mask view
 */
+ (UIView *)createMaskViewWithFrame:(CGRect)frame action:(SEL)action onTarget:(id)target;

/**
 *    close a UIViewController with/o a completion block. It can handle presented vc, pushed vc (or maybe root vc in the navigation controoler)
        if the vc is not in a navigation statck, call the dismiss method.
        if it's in a navigation stack, and if it's not the root, call pop, otherwise close the navigation controller
 *
 *    @param vc the vc to close
 */
+ (void)closeViewController:(UIViewController *)vc;
+ (void)closeViewController:(UIViewController *)vc completion:(void (^)(void))completion;
+ (void)closeViewController:(UIViewController *)vc completion:(void (^)(void))completion ignoreQuitVC:(BOOL)ignore;

/**
 *    customize navigation bar
 */
+ (void)customizeNavigationBar:(UIColor *)color fontSize:(CGFloat)fontSize fontColor:(UIColor *)fontColor;
/**
 *  setNavigationBar titile color
 */

+ (void)setNavigationBarWithTitleColor:(UIColor *)color andNavController:(UINavigationController *)navController;

/**
 *    create a simple Button which looks like a clickable UILabel
 *
 *    @param title
 *    @param color
 *    @param font
 *    @param block a block for TouchUpInside event
 *
 *    @return
 */
+ (UIButton *)createButtonWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font block:(ButtonBlockAction)block;

/**
 *    get remote data at url, and process it with the block
 *
 *    @param url
 *    @param block
 */
+ (void)getDataFrom:(NSString *)url withBlock:(FunctionWithData)block;

+ (UIImage *)createImageFromColor:(UIColor *)color;
+ (UIImage *)createImageFromColor:(UIColor *)color withSize:(CGSize)size;


+ (NSArray *)splitString:(NSString *)rawString withMaxLength:(NSInteger)maxLength;

#pragma mark - 最少返回12像素
+ (CGFloat)heightForText:(NSString*)contentText width:(CGFloat)width font:(UIFont *)font;
#pragma mark - 根据字体，宽度返回 高度
+ (CGFloat)heightWithText:(NSString *)text font:(UIFont *)font width:(CGFloat)width minHeight:(CGFloat)minHeight;
+ (CGFloat)widthWithText:(NSString *)text font:(UIFont *)font height:(CGFloat)height minWidth:(CGFloat)minWidth;
+ (CGFloat)heightWithText:(NSString *)text width:(CGFloat)width minHeight:(CGFloat)minHeight attributes:(NSDictionary*)attributes;

+ (CGRect)getLabelSize:(UIFont*)font labelText:(NSString*)text andWidth:(CGFloat)width andLineSpace:(CGFloat)lineSpace andlimitedToNumberOfLines:(NSInteger)numberOfLines;

// 计算文本尺寸
+ (CGSize)sizeWithText:(NSString *)text boundingSize:(CGSize)boundingSize font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode
;
+ (CGFloat)heightWithText:(NSString *)text boundingSize:(CGSize)boundingSize font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode;


/***************** iOS 6 or higher 需要设置lineSpacing时使用  ****************/
+ (CGFloat)heightForString:(NSString *)string
                      font:(UIFont *)font
        lineSpacingPercent:(CGFloat)lineSpacingPercent
                     width:(CGFloat)width;
+ (CGFloat)heightForString:(NSString *)string
                      font:(UIFont *)font
               lineSpacing:(CGFloat)lineSpacing
                     width:(CGFloat)width;

+ (NSAttributedString *)attributedStringFromText:(NSString *)text
                                            font:(UIFont *)font
                                           color:(UIColor *)textColor
                                     lineSpacing:(CGFloat)lineSpacing
                                   lineBreakMode:(NSLineBreakMode)lineBreakMode;
/***************** 需要设置lineSpacing时使用  ****************/


+ (NSString *)trimWhitespace:(NSString *)string;
+ (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve;
+ (UIImage*)convertImageToGreyScale:(UIImage*) image;

// UITextField Limit Lenght

+ (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string limitMaxLength:(NSUInteger)maxLength;

/**
 *  应用程序的名称
 *
 *  @return NSString
 */
+ (NSString *)appVersion;

+ (NSString *)md5:(NSString *)input;
+ (NSString *)sign:(NSDictionary *)dict;
+ (NSString *)serialize:(NSDictionary *)dict;


/**
 *    create a footview btn for a tableview with txt, background color, for example logout button
 *
 *    @param tableView
 *    @param title
 *    @param color
 *
 *    @return the button
 */
+ (UIButton *)createTableViewFootButtonForTable:(UITableView *)tableView title:(NSString *)title color:(UIColor *)color;


+ (void)showAlertTitle:(NSString *)title msg:(NSString *)msg cancelTitle:(NSString *)cancelTitle commitBtnTitle:(NSString *)commitText handlerBlock:(void (^)(void))handler onVC:(UIViewController *)vc;

+ (void)showMessageFromServer:(id)data defaultMsg:(NSString *)message;
+ (void)showMessage:(NSString *)message;
+ (void)showMessage:(NSString *)message withOffset:(CGFloat)offset;
+ (void)showAlert:(NSString *)message;
+ (BOOL)isNumberFromString:(NSString *)rawString;

+ (UIImage *)resizeImageWithRawImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (UIImage *)restrictImage:(UIImage *)image inSize:(CGFloat)size;
+ (BOOL)writeImage:(UIImage*)image toFileAtPath:(NSString*)aPath;
+ (BOOL)isNetworkAvailable;
+ (BOOL)isMMbangAvailable;
+ (void)showNetworkErrorMsg:(NSError *)error;
+ (void)processNetworkErrorMsg:(NSError *)error block:(ProcessStringBlock)block;
//+ (NSString *)getNetworkErrorMsg:(NSError *)error; //use processNetworkErrorMsg:block instead

//字体的上下间距
+ (CGFloat)getFontSpaceWithLabel:(UIFont*)font;

#pragma mark 路径，存储
+ (NSURL *)getApplicationDocumentsDirectory;
+ (NSString *)getDocumentPath:(NSString *)lastFolderName;

+ (void)saveDataWithKey:(NSString *)key ofValue:(id)value;
+ (void)clearDataWithKey:(NSString *)key;
+ (id)getDataWithKey:(NSString *)key;

+ (void)saveEntityWithKey:(NSString *)key ofValue:(id)value;
+ (id)getEntityWithKey:(NSString *)key;

+(BOOL)judgePhotoPerm;
+(void)showPhotoPermAlert;

+ (NSString *)jsonStringWithObject:(id)object;

+ (BOOL)isEqualFromString:(NSString *)from toString:(NSString *)toString;

+ (NSString *)macAddress;

BOOL isValidatePhone(NSString * candidate);

BOOL isValidateEmail(NSString * candidate);

void TTAlert(NSString* message);

//将fffff转化为uicolor
UIColor * colorWithHexString(NSString *stringToConvert);

NSString* getBabyGenerType(NSString*string);

void setExclusiveTouchToChildrenOf(NSArray *subviews);


void writeToPlist(NSString *strPlistName, NSData *arrData)
;
NSString * getPlistName(NSString *strPlistName);
void removePlist(NSString *strPlistName);

// Register UIWebView UserAgent

+ (void)registerUIWebViewUserAgent;

/**
 *  应用程序的名称
 *
 *  @return NSString
 */
+ (NSString *)appName;

#pragma mark -
#pragma mark 判断字符串是否为空（nil和length为0都是空）

+ (BOOL)isEmpty:(NSString *)value;

+ (BOOL)isHostAvailable:(NSString *)hostname;

+ (UILabel *)createLabel:(UIFont *)textFont color:(UIColor *)textColor;

// 格式化距离
+ (NSString *)formatDistanceWithMeters:(double)meters;

/**
 *  计算文件大小
 *
 *  @param path 路径
 *
 *  @return 正确的image url
 */

+(NSString *)folderSizeAtPath:(NSString *)path;

+ (BOOL)emptyOrNull:(NSString *)str;


#pragma mark - 生成 UUID
+ (NSString *)createUUID;

+ (NSString *)deviceModel;
+ (NSString *)deviceModelOrigin;

+ (void)tellPhoneNumber:(NSString *)phoneNumber;

#pragma mark -- createFilePath

+(NSString *)folderPath:(NSString*)folderPath;

+ (NSString *)createFolderPathIfNeeded:(NSString*)folderPath;

+ (void)cleanFolderPath:(NSString*)folderPath;

+ (void)showAlert:(NSString *)msg commitBtnTitle:(NSString *)commitText handler:(void (^)(UIAlertAction *action))handler oldHandleBlock:(void (^)(void))oldHandler onVC:(UIViewController *)vc;


+(void)showAlertWithTitle:(NSString*)title andContentString:(NSString*)content;
+(void)showAlertWithTitle:(NSString*)title andContentString:(NSString*)content title:(NSString *)commitTitle;


+ (BOOL)canHandlePush;

+ (BOOL)isDate:(NSDate *)date1 sameDayToDate:(NSDate *)date2 format:(NSString *)format;

+ (void)openURL:(NSURL *)url;

+ (NSArray *)calsInvalidDaysForYear:(int)year month:(int)month day:(int)day;

+ (UIButton *)createButtonWithFrame:(CGRect)frame iconName:(NSString *)iconName target:(id)target action:(SEL)action;

+ (CGFloat)lineWidth;

+ (void)selectTextForInput:(UITextField *)input atRange:(NSRange)range;

@end

/**
 *   use cases: when present a normal vc with navigation controller[use presentWithANavigationController] for example LoginViewController, after we quit login, we also want to quit the presenting vc,
     usage: we can implement this protocol on LoginVC, and set the proper value of the quitVC property, the [closeViewController] will use this property later
 */
@protocol QuitVCPropertyDelegate <NSObject>

@property (nonatomic, retain) UIViewController *quitVC;
@property (nonatomic, copy) Action completionBlock;

@end