//
//  MethodSecondCell.m
//  lingtouniao
//
//  Created by 徐凯 on 16/3/29.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "MethodSecondCell.h"

@implementation MethodSecondCell

- (void)awakeFromNib {
    [super awakeFromNib];
    CGSize size = CGSizeMake(kScreenWidth - 20 * 2, 1000);
    CGSize retSize = [self boundingRectWithText:_desLabel.text maxSize:size font:[UIFont systemFontOfSize:14.0]];
    CGRect originFrame = _containerView.frame;
    originFrame.size.height = 112 + retSize.height;
    _containerView.frame = originFrame;
    _des_Label_1.text = locationString(@"des_Label_1");
    _des_Label_2.text = locationString(@"des_Label_2");
    _des_Label_3.text = locationString(@"des_Label_3");
    _des_Label_4.text = locationString(@"des_Label_4");
    _desLabel.text = locationString(@"detail_way");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGSize)boundingRectWithText:(NSString *)text maxSize:(CGSize)size font:(UIFont *)font
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize retSize = [text boundingRectWithSize:size
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    
    return retSize;
}


@end
