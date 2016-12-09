//
//  LTNNewZoneCell.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/4/26.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNNewZoneCell.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@implementation LTNNewZoneCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        [self configUI];//布局UI
        
    }
    return self;
}

- (void)configUI{
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [self.contentView addSubview:lineView1];
    
    //竖线
    self.lineImageV = [[UIImageView alloc]initWithFrame:CGRectMake(18, 13, 3, 20)];
    self.lineImageV.image = [UIImage imageNamed:@"icon_shuxian"];
    [self.contentView addSubview:self.lineImageV];
    
    //标题
    self.titleLabel = [Utility createLabel:[CustomerizedFont heiti:18] color:[UIColor colorWithHexString:@"#333333"]];
    self.titleLabel.frame =CGRectMake(self.lineImageV.right + 5, 7.5, kScreenWidth, 30);
    [self.contentView addSubview:self.titleLabel];
    
    //图片
    self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(18, 48, 74, 74)];
    [self.contentView addSubview:self.imageV];
    
    //说明
    self.detailLabel = [Utility createLabel:[CustomerizedFont heiti:14] color:[UIColor colorWithHexString:@"#999999"]];
    self.detailLabel.numberOfLines = 0;
    [self.contentView addSubview:self.detailLabel];
    
    
    //奖励
    self.rewardLabel = [Utility createLabel:[UIFont boldSystemFontOfSize:12] color:[UIColor colorWithHexString:@"#ff3333"]];
    [self.contentView addSubview:self.rewardLabel];
    
    //按钮
    self.actionLab = [Utility createLabel:[CustomerizedFont heiti:15] color:[UIColor whiteColor]];
    self.actionLab.textAlignment = NSTextAlignmentCenter;
    self.actionLab.layer.borderWidth = 1;
    self.actionLab.layer.cornerRadius = 2.5;
    self.actionLab.layer.masksToBounds = YES;
    [self.contentView addSubview:self.actionLab];
    
    // 进度条
    self.progressView = [[UIView alloc] init];
    [self.contentView addSubview:self.progressView];
    self.progressLabel = [Utility createLabel:[CustomerizedFont heiti:11] color:HexRGB(0x0a54b0)];
    [self.progressView addSubview:self.progressLabel];
    
    // 项目进度
    self.barProgress = [[LTNBarProgressView alloc]init];
    self.barProgress.lineColorString = @"#0a54b0";
    [self.progressView addSubview:self.barProgress];
    self.progressView.hidden = YES;
    
    self.lineView2 = [[UIView alloc]init];
    self.lineView2.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [self.contentView addSubview:self.lineView2];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageV.mas_right).offset(10);
        make.top.equalTo(@45);
        make.width.equalTo(@(kScreenWidth - self.imageV.right - 32));
    }];
    [self.rewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailLabel);
        make.height.equalTo(@25);
        make.width.equalTo(@(kScreenWidth));
    }];
    [self.actionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kScreenWidth - 75 - 20));
        make.width.equalTo(@75);
        make.height.equalTo(@30);
    }];
    
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.height.equalTo(@15.5);
        make.width.equalTo(@68.5);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailLabel);
        make.height.equalTo(self.progressLabel);
        make.width.equalTo(self.detailLabel);
    }];
    
    [self.barProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.progressLabel.mas_right);
        make.height.equalTo(@(0.5 * 8));
        make.width.equalTo(self.progressView.mas_width).offset(-68.5);
        make.centerY.equalTo(self.progressView);
    }];
    
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@0.5);
    }];

}

- (void)setZoneModel:(LTNNewZoneModel *)ZoneModel{
    
    _ZoneModel = ZoneModel;
    
    NSURL *imgUrl = [NSURL URLWithString:ZoneModel.taskIcon];
    [self.imageV sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"icon_abounUs"] options:SDWebImageRetryFailed];
    
    self.titleLabel.text = ZoneModel.taskName;
    
    
    if ([ZoneModel.taskGroupId isEqualToString:@"1"]) {
        
        self.detailLabel.text = ZoneModel.taskDesc;
    
    } else {
        
        NSString * desc = [NSString stringWithFormat:@"%@(%@/%@)", ZoneModel.taskDesc, ZoneModel.taskCurrentValue, ZoneModel.taskEndValue];
        self.detailLabel.text = desc;
        self.progressView.hidden = NO;
        double progress = 0;
        if ([ZoneModel.taskEndValue doubleValue] > 0) {
            progress = [ZoneModel.taskCurrentValue doubleValue] / [ZoneModel.taskEndValue doubleValue];
        }
        self.barProgress.progress = progress;
        self.progressLabel.text = [NSString stringWithFormat:locationString(@"task_progress_text"), (NSInteger)(progress * 100)];
        
        
    }
    
    CGSize maxSize = CGSizeMake(kScreenWidth - self.imageV.right - 32, MAXFLOAT);
    CGSize fitSize = [self.detailLabel sizeThatFits:maxSize];
    self.detailLabel.size = fitSize;
    self.rewardLabel.text = [NSString stringWithFormat:locationString(@"advanced_task_award"),ZoneModel.awardDesc];
    [self.rewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLabel.mas_bottom).offset(25);
    }];
    [self.actionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLabel.mas_bottom).offset(20);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.actionLab.mas_top);
    }];
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.actionLab.mas_bottom).offset(15);
    }];
    

    
    [self createTaskStatus];
    
}

