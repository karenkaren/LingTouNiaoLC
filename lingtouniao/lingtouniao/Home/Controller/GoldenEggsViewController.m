//
//  GoldenEggsViewController.m
//  lingtouniao
//
//  Created by 徐凯 on 16/3/15.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "GoldenEggsViewController.h"
#import "LTNBaseDetailController.h"
#define QuakeTimeInterval 0.25//具体时间和UI沟通
#define CryTimeInterval   0.5

@interface GoldenEggsViewController ()
{
    NSInteger _generalChance;//普通机会次数
    NSInteger _certainlyChance;//必中机会次数
    NSInteger _totalChance;//总的砸蛋机会
    BOOL _isWinning;//是否砸中
    BOOL _isHasWinning;//是否出现过砸中情况
    NSString *_winningAmount;//中奖金额
    UIImageView *_originalImageView;//砸蛋失败动画界面original frame 为了transfrom时有参照
    NSTimer *_transTimer;//
    NSTimer *_switchTimer;
}

@end

@implementation GoldenEggsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    _generalChance = 0;
    _certainlyChance = 0;
    _winningAmount = 0;
    _isWinning = NO;
    _isHasWinning = NO;
    [self setBackGroudView];
    [self addGesture];
    [self loadData];
   
}

//更新约束
- (void)updateViewConstraints
{
    [super updateViewConstraints];
    [_birdCoinLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        if (!_moneyImageView.hidden) {
            make.bottom.equalTo(_eggChanceLabel.mas_top).offset(DimensionBaseIphone6(-35));
        } else {
            make.bottom.equalTo(_eggChanceLabel.mas_top).offset(DimensionBaseIphone6(-75));
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = true;
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    [super viewWillDisappear:animated];
    [self stopQuake:_goldenEggsImageView];
    [self stopEarthQuake:_handimageView];
    _handimageView.hidden = YES;
    _goldenEggsImageView.hidden = YES;
    _plateImageView.hidden = YES;
    _moneyImageView.hidden = YES;
    _cryImageView.hidden = YES;
    _birdCoinLabel.hidden = YES;
}

/**
 *  设置砸金蛋界面的背景颜色  具体色值和UI沟通
 */
-(void)setBackGroudView
{
    [self.view setFrame:[UIScreen mainScreen].bounds];
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.7]];
}

/**
 *  请求砸金蛋界面具体数据：砸金蛋次数
 */
-(void)loadData
{
    [self apiForPath:kGoldenEggGetUrl method:kPostMethod parameter:nil responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        if (!error) {
            _generalChance = esInteger(data[@"general_chance"]);
            _certainlyChance = esInteger(data[@"certainly_chance"]);
            _totalChance = _generalChance + _certainlyChance;
        }
        [self showInterface];
    }];
}

- (void)showInterface
{
    //有金蛋可砸
    _eggChanceLabel.hidden = NO;
    if(_totalChance)
    {
        _handimageView.hidden = NO;
        _goldenEggsImageView.hidden = NO;
        _plateImageView.hidden = NO;
        [self startQuake:_goldenEggsImageView];
        [self earthQuake:_handimageView];
        NSString * chanceString = [NSString stringWithFormat:locationString(@"hit_egg_surplus_number"),_totalChance];
        NSRange range = [chanceString rangeOfString:[NSString stringWithFormat:@"%ld", _totalChance]];
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:chanceString];
        
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:range];
        _eggChanceLabel.attributedText = attributedString;
        
    }else
    {
        //没有任何金蛋可以砸
        _cryImageView.hidden = NO;
        _birdCoinLabel.hidden = NO;
        _cryImageView.image = [UIImage imageNamed:@"cry"];
        _originalImageView= [[UIImageView alloc]initWithFrame:_cryImageView.frame];
        [self transformAnmation:nil];

        _birdCoinLabel.text = locationString(@"no_hit_time");
    }
}

/**
 *
 *  @param theTimer 砸金蛋 成功后的动画效果
 */
-(void)switchAnmation:(NSTimer *)theTimer
{
    static BOOL isShine = NO;
    if (isShine) {
      _moneyImageView.image = [UIImage imageNamed:@"hongbao_shine"];
    }else
    {
      _moneyImageView.image = [UIImage imageNamed:@"hongbao"];
    }
    isShine = !isShine;
}

/**
 *
 *  @param sender 返回或者在砸一次按钮
 */
