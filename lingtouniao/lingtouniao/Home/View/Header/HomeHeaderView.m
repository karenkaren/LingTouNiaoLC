//
//  HomeHeaderView.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/5/20.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "HomeHeaderView.h"
#import "BaseWebViewController.h"

#define kMargin DimensionBaseIphone6(12.5)
// 总高度
#define kHeaderTotalHeight DimensionBaseIphone6(350)
// dock高度
#define kDockHeight DimensionBaseIphone6(90)
// 平台信息高度
#define kPlatformHeight DimensionBaseIphone6(65)
// 底部阴影高度
#define kBottomShadowHeight DimensionBaseIphone6(4)
// 底部视图总高
#define kBottomTotalHeight kDockHeight + kPlatformHeight + kBottomShadowHeight
// 底部试图距离最底端的距离
#define kSpacingWithBottomViewAndBottomLine DimensionBaseIphone6(8)
#define kMessageCountLabelDiam 16

//#define kEyeHide @"eyeHide"
//#define kHeaderHeight (kHeaderTotalHeight - kDockHeight)
//#define kWhiteAlphaColor(a) [UIColor colorWithRed:1 green:1 blue:1 alpha:a]
//#define kDefaultWhiteColor kWhiteAlphaColor(0.8)

@interface HomeHeaderView ()<LTNAcitonBarDelegate>

@property (nonatomic, strong) UIView * backgroundView;
@property (nonatomic, strong) UIView * bottomView;
// 平台信息view
@property (nonatomic, strong) UIView * platformView;
// dock view
@property (nonatomic, strong) LTNAcitonBar * actionBar;
// 平台累计投资总额label
@property (nonatomic, strong) UILabel * platformTotalLabel;
// 平台用户注册总数label
@property (nonatomic, strong) UILabel * registerTotalLabel;
// 用户赚取收益总额label
@property (nonatomic, strong) UILabel * incomeTotalLabel;
// 消息中心数字label
@property (nonatomic, strong) UILabel * messageAmountLabel;

@end

@implementation HomeHeaderView

#pragma mark factory method
+ (HomeHeaderView *)getHomeHeaderViewWithTarget:(id<HomeHeaderViewDelegate>)target
{
    HomeHeaderView * homeHeaderView = [[HomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderTotalHeight) target:target];
    //    homeHeaderView.backgroundColor = BACKGROUND_COLOR;
    return homeHeaderView;
}

#pragma mark init method
- (instancetype)initWithFrame:(CGRect)frame target:(id<HomeHeaderViewDelegate>)target
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = target;
        [self addSubview:self.backgroundView];
        [self addSubview:self.bottomView];
        
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(kMargin);
            make.right.equalTo(self).offset(-kMargin);
            make.height.equalTo(@(kBottomTotalHeight));
            make.width.equalTo(self).offset(-2.0 * kMargin);
            make.bottom.equalTo(self).offset(-kSpacingWithBottomViewAndBottomLine);
        }];
    }
    return self;
}

#pragma mark getter methods
- (UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:_backgroundView];
        
        // 背景图
        UIImageView * bacrgroundImageView = [[UIImageView alloc] initWithFrame:_backgroundView.bounds];
        bacrgroundImageView.image = [UIImage imageNamed:@"header_homepage"];
        [_backgroundView addSubview:bacrgroundImageView];
        
        // 消息中心按钮
        UIImage * messageImage = [[UIImage imageNamed:@"tixing"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIButton * messageButton = [[UIButton alloc] init];
        [messageButton setImage:messageImage forState:UIControlStateNormal];
        [messageButton addTarget:self action:@selector(messageClick:) forControlEvents:UIControlEventTouchUpInside];
        [messageButton addSubview:self.messageAmountLabel];
        [_backgroundView addSubview:messageButton];
        
        [messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_backgroundView).offset(-kMargin);
            make.size.mas_equalTo(CGSizeMake(messageImage.size.width, messageImage.size.height));
            make.top.equalTo(_backgroundView).offset(30);
        }];
        
        [self.messageAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kMessageCountLabelDiam, kMessageCountLabelDiam));
            make.centerY.equalTo(messageButton.mas_top).offset(5);
            make.centerX.equalTo(@(messageImage.size.width - 15));
        }];
    }
    return _backgroundView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        [_bottomView addSubview:self.actionBar];
        [_bottomView addSubview:self.platformView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCheckReport:)];
        [self.platformView addGestureRecognizer:tap];
        
        UIView * lineView = [[UIView alloc] init];
        lineView.backgroundColor = HexRGB(0xe2e2e2);
        [_bottomView addSubview:lineView];
        
        [self.actionBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.width.equalTo(_bottomView);
            make.height.equalTo(@(kDockHeight));
            make.bottom.equalTo(self.platformView.mas_top);
        }];
        
        [self.platformView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.width.equalTo(_bottomView);
            make.height.equalTo(@(kPlatformHeight));
            make.top.equalTo(self.actionBar.mas_bottom);
        }];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(1.0 / [UIScreen mainScreen].scale));
            make.width.equalTo(_bottomView).offset(-2.0 * kMargin);
            make.top.equalTo(self.actionBar.mas_bottom);
            make.centerX.equalTo(_bottomView);
        }];
        
        //加阴影
        _bottomView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        _bottomView.layer.shadowOffset = CGSizeMake(kBottomShadowHeight,kBottomShadowHeight);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _bottomView.layer.shadowOpacity = 0.1;//阴影透明度，默认0
