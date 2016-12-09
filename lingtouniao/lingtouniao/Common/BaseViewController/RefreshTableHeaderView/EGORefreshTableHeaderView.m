//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableHeaderView.h"
#import "LTNDefines.h"

#define TEXT_COLOR	 [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

#define MaxBirdHeadSize CGSizeMake(DimensionBaseIphone6(150*750/1080/2),DimensionBaseIphone6(124*750/1080/2));


//#define MaxBirdHeadSize CGSizeMake(DimensionBaseIphone6(107*750/1080/2),DimensionBaseIphone6(107*750/1080/2));



#define BottomDistance DimensionBaseIphone6(0)

@interface EGORefreshTableHeaderView(){
    CGSize _maxBirdHeadSize;
}


@end

@interface EGORefreshTableHeaderView (Private)

- (void)setState:(EGOPullRefreshState)aState;
@end

@implementation EGORefreshTableHeaderView

@synthesize delegate=_delegate;
@synthesize needArrow = _needArrow;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];

		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [CustomerizedFont systemFontOfSize:12.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
		[label release];
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [CustomerizedFont boldSystemFontOfSize:13.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		[label release];
		
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(100.0f, frame.size.height - 44.0f, 9.0f, 13.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
        layer.contents = (id)[UIImage imageNamed:@"pull_down_arrow"].CGImage;
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
        
        
        _maxBirdHeadSize=MaxBirdHeadSize;
		/*
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		[view release];
		*/
//        _animatingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, frame.size.height - 50.0f, 50.0f, 50.0f)];
        NSData *img = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loading@2x.gif" ofType:nil]];
        _animatingImageView = [[UIImageView alloc] initWithImage:[UIImage sd_animatedGIFWithData:img]];
       
        _animatingImageView.size=_maxBirdHeadSize;
        //_animatingImageView.image = [UIImage sd_animatedGIFWithData:img];
        [self addSubview:_animatingImageView];
        
        _animatingImageView.centerX=self.width/2;
        _animatingImageView.bottom=self.height-BottomDistance;
        //_animatingImageView.backgroundColor=[UIColor yellowColor];
        
        _needArrow = YES;
		[self setState:EGOOPullRefreshNormal];
		
    }
	
    return self;
	
}

- (void)setNeedArrow:(BOOL)needArrow{
    _needArrow = needArrow;
    //_arrowImage.hidden = !needArrow; // 可能需要即时更新view，但是不能简单的这样改，需要根据_state判断
}

- (void)setNormalText:(NSString *)normalText {
    _normalText = normalText;
    if (_statusLabel) {
        _statusLabel.text = normalText;
    }
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
		
		NSDate *date = [_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setAMSymbol:@"AM"];
		[formatter setPMSymbol:@"PM"];
		[formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
		_lastUpdatedLabel.text = [NSString stringWithFormat:locationString(@"last_update"), [formatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[formatter release];
		
	} else {
		
		_lastUpdatedLabel.text = nil;
		
	}
    
    _lastUpdatedLabel.text = nil;
    [_lastUpdatedLabel sizeToFit];
    _lastUpdatedLabel.centerX = self.myCenterX;
    CGFloat animationRight = _lastUpdatedLabel.left - 40;
    if (animationRight < 65) {
        animationRight = _lastUpdatedLabel.left - 20;
    }
    //_animatingImageView.right = animationRight;
        CGSize arrowSize = _arrowImage.bounds.size;
    CGPoint origin =  CGPointMake(_animatingImageView.right + 35, _arrowImage.frame.origin.y);
    _arrowImage.frame = CGRectMake(origin.x, origin.y, arrowSize.width, arrowSize.height);
    
    //self.backgroundColor=[UIColor redColor];
}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
			
			_statusLabel.text = self.pullingText == nil ? locationString(@"release_refresh") : self.pullingText;
            _statusLabel.text = nil;
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            _arrowImage.hidden = _needArrow?NO:YES;
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshNormal:
			
			if (_state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_statusLabel.text = self.normalText == nil ?locationString(@"pull_refresh") : self.normalText;
            _statusLabel.text = nil;
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
            _arrowImage.hidden = _needArrow?NO:YES;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case EGOOPullRefreshLoading:
			
			_statusLabel.text = nil;
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
    _arrowImage.hidden = !self.needArrow;
	_state = aState;
}

- (void)storeOldContentInsetForScrollView:(UIScrollView *)scrollView{
    
    if (!self.oldScrollViewContentInset) {
        self.oldScrollViewContentInset = [NSValue valueWithUIEdgeInsets:scrollView.contentInset];
    }
    
}

- (UIEdgeInsets)oldContentInset{
    return [self.oldScrollViewContentInset UIEdgeInsetsValue];
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
	
    [self storeOldContentInsetForScrollView:scrollView];
    
	if (_state == EGOOPullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
//		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
        UIEdgeInsets oldInsets = [self oldContentInset];
        oldInsets.top += offset;
        scrollView.contentInset = oldInsets;
        
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:EGOOPullRefreshNormal];
		} else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading) {
			[self setState:EGOOPullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != 0) {
//            scrollView.contentInset = UIEdgeInsetsZero;
            scrollView.contentInset = [self oldContentInset];
		}
		
	}
    
    float offsetY=0;
    if(scrollView.contentOffset.y<0){
        offsetY=fabs(scrollView.contentOffset.y);
        if(offsetY>_maxBirdHeadSize.height)
            offsetY=_maxBirdHeadSize.height;
        [UIView animateWithDuration:0.1 animations:^{
            //
            _animatingImageView.size=CGSizeMake(offsetY*_maxBirdHeadSize.width/_maxBirdHeadSize.height, offsetY);
            _animatingImageView.centerX=self.width/2;
            _animatingImageView.bottom=self.height-BottomDistance;
    
        }];
    }
    
    
	
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
    [self storeOldContentInsetForScrollView:scrollView];
    
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
		}
		
		[self setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
//		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        UIEdgeInsets oldInsets = [self oldContentInset];
        oldInsets.top += 60.0f;
        scrollView.contentInset = oldInsets;
		[UIView commitAnimations];
		
	}
	
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	
    [self storeOldContentInsetForScrollView:scrollView];
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
    
    UIEdgeInsets oldInsets = [self oldContentInset];
    [scrollView setContentInset:oldInsets];
    
//	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:EGOOPullRefreshNormal];

}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    
    _animatingImageView = nil;
    
    if(_oldScrollViewContentInset){
        [_oldScrollViewContentInset release];
        _oldScrollViewContentInset=nil;
    }
    
    
    
    [super dealloc];
}


@end
