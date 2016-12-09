//
//  ProductDetailFooterView.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/9/24.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FooterType) {
    FooterTypeOfNormal,
    FooterTypeOfLogin,
    FooterTypeOfTYB,
    FooterTypeOfXSB,
    FooterTypeOfUnknow
};

typedef NS_ENUM(NSUInteger, FooterEnterType) {
    FooterEnterTypeOfLogin,
    FooterEnterTypeOfRegister
};

@protocol ProductDetailFooterViewDelegate <NSObject>

- (void)purchseProduct:(UIButton *)button;
- (void)purchaseOnce:(UIButton *)button;
- (void)enterPlatformWithFooterEnterType:(FooterEnterType)footerEnterType;

@end

@interface ProductDetailFooterView : UIView

@property (nonatomic, weak) id<ProductDetailFooterViewDelegate> delegate;
@property (nonatomic, strong) UITextField * amountTextField;
- (instancetype)initWithType:(FooterType)footerType delegate:(id<ProductDetailFooterViewDelegate>)delegate;
- (void)refreshWithFooterType:(FooterType)footerType;

@end
