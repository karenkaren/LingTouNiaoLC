//
//  LTNLoanProgressCell.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/3/25.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNLoanProgressCell.h"
#import "Masonry.h"

#define kDefaultColor HexRGB(0x8a8a8a)

@interface LTNLoanProgressCell ()
{
    UIImageView * _iconImageView;    // icon
    UIView * _bottomLineView;    // bottom line
    UILabel * _titleLabel;   // title label
    UILabel * _detailLabel;   // detail label
}

@end

@implementation LTNLoanProgressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addAllSubviews];
    }
    return self;
}

- (void)addAllSubviews
{
    // icon
    _iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconImageView];
    
    // bottom line
    _bottomLineView = [[UIView alloc] init];
    _bottomLineView.backgroundColor = HexRGB(0xe2e2e2);
    [self.contentView addSubview:_bottomLineView];
    
    // title label
    _titleLabel = [Utility createLabel:[CustomerizedFont heiti:16] color:kDefaultColor];
    [self.contentView addSubview:_titleLabel];
    
    // date label
    _detailLabel = [Utility createLabel:[CustomerizedFont heiti:12] color:kDefaultColor];
    _detailLabel.numberOfLines = 0;
    [self.contentView addSubview:_detailLabel];
}

- (void)setData:(id)data
{
    CGFloat cellHeight = kLoanProgressCellHeight;
    
    UIImage * icon = [UIImage imageNamed:data[@"image"]];
    _iconImageView.image = icon;
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker * make) {
        make.left.equalTo(@25);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(@(icon.size.width));
        make.height.equalTo(@(icon.size.height));
    }];
    
    CGFloat lineHeight = cellHeight - icon.size.height;
    
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_iconImageView.mas_centerX);
        make.height.equalTo(@(lineHeight));
        make.top.equalTo(_iconImageView.mas_bottom);
        make.width.equalTo(@2);
    }];
    
    _titleLabel.text = data[@"title"];
    [_titleLabel sizeToFit];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(18);
        make.centerY.equalTo(_iconImageView.mas_centerY);
    }];
    
    NSString * detail = data[@"detail"];
    CGSize detailSize = [detail boundingRectWithSize:CGSizeMake(kScreenWidth - 68 - 25, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [CustomerizedFont heiti:12]} context:nil].size;
    _detailLabel.text = detail;
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.top.equalTo(_titleLabel.mas_bottom).offset(5);
        make.width.equalTo(@(detailSize.width));
    }];
    
    if (data[@"attributeText"]) {
        [_detailLabel addAttributes:@{NSForegroundColorAttributeName : HexRGB(kMainColor)} forString:data[@"attributeText"]];
    }
    
    if ([data[@"addAttribute"] boolValue]) {
        [_titleLabel addAttributes:@{NSForegroundColorAttributeName : HexRGB(kMainColor)} forString:_titleLabel.text];
        NSInteger detailLength = _detailLabel.text.length;
        NSString * telephone = @"400-999-9980";
        NSInteger telLength = telephone.length;
        if (detailLength >= telLength) {
            NSRange telRange = [_detailLabel.text rangeOfString:telephone];
            if (telRange.length > 0 && telRange.location + telRange.length == detailLength) {
                NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:_detailLabel.text];
                [attributedString addAttributes:@{NSForegroundColorAttributeName : HexRGB(kMainColor)} range:NSMakeRange(0, telRange.location)];
                [attributedString addAttributes:@{NSForegroundColorAttributeName : HexRGB(0x6bbfff), NSUnderlineStyleAttributeName : @1} range:telRange];
                _detailLabel.attributedText = attributedString;
                _detailLabel.userInteractionEnabled = YES;
                [_detailLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callServicePhone:)]];
            }
        }
    }
}

#pragma mark 拨打客服电话
- (void)callServicePhone:(UILabel *)sender
{
    // 拨打客服电话
    //    NSString * url = [NSString stringWithFormat:@"tel://%@",phoneNo];//这种方式会直接拨打电话
    NSString * url =[NSString stringWithFormat:@"telprompt://%@", @"400-999-9980"];//这种方式会提示用户确认是否拨打电话
    [self openUrl:url];
}

- (void)openUrl:(NSString *)urlStr{
    //注意url中包含协议名称，iOS根据协议确定调用哪个应用，例如发送邮件是“sms://”其中“//”可以省略写成“sms:”(其他协议也是如此)
    NSURL *url = [NSURL URLWithString:urlStr];
    UIApplication * application = [UIApplication sharedApplication];
    if(![application canOpenURL:url]){
        NSLog(@"无法打开\"%@\"，请确保此应用已经正确安装.",url);
        return;
    }
    [[UIApplication sharedApplication] openURL:url];
}

- (void)setHiddenBottomLine:(BOOL)hiddenBottomLine
{
    _hiddenBottomLine = hiddenBottomLine;
    _bottomLineView.hidden = hiddenBottomLine;
}

@end
