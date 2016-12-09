//
//  LTNFriendsCell.h
//  lingtouniao
//
//  Created by 郑程锋 on 15/12/25.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsModel.h"
#define kPartnerCellHeight  110

typedef NS_ENUM(NSUInteger, MyFriendsStatus) {
    MyFriendsStatusRegister,
    MyFriendsStatusNameAuthenticated,
    MyFriendsStatusPurchased,
};


@protocol LTNFriendsHeaderViewTapDelegate <NSObject>

- (void)selectStatus:(MyFriendsStatus)status;

@end


@interface LTNFriendsHeaderView : UIView

@property (nonatomic) FriendsModel *model;
@property (nonatomic, weak) id<LTNFriendsHeaderViewTapDelegate> delegate;
@property (nonatomic) UIColor *selectedColor;

- (instancetype)initWithSelectableStatus:(BOOL)canBeSelected;

//select status, called from outside to update UI
- (void)selectStatus:(MyFriendsStatus)status;

@end
