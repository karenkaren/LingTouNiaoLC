//
//  GuideShadeView.m
//  lingtouniao
//
//  Created by zhangtongke on 16/6/7.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "GuideShadeView.h"
#import "UIView+FrameInScreen.h"

@interface GuideShadeView ()

@property (nonatomic, strong) UIImageView *teachImageView;
@property (nonatomic,strong)UIButton *dismissBtn;

@end


@implementation GuideShadeView

singleton_implementation(GuideShadeView);

- (instancetype)init
{
    if (self = [super init]) {
        // 初始化背景
        self.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
        [self.layer setMask:nil];
    }
    return self;
}


-(void)addCircle:(CGPoint)center radius:(float)radius{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.width, self.height)];
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:center
                                                    radius:radius
                                                startAngle:0
                                                  endAngle:2*M_PI
                                                 clockwise:NO]];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    shapeLayer.path = path.CGPath;
    [self.layer setMask:shapeLayer];
}


-(void)addEllipseRect:(CGRect)frame{
    [self.layer setMask:nil];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.width, self.height)];
    
    
    UIBezierPath *ellipsePath=[[UIBezierPath bezierPathWithOvalInRect:frame] bezierPathByReversingPath];
    //[ellipsePath stroke];
    [path appendPath:ellipsePath];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    [self.layer setMask:shapeLayer];
}

-(void)addRoundedRect:(CGRect)frame withCornerRadius:(float)cornerRadius{
    [self.layer setMask:nil];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.width, self.height)];
    
    [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:cornerRadius] bezierPathByReversingPath]];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    [self.layer setMask:shapeLayer];
}



+ (BOOL)shouldShowTeachingViewWithType:(NSString *)type
{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:type];
    if (value) {
#if !ALWAYS_SHOW_GUIDE_SHADE
        return NO;
#endif
    }
    if([LTNCore globleCore].shouldNotShowTeachingView)
        return NO;
    return YES;
}
+ (void)addTeachType:(NSString *)teachType withView:(id)View{
//    if([self shouldShowTeachingViewWithType:teachType]){
//        if(![[GuideShadeView sharedGuideShadeView].teachDic objectForKey:teachType])
//            [[GuideShadeView sharedGuideShadeView].teachDic setObject:View forKey:teachType];
//    }
    
    
    if(![[GuideShadeView sharedGuideShadeView].teachDic objectForKey:teachType])
        [[GuideShadeView sharedGuideShadeView].teachDic setObject:View forKey:teachType];
}

+ (void)showTeachType:(NSString *)teachType withCloseBlock:(void (^)(void))block{
    if([self shouldShowTeachingViewWithType:teachType]){
        [self showWithType:teachType
                  withView:[GuideShadeView sharedGuideShadeView].teachDic[teachType]
            withCloseBlock:block];
    }
}

+ (void)showWithType:(NSString *)type withView:(UIView *)view withCloseBlock:(void (^)(void))block{
    if(!view)
        return;
    if(![view isKindOfClass:[UIView class]])
        return;
    CGRect rect = [view frameInScreen];
    [self showWithType:type withRect:rect withCloseBlock:block];
}

+ (void)showTeachType:(NSString *)teachType withFrame:(CGRect)dstViewFrame withCloseBlock:(void (^)(void))block
{
//    if(CGRectEqualToRect(dstViewFrame, CGRectZero))
//        return;
    [self showWithType:teachType withRect:dstViewFrame withCloseBlock:block];
}

+ (void)showWithType:(NSString *)type withRect:(CGRect)frame withCloseBlock:(void (^)(void))block
{
    [self showWithType:type withRect:frame];
    GuideShadeView *teachView = [self sharedGuideShadeView];
    teachView.closeBlock = block;
}

