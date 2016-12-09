//
//  LTNMutualCell.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/9/21.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNMutualCell.h"
#import "UIImageView+WebCache.h"

@implementation LTNMutualCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    self.iconView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 80)];
    [self.contentView addSubview:self.iconView];
    
    self.titleLab = [Utility createLabel:[CustomerizedFont heiti:14] color:[UIColor colorWithHexString:@"#333333"]];
    self.titleLab.frame = CGRectMake(10, self.iconView.bottom + 5, kScreenWidth/2, 30);
    [self.contentView addSubview:self.titleLab];
    
    self.startMoneyLab = [Utility createLabel:[CustomerizedFont heiti:14] color:[UIColor colorWithHexString:@"#333333"]];
    self.startMoneyLab.frame = CGRectMake(self.titleLab.right, self.iconView.bottom + 5, kScreenWidth/2 -20, 30);
    self.startMoneyLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.startMoneyLab];
    
    self.descLab =[Utility createLabel:[CustomerizedFont heiti:12] color:[UIColor colorWithHexString:@"#999999"]];
    self.descLab.frame = CGRectMake(10, self.startMoneyLab.bottom, 100, 20);
    [self.contentView addSubview:self.descLab];
    
    self.line = [[UIView alloc]init];
    self.line.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [self.contentView addSubview:self.line];
    
    self.detaLab = [Utility createLabel:[CustomerizedFont heiti:12] color:[UIColor colorWithHexString:@"#999999"]];
    [self.contentView addSubview:self.detaLab];
    
    self.joinLab = [Utility createLabel:[CustomerizedFont heiti:12] color:[UIColor blueColor]];
    self.joinLab.frame = CGRectMake(kScreenWidth - 70, self.titleLab.bottom, 60, 20);
    self.joinLab.text = @"立即加入>";
    self.joinLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.joinLab];
    
}

-(void)setMutualModel:(LTNMutualModel *)mutualModel{
    _mutualModel = mutualModel;
    
    NSURL *imgUrl = [NSURL URLWithString:mutualModel.mutualIcon];
    [self.iconView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"header_homepage"] options:SDWebImageRetryFailed];
    
    self.titleLab.text = mutualModel.taskDesc;
    
    self.startMoneyLab.text = [NSString stringWithFormat:@"%@元起",mutualModel.taskEndValue];
    [self.startMoneyLab addAttributes:@{NSForegroundColorAttributeName : HexRGB(0xea5504)} forString:mutualModel.taskEndValue];
    
    NSString *decString = @"绝症保障10万保额";
    CGSize descSize = [self sizeWithText:decString maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:12];
    self.descLab.text = decString;
    self.descLab.frame = CGRectMake(10, self.titleLab.bottom, descSize.width, 20);
    
    self.line.frame = CGRectMake(self.descLab.right + 5, self.titleLab.bottom +3, 0.5, 14);
    
    self.detaLab.frame = CGRectMake(self.line.right + 5, self.titleLab.bottom, kScreenWidth - self.line.right - 70, 20);
    self.detaLab.text = @"确认全赔";
    
}
//计算文字的大小
- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize
{
    
    CGSize nameSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return nameSize;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
