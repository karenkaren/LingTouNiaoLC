//
//  MMBNetAddressSettingViewController.m
//  mmbang
//
//  Created by 杨世昌 on 15/1/6.
//  Copyright (c) 2015年 iyaya. All rights reserved.
//

#import "MMBNetAddressSettingViewController.h"
#import "ServerEnvironmentConstants.h"
#import "BaseWebViewController.h"
#import "JPUSHService.h"

@interface MMBNetAddressSettingViewController()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UITextField *netAddressField;
@property (nonatomic) UITextField *banggoAddressField;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *dataS;


@end

@implementation MMBNetAddressSettingViewController


- (void)viewDidLoad
{
    _dataS = @[@"http://192.168.18.194:8080",@"http://192.168.18.191:29080",@"http://120.55.184.234:8080", @"http://120.55.184.234:8080", @"https://www.lingtouniao.com/v2",@"https://www.lingtouniao.com/v3",@"http://120.55.184.234/v2"];
    [super viewDidLoad];
    [self setCustomTitle:@"设置API"];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:_scrollView];
    
    CGFloat x = 10;
    self.netAddressField = [self createTextField];
    self.netAddressField.tag = 1000;
    self.netAddressField.frame = CGRectMake(x, 20, kScreenWidth-x*2, 35);
    [_scrollView addSubview:self.netAddressField];
    
    self.banggoAddressField = [self createTextField];
    self.banggoAddressField.frame = CGRectMake(x, CGRectGetMaxY(self.netAddressField.frame) + 15, kScreenWidth-x*2, 35);
    self.banggoAddressField.placeholder = [NSString stringWithFormat:@"推送注册id %@",[JPUSHService registrationID]];//临时加的推送id 测试用
    [_scrollView addSubview:self.banggoAddressField];
    
    // footer button
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, CGRectGetMaxY(self.banggoAddressField.frame) + 15, kScreenWidth - x*2, kGeneralHeight)];
    UIImage *image = [Utility createImageFromColor:[UIColor redColor] withSize:button.bounds.size];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    button.titleLabel.font = [CustomerizedFont systemFontOfSize:18.0];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(saveAddress:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:button];


    UILabel *label = [Utility createLabel:[CustomerizedFont heiti:12] color:[UIColor blackColor]];
    label.text = @"网页测试";
    [label sizeToFit];
    label.top = button.bottom + 20;
    label.centerX = self.view.myCenterX;
    UITextField *inputWeb = [[UITextField alloc] init];
    inputWeb.width = kScreenWidth;
    inputWeb.height = 40;
    inputWeb.textColor = [UIColor blackColor];
    inputWeb.layer.borderWidth = 1;
    inputWeb.top = label.bottom + 10;
    inputWeb.delegate = self;
    inputWeb.tag = 1001;
    [_scrollView addSubview:label];
    [_scrollView addSubview:inputWeb];

    // 设置默认值
    self.netAddressField.text = API_BASE_URL;
}

- (void)clearAddress {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kDefaults_NetAddress];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [Utility showMessage:@"清除成功"];
    [self exit];
}

- (UITextField *)createTextField
{
    UITextField *titleField = [[UITextField alloc] initWithFrame:CGRectZero];
    titleField.layer.borderColor = [[UIColor colorWithHex:0xd5d5d5 alpha:1.0] CGColor];
    titleField.layer.cornerRadius = 0;
    titleField.layer.borderWidth = 1.0;
    titleField.delegate = self;
    titleField.backgroundColor = [UIColor colorWithHex:0xf4f4f4 alpha:1.0];
    titleField.textColor = [UIColor colorWithHex:0x4b4b4b alpha:1.0];
    titleField.font = [CustomerizedFont systemFontOfSize:15.0];
    titleField.background = nil;
    titleField.placeholder = @"服务器地址";
    return titleField;
}

#pragma mark - UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField.tag == 1001) {
        BaseWebViewController *webVC = [[BaseWebViewController alloc] initWithURL:textField.text];
        webVC.hasNav = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }

    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 1000) {
        if (!_tableView.window) {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(textField.left, textField.bottom, kScreenWidth, 100)];
            _tableView.dataSource = self;
            _tableView.delegate = self;
            [self.view addSubview:_tableView];
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 1000) {
        [self.tableView removeFromSuperview];
        self.tableView = nil;
    }
}

#pragma mark - 保存
- (void)saveAddress:(UIButton *)button
{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kDefaults_NetAddress];
    NSMutableDictionary *mdic;
    if (dic == nil) {
        mdic = [[NSMutableDictionary alloc] initWithCapacity:0];
    } else {
        mdic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    }
    
    if (!kIS_NILSTR(self.netAddressField.text)) {
        mdic[kDefaults_POST_ADDR] = self.netAddressField.text;
    } else {
        [Utility showMessage:@"WebService 为空"];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:mdic forKey:kDefaults_NetAddress];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.view endEditing:YES];
    [self exit];
}



- (void)exit {

#if (defined(DEBUG) || defined(ADHOC))
    exit(0);
#endif

}

#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataS.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = _dataS[indexPath.row];
    return cell;
}

- (void)tapGestureAction:(UITapGestureRecognizer *)sender
{
    CGPoint p = [sender locationInView:self.tableView];
    if (!CGRectContainsPoint(self.tableView.bounds, p)) {
        [super performSelector:@selector(tapGestureAction:) withObject:sender afterDelay:0];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.netAddressField.text = _dataS[indexPath.row];
    [self.view endEditing:YES];
}

@end
