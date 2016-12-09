//
//  LTNAccountCollectionCell.h
//  lingtouniao
//
//  Created by 郑程锋 on 16/5/23.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTNAccountCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIButton * pointButton;

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *detailLabel;
@property (nonatomic) UIImageView *img;
@property (nonatomic) UIView *line1,*line2;

@end
