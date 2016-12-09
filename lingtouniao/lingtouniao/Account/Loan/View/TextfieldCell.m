//
//  TextfieldCell.m
//  lingtouniao
//
//  Created by zhangtongke on 16/3/31.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "TextfieldCell.h"

@implementation TextfieldCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font=[UIFont systemFontOfSize:DimensionBaseIphone6(16)];
        self.detailTextLabel.font=[UIFont systemFontOfSize:DimensionBaseIphone6(16)];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, DimensionBaseIphone6(232), 30)];
        _textField.font=[UIFont systemFontOfSize:DimensionBaseIphone6(16)];
        _textField.textColor=[UIColor colorWithHexString:@"#3A3A3A"];
        [self.contentView addSubview:_textField];
        _textField.left=DimensionBaseIphone6(120);
        _textField.centerY=24.0f;
        _textField.delegate=self;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        [_textField addTarget:self action:@selector(textFieldDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        
        
        [_textField addTarget:self action:@selector(textFieldDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
        
    }
    return self;
}

-(void)setCellDic:(NSDictionary *)cellDic{
    _cellDic=cellDic;
    
    if(esBool(cellDic[@"showAccess"])){
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if(esBool(cellDic[@"canEdit"])){
        self.textField.userInteractionEnabled = YES;
    }else{
        self.textField.userInteractionEnabled = NO;
    }
    self.textLabel.text=cellDic[@"title"];
    
    self.textField.placeholder=cellDic[@"placeholder"];
    self.textField.clearButtonMode = UITextFieldViewModeNever;
    self.detailTextLabel.text=@"";
    if([cellDic[@"key"] isEqualToString:@"mobile_phone"]){
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        if(!self.textField.isEditing){
            self.detailTextLabel.text=locationString(@"btn_modify");
            self.detailTextLabel.textColor=[UIColor colorWithRed:100/255.0 green:163/255.0 blue:221/255.0 alpha:1.0];
        }else{
            self.detailTextLabel.text=@"";
        }
        
    }else if([cellDic[@"key"] isEqualToString:@"house_advance"]){
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.detailTextLabel.textColor=[UIColor colorWithHexString:@"#3A3A3A"];
        if([self.textField.text length]>0)
        {
            self.detailTextLabel.text=@"";
        }else{
            self.detailTextLabel.text=locationString(@"unit");
            
        }
    }else{
        self.detailTextLabel.text=@"";
    }
    
    if([cellDic[@"key"] isEqualToString:@"email"]){
        self.textField.keyboardType = UIKeyboardTypeEmailAddress;
    }else if([cellDic[@"key"] isEqualToString:@"mediation_name"]){
        self.textField.keyboardType = UIKeyboardTypeDefault;
        
    }

    
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    return YES;
//}

- (void) textFieldDidChange:(UITextField *) textField{
    
    NSString *textString=textField.text;
    if([_cellDic[@"key"] isEqualToString:@"house_advance"]){
        if([textString length]>0){
            NSRange range=[textString rangeOfString:locationString(@"unit")];
            if(range.location != NSNotFound){
                return;
            }
            
        }
    }
    
    if(_textFieldTextChangeBlock)
        _textFieldTextChangeBlock(textString);
}

- (void) textFieldDidBegin:(UITextField *) textField{
    if([_cellDic[@"key"] isEqualToString:@"mobile_phone"]){
        self.detailTextLabel.text=@"";
    }else if([_cellDic[@"key"] isEqualToString:@"house_advance"]){
        if([self.textField.text length]>0){
            
            NSRange range=[self.textField.text rangeOfString:locationString(@"unit")];
            if(range.location != NSNotFound){
                self.textField.text=[self.textField.text substringToIndex:range.location];
            }
            
        }
        self.detailTextLabel.text=locationString(@"unit");
        
    }
}


- (void) textFieldDidEnd:(UITextField *) textField{
    if([_cellDic[@"key"] isEqualToString:@"mobile_phone"]){
        self.detailTextLabel.text=locationString(@"btn_modify");
    }else if([_cellDic[@"key"] isEqualToString:@"house_advance"]){
        if([self.textField.text length]>0)
        {
            NSRange range=[self.textField.text rangeOfString:locationString(@"unit")];
            if(range.location == NSNotFound){
                self.textField.text=[NSString stringWithFormat:locationString(@"money_unit"),self.textField.text];
            }
            self.detailTextLabel.text=@"";
        }else{
            self.detailTextLabel.text=locationString(@"unit");
            
        }
        
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if([string isEqualToString:@" "]){
        if([_cellDic[@"key"] isEqualToString:@"house_advance"]){
            return NO;
        }
    }

    
    NSString *shouldText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSInteger maxLength=esInteger(_cellDic[@"maxLength"]);
                                  
    if([string isEqualToString:locationString(@"unit")])
        maxLength=maxLength+2;
    
    NSInteger strLength = shouldText.length;
    if (strLength > maxLength) {
        // 允许删除
        if (strLength < textField.text.length) {
            return YES;
        }
        
        return NO;
    }
    return YES;

  
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
