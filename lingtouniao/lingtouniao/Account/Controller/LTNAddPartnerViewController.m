//
//  LTNAddPartnerViewController.m
//  lingtouniao
//
//  Created by 郑程锋 on 15/12/29.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//
//接口 kReplenishUrl

//跳转到补充合伙人页面
#define kSide 5
#define kHeight 30
#define kClearHeight 49

#import "LTNAddPartnerViewController.h"
#import "LTNTextField.h"
#import "LTNUtilsHelper.h"
#import "LTNServerConstant.h"

@interface LTNAddPartnerViewController ()<UITextFieldDelegate>

@property (nonatomic) LTNTextField *textFiled;

@property (nonatomic) UIButton *commitButton;

@end

@implementation LTNAddPartnerViewController

+(instancetype)addPartnerViewController:(VoidBlock)finishBlock{
    LTNAddPartnerViewController *controller=[[LTNAddPartnerViewController alloc] init];
    controller.finishBlock=finishBlock;
    return controller;
}

- (void)back{
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = locationString(@"new_partner_persion");
    
    [self configUI];//布局UI
    [self addNotification];//注册通知
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
    
}

- (void)addNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(change:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configUI{
    UILabel *label = [Utility createLabel:[CustomerizedFont heiti:14] color:[UIColor blackColor]];
    label.frame = CGRectMake(2*kSide, kSide, kScreenWidth-4*kSide, 20);
    label.text = locationString(@"add_recommend_mobile");
    [self.view addSubview:label];
    
    //号码输入框
    _textFiled = [[LTNTextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame)+10, kScreenWidth, kGeneralHeight)];
    _textFiled.delegate = self;
    [_textFiled addClearButtonWithRightMargin:0 imageName:@"icon_delete"];
    _textFiled.leftView = [[UIView alloc]initWithFrame:CGRectMake(0,0,kSide*2,0)];
    _textFiled.leftViewMode = UITextFieldViewModeAlways;
    _textFiled.keyboardType = UIKeyboardTypeNumberPad;
    _textFiled.limitedCount = 11;
    _textFiled.backgroundColor = [UIColor whiteColor];
    _textFiled.tag = 100;
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, _textFiled.top-0.5, kScreenWidth, 0.5)];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    
    UIView *lineViwe2  =[[UIView alloc]initWithFrame:CGRectMake(0, _textFiled.bottom, kScreenWidth, 0.5)];
    lineViwe2.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    
    [self.view addSubview:lineView1];
    [self.view addSubview:lineViwe2];
    [self.view addSubview:_textFiled];
   
    
    //确定按钮
    _commitButton = [[UIButton alloc]initWithFrame:CGRectMake(4*kSide, CGRectGetMaxY(_textFiled.frame)+15, kScreenWidth-8*kSide, kGeneralHeight)];
    _commitButton.layer.cornerRadius = 5;
    _commitButton.layer.masksToBounds = YES;
    [_commitButton setTitle:locationString(@"btn_confirm") forState:UIControlStateNormal];
    [_commitButton setDisenableBackgroundColor:kHexColor(@"#cccccc") enableBackgroundColor:kHexColor(@"#ea5504")];
    _commitButton.enabled = NO;
    [_commitButton addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_commitButton];
    
}

- (void)commit{
    if (![self.textFiled isTelphoneNum]) {
        [self.textFiled becomeFirstResponder];
        [LTNUtilsHelper boxShowWithMessage:locationString(@"mobile_corrected")];
        return;
    }
    [self showWaitingIcon];
    kWeakSelf
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{@"MobileNo" : self.textFiled.text}];
    [BaseDataEngine apiForPath:kReplenishUrl method:kGetMethod parameter:dic responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        kStrongSelf;
        if(strongSelf.finishBlock)
            strongSelf.finishBlock();
        [weakSelf dismissWaitingIcon];
        [weakSelf back];
    }];
}

- (void)change:(NSNotification *)no{
    if (self.textFiled.text.length>0) {
        _commitButton.enabled = YES;
        return;
    }else {
        _commitButton.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