- (void)clickAction:(UIButton *)sender {
    if ([_clickButton.titleLabel.text isEqualToString:locationString(@"back")] ) {
         self.goldenEggsWindow.hidden = YES;
        [LTNCore globleCore].goldenEggsWindowIsShowing=NO;
        [_switchTimer invalidate];
        [_transTimer invalidate];
        _switchTimer = nil;
        _transTimer = nil;
            if (_callBack) {
                _callBack();
            }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"goldRefreash" object:nil userInfo:nil];
    }else if([_clickButton.titleLabel.text isEqualToString:locationString(@"hit_again")])
    {
        _cryImageView.hidden = YES;
        _birdCoinLabel.hidden = YES;
        _moneyImageView.hidden = YES;
        _handimageView.hidden = NO;
        _goldenEggsImageView.hidden = NO;
        _plateImageView.hidden = NO;
        [self startQuake:_goldenEggsImageView];
        [self earthQuake:_handimageView];
        [_clickButton setTitle:_isHasWinning?locationString(@"look_bird_coins") : locationString(@"back") forState:UIControlStateNormal];
        
    }else if([_clickButton.titleLabel.text isEqualToString:locationString(@"look_bird_coins")])
    {
        if (_callBack) {
            _callBack();
        }
        else if (_investCallBack)
        {
           _investCallBack();
        }
        self.goldenEggsWindow.hidden = YES;
        [LTNCore globleCore].goldenEggsWindowIsShowing=NO;
        [_switchTimer invalidate];
        [_transTimer invalidate];
        _switchTimer = nil;
        _transTimer = nil;
        
        [[LTNCore globleCore].tabbarController setSelectedIndex:3];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshAccountInfo];
        UINavigationController * navController=(UINavigationController *)([[LTNCore globleCore].tabbarController selectedViewController]);
        UIViewController *controller=navController.topViewController;
        LTNBaseDetailController * detailController = [[LTNBaseDetailController alloc] init];
        detailController.naviTitle = locationString(@"bird_detail");
        detailController.apiPath = kBirdCoinAmountUrl;
        detailController.isHaveBiedCoinHelp = YES;
        detailController.hidesBottomBarWhenPushed = YES;
        [controller.navigationController  pushViewController:detailController animated:NO];
    }
}

- (void)cancelAction:(UIButton *)sender {
    
     self.goldenEggsWindow.hidden = YES;
    [LTNCore globleCore].goldenEggsWindowIsShowing=NO;
    [_switchTimer invalidate];
    [_transTimer invalidate];
    _switchTimer = nil;
    _transTimer = nil;
    if (_callBack) {
        _callBack();
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"goldRefreash" object:nil userInfo:nil];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshAccountInfo];
}
/**
 *
 *  @param sender 砸金蛋秘籍
 */
- (void)EggRarBookAction:(UIButton *)sender {
    _cancelButton.hidden = YES;
    _handimageView.hidden = YES;
    _goldenEggsImageView.hidden = YES;
    _plateImageView.hidden = YES;
    _moneyImageView.hidden = YES;
    _cryImageView.hidden = YES;
    _eggChanceLabel.hidden = YES;
    _birdCoinLabel.hidden = YES;
    _lineview.hidden = YES;
    _clickButton.hidden = YES;
    _rarebookButton.hidden = YES;
    _rareBookView.hidden = NO;
    [_switchTimer invalidate];
    [_transTimer invalidate];
    _switchTimer = nil;
    _transTimer = nil;
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.9]];
}


-(void)addGesture
{
    UITapGestureRecognizer *goldenGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickGoldenEgg:)];
    [_goldenEggsImageView addGestureRecognizer:goldenGesture];
}
/**
 *
 *  @param gesture 砸金蛋action
 */
