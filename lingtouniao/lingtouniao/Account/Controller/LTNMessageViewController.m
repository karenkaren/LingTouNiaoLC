//
//  LTNMessageViewController.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/3/14.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//
//{"data":{"messages":[],"total":0,"unRead":0},"resultCode":"0"} type 0 标记全部消息 1 部分消息

//{"data":{"messages":[{"content":"您投资的项目乐巢投20160808_001已经到期，可以在【我的账户】-【我的投资】中查看详情。/n如需其他帮助，可以在【关于我们】-【帮助中心】查找。","createDate":"2016-03-22 18:00:09","createType":"0","id":3,"isRead":"0","shortName":"您有投资的项目已经到期还款到您的可用余额，马上查看收益。","showType":"0","title":"还款通知","type":"0","url":"","userId":12063546},{"content":"您的项目乐巢投20160808_001已经投资成功，预计到期时间YYYY-MM-DD，可以在【我的账户】-【我的投资】中查看详情。/n如需其他帮助，可以在【关于我们】-【帮助中心】查找。","createDate":"2016-03-16 10:30:09","createType":"0","id":4,"isRead":"1","shortName":"您有项目已经投资成功，预计到期时间YYYY-MM-DD。","showType":"0","title":"投资成功","type":"0","url":"","userId":12063546}],"total":5,"unRead":3}}

#import "LTNMessageViewController.h"
#import "LTNMessageViewCell.h"

@interface LTNMessageViewController ()<UIAlertViewDelegate>

@property (nonatomic) NSMutableArray *readedArray;
@property (nonatomic) UIButton *btn;

@end

@implementation LTNMessageViewController

- (void)initUIView{
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f3f5f7"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    self.title = locationString(@"message_center_title");

    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f3f5f7"];
    UIButton *btn = [Utility createButtonWithTitle:locationString(@"message_center_allread") color:HexRGB(0x0090ff) font:[CustomerizedFont heiti:16] block:^(UIButton *btn) {
        if (self.data.count == 0) {
            return ;
        }
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:locationString(@"message_center_dialog_content") message:nil delegate:nil cancelButtonTitle:locationString(@"cancel") otherButtonTitles:locationString(@"btn_confirm"), nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                kWeakSelf
            
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"type":@"0"}];
                
                [BaseDataEngine apiForPath:kMessageRead method:kGetMethod parameter:dic responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
    
                    [weakSelf pullReload];
                    
                }];

            }
        }];

     }];
    self.btn = btn;
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    item.width = -5;
    
    self.navigationItem.rightBarButtonItems = @[item,rightBtn];
    
    _readedArray=[NSMutableArray array];

    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 15, kScreenWidth, 15)];
    footView.backgroundColor = [UIColor colorWithHexString:@"#f3f5f7"];
    self.tableView.tableFooterView = footView;
    [self pullReload];
   
}

-(void)back{
    [self postReadedArray];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshHomePage];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)postReadedArray{
    if([_readedArray count]>0){
        
        __block NSString *readedMessageIds=@"";
        [_readedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LTNMessageModel *messageModel=(LTNMessageModel *)obj;
           
            if([readedMessageIds length]>0)
            readedMessageIds = [readedMessageIds stringByAppendingString:@","];
            readedMessageIds = [readedMessageIds stringByAppendingString:messageModel.ID];
            
            
        }];
    
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"id":readedMessageIds,@"type":@"1"}];
    
        [BaseDataEngine apiForPath:kMessageRead method:kPostMethod parameter:dic responseModelClass:[LTNMessageList class] onComplete:^(id response, id data, NSError *error) {

            [LTNServerHelper retrieveAccountInfoWithFinishBlock:^{
                
            }];
                
            }];
        
    
    }
}

-(void)getServiceData:(BOOL)isGetMore{
    [super getServiceData:isGetMore];
    
    kWeakSelf
    
    [self apiForPath:kMessageList method:kGetMethod parameter:nil responseModelClass:[LTNMessageList class] onComplete:^(id response, id data, NSError *error) {
        if (!error) {
            LTNMessageList *list = (LTNMessageList *)data;
            if ([list isKindOfClass:[LTNMessageList class]]) {
                [weakSelf.data addObjectsFromArray:list.messages];
            }
        }
    }];
   
    [self postReadedArray];
    
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.data.count == 0) {
        [self.btn setTitleColor:[UIColor colorWithHexString:@"#6a6a6a"] forState:UIControlStateNormal];
    }else{
        [self.btn setTitleColor:HexRGB(0x0090ff) forState:UIControlStateNormal];
    }
    return self.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    LTNMessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[LTNMessageViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    LTNMessageModel *model = self.data[indexPath.row];
    
    if ([model.isRead isEqualToString:@"0"]) {
        [_readedArray addObject:model];
    }
    
    // [cell reloadModel:model];
    
    [cell reloadModel:model Index:indexPath.row withCount:self.data.count];
    

    [self postReadedArray];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LTNMessageModel *model = self.data[indexPath.row];
    return [LTNMessageViewCell heightForModel:model];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