+ (void)showWithType:(NSString *)type withRect:(CGRect)frame
{
    if (![self shouldShowTeachingViewWithType:type]) {
        return ;
    }
    
    NSLog(@"show teach: %@,%@",type,NSStringFromCGRect(frame));
    
    
    GuideShadeView *teachView = [self sharedGuideShadeView];
    
    if ([type isEqualToString:LTNTeachTypeNone]){
        
    }else if ([type isEqualToString:LTNTeachTypeParter]) {
        
        
        [teachView addRoundedRect:frame
                 withCornerRadius:4];
        
        UIImage *teachImage=[UIImage imageNamed:@"step1_title"];
        
        teachView.teachImageView.image = teachImage;
        teachView.teachImageView.size=teachImage.size;
        teachView.teachImageView.centerX=kScreenWidth/2;
        teachView.teachImageView.bottom=frame.origin.y-5;
        
        CGRect tempFrame=teachView.teachImageView.frame;
        teachView.dismissBtn.frame=CGRectMake(tempFrame.origin.x,tempFrame.origin.y+tempFrame.size.height/2,tempFrame.size.width,tempFrame.size.height/2);
        
        [teachView addSubview:teachView.dismissBtn];
        [teachView addSubview:teachView.teachImageView];
    }else if ([type isEqualToString:LTNTeachTypeBirdCoin]) {
        
        
        [teachView addEllipseRect:frame];
        
        UIImage *teachImage=[UIImage imageNamed:@"step2_title"];
        
        teachView.teachImageView.image = teachImage;
        teachView.teachImageView.size=teachImage.size;
        teachView.teachImageView.centerY=frame.origin.y+frame.size.height/2;
        teachView.teachImageView.right=frame.origin.x-5;
        
        CGRect tempFrame=teachView.teachImageView.frame;
        teachView.dismissBtn.frame=CGRectMake(tempFrame.origin.x,tempFrame.origin.y+tempFrame.size.height/2,tempFrame.size.width,tempFrame.size.height/2);
        
        [teachView addSubview:teachView.dismissBtn];
        [teachView addSubview:teachView.teachImageView];
    }else if ([type isEqualToString:LTNTeachTypeBirdTicket]) {
        
        if(kScreenHeight>480)
            [teachView addRoundedRect:frame
                 withCornerRadius:4];
        else
            [teachView.layer setMask:nil];
        
        UIImage *teachImage=[UIImage imageNamed:@"step3_title"];
        
        teachView.teachImageView.image = teachImage;
        teachView.teachImageView.size=teachImage.size;
        teachView.teachImageView.centerX=kScreenWidth/2;
        teachView.teachImageView.bottom=frame.origin.y-5;
        
    
        CGRect tempFrame=teachView.teachImageView.frame;
        teachView.dismissBtn.frame=CGRectMake(tempFrame.origin.x,tempFrame.origin.y+tempFrame.size.height/2,tempFrame.size.width,tempFrame.size.height/2);
        
        [teachView addSubview:teachView.dismissBtn];
        [teachView addSubview:teachView.teachImageView];
    }

        
    
    [[LTNCore mainWindow] addSubview:teachView];
    [[LTNCore mainWindow] bringSubviewToFront:teachView];
    
    [[NSUserDefaults standardUserDefaults] setObject:type forKey:type];
    
    
}



- (void)disMiss
{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self dissWithNoBlock];
    
    
    if (self.closeBlock) {
        self.closeBlock();
    }
}
- (void)dissWithNoBlock
{
    [self removeFromSuperview];
}

- (UIButton *)dismissBtn{
    if (!_dismissBtn) {
        _dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_dismissBtn setImage:[UIImage imageNamed:@"teach_Iknow"] forState:UIControlStateNormal];
//        [_dismissBtn sizeToFit];
        _dismissBtn.backgroundColor=[UIColor clearColor];
       // _dismissBtn.backgroundColor=[UIColor redColor];
        
        [_dismissBtn addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissBtn;
}

-(NSMutableDictionary *)teachDic{
    if(!_teachDic){
        _teachDic=[NSMutableDictionary dictionary];
    }
    return _teachDic;
}
- (UIImageView *)teachImageView
{
    if (!_teachImageView) {
        _teachImageView = [UIImageView new];
    }
    return _teachImageView;
}

 


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