-(void)clickGoldenEgg:(UITapGestureRecognizer *)gesture
{
    NSString *goldenEggType;
    if (_generalChance) {
        goldenEggType = @"FBZ";
    }else if (_certainlyChance)
    {
       goldenEggType = @"BZ";
    }
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setValue:goldenEggType forKey:@"golden_egg_type"];
    
   [self apiForPath:kGoldenEggSubmitUrl method:kPostMethod parameter:parameter responseModelClass:nil onComplete:^(id response, id data, NSError *error) {

       if (!error) {
           _isWinning = (BOOL)esInteger(data[@"is_winning"]);
           _winningAmount =esString(data[@"winning_amount"]);
           _generalChance = esInteger(data[@"general_chance"]);
           _certainlyChance = esInteger(data[@"certainly_chance"]);
           _totalChance = _generalChance + _certainlyChance;

           [self stopQuake:_goldenEggsImageView];
           [self stopEarthQuake:_handimageView];
           _handimageView.hidden = YES;
           _goldenEggsImageView.hidden = YES;
           _plateImageView.hidden = YES;
           _moneyImageView.hidden = NO;
           _birdCoinLabel.hidden = NO;
           [self showEggsChance];

            //砸中鸟蛋
           if (_isWinning) {
               _isHasWinning = YES;
               NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:locationString(@"hit_egg_choose2"),_winningAmount]];
               [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6, attributedString.length-6)];
               
               _birdCoinLabel.transform = CGAffineTransformScale(_birdCoinLabel.transform, 0.1, 0.1);
                _birdCoinLabel.attributedText = attributedString;
               [UIView animateWithDuration:0.5 animations:^{
                   _birdCoinLabel.transform = CGAffineTransformScale(_birdCoinLabel.transform, 10.0, 10.0);
               }];
           _switchTimer = [NSTimer scheduledTimerWithTimeInterval:QuakeTimeInterval
                                                target:self
                                              selector:@selector(switchAnmation:)
                                              userInfo:nil
                                               repeats:YES];
               [_clickButton setTitle:_totalChance?locationString(@"hit_again"): locationString(@"look_bird_coins") forState:UIControlStateNormal];
             
           }else
           {
               //未砸中鸟蛋

               _birdCoinLabel.transform = CGAffineTransformScale(_birdCoinLabel.transform, 0.1, 0.1);
               _birdCoinLabel.text = locationString(@"hit_fail");
               [UIView animateWithDuration:0.5 animations:^{
                     _birdCoinLabel.transform = CGAffineTransformScale(_birdCoinLabel.transform, 10.0, 10.0);
               }];
             
               _moneyImageView.hidden = YES;
               _cryImageView.hidden = NO;
               _originalImageView= [[UIImageView alloc]initWithFrame:_cryImageView.frame];
     
               [self transformAnmation:nil];
                 [_clickButton setTitle:_totalChance?locationString(@"hit_again") : (_isHasWinning?locationString(@"look_bird_coins"):locationString(@"back")) forState:UIControlStateNormal];
           }
           // tell constraints they need updating
           [self.view setNeedsUpdateConstraints];
           // update constraints now so we can animate the change
           [self.view updateConstraintsIfNeeded];
       }
   }];
}

- (void)showEggsChance
{
    if (_totalChance) {
        NSString * chanceString = [NSString stringWithFormat:locationString(@"hit_egg_surplus_number"),_totalChance];
        NSRange range = [chanceString rangeOfString:[NSString stringWithFormat:@"%ld", _totalChance]];
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:chanceString];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:range];
        _eggChanceLabel.attributedText = attributedString;
    }else
    {
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:locationString(@"hit_egg_surplus_number"), 0]];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(4, 1)];
        _eggChanceLabel.attributedText = attributedString;
    }
}
/**
 *
 *  @param timer 砸蛋失败动画
 */
-(void)transformAnmation:(NSTimer *)timer
{
    CABasicAnimation *scaleAnimation;
    scaleAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration=1;
    scaleAnimation.repeatCount=MAXFLOAT;
    scaleAnimation.autoreverses = YES;
    scaleAnimation.removedOnCompletion = YES;
    scaleAnimation.fromValue = [NSNumber numberWithFloat:0.95];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.05];
    [_cryImageView.layer addAnimation:scaleAnimation forKey:@"animateTransform"];
}


/**
 *
 *  @param btn 开始金蛋抖动
 */
- (void)startQuake:(UIImageView *)imageView {
    double angle1 = -5.0 / 180.0 * M_PI;
    double angle2 = 5.0 / 180.0 * M_PI;
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    
    anim.values = @[@(angle1), @(angle2), @(angle1)];
    anim.duration = 0.1;
    // 动画的重复执行次数
    anim.repeatCount = MAXFLOAT;
    
    // 保持动画执行完毕后的状态
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    
    [imageView.layer addAnimation:anim forKey:@"shake"];
}

// 停止抖动
- (void)stopQuake:(UIImageView *)imageView {
    
    [imageView.layer removeAnimationForKey:@"shake"];
}

/**
 *
 *  @param imageView 开始手臂的抖动
 */
