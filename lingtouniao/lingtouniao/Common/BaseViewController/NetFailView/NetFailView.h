//
//  NetFailView.h
//  mmbang
//
//  Created by lihuaming on 14/11/3.
//  Copyright (c) 2014年 iyaya. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TouchNetFailViewBlock)(UIView *view);

@interface NetFailView : UIView

@property (nonatomic) UIImageView *failIm;
@property (nonatomic) UILabel *remindeLabel;
@property (nonatomic) UILabel *subRemindeLabel;
@property (nonatomic, retain) UIImage *iconImage;
@property (nonatomic) NSString *message;
@property (nonatomic) NSString *subMessage;
@property (nonatomic) NSString *imName;

@property (nonatomic, retain) UIView *customView;

@property (nonatomic,copy) TouchNetFailViewBlock touchNetFailView;

@property (nonatomic, readonly) UITapGestureRecognizer *tapGesture;

- (id)initWithFrame:(CGRect)frame;

@end