//        _bottomView.layer.shadowRadius = 4;//阴影半径，默认3
    }
    return _bottomView;
}

- (UIView *)platformView
{
    if (!_platformView) {
        _platformView = [[UIView alloc] init];
        
        // 平台累计投资
        UIView * platformTotalView = [[UIView alloc] init];
        [_platformView addSubview:platformTotalView];
        
        // 平台用户突破
        UIView * registerTotalView = [[UIView alloc] init];
        [_platformView addSubview:registerTotalView];
        
        // 用户赚取收益
        UIView * incomeTotalView = [[UIView alloc] init];
        [_platformView addSubview:incomeTotalView];
        
        [platformTotalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_platformView).multipliedBy(1.0 / 3.0);
            make.width.equalTo(@[registerTotalView, incomeTotalView]);
            make.left.top.height.equalTo(_platformView);
            make.right.equalTo(registerTotalView.mas_left);
        }];
        
        [registerTotalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_platformView).multipliedBy(1.0 / 3.0);
            make.width.equalTo(@[platformTotalView, incomeTotalView]);
            make.top.height.equalTo(_platformView);
            make.left.equalTo(platformTotalView.mas_right);
            make.right.equalTo(incomeTotalView.mas_left);
        }];
        
        [incomeTotalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_platformView).multipliedBy(1.0 / 3.0);
            make.width.equalTo(@[platformTotalView, registerTotalView]);
            make.top.height.right.equalTo(_platformView);
            make.left.equalTo(platformTotalView.mas_right);
        }];
        
        self.platformTotalLabel = [Utility createLabel:kFont(18) color:HexRGB(0x666666)];
        [platformTotalView addSubview:self.platformTotalLabel];
        UILabel * platformTotalTitleLabel = [self creatLabelWithTitle:@"平台累计投资"];
        [platformTotalView addSubview:platformTotalTitleLabel];
        [self addConstraintsForDataView:self.platformTotalLabel];
        [self addConstraintsForTitleView:platformTotalTitleLabel];
        
        self.registerTotalLabel = [Utility createLabel:kFont(18) color:[UIColor grayColor]];
        [registerTotalView addSubview:self.registerTotalLabel];
        UILabel * registerTotalTitleLabel = [self creatLabelWithTitle:@"平台用户突破"];
        [registerTotalView addSubview:registerTotalTitleLabel];
        [self addConstraintsForDataView:self.registerTotalLabel];
        [self addConstraintsForTitleView:registerTotalTitleLabel];
        
        self.incomeTotalLabel = [Utility createLabel:kFont(18) color:[UIColor grayColor]];
        [incomeTotalView addSubview:self.incomeTotalLabel];
        UILabel * incomeTotalTitleLabel = [self creatLabelWithTitle:@"用户赚取收益"];
        [incomeTotalView addSubview:incomeTotalTitleLabel];
        [self addConstraintsForDataView:self.incomeTotalLabel];
        [self addConstraintsForTitleView:incomeTotalTitleLabel];
    }
    return _platformView;
}

