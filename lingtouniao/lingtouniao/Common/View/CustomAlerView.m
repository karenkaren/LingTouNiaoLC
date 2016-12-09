//
//  CustomAlerView.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/5/5.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "CustomAlerView.h"


//按钮tag
#define TAG 100


NSUInteger const Button_Size_Width = 100;
NSUInteger const Button_Size_Height = 30;

NSInteger const Title_Font = 16;
NSInteger const Detial_Font = 14;

NSInteger const Button_Font = 15;


@interface CustomAlerView ()

{
    UIView * _logoView;//画布
    UILabel * _titleLabel;//标题
    UILabel * _detailLabel;//详情
    
    UIButton * _OkButton;//确定按钮
    UIButton * _canleButton;//取消按钮
    
}

@end
@implementation CustomAlerView

+ (instancetype)showAlertViewWithImage:(NSString *)image title:(NSString *)title detail:(NSString *)detail canleButtonTitle:(NSString *)canle okButtonTitle:(NSString *)ok callBlock:(callBack)callBack{
    
    [[PiwikTracker sharedInstance] sendViews:esString(title),esString(title), nil];
    [[self shared] addImage:image];
    
    [[self shared] addButtonTitleWithCancle:canle OK:ok];
    [[self shared] addTitle:title detail:detail];
    [[self shared] setClickBlock:nil];//释放掉之前的Block
    [[self shared] setClickBlock:callBack];
    [[self shared] setHidden:NO];
    return  [self shared];
    
}

//单例
+ (instancetype)shared
{
    static dispatch_once_t once = 0;
    static CustomAlerView *alert;
    dispatch_once(&once, ^{
        alert = [[CustomAlerView alloc] init];
    });
    return alert;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = (CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size};
        self.alpha = 1;
        [self setBackgroundColor:[UIColor clearColor]];
        self.backgroundColor = kRGBAColor(0, 0, 0, 0.4);
    
        [self setInterFace];
    }
    
    return self;
}

//界面初始化

- (void)setInterFace
{
    [self logoInit];
    [self configUI];
}

//初始化控件

- (void)configUI
{
    
    CGFloat x = _logoView.frame.origin.x;
    CGFloat y = _logoView.frame.origin.y;
    CGFloat height = _logoView.frame.size.height;
    CGFloat width = _logoView.frame.size.width;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x ,y+70, width, 20)];
    [_titleLabel setFont:[UIFont systemFontOfSize:Title_Font]];
    _titleLabel.textColor = [UIColor colorWithHexString:@"#3a3a3a"];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    
    
    _detailLabel  = [[UILabel alloc] initWithFrame:CGRectMake(x+20 ,y+95, width-30, 90)];
    _detailLabel.textColor = [UIColor grayColor];
    _detailLabel.numberOfLines = 0;
    _detailLabel.textColor = [UIColor colorWithHexString:@"#3a3a3a"];
    [_detailLabel setFont:[UIFont systemFontOfSize:Detial_Font]];
    [_detailLabel setTextAlignment:NSTextAlignmentLeft];
    
    
    
    _OkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _OkButton.layer.cornerRadius = 5;
    _OkButton.titleLabel.font = [UIFont systemFontOfSize:Button_Font];
    _OkButton.frame = CGRectMake(x + 20 + 90, height-55, Button_Size_Width, Button_Size_Height);
    _OkButton.backgroundColor = HexRGB(0xea5504);
    
    
    _canleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _canleButton.frame = CGRectMake(x + 20, height-55, Button_Size_Width, Button_Size_Height);
    _canleButton.backgroundColor = [UIColor whiteColor];
    [_canleButton setTitleColor:HexRGB(0xea5504) forState:UIControlStateNormal];
    _canleButton.layer.borderWidth = 1;
    _canleButton.layer.masksToBounds = YES;
    _canleButton.layer.cornerRadius = 5;
    _canleButton.layer.borderColor = HexRGB(0xea5504).CGColor;
    _canleButton.titleLabel.font = [UIFont systemFontOfSize:Button_Font];
    
    
    [self addSubview:_titleLabel];
    [self addSubview:_detailLabel];
    [self addSubview:_OkButton];
    [self addSubview:_canleButton];
    
    
    
    
    _canleButton.hidden = YES;
    _OkButton.hidden = YES;
    
    _OkButton.tag = TAG;
    _canleButton.tag = TAG + 1;
    
    [_OkButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_canleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

//  初始化logo视图——画布

- (void)logoInit
{
    [_logoView removeFromSuperview];
    _logoView = nil;
    //新建画布
    _logoView                     = [UIView new];
    _logoView.center              = CGPointMake(self.center.x, self.center.y );
    _logoView.bounds              = CGRectMake(0, 0, 260, 240);
    _logoView.backgroundColor     = [UIColor whiteColor];
    _logoView.layer.cornerRadius  = 10;
    _logoView.layer.shadowColor   = [UIColor blackColor].CGColor;
    _logoView.layer.shadowOffset  = CGSizeMake(0, 5);
    _logoView.layer.shadowOpacity = 0.3f;
    _logoView.layer.shadowRadius  = 10.0f;
    
    //保证画布位于所有视图层级的最下方
    if (_titleLabel != nil) {
        [self insertSubview:_logoView belowSubview:_titleLabel];
    }
    else
        [self addSubview:_logoView];
}

- (void) addButtonTitleWithCancle:(NSString *)cancle OK:(NSString *)ok
{
   
    BOOL flag = NO;
    if (cancle == nil && ok != nil ) {
        flag = YES;
    }
    
    CGFloat centerY = _detailLabel.center.y + 80;
    
    if (flag) {
        _OkButton.center = CGPointMake(_detailLabel.center.x - 5, centerY);
        _OkButton.bounds = CGRectMake(0, 0, Button_Size_Width, Button_Size_Height);
        _canleButton.hidden = YES;
        
    }
    else
    {
        _canleButton.hidden = NO;
        [_canleButton setTitle:cancle forState:UIControlStateNormal];
        _OkButton.center = CGPointMake(_detailLabel.center.x + 60 - 5, centerY - 10);
        _OkButton.bounds = CGRectMake(0, 0, Button_Size_Width, Button_Size_Height);
        
        _canleButton.center = CGPointMake(_detailLabel.center.x - 60 - 5, centerY - 10);
        _canleButton.bounds = CGRectMake(0, 0, Button_Size_Width, Button_Size_Height);
    }
    _OkButton.hidden = NO;
    [_OkButton setTitle:ok forState:UIControlStateNormal];
    
}

- (void)addTitle:(NSString *)title detail:(NSString *)detail
{
    
    _titleLabel.text  = title;
    _detailLabel.text = detail;
    
}


- (void)addImage:(NSString *)pic
{
    CGFloat x = (_logoView.frame.size.width  - 40)/2;
    CGFloat y = 20;
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, 40, 40)];
    img.image = [UIImage imageNamed:pic];
    [_logoView addSubview:img];
    
}

- (void)buttonClick:(UIButton *)sender
{
    self.clickBlock(sender.tag - TAG);
}



@end
