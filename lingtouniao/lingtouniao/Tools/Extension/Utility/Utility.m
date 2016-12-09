//
//  Utility.m
//  haowan
//
//  Created by wupeijing on 3/12/15.
//  Copyright (c) 2015 iyaya. All rights reserved.
//

#import "Utility.h"
#import "CustomerizedFont.h"
#import <CommonCrypto/CommonCrypto.h>
#import "UIAlertView+Block.h"

#define kTextViewPadding 10.0

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include "sys/stat.h"
#include <fnmatch.h>
#include <stdio.h>
#include <sys/types.h>
#include <dirent.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AFNetworkReachabilityManager.h>
#import "LPPopup.h"

#import "UIAlertView+Block.h"

#define MMBANG_DATA_CACHE @"MMBANG_DATA_CACHE_%@_%@"
#define DEFAULT_VOID_COLOR [UIColor whiteColor]

#define MAX_CACHE_SIZE 1024 * 1024 * 10
#define MIN_CACHE_SIZE 1024 * 1024 * 2     // 超过100M缓存后，自动清理，只留20M
#define kMaskImgTag 3333



@implementation Utility

+ (void)showSimpleMessage:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:locationString(@"hint") message:msg delegate:self cancelButtonTitle:locationString(@"btn_confirm_yes") otherButtonTitles:nil];

    [alertView show];
}

+ (UIView *)createMaskViewWithFrame:(CGRect)frame action:(SEL)action onTarget:(id)target {
    UIView *maskView = [[UIView alloc] initWithFrame:frame];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.5f;

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [maskView addGestureRecognizer:tapGestureRecognizer];
    return maskView;
}

+ (void)closeViewController:(UIViewController *)vc {
    [self closeViewController:vc completion:nil ignoreQuitVC:NO];
}

+ (void)closeViewController:(UIViewController *)vc completion:(void (^)(void))completion {
    [self closeViewController:vc completion:completion ignoreQuitVC:NO];
}

+ (void)closeViewController:(UIViewController *)vc completion:(void (^)(void))completion ignoreQuitVC:(BOOL)ignore {
    if (!ignore && [vc conformsToProtocol:@protocol(QuitVCPropertyDelegate)]) {
        id<QuitVCPropertyDelegate> hasQuitVC = (id<QuitVCPropertyDelegate>)vc;
        UIViewController *vcNeedToQuit = hasQuitVC.quitVC;
        if (vcNeedToQuit) {
            hasQuitVC.quitVC = nil;
            [self closeViewController:vcNeedToQuit completion:completion];
            return;
        }
    }

    if (!vc.navigationController) {
        [vc dismissViewControllerAnimated:YES completion:completion];
    } else if ([vc.navigationController viewControllers][0] == vc) {
        [self closeViewController:vc.navigationController completion:completion];
    } else {
        [vc.navigationController popViewControllerAnimated:YES];
    }
}

+ (void)customizeNavigationBar:(UIColor *)color fontSize:(CGFloat)fontSize fontColor:(UIColor *)fontColor {
    UIImage *image = [Utility createImageFromColor:color withSize:CGSizeMake(1, 1)];
    [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    NSDictionary *ats = @{
                          NSFontAttributeName : [CustomerizedFont systemFontOfSize:fontSize],
                          NSForegroundColorAttributeName : fontColor
                          };
    [UINavigationBar appearance].titleTextAttributes = ats;
}

+ (void)setNavigationBarWithTitleColor:(UIColor *)color andNavController:(UINavigationController *)navController
{
      [navController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:color}];
}

+ (UIButton *)createButtonWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font block:(ButtonBlockAction)block {
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn.titleLabel setFont:font];
    [btn sizeToFit];
    btn.tappedBlock = block;
    return btn;
}

+ (void)getDataFrom:(NSString *)url withBlock:(FunctionWithData)block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(data){
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if (block) {
                    block(dic);
                }
            }
        });
    });
}

+ (UIImage *)createImageFromColor:(UIColor *)color withSize:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);

    CGFloat alpha = 0;
    [color getWhite:nil alpha:&alpha];
    UIGraphicsBeginImageContextWithOptions(rect.size, alpha > 0.99, 0);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

+ (UIImage *)createImageFromColor:(UIColor *)color
{
    return [self createImageFromColor:color withSize:CGSizeMake(1, 1)];
}

+ (NSArray *)splitString:(NSString *)rawString withMaxLength:(NSInteger)maxLength
{
    if (rawString.length < maxLength) {
        return [NSArray arrayWithObject:rawString];
    }
    
    NSMutableArray *splitedStringArray = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < rawString.length / maxLength + 1 ; i++) {
        //        NSLog(@"from=%i to=%i total= %i", i * maxLength, MIN((i + 1) * maxLength, rawString.length - i * maxLength - 1), rawString.length);
        
        [splitedStringArray addObject:[rawString substringWithRange:NSMakeRange(i * maxLength, MIN((i + 1) * maxLength, rawString.length - i * maxLength))]];
    }
    
    return splitedStringArray;
}

#pragma mark - 最少返回12像素
+ (CGFloat)heightForText:(NSString*)contentText width:(CGFloat)width font:(UIFont *)font
{
    if ([contentText length] == 0) {
        return 12;
    }
    //    CGSize size=[contentText sizeWithFont:font constrainedToSize:CGSizeMake(width - kTextViewPadding * 2, CGFLOAT_MAX) lineBreakMode:0];
    CGSize size = [self sizeWithText:contentText boundingSize:CGSizeMake(width - kTextViewPadding * 2, CGFLOAT_MAX) font:font lineBreakMode:NSLineBreakByCharWrapping];
    
    return size.height + kTextViewPadding * 2;
}

