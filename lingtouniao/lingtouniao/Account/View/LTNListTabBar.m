//
//  LTNListTabBar.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/3/18.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNListTabBar.h"


#define kArrowButtonW 30
#define kItemsPadding 30
#define kSide  10

@interface LTNListTabBar()

/**
 *  用于显示所有的item
 */
@property (nonatomic, weak) UIScrollView *listTabBar;
/**
 *  选中item的背景View
 */
@property (nonatomic, weak) UIView *btnBgView;
/**
 *  当前选中的item按钮
 */
@property (nonatomic, weak) UIButton *currentSelectedBtn;
/**
 *  箭头按钮
 */
@property (nonatomic, weak) UIButton *arrowButton1,*arrowButton2;
/**
 *  装有所有item的数组
 */
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation LTNListTabBar


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        _items = [NSMutableArray array];
        
   //     self.backgroundColor = [UIColor colorWithRed:245/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];
        
        [self initView];
    }
    
    return self;
}

- (void)initView{
    
    //设置箭头按钮
    UIButton *arrowButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    arrowButton1.frame = CGRectMake(kScreenWidth - kArrowButtonW*1.5, kSide, kArrowButtonW, kArrowButtonW);
    [arrowButton1 setImage:[UIImage imageNamed:@"icon_arrow1"] forState:UIControlStateNormal];
  //  arrowButton1.backgroundColor = [UIColor lightGrayColor];
    [arrowButton1 addTarget:self action:@selector(arrowButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    self.arrowButton1 = arrowButton1;
    arrowButton1.tag = 500;
    [self addSubview:self.arrowButton1];
    
    UIButton *arrowButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    arrowButton2.frame = CGRectMake(15, kSide, kArrowButtonW, kArrowButtonW);
    [arrowButton2 setImage:[UIImage imageNamed:@"icon_arrow2"] forState:UIControlStateNormal];
  //  arrowButton2.backgroundColor = [UIColor lightGrayColor];
    [arrowButton2 addTarget:self action:@selector(arrowButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    self.arrowButton2 = arrowButton2;
    arrowButton2.tag = 501;
    [self addSubview:self.arrowButton2];
    
    //设置滚动的listTabBar
    UIScrollView *listTabBar = [[UIScrollView alloc] initWithFrame:CGRectMake(kArrowButtonW*2, 0, kScreenWidth - kArrowButtonW*4,kArrowButtonW*1.5)];
    listTabBar.showsHorizontalScrollIndicator = NO;
    self.listTabBar = listTabBar;
    listTabBar.tag = 502;
  //  self.listTabBar.backgroundColor = [UIColor blueColor];
    [self addSubview:self.listTabBar];
    
}
/**
 *  重写属性currentItemIndex的setter方法
 */
- (void)setCurrentItemIndex:(NSInteger)currentItemIndex{
    
    _currentItemIndex = currentItemIndex;
    
    UIButton *button = _items[currentItemIndex];
    
    [self settingSelectedButton:button];
    
    CGFloat listTabBatF = kScreenWidth - kArrowButtonW;
    
    CGFloat rightButtonMaxX = button.frame.origin.x + button.frame.size.width;
    
    if (rightButtonMaxX > listTabBatF - 20)
    {
        CGFloat offsetX = rightButtonMaxX - listTabBatF;
        if (_currentItemIndex < self.itemsTitle.count - 1)
        {
            offsetX = offsetX + 60.0;
        }
        
        [self.listTabBar setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
    else
    {
        [self.listTabBar setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

/**
 *  重写属性setItemsTitle的setter方法(在控制器中调用itemsTitle的setter方法是就会来到这里->self.itemsTitle=)
 */
- (void)setItemsTitle:(NSArray *)itemsTitle{
    
    _itemsTitle = itemsTitle;
    
    CGFloat buttonW = (kScreenWidth-4*kArrowButtonW)/3;
    for (int i = 0; i < itemsTitle.count; i ++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        //取得item的标题
        NSString *title = _itemsTitle[i];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.frame = CGRectMake(buttonW*i, kSide, buttonW+10 , kArrowButtonW);
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
     //   button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button addTarget:self action:@selector(itemsDidClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 1) {
         button.selected = YES;
        }
        [self.listTabBar addSubview:button];
        
        [self.items addObject:button];
        
    }
    
    self.listTabBar.contentSize = CGSizeMake(_itemsTitle.count*buttonW, 0);
    
    
}

/**
 *  item按钮的点击事件
 */
- (void)itemsDidClick:(UIButton *)button{
    
    [self settingSelectedButton:button];
    
    NSInteger index = [_items indexOfObject:button];
    
    if ([self.delegate respondsToSelector:@selector(listTabBar:didSelectedItemIndex:)]) {
        
        [self.delegate listTabBar:self didSelectedItemIndex:index];
    }
}


/**
 *  设置button为选中状态（主要是改变选中按钮的title颜色）
 */
- (void)settingSelectedButton:(UIButton *)button{
    
    for (UIView *view in self.listTabBar.subviews) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            
            ((UIButton *)view).selected = NO;
        }
    }
    button.selected = YES;
}


//箭头按钮点击事件
- (void)arrowButtonDidClick:(UIButton *)btn{
    UIScrollView *src = (id)[self viewWithTag:502];
    CGPoint point = src.contentOffset;
    if (btn.tag == 500) {
        
        if (point.x == 0) {//右边边按钮
            
        }else{
            //更改偏移量
            src.contentOffset = CGPointMake(point.x - (kScreenWidth-4*kArrowButtonW)/3 - 10, 0);
            
        }
    }
    
    if (btn.tag == 501) {//左边按钮
        
        if (point.x == (_itemsTitle.count - 1) *((kScreenWidth-4*kArrowButtonW)/3 - 10)) {
            
        }else{
            src.contentOffset = CGPointMake(point.x + (kScreenWidth-4*kArrowButtonW)/3 + 10, 0);
        }
    }

    
    
    
}





@end