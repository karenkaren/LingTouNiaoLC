//
//  HomeHeaderView.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/5/20.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "HomeHeaderView.h"
#import "BaseWebViewController.h"

#define kEyeHide @"eyeHide"

#define kHeaderTotalHeight DimensionBaseIphone6(350)
#define kDockHeight DimensionBaseIphone6(75)
#define kHeaderHeight (kHeaderTotalHeight - kDockHeight)
#define kWhiteAlphaColor(a) [UIColor colorWithRed:1 green:1 blue:1 alpha:a]
#define kDefaultWhiteColor kWhiteAlphaColor(0.8)

@interface HomeHeaderView ()<LTNAcitonBarDelegate>

@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) LTNAcitonBar * actionBar;
@property (nonatomic, strong) UIView * loginHeaderView;
@property (nonatomic, strong) UIView * logoutHeaderView;
@property (nonatomic, strong) UIView * incomeTotalView;
@property (nonatomic, strong) UIButton * eyeButton;

@end

@implementation HomeHeaderView

#pragma mark factory method
+ (HomeHeaderView *)getHomeHeaderViewWithTarget:(id<HomeHeaderViewDelegate>)target
{
    HomeHeaderView * homeHeaderView = [[HomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderTotalHeight) target:target];
    homeHeaderView.backgroundColor = BACKGROUND_COLOR;
    
    return homeHeaderView;
}

#pragma mark init method
- (instancetype)initWithFrame:(CGRect)frame target:(id<HomeHeaderViewDelegate>)target
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = target;
        [self addSubview:self.headerView];
        [self addSubview:self.actionBar];
    }
    return self;
}

#pragma mark getter方法
- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderHeight)];
        
        UIImageView * headerBackgrouond = [[UIImageView alloc] initWithFrame:_headerView.bounds];
        headerBackgrouond.image = [UIImage imageNamed:@"header_homepage"];
        [_headerView addSubview:headerBackgrouond];
        [[CurrentUser mine] hasLogged] ? [_headerView addSubview:self.loginHeaderView] : [_headerView addSubview:self.logoutHeaderView];
    }
    return _headerView;
}

- (LTNAcitonBar *)actionBar
{
    if (_actionBar == nil) {
        _actionBar = [[LTNAcitonBar alloc] initWithFrame:CGRectMake(0, kHeaderHeight, kScreenWidth, kDockHeight)];
        _actionBar.backgroundColor = [UIColor whiteColor];
        _actionBar.delegate = self;
        [_actionBar addActionItemWithIcon:@"aqbz" selectedIcon:nil title:locationString(@"tab_home_anquan")];
        [_actionBar addActionItemWithIcon:@"lcjq" selectedIcon:nil title:locationString(@"tab_home_volume")];
        [_actionBar addActionItemWithIcon:@"hhr" selectedIcon:nil  title:locationString(@"my_friends")];
        _actionBar.showSeparator = YES;
    }
    return _actionBar;
}

