//
//  MethodSecondViewController.m
//  lingtouniao
//
//  Created by 徐凯 on 16/3/29.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "MethodSecondViewController.h"
#import "MethodSecondCell.h"

@interface MethodSecondViewController ()


@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *waitClickButton;//再看看

@end

@implementation MethodSecondViewController

- (void)viewDidLoad {
    self.hideRefreshHeader = YES;
    [super viewDidLoad];
    [self initWaitButton];
}

- (void)initUIView
{
   self.title = locationString(@"way_2");
}

- (void)initWaitButton
{
    _tableView.showsVerticalScrollIndicator = NO;
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 130)];
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButton"] forState:UIControlStateNormal];
    [confirmButton setTitle:locationString(@"sure_way2") forState:UIControlStateNormal];
    UIButton *waitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [waitButton setTitle:locationString(@"see_again") forState:UIControlStateNormal];
    [waitButton setTitleColor:[UIColor colorWithHexString:@"EA5504"] forState:UIControlStateNormal];
    waitButton.layer.borderWidth = 2;
    waitButton.layer.borderColor = [UIColor colorWithHexString:@"EA5504"].CGColor;
    waitButton.layer.cornerRadius = 3.0;
    
    [footerView addSubview:confirmButton];
    [footerView addSubview:waitButton];
    
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView).offset(15);
        make.left.equalTo(footerView).offset(20);
        make.right.equalTo(footerView).offset(-20);
        make.height.mas_equalTo(@44);
    }];
    
    [waitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(confirmButton.mas_bottom).offset(15);
        make.left.equalTo(footerView).offset(20);
        make.right.equalTo(footerView).offset(-20);
        make.height.mas_equalTo(@44);

    }];
    
    _tableView.tableFooterView = footerView;
    
    
   

}

#pragma mark - tableViewDalegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *METHOD_SECOND_CELL = @"MethodSecondCell";
    
    MethodSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:METHOD_SECOND_CELL];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:METHOD_SECOND_CELL owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str =locationString(@"detail_way");
    CGSize size = CGSizeMake(kScreenWidth - 20 * 2, 1000);
    CGSize retSize = [self boundingRectWithText:str maxSize:size font:[UIFont systemFontOfSize:14.0]];
    return   80 + 112 + retSize.height;;
    
}
/**
 *  确认选择方式二
 *
 *  @param sender <#sender description#>
 */
- (IBAction)confirmClick:(id)sender {
}
/**
 *  再看看
 *
 *  @param sender <#sender description#>
 */
- (IBAction)waitClick:(id)sender {
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
