//
//  LTNMoreController.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/11/11.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNMoreController.h"
//#import "ShareSnsUtil.h"
#import "BaseWebViewController.h"
#import "LTNServerConstant.h"
#import "LTNSystemInfo.h"
#import "LTNFeedbackViewController.h"
#import "MMBNetAddressSettingViewController.h"
#import "WelcomeController.h"

#define kDefaultLogoUrl [NSString stringWithFormat:@"%@%@", API_BASE_URL, @"/logo/logo.png"]

@interface LTNMoreController ()

@property (nonatomic, strong) NSDictionary * moreDictionary;

@end

@implementation LTNMoreController

- (void)viewDidLoad {
    self.hideRefreshHeader = YES;
    self.isTableViewStyleGrouped = YES;
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = HexRGB(0xcccccc);

    self.title = locationString(@"tab_more");

    self.tableView.sectionFooterHeight = 0;
    
    self.data = [@[
                   @[
                       @{
                           @"title" : locationString(@"tab_more_feedback"),
                           @"image" : @"icon_opinion",
                           @"sel" : @"feedback",
                           },
                       @{
                           @"title" : locationString(@"tab_more_score"),
                           @"image" : @"icon_score",
                           @"sel" : @"rating",
                           },
                       ],
                   @[
                       @{
                           @"title" : locationString(@"tab_more_about"),
                           @"image" : @"icon_about_ltn",
                           @"sel" : @"aboutLTN",
                           },
                       @{
                           @"title" : locationString(@"tab_more_welcome"),
                           @"image" : @"icon_welcomePage",
                           @"sel" : @"welcomeLTN",
                           },
                       @{
                           @"title" : locationString(@"tab_more_help"),
                           @"image" : @"icon_help",
                           @"sel"   : @"helpCenter",
                           },
                       @{
                           @"title" : locationString(@"tab_more_phone1"),
                           @"image" : @"icon_phone",
                           @"sel" : @"callServicePhone:",
                           @"detail":@"400-999-9980"
                           },
                       @{
                           @"title" : locationString(@"tab_more_share"),
                           @"image" : @"icon_share",
                           @"sel" : @"shareToFriends",
                           }
                       ],
#if (defined(ADHOC) || defined(DEBUG))
                   @[
                       @{
                           @"title" : @"设置服务器",
                           @"image" : @"icon_about_ltn",
                           @"sel" : @"aboutLTN",
                           },
                       ],
#endif
                   ] mutableCopy];

    CGFloat rate = 400.0 / 1080;
    UIImageView * logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * rate)];
    logoImageView.image = [UIImage imageNamed:@"logo"];
    self.tableView.tableHeaderView = logoImageView;

    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    versionLabel.font = [CustomerizedFont heiti:13.0f];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = HexRGB(0x8a8a8a);
    versionLabel.text = [NSString stringWithFormat:locationString(@"application_version_and_build"), [LTNSystemInfo appVersion], [LTNSystemInfo buildVersion]];
    self.tableView.tableFooterView=versionLabel;
}

#pragma mark - tableview数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 10;
    if (section == 0) {
        height = 0;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * CellIdentifier = NSStringFromClass([self class]);
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = kFont(16);
        cell.textLabel.textColor = HexRGB(0x3a3a3a);
        cell.detailTextLabel.font = kFont(14);
        cell.detailTextLabel.textColor = HexRGB(0x8a8a8a);
    }
    
    NSArray * descriptionArray = self.data[indexPath.section];
    cell.textLabel.text = descriptionArray[indexPath.row][@"title"];
    cell.imageView.image = [UIImage imageNamed:descriptionArray[indexPath.row][@"image"]];
    cell.detailTextLabel.text = descriptionArray[indexPath.row][@"detail"];
    return cell;
}

#pragma mark - tableview代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        MMBNetAddressSettingViewController *vc = [[MMBNetAddressSettingViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    NSDictionary * dic = self.data[indexPath.section][indexPath.row];
    NSString * selName = dic[@"sel"];
    SEL action = NSSelectorFromString(selName);
    if ([self respondsToSelector:action]) {
       [self performSelector:action withObject:dic[@"detail"] afterDelay:0];
    }
}

#pragma mark - 私有方法
#pragma mark 分享给好友
- (void)shareToFriends
{
    [ShareSnsUtils shareSnsOnViewController:self delegate:self];
}

#pragma mark 帮助中心
- (void)helpCenter{
    NSString * urlString =kH5HelpCenter;
    BaseWebViewController *web = [[BaseWebViewController alloc]initWithURL:urlString];
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}
#pragma mark 拨打客服电话
- (void)callServicePhone:(NSString *)phoneNo
{
    // 拨打客服电话
//    NSString * url = [NSString stringWithFormat:@"tel://%@",phoneNo];//这种方式会直接拨打电话
    NSString * url =[NSString stringWithFormat:@"telprompt://%@",phoneNo];//这种方式会提示用户确认是否拨打电话
    [self openUrl:url];
}

#pragma mark 关于领投鸟
- (void)aboutLTN
{
    NSString * urlString = kH5AboutUrl;
    BaseWebViewController * webController = [[BaseWebViewController alloc] initWithURL:urlString];
    webController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webController animated:YES];
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

- (void)feedback {
    kWeakSelf
    [LTNUtilsHelper actionWhenLogin:^(){
        LTNFeedbackViewController *vc = [[LTNFeedbackViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    } onVC:self];
}

- (void)rating {
    NSString *str = kRatingUrl;
    DLog(@"rateApp downloadURL:(%@)",str);
    [Utility openURL:[NSURL URLWithString:str]];
}

- (void)welcomeLTN{
    WelcomeController *welcome = [[WelcomeController alloc]init];
    [welcome setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:welcome animated:YES completion:nil];
    
}

@end