- (UIView *)loginHeaderView
{
    if (_loginHeaderView == nil) {
        
        _loginHeaderView = [[UIView alloc] initWithFrame:_headerView.bounds];
        [_headerView addSubview:_loginHeaderView];
        
        // 个人累积收益label
        UILabel * incomeTotalLabel = [Utility createLabel:[CustomerizedFont heiti:12] color:kWhiteAlphaColor(1.0)];
        incomeTotalLabel.text = locationString(@"tab_home_income");
        [incomeTotalLabel sizeToFit];
        incomeTotalLabel.centerX = _loginHeaderView.centerX;
        incomeTotalLabel.top = DimensionBaseIphone6(57);
        [_loginHeaderView addSubview:incomeTotalLabel];
        
        // 个人累积收益数据
        NSString * incomeString = esNumString([[NSUserDefaults standardUserDefaults] valueForKey:kSumRevenue]);
            
        UIView * incomeTotalView = [[UIView alloc] init];
        incomeTotalView.top = incomeTotalLabel.bottom + DimensionBaseIphone6(8);
        incomeTotalView.height = DimensionBaseIphone6(26);
        [self setDataWithNumString:incomeString inView:incomeTotalView];
        [_loginHeaderView addSubview:incomeTotalView];
        self.incomeTotalView = incomeTotalView;
        
        // 眼睛
        UIImage * showEyesImage = [UIImage imageNamed:@"icon_showeyes"];
        UIImage * hideEyesImage = [UIImage imageNamed:@"icon_hideeyes"];
        UIButton * eyeButton = [[UIButton alloc] initWithFrame:CGRectMake(incomeTotalView.right + 2.5, incomeTotalView.top - 2.5, showEyesImage.size.width, showEyesImage.size.height)];
        [eyeButton setImage:showEyesImage forState:UIControlStateNormal];
        [eyeButton setImage:hideEyesImage forState:UIControlStateSelected];
        [eyeButton setEnlargeEdge:20];
        eyeButton.selected = [[NSUserDefaults standardUserDefaults] boolForKey:kEyeHide];
        [eyeButton addTarget:self action:@selector(showIncomeButton:) forControlEvents:UIControlEventTouchUpInside];
        [_loginHeaderView addSubview:eyeButton];
        self.eyeButton = eyeButton;
        [self setSumRevenueStatus:eyeButton.selected];
        
        // 水平分割线
        UIView * horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, kHeaderHeight - DimensionBaseIphone6(40), _loginHeaderView.width, 1.0 / [UIScreen mainScreen].scale)];
        horizontalLine.backgroundColor = kWhiteAlphaColor(0.5);
        [_loginHeaderView addSubview:horizontalLine];

        NSString *platformAllAmount= esNumString([[NSUserDefaults standardUserDefaults] valueForKey:kPlatformAllAmount]);
        NSString *platformRegisterNum= esNumString([[NSUserDefaults standardUserDefaults] valueForKey:kPlatformRegisterNum]);
        
        // 数据view
        NSArray * datas = @[@{@"title" : locationString(@"tab_home_leiji_money"),
                              @"data" : platformAllAmount},
                            
                            @{@"title" : locationString(@"tab_home_leiji_person"),
                              @"data" : platformRegisterNum}];
        for (int i = 0; i < 2; i++) {
            UILabel * titleLabel = [Utility createLabel:[CustomerizedFont heiti:11] color:kDefaultWhiteColor];
            titleLabel.text = datas[i][@"title"];
            [titleLabel sizeToFit];
            titleLabel.top = horizontalLine.bottom + DimensionBaseIphone6(4);
            [_loginHeaderView addSubview:titleLabel];

            UILabel * dataLabel = [Utility createLabel:[CustomerizedFont boldHeiti:13] color:HexRGB(0xff6633)];
            dataLabel.text = datas[i][@"data"];
            [dataLabel sizeToFit];
            dataLabel.bottom = kHeaderHeight - DimensionBaseIphone6(4);
            [_loginHeaderView addSubview:dataLabel];
            
            if (i == 0) {
                titleLabel.right = _loginHeaderView.centerX - DimensionBaseIphone6(15);
                dataLabel.right = titleLabel.right;
                
                UIView * verticalLine = [[UIView alloc] initWithFrame:CGRectMake(_loginHeaderView.centerX, horizontalLine.bottom + DimensionBaseIphone6(6), 1.0 / [UIScreen mainScreen].scale, DimensionBaseIphone6(40 - 12))];
                verticalLine.backgroundColor = kWhiteAlphaColor(0.8);
                [_loginHeaderView addSubview:verticalLine];
                
            } else {
                titleLabel.left = _loginHeaderView.centerX + DimensionBaseIphone6(15);
                dataLabel.left = titleLabel.left;
            }
        }
        
        // 查看详情
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiangqing3"]];
        imageView.right = _loginHeaderView.width - DimensionBaseIphone6(10);
        imageView.centerY = horizontalLine.bottom + (kHeaderHeight - horizontalLine.bottom) * 0.5;
        [_loginHeaderView addSubview:imageView];
        
        UIButton * button = [[UIButton alloc] init];
        button.left = 0;
        button.top = horizontalLine.top;
        button.width = horizontalLine.width;
        button.height = _loginHeaderView.height - button.top;
        [button addTarget:self action:@selector(clickDetailButton:) forControlEvents:UIControlEventTouchUpInside];
        [_loginHeaderView addSubview:button];
        
