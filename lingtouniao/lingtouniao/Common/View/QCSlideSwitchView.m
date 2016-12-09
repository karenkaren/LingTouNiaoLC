//
//  QCSlideSwitchView.m
//  QCSliderTableView
//
//  Created by “ 邵鹏 on 14-4-16.
//  Copyright (c) 2014年 Scasy. All rights reserved.
//


#import "QCSlideSwitchView.h"

static const CGFloat kHeightOfTopScrollView = 48.0f;
static const CGFloat kFontSizeOfTabButton = 18.0f;
static const NSUInteger kTagOfRightSideButton = 999;

@implementation QCSlideSwitchView
@synthesize selectIndex = _selectIndex;

#pragma mark - 初始化参数

- (void)initValues
{
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.buttonLabelFont = [CustomerizedFont heiti:kFontSizeOfTabButton];
    self.buttonSpaceWidth = 0;
    self.buttonMarginX = 0;
    self.topScrollViewHeight = kHeightOfTopScrollView;
    
    //创建顶部可滑动的tab
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.topScrollViewHeight)];
    _topScrollView.delegate = self;
    _topScrollView.backgroundColor = [UIColor clearColor];
    _topScrollView.pagingEnabled = NO;
    _topScrollView.showsHorizontalScrollIndicator = NO;
    _topScrollView.showsVerticalScrollIndicator = NO;
    _topScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:_topScrollView];
    _userSelectedChannelID = 100;
    
    //创建主滚动视图
    if (_style == TopAndContenScrollView)
    {
        _rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topScrollViewHeight, self.bounds.size.width, self.bounds.size.height - self.topScrollViewHeight)];
        _rootScrollView.delegate = self;
        _rootScrollView.pagingEnabled = YES;
        _rootScrollView.userInteractionEnabled = YES;
        _rootScrollView.bounces = NO;
        _rootScrollView.showsHorizontalScrollIndicator = NO;
        _rootScrollView.showsVerticalScrollIndicator = NO;
        _rootScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        
        [_rootScrollView.panGestureRecognizer addTarget:self action:@selector(scrollHandlePan:)];
        [self addSubview:_rootScrollView];
    }else
    {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.topScrollViewHeight);
    }
    
    _userContentOffsetX = 0;
    _viewArray = [[NSMutableArray alloc] init];
    
    _isBuildUI = NO;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initValues];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame andStyle:(QCSlideSwitchViewStyle)style
{
    self = [super initWithFrame:frame];
    if (self) {
        _style = style;
        [self initValues];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _style = TopAndContenScrollView;
        [self initValues];
    }
    return self;
}

#pragma mark getter/setter

- (void)setRigthSideButton:(UIButton *)rigthSideButton
{
    UIButton *button = (UIButton *)[self viewWithTag:kTagOfRightSideButton];
    [button removeFromSuperview];
    rigthSideButton.tag = kTagOfRightSideButton;
    _rigthSideButton = rigthSideButton;
    [self addSubview:_rigthSideButton];
    
}

- (NSInteger)selectIndex
{
    _selectIndex = _userSelectedChannelID-100;
    return _selectIndex;
}

