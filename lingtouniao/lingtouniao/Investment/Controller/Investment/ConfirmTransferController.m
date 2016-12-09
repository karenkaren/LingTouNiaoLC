//
//  ConfirmTransferController.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/11/15.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "ConfirmTransferController.h"
#import "LTNSuccessView.h"

@interface ConfirmTransferController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _productId;//产品id
    NSString *_productName;//产品名称
    float _netValue;//当前净值
    float _transferPrice;//转让价
    float _rate;//挂牌收益率
    float _poundage;//交易手续费
    double _getAmount;//实际到账金额
}

@property (nonatomic) UITableView *tableView;

@property (nonatomic) NSArray *dataArray;

@property (nonatomic) UIButton *confirmBtn;

@property (nonatomic) UIView *footView;

@end

@implementation ConfirmTransferController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认转让";
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    
    //[self setBtnView];
    
    self.tableView.tableFooterView = [self createFootView];
    
    [self createDataSource];
    
}

-(void)createDataSource{
    
    self.dataArray = [@[
                        @{@"title" : @"产品名称"},
                        @{@"title" : @"当前净值"},
                        @{@"title" : @"转让价"},
                        @{@"title" : @"挂牌收益率"},
                        @{@"title" : @"交易手续费"},
                        @{@"title" : @"实际到账金额"}
                        ] mutableCopy];
    
}

-(id)initTransferProductName:(NSString *)productName ProductId:(NSInteger)productId ProductNetValue:(float)netValue TransferPrice:(float)transferPrice RateOfReturn:(float)rate ProductPoundage:(float)poundage ActuallyGetAmount:(double)getAmount{
    
    if (self = [super init]) {
        _productId = productId;
        _productName = productName;
        _netValue = netValue;
        _transferPrice = transferPrice;
        _rate = rate;
        _poundage = poundage;
        _getAmount = getAmount;
    }
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        cell.textLabel.font = [CustomerizedFont heiti:16];
        cell.detailTextLabel.font = [CustomerizedFont heiti:14];
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.row][@"title"];
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = _productName;
    }
    else if (indexPath.row ==1) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",_netValue];
    }
    else if (indexPath.row ==2) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",_transferPrice];
    }
    else if (indexPath.row ==3) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",_rate];
    }
    else if (indexPath.row ==4) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",_poundage];
    }
    else if (indexPath.row ==5) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",_getAmount];
    }
    
    
    return cell;
}


//-(void)setBtnView{
//
//    self.confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, kScreenHeight - StatusBarHeight - NavigationBarHeight - kScreenWidth * 48 / 320.0, kScreenWidth - 40, 40)];
//    [self.confirmBtn setTitle:@"确认转让" forState:UIControlStateNormal];
//    [self.confirmBtn setBackgroundImage:[UIImage imageNamed:@"confirmButton"] forState:UIControlStateNormal];
//    [self.confirmBtn addTarget:self action:@selector(clickConfirmTransfer) forControlEvents:UIControlEventTouchUpInside];
//    self.confirmBtn.layer.masksToBounds = YES;
//    self.confirmBtn.layer.cornerRadius = 5;
//
//    [self.tableView addSubview:self.confirmBtn];
//
//}

-(UIView *)createFootView{
    self.footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    
    
    self.confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(20,25, kScreenWidth - 40, 40)];
    [self.confirmBtn setTitle:@"确认转让" forState:UIControlStateNormal];
    [self.confirmBtn setBackgroundImage:[UIImage imageNamed:@"confirmButton"] forState:UIControlStateNormal];
    [self.confirmBtn addTarget:self action:@selector(clickConfirmTransfer) forControlEvents:UIControlEventTouchUpInside];
    self.confirmBtn.layer.masksToBounds = YES;
    self.confirmBtn.layer.cornerRadius = 5;
    
    [self.footView addSubview:self.confirmBtn];
    
    return _footView;
}

-(void)clickConfirmTransfer{
    
    NSDictionary *dict = @{@"productId":[NSNumber numberWithInteger:_productId],
                           @"orderAmount":@(_transferPrice),
                           };
    [self apiForPath:kBuyProductConfirmUrl method:kPostMethod parameter:dict responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        if (!error) {
            //需要刷新我的投资页
            // [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"refreshMyInvest"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyInv" object:nil];
            
            TransferSuccessViewController *vc = [[TransferSuccessViewController alloc] init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


//转让成功界面

@implementation TransferSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转让成功";
    [self setupUI];
    
}

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)setupUI{
    LTNSuccessView * successView = [[LTNSuccessView alloc] initWithSuccessTitle:@"转让成功" buttonTitle:@"转让完成" actionBlock:^(UIButton *button) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshAccountInfo];
        [self back];
        
    }];
    [self.view addSubview:successView];
    
}
@end