#pragma mark - 根据字体，宽度返回 高度
+ (CGFloat)heightWithText:(NSString *)text font:(UIFont *)font width:(CGFloat)width minHeight:(CGFloat)minHeight
{
    if (text) {
        CGSize size = CGSizeZero;
        CGSize rSize = CGSizeMake(width, NSUIntegerMax);
        
        size = [self sizeWithText:text boundingSize:rSize font:font lineBreakMode:NSLineBreakByCharWrapping];
        
        if (size.height > minHeight) {
            return size.height;
        } else {
            return minHeight;
        }
    }
    
    return minHeight;
}


+ (CGFloat)heightWithText:(NSString *)text width:(CGFloat)width minHeight:(CGFloat)minHeight attributes:(NSDictionary*)attributes
{
    if (text) {
        CGSize size = CGSizeZero;
        CGSize rSize = CGSizeMake(width, NSUIntegerMax);
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
        CGRect rect = [text boundingRectWithSize:rSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        size = rect.size;
#else
        UIFont *font = attributes[NSFontAttributeName];
        NSAssert(font, @"font不能为空");
        size = [text sizeWithFont:font constrainedToSize:rSize];
#endif
        if (size.height > minHeight) {
            return size.height;
        } else {
            return minHeight;
        }
    }
    
    return minHeight;
}

+ (CGFloat)widthWithText:(NSString *)text font:(UIFont *)font height:(CGFloat)height minWidth:(CGFloat)minWidth
{
    if (text) {
        CGSize size = CGSizeZero;
        CGSize rSize = CGSizeMake(NSUIntegerMax, height);
        
        size = [self sizeWithText:text boundingSize:rSize font:font lineBreakMode:NSLineBreakByCharWrapping];
        
        if (size.width > minWidth) {
            return size.width;
        } else {
            return minWidth;
        }
    }
    
    return minWidth;
}

+ (CGSize)sizeWithText:(NSString *)text boundingSize:(CGSize)boundingSize font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize textSize;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    NSDictionary *ats = @{
                          NSFontAttributeName : font,
                          NSParagraphStyleAttributeName : paragraphStyle
                          };
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
    CGRect rect = [text boundingRectWithSize:boundingSize
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine
                                  attributes:ats
                                     context:nil];
    textSize        = rect.size;
    textSize.width  = ceil(textSize.width);
    textSize.height = ceil(textSize.height);
    
#else
    // -boundingRectWithSize:options:attributes:context: is available in iOS 7.0 and later
    if ( [text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)] ) {
        CGRect rect = [text boundingRectWithSize:boundingSize
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine
                                      attributes:ats
                                         context:nil];
        textSize        = rect.size;
        textSize.width  = ceil(textSize.width);
        textSize.height = ceil(textSize.height);
        
    }else{
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        textSize = [text sizeWithFont:font constrainedToSize:boundingSize lineBreakMode:lineBreakMode];
        textSize.width  = ceil(textSize.width);
        textSize.height = ceil(textSize.height);
#pragma clang diagnostic pop
        
    }
#endif
    return textSize;
}

+ (CGFloat)heightWithText:(NSString *)text boundingSize:(CGSize)boundingSize font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode{
    CGSize size = [self sizeWithText:text boundingSize:boundingSize font:font lineBreakMode:lineBreakMode];
    return ceilf(size.height);
}

+ (CGFloat)heightForString:(NSString *)string font:(UIFont *)font lineSpacingPercent:(CGFloat)lineSpacingPercent width:(CGFloat)width{
    CGFloat lineSpacing = font.lineHeight * (lineSpacingPercent);
    return [self heightForString:string font:font lineSpacing:lineSpacing width:width];
}

+ (CGFloat)heightForString:(NSString *)string font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing width:(CGFloat)width{
    NSAttributedString *attributedStr = [self attributedStringFromText:string font:font color:[UIColor clearColor]  lineSpacing:lineSpacing lineBreakMode:NSLineBreakByCharWrapping];
    
    CGRect boundingRect = [attributedStr boundingRectWithSize:CGSizeMake(width, 999)
                                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine
                                                      context:nil];
    return ceilf(CGRectGetHeight(boundingRect));
}

+ (NSAttributedString *)attributedStringFromText:(NSString *)text font:(UIFont *)font color:(UIColor *)textColor lineSpacing:(CGFloat)lineSpacing lineBreakMode:(NSLineBreakMode)lineBreakMode{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6 && text) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = lineSpacing;
        paragraphStyle.lineBreakMode = lineBreakMode;
        NSDictionary *ats = @{
                              NSFontAttributeName : font,
                              NSForegroundColorAttributeName : textColor,
                              NSParagraphStyleAttributeName : paragraphStyle
                              };
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString: text attributes: ats];
        return attributedText;
    }
    return nil;
}


+ (CGRect)getLabelSize:(UIFont*)font labelText:(NSString*)text andWidth:(CGFloat)width andLineSpace:(CGFloat)lineSpace andlimitedToNumberOfLines:(NSInteger)numberOfLines
{
    UILabel *label = [Utility createLabel:font color:[UIColor whiteColor]];
    label.text = text;
    NSAttributedString *attributedStr = [self attributedStringFromText:text font:font color:[UIColor whiteColor]  lineSpacing:lineSpace lineBreakMode:NSLineBreakByCharWrapping];
    label.attributedText = attributedStr;
    label.width = width;
    return [label textRectForBounds:CGRectMake(0, 0, label.width,FLT_MAX ) limitedToNumberOfLines:numberOfLines];
}

