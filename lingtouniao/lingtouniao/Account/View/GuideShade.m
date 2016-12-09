//
//  GuideShade.m
//  lingtouniao
//
//  Created by 徐凯 on 16/3/30.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "GuideShade.h"
#import "Masonry.h"
#import "AppDelegate.h"

#define kNumberOfRows 5

@interface GuideShade ()
{
    UIBezierPath *path;//贝赛尔曲线路径
    CAShapeLayer *shapeLayer;
      CAShapeLayer *shapeLayer1;
      CAShapeLayer *shapeLayer2;
    UIImageView * imageView;
    UIView * bgView;
    float rate;
    AppDelegate *app;
}

@end


@implementation GuideShade

+ (GuideShade *)guideShade
{
    static dispatch_once_t pred;
    static GuideShade *_guideShade = nil;
    dispatch_once(&pred, ^{
        _guideShade = [[self alloc] init];
        
    });
    return _guideShade;
}


#pragma mark  ===== 新手指引 =====

/**
 *  新手指引
 */


- (void)newUserGuide
{
    if ([[NSUserDefaults standardUserDefaults]valueForKey:IS_FIRST_SHOW]) {
        return;
    }

    // 这里创建指引在这个视图在window上
    bgView = [[UIView alloc]initWithFrame:ScreenBounds];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#323232" alpha:0.9];
    
    UITapGestureRecognizer * firstTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(firstTapClick:)];
    UITapGestureRecognizer * secondTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(secondTapClick:)];
    UITapGestureRecognizer * thirdTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(thirdTapClick:)];
    
    [bgView addGestureRecognizer:thirdTap];
    [bgView addGestureRecognizer:secondTap];
    [bgView addGestureRecognizer:firstTap];
    
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    
    path = [UIBezierPath bezierPathWithRect:ScreenBounds];

    [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(kScreenWidth/2.0 + 5, 285, kScreenWidth/2- 15, 60) cornerRadius:0] bezierPathByReversingPath]];
    
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    [bgView.layer setMask:shapeLayer];
    imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"step1_title"];
    [bgView addSubview:imageView];
    rate = kScreenWidth/375;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView).offset(-120 * rate);
        make.top.equalTo(bgView).offset(270 - 140);
    }];
}


/**
 *   新手指引确定,第一次点击
 */
- (void)firstTapClick:(UITapGestureRecognizer *)tap
{
    UIView * view = tap.view;
    [view removeGestureRecognizer:tap];
    [shapeLayer removeFromSuperlayer];
  
    path = [UIBezierPath bezierPathWithRect:ScreenBounds];
   // [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(kScreenWidth/3.0 * 2 +16, 217, kScreenWidth/3.0 - 20, 53) cornerRadius:0] bezierPathByReversingPath]];
    
    [path appendPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(kScreenWidth/3.0 * 2 +16, 217, kScreenWidth/3.0 - 20, 53)] bezierPathByReversingPath]];
    
    shapeLayer1 = [CAShapeLayer layer];
    shapeLayer1.path = path.CGPath;
    [bgView.layer setMask:shapeLayer1];

    imageView.image = [UIImage imageNamed:@"step2_title"];
    [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(80 * rate);
        make.right.equalTo(bgView).offset(-115 * rate);
        make.top.equalTo(bgView).offset(175);
    }];
    
    
}
/**
 *  第二次点击
 */
- (void)secondTapClick:(UITapGestureRecognizer *)tap
{
    app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    UIView * view = tap.view;
    [view removeGestureRecognizer:tap];
    [shapeLayer1 removeFromSuperlayer];
    if(!((NSInteger)kScreenHeight == 480))
    {
    path = [UIBezierPath bezierPathWithRect:ScreenBounds];

    [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 422 + (app.numberRows == kNumberOfRows ? 47 : 0) , kScreenWidth/2, 58) cornerRadius:0] bezierPathByReversingPath]];
    shapeLayer2 = [CAShapeLayer layer];
    shapeLayer2.path = path.CGPath;
    [bgView.layer setMask:shapeLayer2];
    }
    NSInteger offset = [self getStep2Offset];
    imageView.image = [UIImage imageNamed:@"step3_title"];
    [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(bgView).offset(75 * rate);
        make.right.equalTo(bgView).offset(-95 * rate);
        if (kScreenHeight == 736) {
           make.top.equalTo(bgView).offset(offset + DimensionBaseIphone6(175));
        }else{
           make.top.equalTo(bgView).offset(offset + 175);
        }
        
    }];

}
/**
 *  第三次点击
 */
- (void)thirdTapClick:(UITapGestureRecognizer *)tap
{
    UIView * view = tap.view;
    [view removeFromSuperview];
    [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [view removeGestureRecognizer:tap];
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:IS_FIRST_SHOW];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

- (NSInteger)getStep2Offset
{
       switch ((NSInteger)kScreenHeight) {
        case 480:
            return 105;
            break;
        case 568:
            return 105+(app.numberRows == kNumberOfRows ? 47 : 0);
            break;
        case 667:
            return 105+(app.numberRows == kNumberOfRows ? 47 : 0);
            break;
        case 736:
            return 87+(app.numberRows == kNumberOfRows ? 47 : 0);
            break;
            
        default:
            return 0;
            break;
    }
}

@end
