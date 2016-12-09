//
//  SGSheetMenu.m
//  lingtouniao
//
//  Created by 徐凯 on 15/12/29.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "SGSheetMenu.h"
#import "SGActionView.h"
#import "SGSheetViewCell.h"
#import "ExchangeView.h"
#import <QuartzCore/QuartzCore.h>

//#define kMAX_SHEET_TABLE_HEIGHT   380

@interface SGSheetMenu () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *delegateButton;
@property (nonatomic, strong) UIView *carveview;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *subItems;
@property (nonatomic, strong) NSArray *descItems;
@property (nonatomic, assign) CGRect originFrame;
@property (nonatomic ,assign) BOOL show;

@property (nonatomic, strong) ExchangeView *exchangeView;

@property (nonatomic, strong) void(^actionHandle)(NSInteger);
@end

@implementation SGSheetMenu



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        _selectedItemIndex = NSIntegerMin;
        _items = [NSArray array];
        _subItems = [NSArray array];
        _descItems = [NSArray array];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor grayColor] ;
        
        [self addSubview:_titleLabel];
        
        _delegateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_delegateButton setImage:[UIImage imageNamed:@"layer_close"] forState:UIControlStateNormal];
        [_delegateButton addTarget:self action:@selector(delegateAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_delegateButton];
        
        _carveview = [[UIView alloc]init];
        _carveview.backgroundColor = [UIColor lightGrayColor];
        _carveview.alpha = 0.5;
        [self addSubview:_carveview];
        if (_show) {
            _exchangeView = [[ExchangeView alloc]init];
            [self addSubview:_exchangeView];
        }

        ESWeakSelf
        _exchangeView.handleBlock=^(id obj){
            ESStrongSelf
            NSDictionary *dic=(NSDictionary *)obj;
            NSMutableArray *items=[NSMutableArray arrayWithArray:_self.items];
            NSMutableArray *subItems=[NSMutableArray arrayWithArray:_self.subItems];
            NSMutableArray *descItems=[NSMutableArray arrayWithArray:_self.descItems];
            
            [items insertObject:esString(dic[@"couponName"]) atIndex:0];
            [descItems insertObject:esString(dic[@"desc"]) atIndex:0];
            [subItems insertObject:[NSString stringWithFormat:locationString(@"choose_coupon_title"),esString(dic[@"couponDate"])] atIndex:0];
            
            _self.items=items;
            _self.descItems=descItems;
            _self.subItems=subItems;
            _self.selectedItemIndex=0;
            [_self.tableView reloadData];
            
        };
        
        
        
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.backgroundView = nil;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self addSubview:_tableView];
        
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bottomView];
        
        _iconView.frame = CGRectMake(0, 0, 22, 22);
        
        }
    return self;
}

//-(void)addConpoun:(NSNotification *)notification{
//    NSDictionary *dic=notification.userInfo;
//    
//    
//    if(!isDictionary(dic))
//        return;
//    
//    
//    NSMutableArray *items=[NSMutableArray arrayWithArray:self.items];
//    NSMutableArray *subItems=[NSMutableArray arrayWithArray:self.subItems];
//    NSMutableArray *descItems=[NSMutableArray arrayWithArray:self.descItems];
//    
//    [items insertObject:esString(dic[@"couponName"]) atIndex:0];
//    [descItems insertObject:esString(dic[@"desc"]) atIndex:0];
//    [subItems insertObject:[NSString stringWithFormat:locationString(@"choose_coupon_title"),esString(dic[@"couponDate"])] atIndex:0];
//    
//    self.items=items;
//    self.descItems=descItems;
//    self.subItems=subItems;
//    self.selectedItemIndex=0;
//    [self.tableView reloadData];
//
//}

-(void)delegateAction:(id)sender
{
    [[SGActionView sharedActionView] dismissMenu:self Animated:YES];
    //[self.menus removeObject:menu];

}