#pragma mark -

+ (NSString *)trimWhitespace:(NSString *)string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
}

+ (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve
{
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            return UIViewAnimationOptionCurveEaseInOut;
            break;
        case UIViewAnimationCurveEaseIn:
            return UIViewAnimationOptionCurveEaseIn;
            break;
        case UIViewAnimationCurveEaseOut:
            return UIViewAnimationOptionCurveEaseOut;
            break;
        case UIViewAnimationCurveLinear:
            return UIViewAnimationOptionCurveLinear;
            break;
    }
    
    return kNilOptions;
}

/**
 *    return the gray image of the raw image considering alpha
 *
 *    @param image
 *
 *    @return gray image
 */
+ (UIImage*)convertImageToGreyScale:(UIImage*)image
{
    CGFloat w, h;
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            w = image.size.height;
            h = image.size.width;
            break;
        default:
            w = image.size.width;
            h = image.size.height;
    }
    CGRect imageRect = CGRectMake(0, 0, w, h);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();

    //xcdoc://ios/documentation/GraphicsImaging/Reference/CGBitmapContext/Reference/reference.html
    //The constants for specifying the alpha channel information are declared with the CGImageAlphaInfo type but can be passed to this parameter safely.
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
    CGContextDrawImage(context, imageRect, image.CGImage);
    CGImageRef grayImage = CGBitmapContextCreateImage(context);

    CGContextRelease(context);
    context = CGBitmapContextCreate(NULL, w, h, 8, 0, NULL, (CGBitmapInfo)kCGImageAlphaOnly);
    CGContextDrawImage(context, imageRect, image.CGImage);
    CGImageRef mask = CGBitmapContextCreateImage(context);

    CGImageRef imageRef = CGImageCreateWithMask(grayImage, mask);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];

    CGImageRelease(mask);
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CGImageRelease(grayImage);
    return result;
}

// UITextField Limit Max Lenght

+ (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string limitMaxLength:(NSUInteger)maxLength{
    
    NSString *shouldText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //NSString *trimmedText = [shouldText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSInteger strLength = shouldText.length;
    if (strLength > maxLength) {
        // 允许删除
        if (strLength < textField.text.length) {
            return YES;
        }
        // 已经超长了，不允许输入更多
        return NO;
    }
    return YES;
}

+ (NSString *)appName
{
    NSString *name = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    return name;
}

+ (NSString *)appVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = infoDictionary[@"CFBundleShortVersionString"];
    
#if (defined(DEBUG) || defined(ADHOC))
    NSString *build = infoDictionary[@"CFBundleVersion"];
    version = [NSString stringWithFormat:@"v%@ build %@", version, build];
#else
    version = [@"v" stringByAppendingString:version];
#endif
    return version;
}

+ (NSString *)md5:(NSString *)input {
    if (!input) {
        return nil;
    }
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];

    return  output;
}

+ (NSString *)serialize:(NSDictionary *)dict {
    NSArray *sortedValues = [[dict allKeys] sortedArrayUsingSelector: @selector(compare:)];
    if ([sortedValues count] == 0) {
        NSAssert(NO, @"sign empty data");
        return @"";
    }

    NSMutableString *inputString = [NSMutableString stringWithFormat:@"%@=%@",[sortedValues objectAtIndex:0],[dict valueForKey:[sortedValues objectAtIndex:0]]];
    for (int i = 1; i < [sortedValues count]; i++) {
        [inputString appendString:[NSString stringWithFormat:@"%@=%@",[sortedValues objectAtIndex:i],[dict valueForKey:[sortedValues objectAtIndex:i]]]];
    }
    return inputString;
}

+ (NSString *)sign:(NSDictionary *)dict {
    NSString *result = [self serialize:dict];
    result = [Utility md5:result];
    return result;
}


+ (UIButton *)createTableViewFootButtonForTable:(UITableView *)tableView title:(NSString *)title color:(UIColor *)color {
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];

    btn.layer.cornerRadius = 5;
    [btn setBackgroundImage:[Utility createImageFromColor:color] forState:UIControlStateNormal];
    btn.left = kHorizontalMargin;
    btn.top = 10;
    btn.height = 44;
    btn.width = whiteView.width - 2 * kHorizontalMargin;
    [whiteView addSubview:btn];
    tableView.tableFooterView = whiteView;

    return btn;
}

+ (void)showAlertTitle:(NSString *)title msg:(NSString *)msg cancelTitle:(NSString *)cancelTitle commitBtnTitle:(NSString *)commitText handlerBlock:(void (^)(void))handler onVC:(UIViewController *)vc {
    void (^comitHandler)(void) = ^(void) {
        if (handler) {
            handler();
        }
    };
    CGFloat systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (systemVersion >= 8.0) {
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:nil];
        [alertCtrl addAction:cancelAction];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:commitText style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            comitHandler();
        }];
        [alertCtrl addAction:okAction];
        [vc presentViewController:alertCtrl animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:cancelTitle otherButtonTitles:commitText, nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                comitHandler();
            }
        }];
    }
}

+ (void)showMessageFromServer:(id)data defaultMsg:(NSString *)message {
    NSString *msg = message;
    NSString *msgFromServer = [data valueForKey:@"resultMessage"];
    if ([msgFromServer isKindOfClass:[NSString class]] && [msgFromServer length]) {
        msg = msgFromServer;
    }
    if ([msg length]) {
        [self showMessage:msg];
    }
}

+ (void)showMessage:(NSString *)message
{
    [Utility showMessageAlignCenter:message];
    //    [MBProgressHUD LightToolTipWithString:message];
}

