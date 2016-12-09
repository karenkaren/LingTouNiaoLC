//
//  LTNFriendsCell.m
//  lingtouniao
//
//  Created by 郑程锋 on 15/12/25.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//
#define kSide 24
#define kMargin 2
#define kGeneral 30
#define kBaseTag 1000

#import "LTNFriendsHeaderView.h"

@interface LTNFriendsHeaderView()<UIGestureRecognizerDelegate>
{
    UILabel *_labelRegister;
    UILabel *_labelReal;
    UILabel *_labelInvester;
}

@property (nonatomic) NSMutableArray *itemViews;
@property (nonatomic) MyFriendsStatus currentStatus;
@property (nonatomic) BOOL canBeSelected;
@property (nonatomic) UIImageView *indicatorImgV;
@property (nonatomic) NSInteger itemNum;

@end

@implementation LTNFriendsHeaderView

- (instancetype) initWithSelectableStatus:(BOOL)canBeSelected {
    if (self = [super initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, 75)]) {
        _canBeSelected = canBeSelected;
        [self configUI];
    }
    return self;
}

-(void)setModel:(FriendsModel *)model {
    _model = model;
    _labelRegister.text = [NSString stringWithFormat:@"%@",@(model.registeredNum)];
    //    _labelReal.text = [NSString stringWithFormat:@"%@",@(model.realNameNum)];
    _labelReal.text = [NSString stringWithFormat:@"%@",@(model.bkPersonNum)];
    _labelInvester.text = [NSString stringWithFormat:@"%@",@(model.investNum)];
}


-(void)configUI {
    
    //头部线条
    UIView *headerLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 30, 0.5)];
    headerLineView.backgroundColor = HexRGB(0xe2e2e2);
    [self addSubview:headerLineView];
    
    
    NSArray *dataTitles=@[locationString(@"new_partner_num"),locationString(@"new_partner_bangka"), locationString(@"new_partner_man")];
    NSArray *imageArray = @[@"Registperson",@"CardIcon",@"InvestPerson"];
    _itemNum = 3;
    //注册人数／实名人数／已投资人数
    CGFloat partnerViewWidth= (kScreenWidth - 30) / self.itemNum;
    
    
    NSArray *datas=@[[NSString stringWithFormat:@"%@",@(self.model.registeredNum)],[NSString stringWithFormat:@"%@",@(self.model.realNameNum)],[NSString stringWithFormat:@"%@",@(self.model.investNum)]];
    
    _labelInvester = [Utility createLabel:[CustomerizedFont heiti:25] color:[UIColor colorWithHexString:@"#333333"]];
    _labelReal = [Utility createLabel:[CustomerizedFont heiti:25] color:[UIColor colorWithHexString:@"#333333"]];
    _labelRegister = [Utility createLabel:[CustomerizedFont heiti:25] color:[UIColor colorWithHexString:@"#333333"]];
    _itemViews = [NSMutableArray arrayWithCapacity:self.itemNum];
    
    NSArray *labels = @[_labelRegister, _labelReal, _labelInvester];
    
    
    for (int i=0; i<datas.count; i++) {
        
        UIView *dataView = [[UIView alloc] initWithFrame:CGRectMake(partnerViewWidth * i, 0, partnerViewWidth, 75)];
        dataView.tag = i + kBaseTag;
       
        if (self.canBeSelected) {
           
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
            tap.delegate = self;
            [dataView addGestureRecognizer:tap];
            
            //[dataView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
           
        }
        [self addSubview:dataView];
        dataView.backgroundColor = [UIColor clearColor];
        _itemViews[i] = dataView;
        
        UILabel *label = labels[i];
        label.text = datas[i];
        label.frame = CGRectMake(0, 10, partnerViewWidth, 32);
        label.textAlignment = NSTextAlignmentCenter;
        
        [dataView addSubview:label];
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((partnerViewWidth - 70)/2, label.bottom+5 , 15, 15)];
        image.image = [UIImage imageNamed:imageArray[i]];
        image.userInteractionEnabled = YES;
        [dataView addSubview:image];
        
        UILabel *dataTitleLabel = [Utility createLabel:[CustomerizedFont heiti:12] color:[UIColor colorWithHexString:@"#666666"]];
        dataTitleLabel.frame = CGRectMake(image.right+5, label.bottom+5, 50, 15);
        dataTitleLabel.textAlignment = NSTextAlignmentLeft;
        dataTitleLabel.text = dataTitles[i];
        [dataView addSubview:dataTitleLabel];
        
        
        
        for (int i = 0; i<4; i++)  {
            UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(partnerViewWidth * i, 0, 0.5,75)];
            if (i==1 || i==2) {
                lineView.frame = CGRectMake(partnerViewWidth * i, 15, 0.5, 45);
            }
            lineView.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
            [self addSubview:lineView];
        }
        
    }
    //脚部线条
    UIView *footerLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 75 - 0.5, kScreenWidth-30, 0.5)];
    footerLineView.backgroundColor = HexRGB(0xe2e2e2);
    [self addSubview:footerLineView];
    
    _indicatorImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"triangle"]];
    self.indicatorImgV.bottom = self.height + 25;
    [self addSubview:self.indicatorImgV];
    self.indicatorImgV.hidden = YES;
}

- (void)selectStatus:(MyFriendsStatus)status {
    for (UIView *view in self.itemViews) {
        view.backgroundColor = [UIColor clearColor];
    }
    
    NSInteger index = (NSInteger)status;
    self.currentStatus = status;
    if (index >= 0 && index < self.itemViews.count) {
        [UIView animateWithDuration:0.3 animations:^{
            self.indicatorImgV.hidden = NO;
            self.indicatorImgV.centerX = ((UIView *)(self.itemViews[index])).centerX;
        }];
    }
}

//tap to pass to outside, then the outside calls the - (void)selectStatus:(MyFriendsStatus)status to update this view
- (void)tap:(UITapGestureRecognizer *)gesture {
   
    UIView *view = gesture.view;
    MyFriendsStatus status = (MyFriendsStatus)(view.tag - kBaseTag);
    if (status != self.currentStatus) {
        [self.delegate selectStatus:status];
    }
    
    // CGPoint point = [gesture locationInView:view];
    // NSLog(@"tapPointx:%f,y:%f",point.x,point.y);
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


@end