-(void)earthQuake:(UIImageView*)imageView
{
    CGFloat t = 5.0;
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.translation"];

    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(t, -t)];
    anim.duration = 0.2;
    // 动画的重复执行次数
    anim.repeatCount = MAXFLOAT;
    anim.autoreverses = YES;
    // 保持动画执行完毕后的状态
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    
    [imageView.layer addAnimation:anim forKey:@"earthquake"];
}
/**
 *
 *  @param imageView 停止手臂的抖动
 */
-(void)stopEarthQuake:(UIImageView*)imageView
{
    [imageView.layer removeAnimationForKey:@"earthquake"];
}
/**
 *
 *  @param sender 砸金蛋秘籍的取消按钮
 */
- (void)rarebookClick:(UIButton *)sender {
    _rareBookView.hidden = YES;
    _cancelButton.hidden = NO;
    _lineview.hidden = NO;
    _clickButton.hidden = NO;
    _rarebookButton.hidden = NO;
    [self showInterface];
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.7]];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
     if(self.view.window == nil)
     {
         self.view = nil;
     }
}

- (void)setupUI
{
    UIView *superview = self.view;
    // 右上角取消按钮
    _cancelButton = [[UIButton alloc] init];
    [_cancelButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelButton];
    
    //  手
    _handimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hand"]];
    _handimageView.hidden = YES;
    [self.view addSubview:_handimageView];
    
    //  底座
    _plateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wan"]];
    _plateImageView.hidden = YES;
    [self.view addSubview:_plateImageView];
    
    //  蛋
    _goldenEggsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"egg"]];
    _goldenEggsImageView.userInteractionEnabled = YES;
    _goldenEggsImageView.hidden = YES;
    [self.view addSubview:_goldenEggsImageView];

    //  砸中鸟蛋图片
    _moneyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hongbao"]];
    _moneyImageView.hidden = YES;
    [self.view addSubview:_moneyImageView];
    
    //  未砸中鸟蛋图片
    _cryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cry"]];
    _cryImageView.hidden = YES;
    [self.view addSubview:_cryImageView];
    
    // 底部返回按钮
    _clickButton = [Utility createButtonWithTitle:locationString(@"back") color:[UIColor whiteColor] font:kFont(18) block:^(UIButton *btn) {
        [self clickAction:btn];
    }];
    [_clickButton setDisenableBackgroundColor:kDisabledColor enableBackgroundColor:COLOR_MAIN];
    _clickButton.layer.masksToBounds = YES;
    _clickButton.layer.cornerRadius = DimensionBaseIphone6(44) / 2;
    [self.view addSubview:_clickButton];
    
    // 砸蛋剩余次数label
    _eggChanceLabel = [Utility createLabel:kFontBold(14) color:[UIColor whiteColor]];
    _eggChanceLabel.textAlignment = NSTextAlignmentCenter;
    _eggChanceLabel.text = [NSString stringWithFormat:locationString(@"hit_egg_surplus_number"), 0];
    [_eggChanceLabel addAttributes:@{NSForegroundColorAttributeName : [UIColor yellowColor]} forString:@"0"];
    [self.view addSubview:_eggChanceLabel];
    
    // 查看砸蛋秘籍按钮
    _rarebookButton = [Utility createButtonWithTitle:locationString(@"hit_eggs_look") color:[UIColor whiteColor] font:kFont(14) block:^(UIButton *btn) {
        [self EggRarBookAction:btn];
    }];
    [self.view addSubview:_rarebookButton];
            
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:locationString(@"hit_eggs_look")];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [_rarebookButton setAttributedTitle:str forState:UIControlStateNormal];
    
    // 砸蛋后显示文字label
    _birdCoinLabel = [Utility createLabel:kFontBold(16) color:[UIColor yellowColor]];
    _birdCoinLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_birdCoinLabel];

    // 添加砸蛋界面约束
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@30);
        make.top.equalTo(superview).offset(15);
        make.right.equalTo(superview).offset(-15);
    }];
    
    [_handimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superview);
        make.height.equalTo(@(DimensionBaseIphone6(87)));
        make.width.equalTo(_handimageView.mas_height).multipliedBy(178.0 / 87.0);
        make.top.equalTo(superview).offset(DimensionBaseIphone6(91));
    }];
    
    [_goldenEggsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superview);
        make.height.equalTo(@(DimensionBaseIphone6(153.5)));
        make.width.equalTo(_goldenEggsImageView.mas_height).multipliedBy(125.5 / 153.5);
        make.top.equalTo(superview).offset(DimensionBaseIphone6(198));
    }];
    
    [_plateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superview);
        make.height.equalTo(@(DimensionBaseIphone6(73.5)));
        make.width.equalTo(_plateImageView.mas_height).multipliedBy(155.0 / 73.5);
        make.top.equalTo(_goldenEggsImageView.mas_bottom).offset(DimensionBaseIphone6(-26));
    }];
    
    [_moneyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superview);
        make.width.equalTo(@301.5);
        make.height.equalTo(@171.5);
        make.top.equalTo(superview).offset(DimensionBaseIphone6(180));
    }];
    
    [_cryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superview);
        make.width.equalTo(@146.5);
        make.height.equalTo(@132.5);
        make.top.equalTo(superview).offset(DimensionBaseIphone6(184));
    }];
    
    [_birdCoinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superview);
        make.width.equalTo(superview);
        make.height.equalTo(@16);
        make.bottom.equalTo(_eggChanceLabel.mas_top).offset(-35);
    }];
    
    [_eggChanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superview);
        make.width.equalTo(superview);
        make.height.equalTo(@15);
        make.top.equalTo(_plateImageView.mas_bottom).offset(DimensionBaseIphone6(45));
    }];
    
    [_clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superview);
        make.height.equalTo(@(DimensionBaseIphone6(44)));
        make.width.equalTo(_clickButton.mas_height).multipliedBy(175.0 / 44.0);
        make.top.equalTo(_eggChanceLabel.mas_bottom).offset(DimensionBaseIphone6(24));
    }];
    
    [_rarebookButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superview);
        make.height.equalTo(@14);
        make.width.equalTo(_rarebookButton.mas_height).multipliedBy(6);
        make.top.equalTo(_clickButton.mas_bottom).offset(DimensionBaseIphone6(10));
    }];
    
    // 砸蛋秘籍view
    _rareBookView = [[UIView alloc] initWithFrame:self.view.bounds];
    _rareBookView.hidden = YES;
    [self.view addSubview:_rareBookView];
    
    // 砸蛋秘籍标题label
    _rareLabel = [Utility createLabel:kFont(18) color:[UIColor orangeColor]];
    _rareLabel.text = locationString(@"hit_rare");
    [_rareLabel sizeToFit];
    [_rareBookView addSubview:_rareLabel];
    
    // 砸蛋秘籍标题与内容分割线
    UIImageView * rareSeparateLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line1"]];
    [_rareBookView addSubview:rareSeparateLine];
    
    // 砸蛋秘籍内容label
    UILabel * rareContentLabel = [Utility createLabel:kFont(12) color:[UIColor orangeColor]];
    rareContentLabel.numberOfLines = 0;
    rareContentLabel.text = [NSString stringWithFormat:@"%@\n%@\n\n%@\n\n%@\n\n%@\n\n%@\n\n%@\n\n%@", locationString(@"hit_egg_role_1"), locationString(@"hit_egg_role_2"), locationString(@"hit_egg_role_3"), locationString(@"hit_egg_role_4"), locationString(@"hit_egg_role_5"), locationString(@"hit_egg_role_6"), locationString(@"hit_egg_role_7"), locationString(@"hit_egg_role_8")];
    [rareContentLabel addAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forStringArray:@[locationString(@"hit_egg_role_2"), locationString(@"hit_egg_role_4"), locationString(@"hit_egg_role_6"), locationString(@"hit_egg_role_8")]];
    [_rareBookView addSubview:rareContentLabel];
    
    // 砸蛋秘籍取消按钮
    UIButton * cancel = [[UIButton alloc] init];
    [cancel setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(rarebookClick:) forControlEvents:UIControlEventTouchUpInside];
    [_rareBookView addSubview:cancel];
    
    // 砸蛋秘籍内容约束
    [_rareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_rareBookView);
        make.top.equalTo(_rareBookView).offset(35);
    }];
    
    [rareSeparateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_rareBookView);
        make.top.equalTo(_rareLabel.mas_bottom).offset(25);
    }];
    
    [rareContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_rareBookView).offset(20);
        make.right.equalTo(_rareBookView).offset(-20);
        make.top.equalTo(rareSeparateLine.mas_bottom).offset(25);
    }];
    
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_rareBookView);
        make.width.height.equalTo(@30);
        make.top.equalTo(rareContentLabel.mas_bottom).offset(40);
    }];
}

@end