+ (void)showMessageAlignCenter:(NSString *)message
{

    LPPopup *popup = [LPPopup popupWithText:message];

    CGFloat duration = MAX(2.0f, message.length / 12.0f);
    CGFloat offset = 0.0f;

    BOOL isNavBarHidden = YES;

    //consider nav bar
    //    if ( APP_DELEGATE.loginNavController.viewControllers >= 0 ) {
    //        isNavBarHidden = APP_DELEGATE.loginNavController.navigationBarHidden;
    //    }else if (APP_DELEGATE.navController.viewControllers >= 0 ){
    //        isNavBarHidden = APP_DELEGATE.navController.navigationBarHidden;
    //    }

    if (!isNavBarHidden) {
        offset = 23.0f;
    }

    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [popup showInView:window
        centerAtPoint:CGPointMake(window.center.x, window.center.y + 0 + offset)
             duration:duration
           completion:nil];

}

+ (void)showMessage:(NSString *)message withOffset:(CGFloat)offset
{
    LPPopup *popup = [LPPopup popupWithText:message];

    CGFloat duration = MAX(2.0f, message.length / 12.0f);

    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [popup showInView:window
        centerAtPoint:CGPointMake(window.center.x, window.center.y + 0 + offset)
             duration:duration
           completion:nil];
    //    popup.center = window.center;
    //    [MBProgressHUD LightToolTipWithString:message withOffset:offset];
}
/**
 *  判断是否允许访问相册
 */
+(BOOL)judgePhotoPerm
{

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];

        if (status == ALAuthorizationStatusDenied || status == ALAuthorizationStatusRestricted) {
            return NO;
        }
    }
    return YES;

}

+(void)showPhotoPermAlert
{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:locationString(@"warn") delegate:nil cancelButtonTitle:locationString(@"cancel") otherButtonTitles:nil];
    [alert show];
}

+ (void)showAlert:(NSString *)message
{
    UIAlertView *waitingDialog = [[UIAlertView alloc] initWithTitle:locationString(@"hint") message:message delegate:nil cancelButtonTitle:locationString(@"btn_confirm_yes") otherButtonTitles:nil];
    [waitingDialog show];
}

+ (BOOL)isNumberFromString:(NSString *)string
{
    if (string == nil) {
        return false;
    }

    if ([string isKindOfClass:[NSNumber class]]) {
        return YES;
    }

    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}

+ (UIImage *)resizeImageWithRawImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);

    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return resizedImage;
}

+ (UIImage *)restrictImage:(UIImage *)image inSize:(CGFloat)size
{
    if (image.size.width <= size && image.size.height <= size) {
        return image;
    }

    CGFloat hScale = image.size.width / size;
    CGFloat vScale = image.size.height / size;
    CGFloat scale = MAX(hScale, vScale);
    CGSize newSize = CGSizeMake(image.size.width / scale, image.size.height / scale);

    image = [Utility resizeImageWithRawImage:image scaledToSize:newSize];

    return image;
}

+ (BOOL)writeImage:(UIImage*)image toFileAtPath:(NSString*)aPath
{
    if ((image == nil) || (aPath == nil) || ([aPath isEqualToString:@""]))
        return NO;

    @try
    {
        NSData *imageData = nil;
        NSString *ext = [aPath pathExtension];
        if ([ext isEqualToString:@"png"]) {
            imageData = UIImagePNGRepresentation(image);
        } else {
            imageData = UIImageJPEGRepresentation(image, 0);
        }

        if ((imageData == nil) || ([imageData length] <= 0))
            return NO;

        [imageData writeToFile:aPath atomically:YES];
        return YES;
    } @catch (NSException *e) {
    }

    return NO;
}

+ (BOOL)isNetworkAvailable
{
    AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager managerForDomain:@"www.baidu.com"] networkReachabilityStatus];
    return status != AFNetworkReachabilityStatusNotReachable;
}

+ (BOOL)isMMbangAvailable
{
    //simialr to isNetworkAvaialble because we don't have a website now
    AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager managerForDomain:@"www.baidu.com"] networkReachabilityStatus];
    return status != AFNetworkReachabilityStatusNotReachable;
}

+ (BOOL)isHostAvailable:(NSString *)hostname
{
    AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager managerForDomain:hostname] networkReachabilityStatus];
    return status != AFNetworkReachabilityStatusNotReachable;
}


+ (void)showNetworkErrorMsg:(NSError *)error
{
    if (error) {
        [Utility processNetworkErrorMsg:error block:^(NSString *msg) {
            [Utility showMessage:msg];
        }];
    }
}

+ (void)processNetworkErrorMsg:(NSError *)error block:(ProcessStringBlock)block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *msg = [Utility getNetworkErrorMsg:error];
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(msg);
            });
        }
    });
}


+ (NSString *)getNetworkErrorMsg:(NSError *)error
{
    NSString *msg = @"";

    //error code: https://developer.apple.com/library/ios/documentation/Networking/Reference/CFNetworkErrors/Reference/reference.html
    if (error) {
        if (error.code == kCFURLErrorTimedOut) {
            // -1001 连接超时
            if ([Utility isNetworkAvailable]) {
                msg = locationString(@"unable_to_connect_to_server");
            } else {
                msg = locationString(@"network_is_not_good");
            }
        } else if (error.code == kCFURLErrorCannotConnectToHost) {
            // -1004
            BOOL networkAvailable = [Utility isNetworkAvailable];

            if (networkAvailable) {
                msg = locationString(@"unable_to_connect_to_server");
            } else {
                msg = locationString(@"network_is_not_good");
            }
        } else if (error.code == kCFURLErrorBadServerResponse) {
            // -1011 502 bad gateway
            msg = locationString(@"unable_to_connect_to_server");
        } else {
            // -1009
            msg = locationString(@"network_is_not_good");
        }
    }

    return msg;
}

