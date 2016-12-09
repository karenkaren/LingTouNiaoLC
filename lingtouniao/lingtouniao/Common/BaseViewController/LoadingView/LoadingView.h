//
//  LoadingView.h
//  LikeItReaderLibrary
//
//  Created by Resion Shi on 12/21/12.
//
//

#import <UIKit/UIKit.h>

#define LOADING_HEIGHT 44.0f
#define MIN_LOADING_OFFSET 10.0f

typedef enum {
    LoadingViewStateNormal,
    LoadingViewStateReady,
    LoadingViewStateLoading,
} LoadingViewState;

@interface LoadingView : UIView
{
    UILabel                         *_label;
    UIActivityIndicatorView         *_activityIndicatorView;
    UIImageView                     *_iconImage;
}

@property (nonatomic, copy)     NSString            *text;
@property (nonatomic, copy)     NSString            *textReady;
@property (nonatomic, copy)     NSString            *textLoading;
@property (nonatomic)           NSTextAlignment     alignment;
@property (nonatomic)           LoadingViewState    state;
@property (nonatomic)           UIActivityIndicatorViewStyle        activityIndicatorViewStyle;

-(void)setContentView:(BOOL)isMore;

@end