- (id)initWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles
{
    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        [self setupWithTitle:title items:itemTitles subItems:nil descTitles:nil];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles subTitles:(NSArray *)subTitles  descTitles:(NSArray *)descTitles isShowExchangeView:(BOOL)show
{
    _show = show;
    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        [self setupWithTitle:title items:itemTitles subItems:subTitles  descTitles:descTitles];
    }
    return self;
}

- (void)setupWithTitle:(NSString *)title items:(NSArray *)items subItems:(NSArray *)subItems  descTitles:(NSArray *)descItems;
{
    _titleLabel.text = title;
    _items = items;
    _subItems = subItems;
    _descItems = descItems;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float height = 0;
    float table_top_margin = 0;
    float table_bottom_margin = 10;
    
    self.titleLabel.frame = (CGRect){CGPointMake(30, 0), CGSizeMake(self.bounds.size.width, 48)};
    self.delegateButton.frame = (CGRect){CGPointMake(kScreenWidth-60, 0), CGSizeMake(40, 48)};
    _carveview.frame = CGRectMake(0, 47, kScreenWidth, 1);
    _exchangeView.frame = CGRectMake(0, 48, kScreenWidth, 74);
    height += self.titleLabel.bounds.size.height+_exchangeView.frame.size.height;
    height += table_top_margin;
    
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
    float contentHeight = self.tableView.contentSize.height;
    float kMAX_SHEET_TABLE_HEIGHT;
    if (kScreenHeight==480) {
        kMAX_SHEET_TABLE_HEIGHT = 290;
    }else if (kScreenHeight==568){
        kMAX_SHEET_TABLE_HEIGHT = 380;
    }else{
        kMAX_SHEET_TABLE_HEIGHT = 400;
    }
    if (contentHeight > kMAX_SHEET_TABLE_HEIGHT) {
        contentHeight = kMAX_SHEET_TABLE_HEIGHT;
        self.tableView.scrollEnabled = YES;
    }else{
        self.tableView.scrollEnabled = NO;
    }
    self.tableView.frame = CGRectMake(self.bounds.size.width * 0.05, height, self.bounds.size.width * 0.9, contentHeight);
    height += self.tableView.bounds.size.height;
    self.bottomView.frame = CGRectMake(0, height, kScreenWidth, table_bottom_margin);
    
    height += table_bottom_margin;
    
    self.bounds = (CGRect){CGPointZero, CGSizeMake(self.bounds.size.width, height)};
}

#pragma mark -

- (void)triggerSelectedAction:(void (^)(NSInteger))actionHandle
{
    self.actionHandle = actionHandle;
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.subItems.count > 0) {
        return 84;
    }else{
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *SGSHEETVIEW_CELL = @"SGSheetViewCell";
    SGSheetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SGSHEETVIEW_CELL];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:SGSHEETVIEW_CELL owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    if (![_items isEqual:[NSNull null]] &&![_descItems isEqual:[NSNull null]] && ![_subItems isEqual:[NSNull null]] ) {
         [cell setTitleLabel:_items[indexPath.row] withDescLabel:_descItems[indexPath.row] withDateLabel:_subItems[indexPath.row]];
    }
    _iconView = [[UIImageView alloc]initWithImage:[UIImage  imageNamed:_selectedItemIndex == indexPath.row ?  @"icon_selected": @"icon_choice"]];
       cell.accessoryView = _iconView;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedItemIndex != indexPath.row) {
        self.selectedItemIndex = indexPath.row;
        NSDictionary *userInfo = @{@"index": @(_selectedItemIndex)};
       [[NSNotificationCenter defaultCenter]postNotificationName:Notification_Select_Coupon object:nil userInfo:userInfo];

        [tableView reloadData];
    }
    if (self.actionHandle) {
        double delayInSeconds = 0.15;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.actionHandle(indexPath.row);
        });
    }
  
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.bottom = kScreenHeight - kbSize.height + 84*MIN(self.items.count, 2);
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.bottom = kScreenHeight;
}

@end