-(void)setUpLine:(NSInteger)index withCount:(NSInteger)count{
    if (index == count - 1) {
        self.lineView2.hidden = NO;
    }else{
        self.lineView2.hidden = YES;
    }
}

+ (CGFloat)heightForModel:(LTNNewZoneModel *)zoneModel{
    
    CGFloat height = 45+20+30+15 ;
    
    static UILabel *label;
    if (!label) {
        label = [Utility createLabel:[CustomerizedFont heiti:14] color:[UIColor colorWithHexString:@"#999999"]];
        label.numberOfLines = 0;
    }
    
    
    if ([zoneModel.taskGroupId isEqualToString:@"1"]) {
        label.text = zoneModel.taskDesc;
        
    }else{
        NSString * desc = [NSString stringWithFormat:@"%@(%@/%@)", zoneModel.taskDesc, zoneModel.taskCurrentValue, zoneModel.taskEndValue];
        label.text = desc;
        
    }
   
    //label.text = [NSString stringWithFormat:@"%@(%@/%@)", zoneModel.taskDesc, zoneModel.taskCurrentValue, zoneModel.taskEndValue];
    
    CGSize maxSize = CGSizeMake(kScreenWidth - 124, MAXFLOAT);
    CGSize fitSize = [label sizeThatFits:maxSize];
    
    return ceilf(height + fitSize.height);
    
    
}

- (void)createTaskStatus{
    
    NSString *titleString = nil;
    
    self.actionLab.backgroundColor = HexRGB(0xea5504);
    self.actionLab.layer.borderColor = HexRGB(0xea5504).CGColor;
    
    if ([_ZoneModel.taskUserStatus isEqualToString:@"0"]) {
        
        if ([_ZoneModel.taskGroupId isEqualToString:@"1"]) {
            titleString = locationString(@"new_region_btn2");
        } else {
            titleString = locationString(@"advance_task_doing");
        }
        
        if ([_ZoneModel.skipMode isEqualToString:@"GYWM"]) {
            
            titleString = [[NSUserDefaults standardUserDefaults]valueForKey:@"Reward"];
            if (titleString == NULL) {
                titleString = locationString(@"new_region_btn2");
            }
            
        }
        
    }else if ([_ZoneModel.taskUserStatus isEqualToString:@"1"]){
        titleString = locationString(@"new_region_btn3");
    }else{
        titleString = locationString(@"task_have_award");
        if ([_ZoneModel.skipMode isEqualToString:@"TZ"] || [_ZoneModel.skipMode isEqualToString:@"CZ"]) {
            titleString = locationString(@"new_region_btn4");
        }
        
        self.actionLab.backgroundColor =  HexRGB(0xcccccc);
        self.actionLab.layer.borderColor = HexRGB(0xcccccc).CGColor;
        
    }
    if ([[CurrentUser mine].sessionKey isEqualToString:@""]) {
        titleString = locationString(@"login_immediately");
        
        if ([_ZoneModel.skipMode isEqualToString:@"GYWM"]) {
            
            titleString =[[NSUserDefaults standardUserDefaults]valueForKey:@"Reward"];
            if (titleString == NULL) {
                titleString = locationString(@"new_region_btn2");
            }
            
        }
    }
    
    
    if ([_ZoneModel.taskGroupId isEqualToString:@"3"] || [_ZoneModel.taskGroupId isEqualToString:@"2"]) {
        if (_ZoneModel.isStart == 0) {
            _ZoneModel.taskUserStatus = @"2";
            titleString = locationString(@"task_will_start");
            self.actionLab.backgroundColor =  HexRGB(0xcccccc);
            self.actionLab.layer.borderColor = HexRGB(0xcccccc).CGColor;
            
        }else if (_ZoneModel.isEnd == 1) {
            
            _ZoneModel.taskUserStatus = @"2";
            titleString = locationString(@"task_end");
            
            self.actionLab.backgroundColor =  HexRGB(0xcccccc);
            self.actionLab.layer.borderColor = HexRGB(0xcccccc).CGColor;
        }
    }
    
    self.actionLab.text = titleString;
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
