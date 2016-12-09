//
//  LoanListViewController.m
//  lingtouniao
//
//  Created by zhangtongke on 16/3/29.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LoanListViewController.h"
#import "LoanListCell.h"
#import "ProductSectionHeader.h"
#import "LoanFillFormViewController.h"
@interface LoanListViewController ()
@property (nonatomic,strong)NSMutableArray *loanArray;

@end

@implementation LoanListViewController

- (void)back{
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    self.isTableViewStyleGrouped = YES;
    self.hideRefreshHeader = YES;
    [super viewDidLoad];
    self.title = locationString(@"loan_title");
    [self.tableView registerClass:[LoanListCell class] forCellReuseIdentifier:@"LoanListCell"];
    
    
    // Do any additional setup after loading the view.
}

-(NSMutableArray *)loanArray{
    if(!_loanArray){
        _loanArray=[NSMutableArray array];
    }
    return _loanArray;
}


- (void)getServiceData:(BOOL)isGetMore {
    [super getServiceData:isGetMore];
    //kWeakSelf
    [self apiForPath:kLoanShow method:kPostMethod parameter:nil responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        if (!error) {
            if(data&&data[@"loanTypes"]&&isArray(data[@"loanTypes"])){
                [self.data addObjectsFromArray:data[@"loanTypes"]];
                [self loadTableViewWithData:data];
            }
            
        }
    }];
}

-(void)loadTableViewWithData:(NSDictionary *)dic{
    if(isDictionary(dic)){
        if([self.loanArray count]>0){
            [self.loanArray removeAllObjects];
        }
        NSArray *listArray=dic[@"loanTypes"];
        for(int i=0;i<[listArray count];i++){
            NSDictionary * dic =listArray[i];
            if(esBool(dic[@"is_show"]))
                [self.loanArray addObject:dic];
                //[_loanArray addObject:@{@"type":@(i+1),@"content":[NSString stringWithFormat:@"%dloan",i+1]}];
        }
    }
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self pullReload];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.loanArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LoanListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoanListCell"];
    cell.loanDic=self.loanArray[indexPath.section];
    cell.loanBlock=^(NSDictionary *loanDic){
        LoanFillFormViewController *controller= [LoanFillFormViewController loanFillFormViewController:loanDic];
        [self.navigationController pushViewController:controller animated:YES];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if(section==0){
//        if([_loanArray count]>0){
//            if(esInteger(_loanArray[0][@"type"])==1){
//               return 15.0;
//            }else
//                return 30;
//        }
//    }
//    if(section==1){
//        if([_loanArray count]>0){
//            if(esInteger(_loanArray[0][@"type"])==1){
//                return 30.0;
//            }else
//                return 15.0;
//        }
//    }
    
    return 15.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScreenWidth*125/360;//DimensionBaseIphone6(130);
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0f;
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
//    if(section==0){
//        if([_loanArray count]>0){
//            if(esInteger(_loanArray[0][@"type"])==1){
//                return nil;
//            }else{
//                ProductSectionHeader *sectionHeader=[[ProductSectionHeader alloc] init];
//                [sectionHeader setTitle:@"乐巢贷系列"];
//                return sectionHeader;
//
//            }
//            
//        }
//    }
//    if(section==1){
//        if([_loanArray count]>0){
//            if(esInteger(_loanArray[0][@"type"])==1){
//                ProductSectionHeader *sectionHeader=[[ProductSectionHeader alloc] init];
//                [sectionHeader setTitle:@"乐巢贷系列"];
//                
//                return sectionHeader;
//            }else
//                nil;
//        }
//    }
    
    return nil;

    
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