- (void)setSelectIndex:(NSInteger)selectIndex animated:(BOOL)animated
{
    for (UIViewController *vc in self.viewController.childViewControllers) {
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
    _selectIndex = selectIndex;
    UIButton *btn = (UIButton *)[_topScrollView viewWithTag:_selectIndex+100];
    [self selectNameButton:btn];

    UIViewController *vc = _viewArray[selectIndex];
    [self.viewController addChildViewController:vc];

    [_rootScrollView addSubview:vc.view];
//    [self layoutIfNeeded];
}

- (UIView *)topScrollViewItemWithIndex:(NSInteger)index
{
    UIButton *btn = (UIButton *)[_topScrollView viewWithTag:index+100];
    return btn;
}

// 修改
- (UIView *)shadowView
{
    if (_shadowView) {
        return _shadowView;
    } else {
        if (_shadowImage) {
            if (_shadowImageView) {
                return _shadowImageView;
            } else {
                _shadowImageView = [[UIImageView alloc] init];
                [_shadowImageView setImage:_shadowImage];
                _shadowImageView.frame = CGRectMake(self.buttonMarginX, 0, 0, _shadowImage.size.height);
                return _shadowImageView;
            }
        }
    }
    return nil;
}


#pragma mark - 创建控件

//当横竖屏切换时可通过此方法调整布局
- (void)layoutSubviews
{
    //创建完子视图UI才需要调整布局
    if (_isBuildUI) {
        //如果有设置右侧视图，缩小顶部滚动视图的宽度以适应按钮
        if (self.rigthSideButton.bounds.size.width > 0) {
            _rigthSideButton.frame = CGRectMake(self.bounds.size.width - self.rigthSideButton.bounds.size.width, 0,
                                                _rigthSideButton.bounds.size.width, _topScrollView.bounds.size.height);
            
            _topScrollView.frame = CGRectMake(0, 0,
                                              self.bounds.size.width - self.rigthSideButton.bounds.size.width, self.topScrollViewHeight);
        }
        
        //更新主视图的总宽度
        _rootScrollView.contentSize = CGSizeMake(self.bounds.size.width * [_viewArray count], 0);
        
        //更新主视图各个子视图的宽度
        for (int i = 0; i < [_viewArray count]; i++) {
            UIViewController *listVC = _viewArray[i];
            listVC.view.frame = CGRectMake(0+_rootScrollView.bounds.size.width*i, 0,
                                           _rootScrollView.bounds.size.width, _rootScrollView.bounds.size.height);
            [listVC.view layoutIfNeeded];
        }
        
        //滚动到选中的视图
        [_rootScrollView setContentOffset:CGPointMake((_userSelectedChannelID - 100)*self.bounds.size.width, 0) animated:NO];
        
        //调整顶部滚动视图选中按钮位置
        UIButton *button = (UIButton *)[_topScrollView viewWithTag:_userSelectedChannelID];
        [self adjustScrollViewContentX:button];
    }
}

/*!
 * @method 创建子视图UI
 * @abstract
 * @discussion
 * @param
 * @result
 */
- (void)buildUI
{
    // 修正frame
    _topScrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.topScrollViewHeight);
    
    // 修正frame
    _rootScrollView.frame = CGRectMake(0, self.topScrollViewHeight, self.bounds.size.width, self.bounds.size.height - self.topScrollViewHeight);
    
    NSUInteger number = [self.slideSwitchViewDelegate numberOfTab:self];
    
    for (int i=0; i<number; i++) {
        UIViewController *vc = [self.slideSwitchViewDelegate slideSwitchView:self viewOfTab:i];
        [_viewArray addObject:vc];
        [_rootScrollView addSubview:vc.view];
        NSLog(@"%@",[vc.view class]);
    }
    if (_isShowSpot) {
        [self createNameButtonsWithAgrc];
    }else {
         [self createNameButtons];
    }
    
    //选中第一个view
//    if (self.slideSwitchViewDelegate && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:didselectTab:)]) {
//        [self.slideSwitchViewDelegate slideSwitchView:self didselectTab:_userSelectedChannelID - 100];
//    }
    
    _isBuildUI = YES;
    
    //创建完子视图UI才需要调整布局
    [self setNeedsLayout];
}