+ (CGFloat)getFontSpaceWithLabel:(UIFont*)font{
    CGFloat space =  round(font.lineHeight - font.pointSize)/2.;
    return space;
}

#pragma mark 路径，存储
+ (NSURL *)getApplicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)getDocumentPath:(NSString *)lastFolderName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:lastFolderName];

    return documentsDirectory;
}

#pragma mark - 存储数据
+ (void)saveDataWithKey:(NSString *)key ofValue:(id)value
{
    NSString *k = [NSString stringWithFormat:MMBANG_DATA_CACHE, @"", key];
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:k];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)clearDataWithKey:(NSString *)key
{
    NSString *k = [NSString stringWithFormat:MMBANG_DATA_CACHE, @"", key];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:k];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)getDataWithKey:(NSString *)key
{
    NSString *k = [NSString stringWithFormat:MMBANG_DATA_CACHE, @"", key];
    return [[NSUserDefaults standardUserDefaults] objectForKey:k];
}

+ (void)saveEntityWithKey:(NSString *)key ofValue:(id)value
{
    NSData *entity = [NSKeyedArchiver archivedDataWithRootObject:value];

    [self saveDataWithKey:key ofValue:entity];
}

+ (id)getEntityWithKey:(NSString *)key
{
    NSData *entity = [self getDataWithKey:key];

    return [NSKeyedUnarchiver unarchiveObjectWithData:entity];
}

+ (void)clearLoginUserInfo
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"WeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"QQAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self saveDataWithKey:@"userID" ofValue:nil];
    [self saveDataWithKey:@"isGuset" ofValue:[NSNumber numberWithBool:YES]];
}

+ (BOOL)hasReadedGuide
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSNumber *readed = [Utility getDataWithKey:[NSString stringWithFormat:@"guide%@", version]];

    return readed && readed.boolValue == YES;
}

+ (void)readGuide
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

    [Utility saveDataWithKey:[NSString stringWithFormat:@"guide%@", version] ofValue:[NSNumber numberWithBool:YES]];
}

// 这个字段好像不会被清除掉，暂时用这个做为判断依据
+ (BOOL)isOldUser{
    id isGuest = [self getDataWithKey:@"isGuset"];
    if (isGuest != nil) {
        return YES;
    }
    return NO;
}

#pragma mark 存储 O2O 景区信息
/**
 *  返回所有城市的 景区信息
 *
 *  @return dictionary
 */
+ (NSDictionary *)getO2OAllScenices
{
    NSString *path = [self getDocumentPath:@"O2OScenicZones.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];

    return dic;
}
+ (NSDictionary *)getO2OScenicDataWithCityID:(NSString *)cityID
{
    NSString *path = [self getDocumentPath:@"O2OScenicZones.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];

    NSDictionary *scenic = dic[cityID];
    return scenic;
}

/**
 *  存储 足迹里面的景区信息，以里面的_id(城市id)直接存储
 *
 *  @param dictionary 从服务器拉回来的数据，
 *
 *  @return 是否存储成功
 */
+ (BOOL)saveO2OScenicData:(NSDictionary *)dictionary
{
    if (!dictionary) {
        return NO;
    }

    NSString *path = [self getDocumentPath:@"O2OScenicZones.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithCapacity:0];
    if (dic && [dic isKindOfClass:[NSDictionary class]]) {
        [mutDic setDictionary:dic];
    }
    // 删除 用户的 footprints
    NSMutableDictionary *mutScenic = [dictionary mutableCopy];
    [mutScenic removeObjectForKey:@"footprints"];

    int ID = [dictionary[@"_id"] intValue];
    [mutDic setObject:mutScenic forKey:[NSString stringWithFormat:@"%d",ID]];

    return [mutDic writeToFile:path atomically:YES];
}

#pragma mark - 存储 位置搜索的历史记录
+ (NSArray *)getO2OLocationSearchHistory
{
    NSString *path = [self getDocumentPath:@"O2OLocationSearchHistory.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *arr = [dic objectForKey:@"items"];
    return arr;
}

+ (BOOL)saveO2OLocationSearchHistory:(NSDictionary *)dictionary
{
    if (!dictionary) {
        return NO;
    }

    NSString *path = [self getDocumentPath:@"O2OLocationSearchHistory.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithCapacity:0];
    if (dic && [dic isKindOfClass:[NSDictionary class]]) {
        [mutDic setDictionary:dic];
    }
    NSMutableArray *arr = [mutDic[@"items"] mutableCopy];
    if (!arr) {
        arr = [NSMutableArray array];
    }

    BOOL isExit = NO;
    for (int i = 0; i<arr.count; i++) {
        NSDictionary *loc = arr[i];
        if ([loc isEqualToDictionary:dictionary]) {
            isExit = YES;
            [arr exchangeObjectAtIndex:i withObjectAtIndex:0];
            break;
        }
    }
    if (!isExit) {
        [arr insertObject:dictionary atIndex:0];
    }
    [mutDic setObject:arr forKey:@"items"];

    return [mutDic writeToFile:path atomically:YES];
}

+ (BOOL)cleanO2OLocationSearchHistory
{
    NSString *path = [self getDocumentPath:@"O2OLocationSearchHistory.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    return YES;
}

#pragma mark -
+ (NSString *)jsonStringWithObject:(id)object
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (BOOL)isEqualFromString:(NSString *)from toString:(NSString *)toString
{
    return [[NSString stringWithFormat:@"%@", from] isEqualToString:[NSString stringWithFormat:@"%@", toString]];
}

//mac address
// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to erica sadun & mlamb.
+ (NSString *)macAddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;

    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;

    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }

    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }

    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }

    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }

    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);

    return outstring;
}

