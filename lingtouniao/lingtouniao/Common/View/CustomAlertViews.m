//
//  CustomAlertViews.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/6/1.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "CustomAlertViews.h"


//按钮tag
#define TAGS 444


NSUInteger const Button_Size_Widths = 100;
NSUInteger const Button_Size_Heights = 30;

NSInteger const Title_Fonts = 16;
NSInteger const Detial_Fonts = 12;

NSInteger const Button_Fonts = 15;


@interface CustomAlertViews ()

{
    UIView * _backView;//画布
    
    UILabel * _titleLabel;//标题
    UILabel * _detailLabel;//详情
    
    UIButton * _sureButton;//马上领奖按钮
    UIButton * _closeButton;//关闭按钮
    
    UIView *_view;
    
    
}

@end
@implementation CustomAlertViews


+ (instancetype)showAlertViewWithImage:(NSString *)image title:(NSString *)title detail:(NSString *)detail closeButtonImage:(NSString *)close sureButtonTitle:(NSString *)sure onViewController:(UIViewController *)viewController callBlock:(callBacks)callBack{
    
    CustomAlertViews * customAlertViews = [[CustomAlertViews alloc] init];
    [customAlertViews addBackImage:image];
    
    [customAlertViews addButtonImageWithClose:close Sure:sure];
    [customAlertViews addTitle:title detail:detail];
    [customAlertViews setClickBlocks:nil];//释放掉之前的Block
    [customAlertViews setClickBlocks:callBack];
    [customAlertViews setHidden:NO];
    
    [customAlertViews showToController:viewController];
    return  customAlertViews;
}

- (void)showToView:(UIView *)view
{
    [view addSubview:self];
    [view bringSubviewToFront:self];
}

- (void)showToController:(UIViewController *)viewController{
    
    if(viewController.tabBarController){
        [self showToView:viewController.tabBarController.view];
    }else if(viewController.navigationController){
        [self showToView:viewController.navigationController.view];
    }else{
        [self showToView:viewController.view];
    }
}


////单例
//+ (instancetype)shareds
//{
//    static dispatch_once_t once = 0;
//    static CustomAlertViews *alert;
//    dispatch_once(&once, ^{
//        alert = [[CustomAlertViews alloc] init];
//    });
//    return alert;
//}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = (CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size};
        self.alpha = 1;
        [self setBackgroundColor:[UIColor clearColor]];
        //self.backgroundColor = kRGBAColor(0, 0, 0, 0.4);
        self.backgroundColor = [UIColor colorWithHexString:@"#3A3A3A" alpha:0.4];
        
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
    
    CGFloat x = _backView.frame.origin.x;
    CGFloat y = _backView.frame.origin.y;
    CGFloat height = _backView.frame.size.height;
    CGFloat width = _backView.frame.size.width;
    
    _view = [[UIView alloc]initWithFrame:CGRectMake(0, 120, 250,150)];
    _view.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x ,y+130,width,20)];
    [_titleLabel setFont:[UIFont systemFontOfSize:Title_Fonts]];
    _titleLabel.textColor = [UIColor colorWithHexString:@"#3a3a3a"];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    
    
    _detailLabel  = [[UILabel alloc] initWithFrame:CGRectMake(x+20 ,y+150, width-40, 70)];
    _detailLabel.textColor = [UIColor grayColor];
    _detailLabel.numberOfLines = 0;
    _detailLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    [_detailLabel setFont:[UIFont systemFontOfSize:Detial_Fonts]];
    [_detailLabel setTextAlignment:NSTextAlignmentCenter];
    
    
    _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureButton.layer.cornerRadius = 2.5;
    _sureButton.titleLabel.font = [UIFont systemFontOfSize:Button_Fonts];
    _sureButton.frame = CGRectMake(x - Button_Size_Widths/2 ,height-20, Button_Size_Widths, Button_Size_Heights);
    _sureButton.backgroundColor = HexRGB(0xea5504);
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton.frame = CGRectMake(x, height + 50, 40, 40);
    _closeButton.backgroundColor = [UIColor clearColor];
    
    
    [self addSubview:_titleLabel];
    [self addSubview:_detailLabel];
    [self addSubview:_closeButton];
    [self addSubview:_sureButton];
    
    [_backView addSubview:_view];
    

    _sureButton.hidden = YES;
    _closeButton.hidden = YES;
    
    _sureButton.tag = TAGS;
    _closeButton.tag = TAGS +1;
    
    [_closeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_sureButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

//  初始化logo视图——画布

- (void)logoInit
{
    
    [_backView removeFromSuperview];
    _backView = nil;
    //新建画布
    _backView                     = [UIView new];
    _backView.center              = CGPointMake(self.center.x, self.center.y );
    _backView.bounds              = CGRectMake(0, 0, 250, 270);
    _backView.backgroundColor     = [UIColor clearColor];
   
    
    //保证画布位于所有视图层级的最下方
    if (_titleLabel != nil) {
        [self insertSubview:_backView belowSubview:_titleLabel];
    }
    else
        [self addSubview:_backView];
    
}

-(void)addButtonImageWithClose:(NSString *)close Sure:(NSString *)sure{
    
    
    BOOL flag = NO;
    if (close == nil && sure != nil ) {
        flag = YES;
    }
    
    CGFloat centerY = _detailLabel.center.y + 80;
    
    if (flag) {
        _sureButton.center = CGPointMake(_detailLabel.center.x, centerY);
        _sureButton.bounds = CGRectMake(0, 0, Button_Size_Widths, Button_Size_Heights);
        _closeButton.hidden = YES;
        
    }
    else
    {
        _closeButton.hidden = NO;
        [_closeButton setImage:[UIImage imageNamed:close] forState:UIControlStateNormal];
        
        _sureButton.center = CGPointMake(_detailLabel.center.x, centerY - 20);
        _sureButton.bounds = CGRectMake(0, 0, Button_Size_Widths, Button_Size_Heights);
        
        _closeButton.center = CGPointMake(_detailLabel.center.x + 105, centerY - 235);
        _closeButton.bounds = CGRectMake(0, 0, 40, 40);
    }
    _sureButton.hidden = NO;
    [_sureButton setTitle:sure forState:UIControlStateNormal];
    
    
}
- (void)addTitle:(NSString *)title detail:(NSString *)detail
{
    
    _titleLabel.text  = title;
    _detailLabel.text = detail;
    
}


- (void)addBackImage:(NSString *)pic
{
    CGFloat x = 0;
    CGFloat y = 0;
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(x, y , 250, 120)];
    img.image = [UIImage imageNamed:pic];
    [_backView addSubview:img];
    
//    CGFloat x = self.center.x;
//    CGFloat y = self.center.y;
//    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(x - 125, y - 150, 250, 130)];
//    img.image = [UIImage imageNamed:pic];
//    [self addSubview:img];
    
    
    
}



- (void)buttonClick:(UIButton *)sender
{
    self.clickBlocks(sender.tag - TAGS);
}



@end