- (void)createNameButtonsWithAgrc
{
    if ([self shadowView]) {
        [_topScrollView addSubview:[self shadowView]];
    }
    
    //顶部tabbar的总长度
    CGFloat topScrollViewContentWidth = self.buttonMarginX;
    //每个tab偏移量
    CGFloat xOffset = self.buttonMarginX;
    for (int i = 0; i < [_viewArray count]; i++) {
        UIViewController *vc = _viewArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGSize textSize = [vc.title boundingRectWithSize:CGSizeMake(_topScrollView.bounds.size.width, _buttonHeight?[_buttonHeight intValue]:self.topScrollViewHeight) options:NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName : self.buttonLabelFont} context:nil].size;
        CGFloat buttonWidth = textSize.width + self.buttonWidthOffset;
        CGFloat spaceFloat = (_buttonWidth - buttonWidth )/2.;
        
        //累计每个tab文字的长度
        if (i == _viewArray.count-1) { // 最后一个 不需要加上 间隔
            topScrollViewContentWidth += buttonWidth;
        } else {// 中间的 加上间隔
            topScrollViewContentWidth += (self.buttonSpaceWidth+buttonWidth);
        }
        //设置按钮尺寸
        
        
        [button setFrame:CGRectMake(xOffset + i*_buttonWidth + spaceFloat,_buttonHeight?(self.topScrollViewHeight - [_buttonHeight intValue])/2.0:0,
                                    buttonWidth, _buttonHeight?[_buttonHeight intValue]:self.topScrollViewHeight)];
        
        [button setTag:i+100];
        if (i == 0) {
            //            _shadowImageView.frame = CGRectMake(kWidthOfButtonMargin, 0, textSize.width, _shadowImage.size.height);
            // Yang 修改
            CGRect frame = self.shadowView.frame;
            if (self.shadowWidthInset) {
                frame.size.width = textSize.width + self.shadowWidthInset.floatValue * 2;
                frame.origin.x = (buttonWidth - frame.size.width)/2.0 + xOffset + spaceFloat;
            } else {
                frame.size.width = buttonWidth;
                frame.origin.x = xOffset + spaceFloat;
            }
            self.shadowView.frame = frame;
            button.selected = YES;
            
        }
        [button setTitle:vc.title forState:UIControlStateNormal];
        button.titleLabel.font = self.buttonLabelFont;
        [button setTitleColor:self.tabItemNormalColor forState:UIControlStateNormal];
       [button setTitleColor:[UIColor colorWithHexString:@"#ea5504"] forState:UIControlStateSelected];
        [button setBackgroundImage:self.tabItemNormalBackgroundImage forState:UIControlStateNormal];
        [button setBackgroundImage:[self.tabItemSelectedBackgroundImage stretchableImageWithLeftCapWidth:_stretchWidth?[_stretchWidth intValue]:0 topCapHeight:0] forState:UIControlStateSelected];
        
        [button addTarget:self action:@selector(selectTopScrollViewNameButton:) forControlEvents:UIControlEventTouchUpInside];
        [_topScrollView addSubview:button];
        
        //计算下一个tab的x偏移量
//        xOffset += (buttonWidth + self.buttonSpaceWidth);
    }
    
    //设置顶部滚动视图的内容总尺寸
    _topScrollView.contentSize = CGSizeMake(_viewArray.count * _buttonWidth, self.topScrollViewHeight);
}

/*!
 * @method 初始化顶部tab的各个按钮
 * @abstract
 * @discussion
 * @param
 * @result
 */
