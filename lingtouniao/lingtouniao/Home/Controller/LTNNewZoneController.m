//
//  LTNNewZoneController.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/4/26.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNNewZoneController.h"
#import "LTNNewZoneCell.h"
#import "LTNNewZoneModel.h"
#import "BaseWebViewController.h"
#import "CustomAlertViews.h"
#import "VerifyRealNameViewController.h"
#import "BoundBankCardViewController.h"
#import "LTNProductDetailController.h"
#import "LTNInvestmentController.h"
#import "CustomAlertView2.h"
#import "TaskCheckModel.h"

@interface LTNNewZoneController ()
{
    UIView *_sheetWindows ;
    LTNNewZoneModel *_model;
    NSString *_prizeString, *_nextSkipString;
    BOOL isShowXS;
    TaskCheckModel * _taskCheck;
    NSArray * _taskArray;
}
@end

@implementation LTNNewZoneController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self pullReload];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.navigationTitle ?  self.navigationTitle : locationString(@"tab_new_account_wdrw");
    if (self.showHeader) {
        UIView *headViwe = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 235)];
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:headViwe.frame];
        imageV.image = [UIImage imageNamed:@"icon_xinshouBg"];
        [headViwe addSubview:imageV];
        
        self.tableView.tableHeaderView = headViwe;
    }
    [self pullReload];
}

- (void)getServiceData:(BOOL)isGetMore{
    [super getServiceData:isGetMore];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"groupName": self.groupName ? self.groupName : @"XSRW"}];
    
    kWeakSelf
    [self apiForPath:kTaskListUrl method:kGetMethod parameter:dic responseModelClass:[LTNNewZoneList class] onComplete:^(id response, id data, NSError *error) {
        if (!error) {
            
            LTNNewZoneList *list = (LTNNewZoneList *)data;
            if ([list isKindOfClass:[LTNNewZoneList class]]) {
                [weakSelf.data addObjectsFromArray:list.taskList];
                _taskArray = [NSArray arrayWithArray:list.taskList];
            }
        }
        
    }];
}

- (void)back
{
    BOOL postNotification = YES;
    if (_taskArray.count) {
        for (LTNNewZoneModel * newZoneModel in _taskArray) {
            if (![newZoneModel.taskUserStatus isEqualToString:@"2"]) {
                postNotification = NO;
                break;
            }
        }
    }
    if (postNotification) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCompleteNewHandTask object:nil];
    }
    if (self.navigationController.visibleViewController == self) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _taskArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"cell";
    LTNNewZoneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[LTNNewZoneCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.ZoneModel = _taskArray[indexPath.row];
    [cell setUpLine:indexPath.row withCount:self.data.count];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   // return 140;
    
    LTNNewZoneModel *model = self.data[indexPath.row];
    return [LTNNewZoneCell heightForModel:model];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LTNNewZoneCell *selectCell = [tableView cellForRowAtIndexPath:indexPath];
    LTNNewZoneModel *model = selectCell.ZoneModel;
    _model = model;
    
    if ([model.taskUserStatus isEqualToString:@"2"]) {
        return;
    }
    
    
    //点击了解我们的row
    if ([self.groupName isEqualToString:@"XSRW"] && [model.skipMode isEqualToString:@"GYWM"]) {
        
        selectCell.actionLab.text = locationString(@"task_award_done");
        
        [[NSUserDefaults standardUserDefaults]setValue:selectCell.actionLab.text forKey:@"Reward"];
       
        _sheetWindows = [CustomAlertViews showAlertViewWithImage:@"icon_rewardBg" title:locationString(@"welcome_lingtouniao") detail:locationString(@"lingtouniao_content") closeButtonImage:@"icon_close2" sureButtonTitle:locationString(@"task_get_award") onViewController:self callBlock:^(MyWindowClicks buttonIndex) {
            if (buttonIndex == 1) {
                _sheetWindows.hidden = YES;
                _sheetWindows = nil;
            }
            if (buttonIndex == 0) {
                _sheetWindows.hidden = YES;
                _sheetWindows = nil;
        
                
                if ([[CurrentUser mine].sessionKey isEqualToString:@""]) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:locationString(@"hint") message:locationString(@"task_should_login_before_get_award") delegate:nil cancelButtonTitle:locationString(@"btn_cancel") otherButtonTitles:locationString(@"login_label_signin"), nil];
                    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                        
                        if (buttonIndex == 1) {
                            
                             [LTNUtilsHelper actionWhenLogin:^(){
                                 
                                 [self pullReload];
                                 isShowXS = [[NSUserDefaults standardUserDefaults]boolForKey:@"FirstData"];
                                 if (isShowXS) {//0是新手 1不是新手
                                     
                                     [[LTNCore globleCore] backToMainController];
                                    
                                 }
                                 
//                                 else if ([model.taskUserStatus isEqualToString:@"0"]) {
//                                     [self increaseNextTask];
//                                 }

                                 
                             
                             } onVC:self];
                            
                        }
                        
                    }];
                }else{
                   
                    [self submitTask];
                }
              
            }
        }];
        
    } else {
        if ([[CurrentUser mine].sessionKey isEqualToString:@""]){
            
            [LTNUtilsHelper actionWhenLogin:^(){
                [self pullReload];
                isShowXS = [[NSUserDefaults standardUserDefaults]boolForKey:@"FirstData"];
                if (isShowXS) {
                    [[LTNCore globleCore] backToMainController];
                }
            } onVC:self];
            return;
        }

        //点击实名的row
        if ([model.skipMode isEqualToString:@"SM"]) {
            
            if ([model.taskUserStatus isEqualToString:@"1"]) {
                
                [self submitTask];
            }
            else{
                
                [LTNCore verifyRealNameViewController:^{
                    [self pullReload];
                }];
                
            }
        }

        //点击绑卡的row
        else if ([model.skipMode isEqualToString:@"BK"]) {
            
            if(![CurrentUser verifyedRealName])
                
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:locationString(@"realname_text") delegate:nil cancelButtonTitle:locationString(@"know") otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            
            if ([model.taskUserStatus isEqualToString:@"1"]) {
                
                [self submitTask];
            }
            else{
                
                [LTNCore boundBankCardViewController:^{
                    [self pullReload];
                }];
            }
            
        }
        
        //点击新手标的row
        else  if ([model.skipMode isEqualToString:@"TZ"]) {
            
            if ([model.taskUserStatus isEqualToString:@"1"]) {
                
                [self submitTask];
            }else{
            
            [[LTNCore globleCore] backToInvestmentListController];
            }
        }
        
        // 点击充值的row
        else if ([model.skipMode isEqualToString:@"CZ"]) {
            if(![CurrentUser verifyedRealName])
                
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:locationString(@"realname_text") delegate:nil cancelButtonTitle:locationString(@"know") otherButtonTitles:nil, nil];
                [alert show];
                return;
            } else if (![CurrentUser bindedBankCard]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:locationString(@"should_bound_bank") delegate:nil cancelButtonTitle:locationString(@"know") otherButtonTitles:nil, nil];
                [alert show];
                return;
            }else if ([model.taskUserStatus isEqualToString:@"1"]) {
                
                [self submitTask];
            }else{
            [LTNCore rechargeViewController:^{
                [self pullReload];
            }];
            }
        }
    }
}

