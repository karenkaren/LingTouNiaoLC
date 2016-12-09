//
//  LTNDiscoverViewController.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/9/21.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNDiscoverViewController.h"
#import "LTNMutualDetailController.h"
#import "LTNArrangeDetailController.h"

@interface LTNDiscoverViewController ()

@end

@implementation LTNDiscoverViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self pullReload];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = locationString(@"tab_discover");
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"众筹计划";
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"互助计划";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
    
        LTNArrangeDetailController *arrDetail = [[LTNArrangeDetailController alloc]init];
        arrDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:arrDetail animated:YES];
        
    }else if (indexPath.row == 1){
        
        LTNMutualDetailController *mutDetail = [[LTNMutualDetailController alloc]init];
        mutDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mutDetail animated:YES];
    }
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
