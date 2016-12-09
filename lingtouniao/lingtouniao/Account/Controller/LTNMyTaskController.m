//
//  LTNMyTaskController.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/4/27.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNMyTaskController.h"
#import "LTNMyTaskModel.h"
#import "LTNMyTaskCell.h"
#import "LTNNewZoneController.h"

#define kMyTaskCell @"MyTaskCell"

@interface LTNMyTaskController ()

@property (nonatomic, assign) BOOL showXSRW;

@property (nonatomic) NSString *jjData;
@property (nonatomic) NSString *xsData;

@end

@implementation LTNMyTaskController

- (void)back{
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = locationString(@"tab_new_account_wdrw");
    [self pullReload];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, DimensionBaseIphone6(215))];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:headView.frame];
    imageV.image = [UIImage imageNamed:@"icon_taskBg"];
    [headView addSubview:imageV];
    self.tableView.tableHeaderView = headView;
    [self.tableView registerClass:[LTNMyTaskCell class] forCellReuseIdentifier:kMyTaskCell];
    [self loadData:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:kNewHandTaskChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:kCompleteNewHandTask object:nil];
}

- (void)refreshUI
{
    [self pullReload];
}

- (void)loadData:(id)data
{
    self.jjData = data ? [NSString stringWithFormat:@"%ld/%ld", [data[@"jjrwNum"][@"now"] integerValue], [data[@"jjrwNum"][@"all"] integerValue]] : @"0/0";
    self.xsData = data ? [NSString stringWithFormat:@"%ld/%ld", [data[@"sjrwNum"][@"now"] integerValue], [data[@"sjrwNum"][@"all"] integerValue]] : @"0/0";
    
    NSArray * xsArray = @[@{@"icon" : @"icon_xs",
                             @"title" : locationString(@"new_region_title"),
                             @"detail" : locationString(@"new_region_title_content"),
                             @"sel" : @"newHandArea",
                             @"taskPro" : data ? [NSString stringWithFormat:@"%ld/%ld", [data[@"xsrwNum"][@"now"] integerValue], [data[@"xsrwNum"][@"all"] integerValue]] : @"0/0"}];
    
    NSArray * datas = @[@[@{@"icon" : @"icon_jjrw",
                          @"title" : locationString(@"task_jinjie"),
                          @"detail" : locationString(@"task_jinjie_content"),
                          @"sel" : @"stageArea",
                          @"taskPro" : self.jjData}],
                        @[@{@"icon" : @"icon_xsrw",
                          @"title" : locationString(@"task_xianshi"),
                          @"detail" : locationString(@"task_xianshi_content"),
                          @"sel" : @"limitTimeArea",
                          @"taskPro" : self.xsData}]];
    if (self.showXSRW) {
        [self.data addObject:xsArray];
    }
    [self.data addObjectsFromArray:datas];
}

-(void)getServiceData:(BOOL)isGetMore{
    
    [super getServiceData:isGetMore];

    kWeakSelf
    [self apiForPath:kTaskNum method:kGetMethod parameter:nil responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        if (!error) {
            weakSelf.showXSRW = [data[@"isShowXSRW"] isEqualToString:@"SHOW"] ? YES : NO;
            [weakSelf loadData:data];
            
        }
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.data.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data[section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 8;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    LTNMyTaskCell * cell = [tableView dequeueReusableCellWithIdentifier:kMyTaskCell forIndexPath:indexPath];

    cell.imgV.image = [UIImage imageNamed:self.data[indexPath.section][indexPath.row][@"icon"]];
    cell.titleLab.text = self.data[indexPath.section][indexPath.row][@"title"];
    cell.detailLab.text = self.data[indexPath.section][indexPath.row][@"detail"];
    NSString * taskPro = self.data[indexPath.section][indexPath.row][@"taskPro"];

    cell.taskProgressLab.text = taskPro;
    CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    CGSize labSize =[cell.taskProgressLab.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [CustomerizedFont heiti:11]} context:nil].size;
    cell.taskProgressLab.frame = CGRectMake(cell.titleLab.right + 2, 28, labSize.width + 10, labSize.height);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = self.data[indexPath.section][indexPath.row];
    NSString *selName = dic[@"sel"];
    SEL action = NSSelectorFromString(selName);
    if ([self respondsToSelector:action]) {
        [self performSelector:action withObject:nil afterDelay:0];
    }
}

#pragma mark 新手任务
-(void)newHandArea{
    LTNNewZoneController * newZone = [[LTNNewZoneController alloc]init];
    newZone.navigationTitle = locationString(@"new_region_title");
    newZone.groupName = @"XSRW";
    newZone.showHeader = YES;
    [self.navigationController pushViewController:newZone animated:YES];
}

#pragma mark 进阶任务
-(void)stageArea{
//    if ([self.jjData isEqualToString:@"0/0"]) {
//        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"此任务暂未开放，敬请期待" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [aler show];
//        return;
//    }
    LTNNewZoneController * newZone = [[LTNNewZoneController alloc]init];
    newZone.navigationTitle = locationString(@"task_jinjie");
    newZone.groupName = @"JJRW";
    [self.navigationController pushViewController:newZone animated:YES];
}

#pragma mark 限时任务
-(void)limitTimeArea{
//    if ([self.xsData isEqualToString:@"0/0"]) {
//        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"此任务暂未开放，敬请期待" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [aler show];
//        return;
//    }

    LTNNewZoneController * newZone = [[LTNNewZoneController alloc]init];
    newZone.navigationTitle = locationString(@"task_xianshi");
    newZone.groupName = @"SJRW";
    [self.navigationController pushViewController:newZone animated:YES];
}

@end