-(void)submitTask{
    [self showWaitingIcon];
    kWeakSelf
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"taskId":_model.ID}];
    //领取奖励接口
    [self apiForPath:kTaskSubmitUrl method:kGetMethod parameter:dic responseModelClass:[TaskCheckModel class] onComplete:^(id response, id data, NSError *error) {
        
        if (!error) {
            [weakSelf.data addObjectsFromArray:_taskArray];
            _taskCheck = (TaskCheckModel *)data;
            _prizeString = _taskCheck.taskPrize.prizeDesc;
            _nextSkipString = _taskCheck.taskPrize.nextSkipModel;
            
            [weakSelf dismissWaitingIcon]; 
            [weakSelf pullReload];
            [weakSelf increaseNextTask];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNewHandTaskChanged object:nil];
        }
        
    }];
    
}

-(void)increaseNextTask{
    
    NSString *string = nil;
    if ([_model.skipMode isEqualToString:@"CZ"] || [_model.skipMode isEqualToString:@"TZ"]) {
        string = locationString(@"complete_toast");
    }else{
        string = locationString(@"next_task");
    }
    _sheetWindows = [CustomAlertView2 showAlertViewWithImage:@"icon_tanchu1" detail:_prizeString canleButtonTitle:@"icon_close1" okButtonTitle:string onViewController:self callBlock:^(MyWindowClick2 buttonIndex) {
        
        if (buttonIndex == 1) {
            _sheetWindows.hidden = YES;
            _sheetWindows = nil;
        }
        if (buttonIndex == 0) {
            _sheetWindows.hidden = YES;
            _sheetWindows = nil;
            if ([_nextSkipString isEqualToString:@"SM"]) {
                
                [LTNCore verifyRealNameViewController:^{
                    [self pullReload];
                }];
            }
            if ([_nextSkipString isEqualToString:@"BK"]) {
                
                [LTNCore boundBankCardViewController:^{
                    [self pullReload];
                }];
            }
            if ([_nextSkipString isEqualToString:@"XSB"]) {
                
                [[LTNCore globleCore] backToInvestmentListController];

            }
            if ([_nextSkipString isEqualToString:@"OTHER"] || [_nextSkipString isEqualToString:@""]) {
                
                
            }
        }
        
    }];
}

- (UIImage *)iconImageWhenDataEmpty{
    return [UIImage imageNamed:@"icon_noTask"];
}

//- (NSString *)tipsMessageWhenDataEmpty{
//    return @"暂无可进行的任务";
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
