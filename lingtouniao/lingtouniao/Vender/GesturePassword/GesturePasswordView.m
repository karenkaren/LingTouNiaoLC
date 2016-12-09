//
//  GesturePasswordView.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import "GesturePasswordView.h"
#import "GesturePasswordButton.h"
#import "TentacleView.h"

@implementation GesturePasswordView {
    NSMutableArray * buttonArray;
    
    CGPoint lineStartPoint;
    CGPoint lineEndPoint;
    UIView *rootView;
    UIView *backView;
    
}
@synthesize imgView;
@synthesize forgetButton;
@synthesize otherAccoutButton;

@synthesize tentacleView;
@synthesize state;
@synthesize error;
@synthesize gesturePasswordDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //self.backgroundColor= BACKGROUND_COLOR;
        self.backgroundColor= [UIColor clearColor];
        rootView= [[UIView alloc] initWithFrame:frame];
        rootView.backgroundColor=[UIColor clearColor];
        if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0&&self.height==480){
            rootView.top=64;
            rootView.height=416;
            
        }
        
        [self addSubview:rootView];
        
        //self.backgroundColor=[UIColor redColor];
       state = [[UILabel alloc]initWithFrame:CGRectMake(0,DimensionBaseIphone6(30), 280, 14)];
        state.centerY=DimensionBaseIphone6(120)-64;
        state.centerX=rootView.width/2;
        [state setTextAlignment:NSTextAlignmentCenter];
        [state setFont:[UIFont systemFontOfSize:16.f]];
        [rootView addSubview:state];
        [state setTextColor:kHexColor(@"#3a3a3a")];
        
        error=[[UILabel alloc]initWithFrame:CGRectMake(0,state.bottom+DimensionBaseIphone6(10), 300, 12)];
        
        error.centerX=rootView.width/2;
        [error setTextAlignment:NSTextAlignmentCenter];
        [error setFont:[UIFont systemFontOfSize:11.f]];
        [rootView addSubview:error];
        [error setTextColor:kHexColor(@"#EA5504")];
        
        
        buttonArray = [[NSMutableArray alloc]initWithCapacity:0];
        
        
        
        NSInteger distance = DimensionBaseIphone6(100);
        NSInteger size = DimensionBaseIphone6(60);
        NSInteger margin = (kScreenWidth-size-distance*2)/2;
        
        backView = [[UIView alloc]initWithFrame:CGRectMake(0, state.bottom+25, rootView.width, size+distance*2)];
        
        //view.backgroundColor=[UIColor yellowColor];
        NSLog(@"self.height======%f",self.height);
        backView.centerY=rootView.height/2-32;
        if(kScreenHeight<568)
            backView.centerY=backView.centerY+20;
        
        //error.bottom=backView.top-20;
        
        if(rootView.height==416)
            state.top=0;
        //state.centerY=view.top/2-10;
        
        error.centerY=(backView.top+state.bottom)/2;
        
        self.drawView=[[LineDrawView alloc] initWithFrame:backView.frame];
        [rootView addSubview:self.drawView];
        //self.drawView.backgroundColor=[UIColor blueColor];
        
        for (int i=0; i<9; i++) {
            NSInteger row = i/3;
            NSInteger col = i%3;
            // Button Frame
            
            
            GesturePasswordButton * gesturePasswordButton = [[GesturePasswordButton alloc]initWithFrame:CGRectMake(col*distance+margin, row*distance, size, size)];
            [gesturePasswordButton setTag:i];
            [backView addSubview:gesturePasswordButton];
            [buttonArray addObject:gesturePasswordButton];
            
        }
        frame.origin.y=0;
        [rootView addSubview:backView];
        
        
        tentacleView = [[TentacleView alloc]initWithFrame:backView.frame];
        [tentacleView setButtonArray:buttonArray];
        tentacleView.lineView=self.drawView;
        [tentacleView setTouchBeginDelegate:self];
        [rootView addSubview:tentacleView];

        
        
        float space= kScreenHeight<568 ? DimensionBaseIphone6(100)-50.0 : DimensionBaseIphone6(100);
        forgetButton = [[UIButton alloc]initWithFrame:CGRectMake(0,backView.bottom+space, 120, 44)];
        
        [forgetButton.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [forgetButton setTitleColor:kHexColor(@"#2980B9") forState:UIControlStateNormal];
        [forgetButton setTitle:locationString(@"forget_gesture_code") forState:UIControlStateNormal];
        [forgetButton addTarget:self action:@selector(forget) forControlEvents:UIControlEventTouchDown];
        [rootView addSubview:forgetButton];
        
        
        
        forgetButton.centerX=rootView.width/2;
        
        otherAccoutButton = [[UIButton alloc]initWithFrame:CGRectMake(0,backView.bottom+space, 120, 44)];
        [otherAccoutButton.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [otherAccoutButton setTitleColor:kHexColor(@"#2980B9") forState:UIControlStateNormal];
        
        [otherAccoutButton setTitle:locationString(@"login_other_account") forState:UIControlStateNormal];
        [otherAccoutButton addTarget:self action:@selector(otherAccout) forControlEvents:UIControlEventTouchDown];
        [rootView addSubview:otherAccoutButton];
        otherAccoutButton.centerX=self.width*3/4;
        otherAccoutButton.hidden=YES;
        
    }
    
    return self;
}

-(void)showOtherAccountButton{
    
    forgetButton.centerX=self.width/4;
    otherAccoutButton.centerX=self.width*3/4;
    otherAccoutButton.hidden=NO;
    
}

-(void)setStateText:(NSString *)stateText{
    self.state.text=stateText;
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    /*
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colors[] =
    {
        134 / 255.0, 157 / 255.0, 147 / 255.0, 1.00,
        3 / 255.0,  3 / 255.0, 37 / 255.0, 1.00,
    };
    CGGradientRef gradient = CGGradientCreateWithColorComponents
    (rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    CGColorSpaceRelease(rgb);
    CGContextDrawLinearGradient(context, gradient,CGPointMake
                                (0.0,0.0) ,CGPointMake(0.0,self.frame.size.height),
                                kCGGradientDrawsBeforeStartLocation);
     */
}

- (void)gestureTouchBegin {
    //[self.state setText:@""];
}

-(void)forget{
    [gesturePasswordDelegate forget];
}

-(void)otherAccout{
    [gesturePasswordDelegate otherAccountLogin];
}


@end
