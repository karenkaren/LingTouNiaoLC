//
//  LTNProductDetailController.h
//  lingtouniao
//
//  Created by LiuFeifei on 15/12/11.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "LTNProduct.h"

@protocol LTNProductDetailControllerDelegate <NSObject>

- (void)needsRefreshWithProduct:(LTNProduct *)product;

@end

@interface LTNProductDetailController : BaseTableViewController

@property (nonatomic, weak) id<LTNProductDetailControllerDelegate> delegate;
@property (nonatomic, strong) LTNProduct * product;
@property (nonatomic, assign) NSInteger productId;

@property (nonatomic,strong)NSMutableArray *coupounArray;

@end