- (void)createNameButtons
{
    
    //    _shadowImageView = [[UIImageView alloc] init];
    //    [_shadowImageView setImage:_shadowImage];
    //    [_topScrollView addSubview:_shadowImageView];
    // Yang  修改
    if ([self shadowView]) {
        [_topScrollView addSubview:[self shadowView]];
    }
    
    //顶部tabbar的总长度
    CGFloat topScrollViewContentWidth = self.buttonMarginX;
    //每个tab偏移量
    CGFloat xOffset = self.buttonMarginX;
    for (int i = 0; i < [_viewArray count]; i++) {
        UIViewController *vc = _viewArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGSize textSize = [vc.title boundingRectWithSize:CGSizeMake(_topScrollView.bounds.size.width, _buttonHeight?[_buttonHeight intValue]:self.topScrollViewHeight) options:NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName : self.buttonLabelFont} context:nil].size;
        CGFloat buttonWidth = textSize.width + self.buttonWidthOffset;
        
        //累计每个tab文字的长度
        if (i == _viewArray.count-1) { // 最后一个 不需要加上 间隔
            topScrollViewContentWidth += buttonWidth;
        } else {// 中间的 加上间隔
            topScrollViewContentWidth += (self.buttonSpaceWidth+buttonWidth);
        }
        //设置按钮尺寸
        
        
        [button setFrame:CGRectMake(xOffset,_buttonHeight?(self.topScrollViewHeight - [_buttonHeight intValue])/2.0:0,
                                    buttonWidth, _buttonHeight?[_buttonHeight intValue]:self.topScrollViewHeight)];
        
        [button setTag:i+100];
        if (i == 0) {
            //            _shadowImageView.frame = CGRectMake(kWidthOfButtonMargin, 0, textSize.width, _shadowImage.size.height);
            // Yang 修改
            CGRect frame = self.shadowView.frame;
            if (self.shadowWidthInset) {
                frame.size.width = textSize.width + self.shadowWidthInset.floatValue * 2;
                frame.origin.x = (buttonWidth - frame.size.width)/2.0 + xOffset;
            } else {
                frame.size.width = buttonWidth;
                frame.origin.x = xOffset;
            }
            self.shadowView.frame = frame;
            button.selected = YES;
            
        }
        [button setTitle:vc.title forState:UIControlStateNormal];
        button.titleLabel.font = self.buttonLabelFont;
        [button setTitleColor:self.tabItemNormalColor forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#ea5504"] forState:UIControlStateSelected];
        [button setBackgroundImage:self.tabItemNormalBackgroundImage forState:UIControlStateNormal];
        [button setBackgroundImage:[self.tabItemSelectedBackgroundImage stretchableImageWithLeftCapWidth:_stretchWidth?[_stretchWidth intValue]:0 topCapHeight:0] forState:UIControlStateSelected];
        
        [button addTarget:self action:@selector(selectTopScrollViewNameButton:) forControlEvents:UIControlEventTouchUpInside];
        [_topScrollView addSubview:button];
        
        //计算下一个tab的x偏移量
        xOffset += (buttonWidth + self.buttonSpaceWidth);
    }
    
    //设置顶部滚动视图的内容总尺寸
    _topScrollView.contentSize = CGSizeMake(topScrollViewContentWidth+self.buttonMarginX, self.topScrollViewHeight);
}


#pragma mark - 顶部滚动视图逻辑方法

/*!
 * @method 选中tab时间
 * @abstract
 * @discussion
 * @param 按钮
 * @result
 */

-(void)selectTopScrollViewNameButton:(UIButton*)sender
{
    _isRootScroll = NO;
    [self selectNameButton:sender];
}

- (void)selectNameButton:(UIButton *)sender
{
    //如果点击的tab文字显示不全，调整滚动视图x坐标使用使tab文字显示全
    [self adjustScrollViewContentX:sender];
    //app首页红点
    if (_isShowSpot) {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTabSpot" object:nil userInfo:@{@"tag":[NSNumber numberWithInteger:sender.tag - 100]}];
        UIImageView *spotIm = (UIImageView *)[sender viewWithTag:90];
        if (spotIm) {
            spotIm.hidden = YES;
        }
    }
    UITableViewRowAnimation  tableViewRowAnimation = 0;

    //按钮选中状态
    if (!sender.selected) {
        if (_isShowSpot) {
            if (sender.tag != _userSelectedChannelID) {
                //取之前的按钮
                if (_userSelectedChannelID < sender.tag) {
                    tableViewRowAnimation = UITableViewRowAnimationLeft;
                } else {
                     tableViewRowAnimation = UITableViewRowAnimationRight;
                }
                UIButton *lastButton = (UIButton *)[_topScrollView viewWithTag:_userSelectedChannelID];
                lastButton.selected = NO;
                //赋值按钮ID
                _userSelectedChannelID = sender.tag;
            }
        }
        self.shadowView.hidden = self.isShadowHiddenWhenAniamting;
        [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            // Yang 修改
            CGRect frame = self.shadowView.frame;
            if (self.shadowWidthInset) {
                CGRect titleRect = [sender titleRectForContentRect:sender.bounds];
                frame.size.width = titleRect.size.width + self.shadowWidthInset.floatValue * 2.0;
                frame.origin.x = (sender.frame.size.width - frame.size.width)/2.0 + sender.frame.origin.x;
            } else {
                frame.origin.x = sender.frame.origin.x;
                frame.size.width = sender.frame.size.width;
            }
            self.shadowView.frame = frame;
            
            self.shadowView.hidden = NO;
            
            
            
        } completion:^(BOOL finished) {
            //如果更换按钮
            if (sender.tag != _userSelectedChannelID) {
                //取之前的按钮
                UIButton *lastButton = (UIButton *)[_topScrollView viewWithTag:_userSelectedChannelID];
                lastButton.selected = NO;
                //赋值按钮ID
                _userSelectedChannelID = sender.tag;
            }
            sender.selected = YES;
            
            if (finished) {
                
                //设置新页出现
                if (!_isRootScroll && !_rootScrollView.isTracking) {
                    [_rootScrollView setContentOffset:CGPointMake((sender.tag - 100)*self.bounds.size.width, 0) animated:YES];
                }
                _isRootScroll = NO;
                
                if (self.slideSwitchViewDelegate && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:didselectTab:)]) {
                    [self.slideSwitchViewDelegate slideSwitchView:self didselectTab:_userSelectedChannelID - 100];
                }
                
                if (self.slideSwitchViewDelegate &&[self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:didselectTab:withRowAnimation:)]) {
                     [self.slideSwitchViewDelegate slideSwitchView:self didselectTab:_userSelectedChannelID - 100 withRowAnimation:tableViewRowAnimation];
                }
            }
        }];
        
    }
    //重复点击选中按钮
    else {
        self.shadowView.hidden = NO;
    }
}

