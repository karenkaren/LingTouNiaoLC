//
//  LoadingView.m
//  LikeItReaderLibrary
//
//  Created by Resion Shi on 12/21/12.
//
//

#import "LoadingView.h"

#define VIEW_MIN_WIDTH        50.0f
#define VIEW_MIN_HEIGHT       20.0f
#define ACTIVITYVIEW_HEIGHT   20.0f
#define ACTIVITYVIEW_WIDTH    20.0f
#define ACTIVITYVIEW_PADDING  10.0f

@implementation LoadingView
@synthesize text = _text;
@synthesize textReady = _textReady;
@synthesize textLoading = _textLoading;
@synthesize state = _state;
@synthesize activityIndicatorViewStyle = _activityIndicatorViewStyle;
@synthesize alignment = _alignment;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:NO];
        
        _activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:_activityIndicatorViewStyle];
        [_activityIndicatorView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_activityIndicatorView];
        
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        [_label setBackgroundColor:[UIColor clearColor]];
        [_label setLineBreakMode:NSLineBreakByTruncatingHead];
        [_label setNumberOfLines:1];
        [_label setTextAlignment:NSTextAlignmentLeft];
        _label.textColor = [UIColor grayColor];
        [_label setFont:[CustomerizedFont systemFontOfSize:[CustomerizedFont smallSystemFontSize]]];
        [self addSubview:_label];

        _alignment = NSTextAlignmentCenter;

        
        _iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pull_down_arrow"]];
        [self addSubview:_iconImage];
        
        [self setFrame:frame];
        [self setState:LoadingViewStateNormal];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    if (frame.size.width < VIEW_MIN_WIDTH) {
		frame.size.width = VIEW_MIN_WIDTH;
	}
	if (frame.size.height < VIEW_MIN_HEIGHT) {
		frame.size.height = VIEW_MIN_HEIGHT;
	}
    
	[super setFrame:frame];
    [self setAlignment:_alignment];
}

- (void)setText:(NSString *)text
{
    if (![_text isEqualToString:text]) {
        _text = [text copy];
        [_label setText:_text];
        [self setAlignment:_alignment];
    }
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    if (_activityIndicatorViewStyle != activityIndicatorViewStyle) {
        _activityIndicatorViewStyle = activityIndicatorViewStyle;
        [_activityIndicatorView setActivityIndicatorViewStyle:_activityIndicatorViewStyle];
    }
}
-(void)setContentView:(BOOL)isMore
{
    if (isMore)
    {
        _iconImage.hidden = NO;
    }else
    {
        _iconImage.hidden =YES;
    }
}
- (void)setAlignment:(NSTextAlignment)alignment
{
    CGRect activityIndicatorRect = CGRectMake(0, (self.frame.size.height - ACTIVITYVIEW_HEIGHT) / 2.0f, ACTIVITYVIEW_WIDTH, ACTIVITYVIEW_HEIGHT);
//    CGSize labelSize = [_label.text sizeWithFont:_label.font];
//    
    CGSize labelSize = [Utility sizeWithText:_label.text boundingSize:CGSizeMake(self.width, 40) font:[CustomerizedFont systemFontOfSize:[CustomerizedFont smallSystemFontSize]] lineBreakMode:NSLineBreakByCharWrapping];
    
    CGRect labelRect = CGRectMake(ACTIVITYVIEW_WIDTH + ACTIVITYVIEW_PADDING, (self.bounds.size.height - labelSize.height) / 2.0f, labelSize.width, labelSize.height);
    
    CGRect iconRect = CGRectMake(100.0f, activityIndicatorRect.origin.y + (ACTIVITYVIEW_HEIGHT - 13.0f) / 2, 9.0f, 13.0f);
    
    switch (_alignment) {
        case NSTextAlignmentLeft: break;
        default:
        case NSTextAlignmentCenter: {
            labelRect.origin.x = kScreenWidth/2. - labelSize.width / 2.0f;
            activityIndicatorRect.origin.x = labelRect.origin.x - ACTIVITYVIEW_PADDING - ACTIVITYVIEW_WIDTH;
            break;
        }
        case NSTextAlignmentRight: {
            [_label sizeToFit];
            labelRect.origin.x = kScreenWidth - _label.frame.size.width;
            activityIndicatorRect.origin.x = labelRect.origin.x -  - ACTIVITYVIEW_PADDING - ACTIVITYVIEW_WIDTH;
            break;
        }
    }
    
    iconRect.origin.x = activityIndicatorRect.origin.x + (ACTIVITYVIEW_WIDTH - iconRect.size.width) / 2;
    
    [_activityIndicatorView setFrame:activityIndicatorRect];
    [_label setFrame:labelRect];
    [_iconImage setFrame:iconRect];

}

- (void)setState:(LoadingViewState)state
{
    _state = state;
    switch (_state) {
        default:
        case LoadingViewStateNormal: {
            [_activityIndicatorView stopAnimating];
            [_activityIndicatorView setHidden:YES];
            [_iconImage setHidden:NO];
            [UIView beginAnimations:@"refresh" context:nil];
            
            [UIView animateWithDuration:0.2 animations:^{
                _iconImage.layer.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            }];
            
            [UIView commitAnimations];
            [_label setText:_text];
            break;
        }
        case LoadingViewStateReady: {
            [_activityIndicatorView stopAnimating];
            [_activityIndicatorView setHidden:YES];
            [_label setText:_textReady];
            [_iconImage setHidden:NO];            
            [UIView beginAnimations:@"refresh" context:nil];
            
            [UIView animateWithDuration:0.2 animations:^{
                _iconImage.layer.transform = CATransform3DIdentity;
            }];
            [UIView commitAnimations];
            break;
        }
        case LoadingViewStateLoading: {
            [_activityIndicatorView startAnimating];
            [_activityIndicatorView setHidden:NO];
            [_iconImage setHidden:YES];
            [_label setText:_textLoading];
            break;
        }
    }
    
    [self setAlignment:_alignment];
}

@end
