//
//  CustomAlertView2.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/6/28.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "CustomAlertView2.h"


//按钮tag
#define TAG2 10008


NSUInteger const Button_Size_Width2 = 150;
NSUInteger const Button_Size_Height2 = 30;

NSInteger const Title_Font2 = 16;
NSInteger const Detial_Font2 = 14;

NSInteger const Button_Font2 = 15;


@interface CustomAlertView2 ()

{
    UIView * _logoView;//画布
    UILabel * _detailLabel;//详情
    
    UIButton * _OkButton;//确定按钮
    UIButton * _canleButton;//取消按钮
    
}

@end
@implementation CustomAlertView2

+ (instancetype)showAlertViewWithImage:(NSString *)image  detail:(NSString *)detail canleButtonTitle:(NSString *)canle okButtonTitle:(NSString *)ok onViewController:(UIViewController *)viewController callBlock:(callBack2)callBack{
    
    CustomAlertView2 * customAlertView = [[CustomAlertView2 alloc] init];
    
    [customAlertView addImage:image];
    
    [customAlertView addButtonTitleWithCancle:canle OK:ok];
    [customAlertView addDetail:detail];
    [customAlertView setClickBlock:nil];//释放掉之前的Block
    [customAlertView setClickBlock:callBack];
    [customAlertView setHidden:NO];
    
    [customAlertView showToController:viewController];
    
    return  customAlertView;
    
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
//+ (instancetype)shared2
//{
//    static dispatch_once_t once = 0;
//    static CustomAlertView2 *alert;
//    dispatch_once(&once, ^{
//        alert = [[CustomAlertView2 alloc] init];
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
    
    CGFloat x = _logoView.frame.origin.x;
    CGFloat y = _logoView.frame.origin.y;
    CGFloat height = _logoView.frame.size.height;
    CGFloat width = _logoView.frame.size.width;

    
    _detailLabel  = [[UILabel alloc] initWithFrame:CGRectMake(x+20 ,y+70, width-40, 70)];
    _detailLabel.textColor = [UIColor grayColor];
    _detailLabel.numberOfLines = 0;
    _detailLabel.textColor = [UIColor colorWithHexString:@"#3a3a3a"];
    [_detailLabel setFont:[UIFont systemFontOfSize:Detial_Font2]];
    [_detailLabel setTextAlignment:NSTextAlignmentCenter];
    
    
    _OkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _OkButton.layer.cornerRadius = 2.5;
    _OkButton.titleLabel.font = [UIFont systemFontOfSize:Button_Font2];
    _OkButton.frame = CGRectMake(x - Button_Size_Width2/2 ,height-20, Button_Size_Width2, Button_Size_Height2);
    _OkButton.backgroundColor = HexRGB(0xea5504);
    
    
    _canleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _canleButton.frame = CGRectMake(x, height + 50, 40, 40);
    _canleButton.backgroundColor = [UIColor clearColor];
   
    
    
    [self addSubview:_detailLabel];
    [self addSubview:_OkButton];
    [self addSubview:_canleButton];
    
    
    
    
    _canleButton.hidden = YES;
    _OkButton.hidden = YES;
    
    _OkButton.tag = TAG2;
    _canleButton.tag = TAG2 + 1;
    
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
    _logoView.bounds              = CGRectMake(0, 0, 260, 200);
    _logoView.backgroundColor     = [UIColor whiteColor];
//    _logoView.layer.cornerRadius  = 10;
//    _logoView.layer.shadowColor   = [UIColor blackColor].CGColor;
//    _logoView.layer.shadowOffset  = CGSizeMake(0, 5);
//    _logoView.layer.shadowOpacity = 0.3f;
//    _logoView.layer.shadowRadius  = 10.0f;
    
    //保证画布位于所有视图层级的最下方
    
        [self addSubview:_logoView];
}

- (void) addButtonTitleWithCancle:(NSString *)cancle OK:(NSString *)ok
{
    
    BOOL flag = NO;
    if (cancle == nil && ok != nil ) {
        flag = YES;
    }
    
    CGFloat centerY = _detailLabel.center.y + 60;
    
    if (flag) {
        _OkButton.center = CGPointMake(_detailLabel.center.x, centerY);
        _OkButton.bounds = CGRectMake(0, 0, Button_Size_Width2, Button_Size_Height2);
        _canleButton.hidden = YES;
        
    }
    else
    {
        _canleButton.hidden = NO;
        [_canleButton setImage:[UIImage imageNamed:cancle] forState:UIControlStateNormal];
        _OkButton.center = CGPointMake(_detailLabel.center.x , centerY);
        _OkButton.bounds = CGRectMake(0, 0, Button_Size_Width2, Button_Size_Height2);
        
        _canleButton.center = CGPointMake(_detailLabel.center.x + 110, centerY - 145);
        _canleButton.bounds = CGRectMake(0, 0, 40, 40);
    }
    _OkButton.hidden = NO;
    [_OkButton setTitle:ok forState:UIControlStateNormal];
    
}

- (void)addDetail:(NSString *)detail
{
    _detailLabel.text = detail;
    
}


- (void)addImage:(NSString *)pic
{
    CGFloat x = (_logoView.frame.size.width  - 50)/2;
    CGFloat y = 20;
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, 50, 50)];
    img.image = [UIImage imageNamed:pic];
    [_logoView addSubview:img];
    
}

- (void)buttonClick:(UIButton *)sender
{
    self.clickBlock(sender.tag - TAG2);
}



@end