//        UIButton * button = [Utility createButtonWithFrame:CGRectMake(0, 0, 8, 8) iconName:@"xiangqing3" target:self action:@selector(clickDetailButton:)];
//        button.right = _loginHeaderView.width - DimensionBaseIphone6(10);
//        button.centerY = horizontalLine.bottom + (kHeaderHeight - horizontalLine.bottom) * 0.5;
//        [button setEnlargeEdge:20];
//        [_loginHeaderView addSubview:button];
    }
    return _loginHeaderView;
}

- (UIView *)logoutHeaderView
{
    if (_logoutHeaderView == nil) {
        
        _logoutHeaderView = [[UIView alloc] initWithFrame:_headerView.bounds];
        [_headerView addSubview:_logoutHeaderView];
        
        // 累计投资总额label
        UILabel * investTotalLabel = [Utility createLabel:[CustomerizedFont heiti:11] color:kDefaultWhiteColor];
        investTotalLabel.text = locationString(@"tab_home_intr_money");
        [investTotalLabel sizeToFit];
        investTotalLabel.top = DimensionBaseIphone6(37);
        investTotalLabel.centerX = _headerView.centerX;
        [_logoutHeaderView addSubview:investTotalLabel];

        // 累计投资总额左右线
        for (int i = 0; i < 2; i++) {
            UIView * horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 1)];
            horizontalLine.backgroundColor = kDefaultWhiteColor;
            horizontalLine.centerY = investTotalLabel.centerY;
            i == 0 ? (horizontalLine.right = investTotalLabel.left - 5) : (horizontalLine.left = investTotalLabel.right + 5);
            [_logoutHeaderView addSubview:horizontalLine];
        }
        
        // 累计投资总额数字
        NSString * investTotalString = esNumString([[NSUserDefaults standardUserDefaults] valueForKey:kPlatformAllAmount]);
        UIView * investTotalView = [[UIView alloc] init];
        investTotalView.top = investTotalLabel.bottom + DimensionBaseIphone6(9);
        investTotalView.height = DimensionBaseIphone6(20);
        [self setDataWithNumString:investTotalString inView:investTotalView];
        [_logoutHeaderView addSubview:investTotalView];
        
        // 平台用户量label
        NSString * registerNumString = esNumString([[NSUserDefaults standardUserDefaults] valueForKey:kPlatformRegisterNum]);
        UILabel * usersTotalLabel = [Utility createLabel:[CustomerizedFont heiti:11] color:kDefaultWhiteColor];
        usersTotalLabel.text = [NSString stringWithFormat:@"%@%@", locationString(@"tab_home_person_num"), registerNumString];
        [usersTotalLabel sizeToFit];
        usersTotalLabel.top = investTotalView.bottom + DimensionBaseIphone6(9);
        usersTotalLabel.centerX = _headerView.centerX;
        [usersTotalLabel addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#ff6633" alpha:0.8]} forString:registerNumString];
        [_logoutHeaderView addSubview:usersTotalLabel];
        
        // 登录按钮
        UIButton * loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, DimensionBaseIphone6(90), DimensionBaseIphone6(30))];
        loginButton.bottom = kHeaderHeight - DimensionBaseIphone6(23);
        loginButton.centerX = _headerView.centerX;
        [loginButton setTitle:locationString(@"login_immediately") forState:UIControlStateNormal];
        [loginButton setTitleColor:kDefaultWhiteColor forState:UIControlStateNormal];
        [loginButton.titleLabel setFont:[CustomerizedFont heiti:14]];
        UIColor * borderColor = kDefaultWhiteColor;
        loginButton.layer.borderColor =  borderColor.CGColor;
        loginButton.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
        loginButton.layer.cornerRadius = 2.5;
        loginButton.layer.masksToBounds = YES;
        [loginButton addTarget:self action:@selector(clickLoginButton:) forControlEvents:UIControlEventTouchUpInside];
        [_logoutHeaderView addSubview:loginButton];
    }
    return _logoutHeaderView;
}