/*!
 * @method 调整顶部滚动视图x位置
 * @abstract
 * @discussion
 * @param
 * @result
 */
- (void)adjustScrollViewContentX:(UIButton *)sender
{
    // 原来代码，点击后 保持不动
    //    //如果 当前显示的最后一个tab文字超出右边界
    //    if (sender.frame.origin.x - _topScrollView.contentOffset.x > self.bounds.size.width - (kWidthOfButtonMargin+sender.bounds.size.width)) {
    //        //向左滚动视图，显示完整tab文字
    //        [_topScrollView setContentOffset:CGPointMake(sender.frame.origin.x - (_topScrollView.bounds.size.width- (kWidthOfButtonMargin+sender.bounds.size.width)), 0)  animated:YES];
    //    }
    //
    //    //如果 （tab的文字坐标 - 当前滚动视图左边界所在整个视图的x坐标） < 按钮的隔间 ，代表tab文字已超出边界
    //    if (sender.frame.origin.x - _topScrollView.contentOffset.x < kWidthOfButtonMargin) {
    //        //向右滚动视图（tab文字的x坐标 - 按钮间隔 = 新的滚动视图左边界在整个视图的x坐标），使文字显示完整
    //        [_topScrollView setContentOffset:CGPointMake(sender.frame.origin.x - kWidthOfButtonMargin, 0)  animated:YES];
    //    }
    
    //    [_topScrollView setContentOffset:CGPointMake(50, 0)  animated:YES];
    
    // 自己需求 将当前 sender 移动到屏幕中间
    CGFloat offsetXMax = _topScrollView.contentSize.width - _topScrollView.bounds.size.width;
    CGFloat offsetXMin = 0;
    if (offsetXMax < offsetXMin) {
        //if content size is small than self.width, don't move
        return;
    }
    CGFloat x = CGRectGetMinX(sender.frame) - (_topScrollView.bounds.size.width-sender.bounds.size.width)/2.0;
    CGFloat offsetX = x;
    if (offsetX > offsetXMin && offsetX < offsetXMax) {
        [_topScrollView setContentOffset:CGPointMake(offsetX, 0)  animated:YES];
    } else if (offsetX < offsetXMin) {
        [_topScrollView setContentOffset:CGPointMake(offsetXMin, 0)  animated:YES];
    } else if (offsetX > offsetXMax) {
        [_topScrollView setContentOffset:CGPointMake(offsetXMax, 0)  animated:YES];
    }
}

