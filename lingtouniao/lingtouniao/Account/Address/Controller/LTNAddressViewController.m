//
//  LTNAddressViewController.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/11/3.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNAddressViewController.h"
#import "EditAddressViewController.h"
#import "AddressViewCell.h"

#define kSide 5

@interface LTNAddressViewController ()<AddressInfoCellDelegate>
@property (nonatomic) UIButton *addButton;

@property (nonatomic) LTNAddressModel *addressModel;

@end

@implementation LTNAddressViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self pullReload];
    
}

- (void)viewDidLoad {
    //self.hideRefreshHeader = YES;
    self.isTableViewStyleGrouped = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = locationString(@"managerGetAddress");

    [self.tableView registerClass:[AddressViewCell class] forCellReuseIdentifier:@"addressCell"];
}

-(void)getServiceData:(BOOL)isGetMore{
    [super getServiceData:isGetMore];
    
    [self apiForPath:kGetAddressUrl method:kGetMethod parameter:nil responseModelClass:[LTNAddressModel class] onComplete:^(id response, id data, NSError *error) {
        
        if (!error) {
            
            self.addressModel = (LTNAddressModel *)data;
            
            if (![esString(self.addressModel.ID) isEqualToString:@""]) {
                [self.data addObject:self.addressModel];
            }
            
            [self performSelector:@selector(initFootview) withObject:nil afterDelay:0.1];
            
            [self.tableView reloadData];
        }
        
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressViewCell *cell = [[AddressViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addressCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.model = self.data[indexPath.section];
   
    cell.delegate = self;
    return cell;
}

#pragma mark addressDelete

//删除按钮
-(void)AddressInfoCell:(AddressViewCell *)cell deleteButtonClickedButton:(UIButton *)touchBtn{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:locationString(@"isDeleteAddress") delegate:nil cancelButtonTitle:locationString(@"btn_cancel") otherButtonTitles:locationString(@"btn_confirm"), nil];
    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{@"id" : self.addressModel.ID}];
            [BaseDataEngine apiForPath:kDelteAddressUrl method:kPostMethod parameter:dic responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
                [LTNUtilsHelper boxShowWithMessage:locationString(@"deleteSuccess")];
            }];

            [self.data removeObjectAtIndex:indexPath.section];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView reloadData];
            self.addButton.hidden = NO;
        }
    }];
    
    
}
//编辑按钮
-(void)AddressInfoCell:(AddressViewCell *)cell editButtonClickedButton:(UIButton *)touchBtn{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    EditAddressViewController *edit = [[EditAddressViewController alloc]init];
    LTNAddressModel *model = self.data[indexPath.section];
    edit.addressModel = model;
    edit.isEditAddress = YES;
    [self.navigationController pushViewController:edit animated:YES];
}


-(void)initFootview{
    if (!_addButton) {
        _addButton = [[UIButton alloc]initWithFrame:CGRectMake(4*kSide, kScreenHeight - kGeneralHeight - 4*kSide - 64, kScreenWidth-8*kSide, kGeneralHeight)];
        _addButton.layer.cornerRadius = 5;
        _addButton.layer.masksToBounds = YES;
        [_addButton setTitle:locationString(@"addGoodsAddress") forState:UIControlStateNormal];
        _addButton.backgroundColor = [UIColor colorWithHexString:@"#ea5504"];
        
        [_addButton addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
      
        [self.view addSubview:_addButton];
        
    }
    if (![self.addressModel.ID isEqualToString:@""]) {
        _addButton.hidden = YES;
    }else{
        _addButton.hidden = NO;
        [self.view bringSubviewToFront:_addButton];
    }

    
}

-(void)addAddress{
    EditAddressViewController *edit = [[EditAddressViewController alloc]init];
    [self.navigationController pushViewController:edit animated:YES];
    
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
