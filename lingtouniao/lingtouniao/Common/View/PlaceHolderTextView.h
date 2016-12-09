//
//  UIPlaceHolderTextView.h
//  Giglr
//
//  Created by Zhu Yuzhou on 9/6/12.
//  Copyright (c) 2012 Giglr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceHolderTextView : UITextView {
    NSString *placeholder;
    UIColor *placeholderColor;
    
@private
    UILabel *placeHolderLabel;
}

@property (nonatomic, retain) UILabel *placeHolderLabel;
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

@property (nonatomic, assign) CGPoint placeHolderLabelOrigion;

-(void)textChanged:(NSNotification*)notification;

@end