//add li
BOOL isValidatePhone(NSString * candidate)
{
    //    NSString *phoneRegex = @"(13[0-9]|15[0|3|6|7|8|9]|18[2|3|6|7|8|9])\\d{8}";
    NSString *phoneRegex=@"(\\d{11,11})";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];

    return [phoneTest evaluateWithObject:candidate];
}

BOOL isValidateEmail(NSString * candidate)
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

    return [emailTest evaluateWithObject:candidate];
}

void TTAlert(NSString* message) {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:locationString(@"hint")
                                                    message:message delegate:nil
                                          cancelButtonTitle:locationString(@"cancel")
                                          otherButtonTitles:nil];
    [alert show];
}

UIColor * colorWithHexString(NSString *stringToConvert)
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;

    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];

    range.location = 2;
    NSString *gString = [cString substringWithRange:range];

    range.location = 4;
    NSString *bString = [cString substringWithRange:range];


    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

NSString* getBabyGenerType(NSString*string)
{
    if (string.length== 0)
    {
        return nil;
    }else
    {
        NSArray *array = [[NSArray alloc]initWithObjects:locationString(@"no_sex"), locationString(@"boy"), locationString(@"girl"), locationString(@"brother"), locationString(@"sister"), locationString(@"twin"), locationString(@"multiple_birth"), nil];
        NSInteger i = [array indexOfObject:string];

        return [NSString stringWithFormat:@"%@",@(i+1)];
    }
}

void setExclusiveTouchToChildrenOf(NSArray *subviews)
{
    for (UIView *v in subviews) {
        //        [self setExclusiveTouchToChildrenOf:v.subviews];

        setExclusiveTouchToChildrenOf(v.subviews);
        if ([v isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)v;
            [btn setExclusiveTouch:YES];
        }
    }
}



#pragma mark -- createFilePath

+(NSString *)folderPath:(NSString*)folderPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *newFilePath = [paths[0] stringByAppendingPathComponent:folderPath];
    return newFilePath;
}

+ (NSString *)createFolderPathIfNeeded:(NSString*)folderPath
{
    BOOL pathExists = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *newFolderPath = [paths[0] stringByAppendingPathComponent:folderPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if (![fileManager fileExistsAtPath:newFolderPath]) {
        [fileManager createDirectoryAtPath:newFolderPath withIntermediateDirectories:YES attributes:nil error:NULL];
        pathExists = [fileManager fileExistsAtPath:newFolderPath];
    } else {
        pathExists = YES;
    }

    return pathExists ? newFolderPath : nil;
}


+ (void)cleanFolderPath:(NSString*)folderPath
{
    dispatch_queue_t removeOtherCacheQueue = dispatch_queue_create("removeOtherCache", DISPATCH_QUEUE_SERIAL);
    dispatch_async(removeOtherCacheQueue, ^
                   {
                       [[NSFileManager defaultManager] removeItemAtPath:[self folderPath:folderPath] error:nil];
                       [self createFolderPathIfNeeded:folderPath];
                   });
}



BOOL getFileName(NSString *fileName)
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:fileName];

    return [fm fileExistsAtPath:filename];

}
void removePlist(NSString *strPlistName)
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];

    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:strPlistName];
    if ([fm fileExistsAtPath:filename])
    {
        NSError *error;
        BOOL isDelete = [fm removeItemAtPath:filename error:&error];
        NSLog(@"%d",isDelete);
    }
}
//创建文件
NSString * getPlistName(NSString *strPlistName)
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:strPlistName];
    if (![fm fileExistsAtPath:filename])
    {
        [fm createFileAtPath:filename contents:nil attributes:nil];
    }
    return filename;
}
void writeToPlist(NSString *strPlistName, NSData *arrData)
{
    [arrData writeToFile:getPlistName(strPlistName) atomically:YES];

}

#pragma mark - UIWebView UserAgent

+ (void)registerUIWebViewUserAgent{

    // Set user agent (the only problem is that we can't modify the User-Agent later in the program)

    NSString *originUserAgent = [self originUIWebViewUserAgent];

    NSString *mmbangVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *modifiedUserAgent = [NSString stringWithFormat:@"%@ mmbang/%@",originUserAgent,mmbangVersion];

    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:modifiedUserAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];

}

// see http://stackoverflow.com/a/19184414

+ (NSString *)originUIWebViewUserAgent{
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString* secretAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    return secretAgent;
}

#pragma mark -
#pragma mark 判断字符串是否为空（nil和length为0都是空）

