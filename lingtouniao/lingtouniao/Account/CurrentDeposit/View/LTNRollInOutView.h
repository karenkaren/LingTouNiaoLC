//
//  LTNRollInOutView.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/1/21.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTNMyCurrentDepositModel.h"

typedef NS_ENUM(NSUInteger, RollType) {
    RollIn,
    RollOut
};

@class LTNRollInOutView;
@protocol LTNRollInOutViewDelegate <NSObject>

- (void)rollInOutView:(LTNRollInOutView *)rollInOutView submitButton:(UIButton *)sumbitButton submitRequestWithAmount:(double)amount;
@optional
- (void)rollInOutViewWillShowInvestProtocol;

@end

@interface LTNRollInOutView : UIView

@property (nonatomic, weak) id<LTNRollInOutViewDelegate> delegate;

- (instancetype)initWithType:(RollType)rollType currentDepositInfo:(LTNMyCurrentDepositModel *)currentDepositInfo target:(id)target;
- (void)refreshUI;

@end
