//
//  LTNHotActivityCell.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/9/23.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNHotActivityCell.h"
#import "UIImageView+WebCache.h"

@implementation LTNHotActivityCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self configUI];
        
    }
    return self;
}

-(void)configUI{
    
    self.imgView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.imgView];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@((kScreenWidth - DimensionBaseIphone6(350))/2));
        make.top.equalTo(@0);
        make.width.equalTo(@(DimensionBaseIphone6(350)));
        make.height.equalTo(@185);
    }];
    
//    UIView *view =[[UIView alloc]init];
//    view.backgroundColor = [UIColor whiteColor];
//    [self.contentView addSubview:view];
    
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@0);
//        make.top.equalTo(self.imgView.mas_bottom).offset(5);
//        make.width.equalTo(@(kScreenWidth));
//        make.height.equalTo(@5);
//
//    }];
    
}

-(void)setBanner:(LTNBanner *)banner{
    _banner = banner;
    
    NSString *urlString = banner.bannerPicture;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"placeholder_banner"] options:SDWebImageRetryFailed];
    
    //self.imgView.image =[UIImage imageNamed:banner.bannerPicture];
   
    
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