#pragma mark -- 消息中心上显示数量的label
-(UILabel *)messageAmountLabel{
    if (!_messageAmountLabel) {
        _messageAmountLabel = [Utility createLabel:[CustomerizedFont heiti:10] color:[UIColor whiteColor]];
        _messageAmountLabel.textAlignment = NSTextAlignmentCenter;
        _messageAmountLabel.backgroundColor = [UIColor redColor];
        _messageAmountLabel.layer.cornerRadius = kMessageCountLabelDiam * 0.5;
        _messageAmountLabel.layer.masksToBounds = YES;
        if (_messageAmountLabel.text == nil) {
            _messageAmountLabel.hidden = YES;
        }
    }
    return _messageAmountLabel;
}

- (LTNAcitonBar *)actionBar
{
    if (_actionBar == nil) {
        _actionBar = [[LTNAcitonBar alloc] initWithFrame:CGRectMake(0, 0, self.width - 2 * kMargin, kDockHeight)];
        _actionBar.backgroundColor = [UIColor whiteColor];
        _actionBar.delegate = self;
        [_actionBar addActionItemWithIcon:@"pinpai" selectedIcon:nil title:locationString(@"tab_home_brand")];
        [_actionBar addActionItemWithIcon:@"huodong" selectedIcon:nil  title:locationString(@"tab_home_activity")];
        [_actionBar addActionItemWithIcon:@"licaijinjuan" selectedIcon:nil title:locationString(@"tab_home_volume")];
        [_actionBar addActionItemWithIcon:@"anquanbaozhang" selectedIcon:nil title:locationString(@"tab_home_anquan")];
    }
    return _actionBar;
}

#pragma mark actionBar delegate
- (void)acitonBar:(LTNAcitonBar *)acitonBar clickedItemIndex:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickAcitonBar:clickedItemIndex:)]) {
        [self.delegate clickAcitonBar:acitonBar clickedItemIndex:index];
    }
}

#pragma mark - event methods
- (void)clickCheckReport:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickCheckReport:)]) {
        [self.delegate clickCheckReport:sender];
    }
}

- (void)messageClick:(UIButton *)messageButton
{
    [LTNUtilsHelper actionWhenLogin:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickMessageCenter:)]) {
            [self.delegate clickMessageCenter:messageButton];
        }
    }];
}

#pragma mark - private methods
- (void)addConstraintsForTitleView:(UIView *)view
{
    UIView * superView = view.superview;
    if (superView) {
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superView.mas_centerY).offset(5);
            make.centerX.equalTo(superView.mas_centerX);
        }];
    }
}

- (void)addConstraintsForDataView:(UIView *)view
{
    UIView * superView = view.superview;
    if (superView) {
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(superView.mas_centerY).offset(2.5);
            make.centerX.equalTo(superView.mas_centerX);
        }];
    }
}

- (UILabel *)creatLabelWithTitle:(NSString *)title
{
    UILabel * titleLabel = [Utility createLabel:kFont(11) color:HexRGB(0x666666)];
    titleLabel.text = title;
    [titleLabel sizeToFit];
    return titleLabel;
}

- (void)refresh
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    self.platformTotalLabel.text = [defaults stringForKey:kPlatformAllAmount];
    [self.platformTotalLabel sizeToFit];
    [self addAttributesForLabel:self.platformTotalLabel];
    self.registerTotalLabel.text = [defaults stringForKey:kPlatformRegisterNum];
    [self.registerTotalLabel sizeToFit];
    [self addAttributesForLabel:self.registerTotalLabel];
    self.incomeTotalLabel.text = [defaults stringForKey:kSumRevenue];
    [self.incomeTotalLabel sizeToFit];
    [self addAttributesForLabel:self.incomeTotalLabel];
    [self updateMessageCount];
}

- (void)addAttributesForLabel:(UILabel *)label
{
    if (label.text.length > 2) {
        [label addAttributesWithFontSize:15 forString:[label.text substringWithRange:NSMakeRange(label.text.length - 2, 2)]];
    }
}

-(void)updateMessageCount{
    
//    NSInteger unreadMessageCount = [CurrentUser mine].accountInfo.unreadMessageCount;
    NSInteger unreadMessageCount = [[NSUserDefaults standardUserDefaults] integerForKey:kUnreadMessageCount];
    if (unreadMessageCount) {
        self.messageAmountLabel.hidden=NO;
        self.messageAmountLabel.text = [NSString stringWithFormat:@"%ld", unreadMessageCount];
    }else{
        self.messageAmountLabel.hidden=YES;
    }
}

@end
