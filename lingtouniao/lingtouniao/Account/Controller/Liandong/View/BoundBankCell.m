//
//  BoundBankCell.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/5/4.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BoundBankCell.h"

@interface BoundBankCell()<UITextFieldDelegate>

@property (nonatomic,strong) UIButton * accessButton;

@end

@implementation BoundBankCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(22, 0, kScreenWidth - 22 * 2, kBoundBankCellHeight)];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.font = [CustomerizedFont heiti:14];
        [_textField setValue:[CustomerizedFont heiti:14] forKeyPath:@"_placeholderLabel.font"];
        [self.contentView addSubview:_textField];
        
        _accessButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * accessImage = [UIImage imageNamed:@"xiangqing"];
        [_accessButton setImage:accessImage forState:UIControlStateNormal];
        _accessButton.size = accessImage.size;
        _accessButton.right = kScreenWidth - 22;
        _accessButton.centerY = kBoundBankCellHeight * 0.5;
        [self.contentView addSubview:_accessButton];
    }
    return self;
}

- (void)setCellDic:(NSDictionary *)cellDic
{
    _cellDic = cellDic;
    _textField.placeholder = cellDic[@"placeholder"];
    [_textField setValue:cellDic[@"placeholderColor"] forKeyPath:@"_placeholderLabel.textColor"];
    _textField.userInteractionEnabled = [cellDic[@"canEdit"] boolValue];
    _accessButton.hidden = [cellDic[@"hideAccess"] boolValue];
}

@end