#pragma mark 主视图逻辑方法

//滚动视图开始时
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == _rootScrollView) {
        _userContentOffsetX = scrollView.contentOffset.x;
    }
}

//滚动视图结束
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _rootScrollView) {
        //判断用户是否左滚动还是右滚动
        if (_userContentOffsetX < scrollView.contentOffset.x) {
            _isLeftScroll = YES;
        }
        else {
            _isLeftScroll = NO;
        }
        
        int tag = roundf(scrollView.contentOffset.x*1.0f/self.bounds.size.width) + 100;
        if (_userSelectedChannelID != tag) { // 如果滑动没有改变selectIndex，则不需要 修改按钮状态
            //peijing: any regresion?
//            _isRootScroll = YES;
            
            UIButton *button = (UIButton *)[_topScrollView viewWithTag:tag];
            
            if (scrollView.isDragging)
            {
                [self selectNameButton:button];
                
            }
            
        }
        
    }
    
    
}
//滚动视图释放滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _rootScrollView) {
        //调整顶部滑条按钮状态
        int tag = roundf(scrollView.contentOffset.x*1.0f/self.bounds.size.width) + 100;
        if (_userSelectedChannelID != tag) { // 如果滑动没有改变selectIndex，则不需要 修改按钮状态
//            _userSelectedChannelID = tag;
            if (self.slideSwitchViewDelegate
                && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideScrollViewWithScrolling)]) {
                [self.slideSwitchViewDelegate slideScrollViewWithScrolling];
            }
            
        }
    }
}

//传递滑动事件给下一层
-(void)scrollHandlePan:(UIPanGestureRecognizer*) panParam
{
    //当滑道左边界时，传递滑动事件给代理
    if(_rootScrollView.contentOffset.x <= 0) {
        if (self.slideSwitchViewDelegate
            && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:panLeftEdge:)]) {
            [self.slideSwitchViewDelegate slideSwitchView:self panLeftEdge:panParam];
        }
    } else if(_rootScrollView.contentOffset.x >= _rootScrollView.contentSize.width - _rootScrollView.bounds.size.width) {
        if (self.slideSwitchViewDelegate
            && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:panRightEdge:)]) {
            [self.slideSwitchViewDelegate slideSwitchView:self panRightEdge:panParam];
        }
    }
}

#pragma mark - 适应屏幕宽度
- (void)adjustScreenWidth
{
    // 如果不超出屏幕宽度，则重新计算每个button的frame。使得全部铺满
    if (_topScrollView.contentSize.width < kScreenWidth) {
        NSUInteger number = [self.slideSwitchViewDelegate numberOfTab:self];
        CGFloat space = (kScreenWidth - _topScrollView.contentSize.width)/number;
        self.buttonWidthOffset += space;// 修正buttonWidthOffset
        CGFloat totalWidth = 0;
        for (int i = 0; i < number; i++) {
            UIView *sub = [self topScrollViewItemWithIndex:i];
            CGFloat width = sub.width+space;
            sub.width = width;
            sub.left += space*i;
            if (i == self.selectIndex) {
                CGRect frame = self.shadowView.frame;
                
                UIButton *sender = (UIButton *)sub;
                if (self.shadowWidthInset) {
                    CGRect titleRect = [sender titleRectForContentRect:sender.bounds];
                    frame.size.width = titleRect.size.width + self.shadowWidthInset.floatValue * 2.0;
                    frame.origin.x = (sender.frame.size.width - frame.size.width)/2.0 + sender.frame.origin.x;
                } else {
                    frame.origin.x = sender.frame.origin.x;
                    frame.size.width = sender.frame.size.width;
                }
                self.shadowView.frame = frame;
            }
            totalWidth += (sub.left+sub.width);
        }
        DLog(@" \n\n %f ",totalWidth);
        [self setNeedsLayout];
    }
}


#pragma mark - 工具方法

/*!
 * @method 通过16进制计算颜色
 * @abstract
 * @discussion
 * @param 16机制
 * @result 颜色对象
 */
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

@end

