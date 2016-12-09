//
//  HomeIntroduceAttachedCellFrame.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/6/23.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "HomeIntroduceAttachedCellFrame.h"
#import "ProductIntroduceModel.h"

#define kMargin 20
#define kItemHeight 22
#define kMarginItem 10
#define kCircleDiam 6

@implementation HomeIntroduceAttachedCellFrame

+ (instancetype)attachedCellFrameWithProductIntroduce:(ProductIntroduceModel *)introduce
{
    HomeIntroduceAttachedCellFrame * attachedCellFrame = [[HomeIntroduceAttachedCellFrame alloc] init];
    attachedCellFrame.introduce = introduce;
    return attachedCellFrame;
}

- (void)setIntroduce:(ProductIntroduceModel *)introduce
{
    _introduce = introduce;
    
    CGSize introduceSize = [_introduce.productIntroduce boundingRectWithSize:CGSizeMake(kScreenWidth - 2 * kMargin, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : kIntroduceFont} context:nil].size;
    _introduceFrame = (CGRect){kMargin, kMargin, introduceSize.width, introduceSize.height};
    
    NSArray * items = _introduce.items;
    NSMutableArray * circleArray = [NSMutableArray arrayWithCapacity:items.count];
    NSMutableArray * itemArray = [NSMutableArray arrayWithCapacity:items.count];
    for (int i = 0; i < items.count; i++) {
        
        CGFloat itemX = kMargin + kCircleDiam + kMarginItem;
        CGFloat itemY = _introduceFrame.origin.y + _introduceFrame.size.height + kMarginItem;
        if (itemArray.count) {
            CGRect frame = [itemArray[i - 1] CGRectValue];
            itemY = frame.origin.y + frame.size.height;
        }
        
        NSString * itemString = items[i];
        CGSize itemSize = [itemString boundingRectWithSize:CGSizeMake(kScreenWidth - kMargin * 2 - kCircleDiam - kMarginItem, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : kItemFont} context:nil].size;
        CGRect itemFrame = CGRectMake(itemX, itemY, itemSize.width, itemSize.height);
        [itemArray addObject:[NSValue valueWithCGRect:itemFrame]];
        
        CGFloat circleY = itemY + kItemFontSize * 0.5 - kCircleDiam * 0.4;
        CGFloat circleX = kMargin;
        CGRect circleFrame = CGRectMake(circleX, circleY, kCircleDiam, kCircleDiam);
        [circleArray addObject:[NSValue valueWithCGRect:circleFrame]];
    }
    
    _itemFrames = itemArray;
    _circleFrames = circleArray;
    
    CGRect lastFrame = [itemArray.lastObject CGRectValue];
    _cellHeight = lastFrame.origin.y + lastFrame.size.height + kMargin;

}

@end