+ (BOOL)isEmpty:(NSString *)value
{
    return  (nil == value || [value isKindOfClass:[NSNull class]] || ([value length] == 0) || [[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]);
}

+(void)showAlertWithTitle:(NSString*)title andContentString:(NSString*)content {
    [self showAlertWithTitle:title andContentString:content title:nil];
}

+(void)showAlertWithTitle:(NSString*)title andContentString:(NSString*)content title:(NSString *)commitTitle
{
    UIAlertView*alert = [[UIAlertView alloc] initWithTitle:title message:content delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];

    NSString *appSettingsUrl;

#if defined __IPHONE_8_0
    if (SYSTEM_VERSION_GREATER_THAN([NSString stringWithFormat:@"7.9"])) {
        appSettingsUrl = UIApplicationOpenSettingsURLString;
    }
#endif

    if (appSettingsUrl) {
        [alert addButtonWithTitle:locationString(@"btn_cancel")];
        NSString *btnTitle = locationString(@"action_settings");
        if ([commitTitle length]) {
            btnTitle = commitTitle;
        }
        [alert addButtonWithTitle:btnTitle];
    } else {
        [alert addButtonWithTitle:locationString(@"btn_confirm")];
    }

    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex)
     {
         if (buttonIndex == 1)
         {
             [Utility openURL:[NSURL URLWithString:appSettingsUrl]];

         }
     }];
}

+ (UILabel *)createLabel:(UIFont *)textFont color:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = textColor;
    label.backgroundColor = [UIColor clearColor];
    label.font = textFont;
    return label;
}
/**
 *  格式化距离，如果小于1000米，则单位返回 ***米，否则返回 ****公里
 *
 *  @param meters 需要格式化的 距离，单位为米
 *
 *  @return 格式化后的字符串
 */
+ (NSString *)formatDistanceWithMeters:(double)meters
{
    if (meters < 1000) {
        NSString *result = [NSString stringWithFormat:@"%g米",meters];
        return result;
    } else {
        NSString *result = [NSString stringWithFormat:@"%.1f公里",meters/1000.0];
        return result;
    }
}

//+ (UIView *)resizeButton:(UIButton *)origBtn to:(CGSize)newSize {
//    EnlargeActionView *newView = [[EnlargeActionView alloc] init];
//    newView.size = newSize;
//    [newView addSubview:origBtn];
//    newView.originView = origBtn;
//    origBtn.center = newView.myCenter;
//    return newView;
//}

//+ (UIImage *)createDefaultImage:(NSString *)defaultImageName InView:(UIView *)parentView {
//
//    UIImage *cacheIm = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:[[NSMutableString alloc] initWithFormat:@"%@Width_%@Height_%@",defaultImageName,@(parentView.width),@(parentView.height)]];
//    if (cacheIm) {
//        return cacheIm;
//    }
//    UIImage *image = [UIImage imageNamed:defaultImageName];
//    CGFloat width = parentView.width;
//    CGFloat height = parentView.height;
//
//    //suppose image is square.
//    NSAssert(fabs(image.size.width - image.size.height) < 2, @"default image is squre. It's a minor request, please obey");
//
//    CGFloat minWidth = MIN(width, height);
//    CGFloat imgWidth = image.size.width;
//
//    if (minWidth < imgWidth) {
//        imgWidth = minWidth * 3 / 4;
//    }
//
//    CGRect imgFrame = CGRectMake((width - imgWidth) / 2, (height - imgWidth) / 2, imgWidth, imgWidth);
//
//    CGRect rect = CGRectMake(0, 0, parentView.width, parentView.height);
//    UIColor *color = [UIColor colorWithHex:0xf4f4f4 alpha:1];
//    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, color.CGColor);
//    CGContextFillRect(context, rect);
//    [image drawInRect:imgFrame];
//    image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    [[SDImageCache sharedImageCache] storeImage:image forKey:[[NSMutableString alloc] initWithFormat:@"%@Width_%@Height_%@",defaultImageName,@(parentView.width),@(parentView.height)] toDisk:NO];
//    return image;
//}
//
//+ (UIImage *)createDefaultO2OImageInView:(UIView *)parentView {
//    UIImage *image = [self createDefaultImage:kDefaultO2OImage InView:parentView];
//    return image;
//}



+(NSString *)folderSizeAtPath:(NSString *)path{

    const char* folderPath = [path cStringUsingEncoding:NSUTF8StringEncoding];
    long long folderSize = 0;
    DIR* dir = opendir(folderPath);
    if (dir == NULL) return 0;
    struct dirent* child;
    while ((child = readdir(dir)) != NULL) {

        if (child->d_type == DT_DIR && (
                                        (child->d_name[0] == '.' && child->d_name[1] == 0) || // 忽略目录 .
                                        (child->d_name[0] == '.' && child->d_name[1] == '.' && child->d_name[2] == 0) // 忽略目录 ..
                                        )) continue;

        unsigned long folderPathLength = strlen(folderPath);

        char childPath[1024]; // 子文件的路径地址

        stpcpy(childPath, folderPath);

        if (folderPath[folderPathLength-1] != '/'){
            childPath[folderPathLength] = '/';
            folderPathLength++;
        }

        stpcpy(childPath+folderPathLength, child->d_name);

        if (child->d_type == DT_REG || child->d_type == DT_LNK){ // file or link
            struct stat st;
            if(lstat(childPath, &st) == 0) folderSize += st.st_size;
        }
    }
    closedir(dir);
    NSString *sizeString = [NSString stringWithFormat:@"%.1fM",folderSize/(1024.0*1024.0)];
    return sizeString;
}

+ (BOOL)emptyOrNull:(NSString *)str
{
    return str == nil || (NSNull *)str == [NSNull null] || str.length == 0 ;
}

#pragma mark - 生成 UUID
+ (NSString *)createUUID
{
    // generate a new uuid and store it in user defaults
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    NSString *uuID = (NSString *) CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
    CFRelease(uuid);

    return uuID;
}

#pragma mark - device Model

+ (NSString *)deviceModelOrigin {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

+ (NSString *)deviceModel {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);

    //http://blog.csdn.net/xufeidll/article/details/24306187
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";

    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch (1 Gen)";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch (2 Gen)";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch (3 Gen)";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch (4 Gen)";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";

    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini(WCDMA)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";

    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";

    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";

    return platform;
}


