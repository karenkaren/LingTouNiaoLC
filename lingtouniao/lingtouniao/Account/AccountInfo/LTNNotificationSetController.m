//
//  LTNNotificationSetController.m
//  lingtouniao
//
//  Created by zhangtongke on 16/2/22.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNNotificationSetController.h"
#import "UIDevice+ESInfo.h"
#import "InsetsLabel.h"

@interface LTNNotificationSetController ()
@property (nonatomic,strong)NSArray *cellArray;

@end

@implementation LTNNotificationSetController

- (void)viewDidLoad {
    self.isTableViewStyleGrouped = YES;
    self.hideRefreshHeader = YES;
    [super viewDidLoad];
    self.title=locationString(@"new_message_notification");
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = HexRGB(0xcccccc);
    // Do any additional setup after loading the view.
    self.cellArray=@[@{@"title":locationString(@"notification_receive_new")}];
}


-(NSString *)pushSetStatus{
    if([UIDevice isAllowedNotification])
        return locationString(@"notification_opened");
    else
        return locationString(@"notification_unopened");
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.cellArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * CellIdentifier = @"AccountInfoCellIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.font = kFont(16);
        cell.textLabel.textColor = HexRGB(0x3a3a3a);
        cell.detailTextLabel.font = kFont(14);
        cell.detailTextLabel.textColor = HexRGB(0x8a8a8a);
    }
    
    NSDictionary *cellDic=self.cellArray[indexPath.section];
    
    cell.textLabel.text=cellDic[@"title"];
    cell.detailTextLabel.text=[self pushSetStatus];
    return cell;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 44;
//}




- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 70;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    InsetsLabel *sectionFooterLabel=[[InsetsLabel alloc] initWithFrame:CGRectMake(0,0,self.view.width,60) andInsets:UIEdgeInsetsMake(3,15,0,15)];
    
    sectionFooterLabel.textAlignment = NSTextAlignmentLeft;
    sectionFooterLabel.textColor=[UIColor grayColor];
    sectionFooterLabel.font=[UIFont systemFontOfSize:13];
    sectionFooterLabel.backgroundColor =[UIColor clearColor];
    sectionFooterLabel.numberOfLines = 0;
    
    
    NSString *labelString= locationString(@"notification_prompt");
    
    CGSize size = [Utility sizeWithText:labelString
                          boundingSize:CGSizeMake(sectionFooterLabel.width-sectionFooterLabel.insets.left*2, CGFLOAT_MAX)
                   font:sectionFooterLabel.font
                              lineBreakMode:NSLineBreakByWordWrapping];
    sectionFooterLabel.height=size.height+12;
    sectionFooterLabel.text=labelString;
    return sectionFooterLabel;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
