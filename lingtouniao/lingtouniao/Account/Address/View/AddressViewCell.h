//
//  AddressViewCell.h
//  lingtouniao
//
//  Created by 郑程锋 on 16/11/3.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTNAddressModel.h"

@class AddressViewCell;
@protocol AddressInfoCellDelegate <NSObject>
@optional

/**点击编辑
 */
- (void)AddressInfoCell:(AddressViewCell *)cell editButtonClickedButton:(UIButton *)touchBtn;

/**点击删除
 */
- (void)AddressInfoCell:(AddressViewCell *)cell deleteButtonClickedButton:(UIButton *)touchBtn;


@end


@interface AddressViewCell : UITableViewCell

@property (nonatomic) LTNAddressModel *model;

@property (nonatomic) UILabel *phoneLabel;//电话

@property (nonatomic) UILabel *nameLabel;//姓名

@property (nonatomic) UILabel *addressLabel;//详细地址

@property (nonatomic) UIButton *editButton;//编辑

@property (nonatomic) UIButton *deleteButton;//删除

@property (nonatomic) UIImageView *editIconView;//编辑图片

@property (nonatomic) UIImageView *deleteIconView;//删除图片

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (weak, nonatomic) id<AddressInfoCellDelegate>delegate;

@end