#pragma mark private methods
- (void)setDataWithNumString:(NSString *)numString inView:(UIView *)view
{
    if (view.subviews) {
        for (UIView * subview in view.subviews) {
            [subview removeFromSuperview];
        }
    }
    NSInteger length = numString.length;
    CGFloat width = 0;
    for (int i = 0; i < length; i++) {
        NSString * character = [numString substringWithRange:NSMakeRange(i, 1)];
        UIImage * image = [self getImageNameWithCharacter:character];
        UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
        imageView.top = 0;
        imageView.left = width;
        CGFloat scale = image.size.width / image.size.height;
        imageView.height = view.height;
        imageView.width = scale * view.height;
        width += imageView.width + 2.5;
        [view addSubview:imageView];
    }
    
    // 调整view大小
    view.width = view.subviews.lastObject.right;
    view.centerX = _headerView.centerX;
}

- (UIImage *)getImageNameWithCharacter:(NSString *)character
{
    const char * cha = [character UTF8String];
    NSString * imageName = nil;
    switch (*cha) {
        case '0':
            imageName = @"0";
            break;
        case '1':
            imageName = @"1";
            break;
        case '2':
            imageName = @"2";
            break;
        case '3':
            imageName = @"3";
            break;
        case '4':
            imageName = @"4";
            break;
        case '5':
            imageName = @"5";
            break;
        case '6':
            imageName = @"6";
            break;
        case '7':
            imageName = @"7";
            break;
        case '8':
            imageName = @"8";
            break;
        case '9':
            imageName = @"9";
            break;
        case '.':
            imageName = @"dian";
            break;
        case ',':
            imageName = @"douhao";
            break;
        case '*':
            imageName = @"xinghao";
            break;
        default:
            break;
    }
    return [UIImage imageNamed:imageName];
}

#pragma mark actionBar delegate
- (void)acitonBar:(LTNAcitonBar *)acitonBar clickedItemIndex:(NSInteger)index
{
    DLog(@"index:%ld", index);
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickAcitonBar:clickedItemIndex:)]) {
        [self.delegate clickAcitonBar:acitonBar clickedItemIndex:index];
    }
}

#pragma mark monitor method
- (void)clickLoginButton:(UIButton *)sender
{
    [[LTNCore globleCore] loginController:^{
        
    }];
}

- (void)clickDetailButton:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickCheckDetail:)]) {
        [self.delegate clickCheckDetail:sender];
    }
}

- (void)showIncomeButton:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [[NSUserDefaults standardUserDefaults] setBool:sender.selected forKey:kEyeHide];
    [self setSumRevenueStatus:sender.selected];
}

- (void)setSumRevenueStatus:(BOOL)hideen
{
    NSString * numString = nil;
    if (hideen) {
        numString = @"****";
    } else {
        numString = esNumString([[NSUserDefaults standardUserDefaults] valueForKey:kSumRevenue]);
        
    }
    [self setDataWithNumString:numString inView:self.incomeTotalView];
    self.eyeButton.left = self.incomeTotalView.right + 2.5;
    self.eyeButton.top = self.incomeTotalView.top - 2.5;
}

@end