+ (void)tellPhoneNumber:(NSString *)phoneNumber
{
    UIAlertView*alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:locationString(@"client_line"), [Utility appName]] message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textFiled = [alert textFieldAtIndex:0];
    textFiled.clearButtonMode = UITextFieldViewModeAlways;
    textFiled.text = phoneNumber;
    textFiled.keyboardType = UIKeyboardTypePhonePad;
    [alert addButtonWithTitle:locationString(@"think_again")];
    [alert addButtonWithTitle:locationString(@"call_client")];
    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex){
        if (buttonIndex == 1)
        {
            [Utility openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",textFiled.text]]];
        }
    }];
}

+ (void)showAlert:(NSString *)msg commitBtnTitle:(NSString *)commitText handler:(void (^)(UIAlertAction *action))handler oldHandleBlock:(void (^)(void))oldHandler onVC:(UIViewController *)vc {
    CGFloat systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (systemVersion >= 8.0) {
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:locationString(@"hint") message:msg preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:locationString(@"btn_cancel") style:UIAlertActionStyleDefault handler:nil];
        [alertCtrl addAction:cancelAction];

        UIAlertAction *okAction = [UIAlertAction actionWithTitle:commitText style:UIAlertActionStyleDefault handler:handler];
        [alertCtrl addAction:okAction];
        [vc presentViewController:alertCtrl animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:locationString(@"hint") message:msg delegate:nil cancelButtonTitle:locationString(@"btn_cancel") otherButtonTitles:commitText, nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if(buttonIndex==1){
                if (oldHandler) {
                    oldHandler();
                }
            }
        }];
    }
}

//for ios version < 8.0
+ (BOOL)canHandlePushOnOldSys {
    BOOL canHandle = YES;

    //we support IOS8+
//    UIRemoteNotificationType remoteNotificationType = [UIApplication sharedApplication].enabledRemoteNotificationTypes;
//    if (remoteNotificationType == UIRemoteNotificationTypeNone) {
//        canHandle = NO;
//    }

    return canHandle;
}

+ (BOOL)canHandlePush {
    BOOL canHandle = YES;

#ifdef __IPHONE_8_0
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(currentUserNotificationSettings)]) {
        UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (settings.types == UIUserNotificationTypeNone) {
            canHandle = NO;
        }
    } else {
        canHandle = [self canHandlePushOnOldSys];
    }
#else
    canHandle = [self canHandlePushOnOldSys];
#endif

    DLog(@"canhandle : %@, another bool:%@", @(canHandle), @([UIApplication sharedApplication].applicationState != UIApplicationStateActive));
    return canHandle || [UIApplication sharedApplication].applicationState != UIApplicationStateActive;
}

+ (BOOL)isDate:(NSDate *)date1 sameDayToDate:(NSDate *)date2 format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *dayVString = [formatter stringFromDate:date1];
    NSString *focusDayString = [formatter stringFromDate:date2];
    return [dayVString isEqualToString:focusDayString];
}



+ (void)openURL:(NSURL *)url {
    //    http://stackoverflow.com/questions/19356488/openurl-freezes-app-for-over-10-seconds

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[UIApplication sharedApplication] openURL:url];
    });
}

+ (NSArray *)calsInvalidDaysForYear:(int)year month:(int)month day:(int)day {
    int fixedDays = 31;

    NSMutableArray *months = [@[@31,@0,@31,@30,@31,@30,@31,@31,@30,@31,@30,@31,@31,@0,@31,@30,@31,@30,@31,@31,@30,@31,@30,@31,@31] mutableCopy];

    months[1] = (((year%4 == 0)&&(year%100 != 0)) || (year%400 == 0)) ? @29 : @28;
    year += 1;
    months[13] = (((year%4 == 0)&&(year%100 != 0)) || (year%400 == 0)) ? @29 : @28;

    NSMutableArray *invalidDays = [NSMutableArray array];

    //
    for (int i = 1; i <= 12; i++) {
        int tmpMonth = month + 1;
        NSInteger maxDay = [months[tmpMonth - 1] integerValue];
        NSInteger curMaxDay = [months[month - 1] integerValue];

        NSInteger validDays = (curMaxDay - day + 1 + maxDay);
        if (day > maxDay) {
            //day = 31, maxDay = 28,
            //[month day----month, curMax], [1, max] 有效
            //
            day = 1;
            month = tmpMonth + 1;
        } else {
            //day <= maxDay, day - 1 means last day in current month, so vaild days are:
            //[month ,day --- month, curMax], 1 - (day -1)
            validDays = (curMaxDay - day + 1 + day - 1);
            month = tmpMonth;
        }

        for (NSInteger j = validDays + 1; j <= fixedDays; j++) {
            [invalidDays addObject:@((i - 1) * fixedDays + j - 1)];
        }

    }

    return invalidDays;
}

+ (UIButton *)createButtonWithFrame:(CGRect)frame iconName:(NSString *)iconName target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+ (CGFloat)lineWidth
{
    static CGFloat width = 0;
    width = 1/[[UIScreen mainScreen] scale];
    return width;
}

+ (void)selectTextForInput:(UITextField *)input atRange:(NSRange)range {
    UITextPosition *start = [input positionFromPosition:[input beginningOfDocument]
                                                 offset:range.location];
    UITextPosition *end = [input positionFromPosition:start
                                               offset:range.length];
    [input setSelectedTextRange:[input textRangeFromPosition:start toPosition:end]];
}


@end
