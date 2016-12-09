//
//  LTNAccountCell.h
//  lingtouniao
//
//  Created by LiuFeifei on 15/12/12.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAccountCellHeight 70
#define kAccountCellWidth [UIScreen mainScreen].bounds.size.width

@protocol LTNAccountCellDelegate <NSObject>

- (void)accountCellWillShowUsableBalanceDetail;
- (void)accountCellWillShowBirdCoinDetail;
- (void)accountCellWillShowTotalAssetDetail;

@end

@interface LTNAccountCell : UIView

@property (nonatomic, weak) id<LTNAccountCellDelegate> delegate;
@property (nonatomic,assign) BOOL isShow;


-(void)updateCell;
@end
