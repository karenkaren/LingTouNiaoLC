//
//  LTNBaseOfflineController.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/2/22.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNBaseOfflineController.h"
#import "LTNOfflineTitleCell.h"
#import "LTNOfflineInvestTableCell.h"

#define kContentIdentifier @"ContentCell"
#define KTitleIdentifier @"TitleCell"

@interface LTNBaseOfflineController ()

@property (nonatomic) BOOL loadSucceeds;

@end

@implementation LTNBaseOfflineController

- (void)viewDidLoad {
    self.isTableViewStyleGrouped = YES;
    [super viewDidLoad];
    
    [self.tableView registerClass:[LTNOfflineInvestTableCell class] forCellReuseIdentifier:kContentIdentifier];
    [self.tableView registerClass:[LTNOfflineTitleCell class] forCellReuseIdentifier:KTitleIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = DEVIDE_LINE_COLOR;
    self.tableView.sectionFooterHeight = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.loadSucceeds) {
        [self pullReload];
    }
}

- (void)refreshIfNeeded {
    if (!self.loadSucceeds) {
        [self pullReload];
    }
}

- (void)getServiceData:(BOOL)isGetMore {
    [super getServiceData:isGetMore];
    
    NSDictionary *dict = @{@"orderType":self.status};
    [self apiForPath:kFindOfflineOrder method:kGetMethod parameter:dict responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        [self.data addObjectsFromArray:[data valueForKey:@"offlineOrderList"]];
        if (!error || self.data.count) {
            self.loadSucceeds = YES;
        } else {
            self.loadSucceeds = NO;
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:KTitleIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary * dic = self.data[indexPath.section];
        cell.textLabel.text = dic[@"product_name"];
    } else {
        LTNOfflineInvestTableCell *contentCell = [tableView dequeueReusableCellWithIdentifier:kContentIdentifier];
        contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        contentCell.data = self.data[indexPath.section];
        cell = contentCell;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //2, one for header, the other for content
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 48.0;
    }
    return 136;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.0;
}

@end
