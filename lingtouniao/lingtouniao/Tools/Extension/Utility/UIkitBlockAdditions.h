//
//  BlockedUIs.h
//  haowan
//
//  Created by wupeijing on 3/29/15.
//  Copyright (c) 2015 iyaya. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^ButtonBlockAction)(UIButton *btn);
typedef void (^TapBlockAction)(UITapGestureRecognizer *tap);


@interface UIKitBlockAdditions : NSObject

@end

@interface UIButton (Block)

@property (nonatomic) ButtonBlockAction tappedBlock;

@end

@interface UIView(Block)

@property (nonatomic) TapBlockAction tappedBlock;

@end