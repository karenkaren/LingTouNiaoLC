//
//  DetailButton.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/5/27.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "DetailButton.h"

@interface DetailButton ()

@property(nonatomic, copy) ESHandlerBlock handleBlock;

@end

@implementation DetailButton

+ (DetailButton *)creatDetailButtonWithTitle:(NSString *)title rightImage:(UIImage *)rightImage handle:(ESHandlerBlock)handleBlock
{
    DetailButton * detailButton = [[DetailButton alloc] initWithTitle:title rightImage:rightImage handle:handleBlock];
    return detailButton;
}

- (instancetype)initWithTitle:(NSString *)title rightImage:(UIImage *)rightImage handle:(ESHandlerBlock)handleBlock
{
    self = [super init];
    if (self) {
        if (handleBlock) {
            self.handleBlock = handleBlock;
        }
        self.titleLabel = [Utility createLabel:kFont(14) color:HexRGB(0x999999)];
        self.titleLabel.text = title;
        [self.titleLabel sizeToFit];
        [self addSubview:self.titleLabel];

        UIImageView * imageView = [[UIImageView alloc] initWithImage:rightImage];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.left = self.titleLabel.right;
        CGFloat rightImageViewHeight = MAX(rightImage.size.width, rightImage.size.height);
        [self addSubview:imageView];
        
        CGFloat height = MAX(self.titleLabel.height, rightImageViewHeight);
        self.bounds = CGRectMake(0, 0, self.titleLabel.width + imageView.width, height);
        self.titleLabel.centerY = imageView.centerY = height * 0.5;
        
        UIButton * button = [[UIButton alloc] init];
        [button setBackgroundColor:[UIColor clearColor]];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(imageView.mas_left);
            make.left.equalTo(self);
        }];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(rightImageViewHeight, rightImageViewHeight));
            make.right.equalTo(self);
            make.left.equalTo(self.titleLabel.mas_right);
            make.centerY.equalTo(self);
        }];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)clickButton:(UIButton *)button
{
    if (self.handleBlock) {
        self.handleBlock(button);
    }
}

@end
