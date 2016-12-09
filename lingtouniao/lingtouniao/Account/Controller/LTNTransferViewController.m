//
//  LTNTransferViewController.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/11/15.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNTransferViewController.h"

#import "ConfirmTransferController.h"

@interface LTNTransferViewController ()<UITextFieldDelegate>

@property (nonatomic) UIView *footView;
@property (nonatomic) UIButton *nextBtn,*addBtn,*deleteBtn;
@property (nonatomic) UILabel *numCountLab,*percentLab;
@property (nonatomic) UILabel *routineLab,*rateLab,*priceLab;
@property (nonatomic) UILabel *actuallyLab,*detailLab;

@property (nonatomic) UITextField *transferTextField;////////////////////////
@property (nonatomic) BOOL isHaveDecimalPoint;


@property (nonatomic) UIView *backView1,*backView2,*backView3;

@property (nonatomic) NSString *rate;//挂牌收益率
@property (nonatomic) NSString *actuallyPrice;//实际到账金额
@property (nonatomic) NSString *actuallyRate;//实际收益率

@end

@implementation LTNTransferViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    kWeakSelf;
    //    [BaseDataEngine apiForPath:kUserAccountSpiltUrl method:kGetMethod parameter:nil responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
    //        if (!error) {
    //            weakSelf.actuallyPrice = [NSString stringWithFormat:@"%.2f",[data[@"myOrder"] floatValue]];
    //        }
    //        [self createDataSource];
    //    }];
    
    //    [self pullReload];
    
}

- (void)viewDidLoad {
    self.isTableViewStyleGrouped = YES;
    [super viewDidLoad];
    
    self.title = @"申请转让";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor =[UIColor colorWithHexString:@"#e2e2e2"];
    
    self.tableView.tableFooterView = [self createFootView];
    
    [self createDataSource];
    [self pullReload];
    
}

-(void)createDataSource{
    
    //    self.data =[@[
    //                  @{@"title" : @"产品名称"},
    //                  @{@"title" : @"可转让本金"},
    //                  @{@"title" : @"当前净值"},
    //                  @{@"title" : @"挂牌收益率"},
    //                  @{@"title" : @"挂牌交易价"},
    //                  @{@"title" : @"交易手续费"},
    //                  @{@"title" : @"实际到账金额"},
    //                  @{@"title" : @"持有期实际收益率"}
    //                  ] mutableCopy];
    
    self.data =[@[
                  @{@"title" : @"产品名称"},
                  @{@"title" : @"可转让本金"},
                  @{@"title" : @"当前净值"},
                  @{@"title" : @"转让价"},
                  @{@"title" : @"挂牌收益率"},
                  @{@"title" : @"交易手续费"},
                  @{@"title" : @"实际到账金额"},
                  @{@"title" : @"持有期实际收益率"}
                  ] mutableCopy];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(void)getServiceData:(BOOL)isGetMore{
    [super getServiceData:isGetMore];
    
    [self apiForPath:kUserAccountSpiltUrl method:kGetMethod parameter:nil responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        if (!error) {
            self.rate = [NSString stringWithFormat:@"%.2f",[data[@"myCoupons"] floatValue]];
            self.actuallyPrice = [NSString stringWithFormat:@"%.2f",[data[@"myOrder"] floatValue]];
            self.actuallyRate = [NSString stringWithFormat:@"%.2f",[data[@"myTask"] floatValue]];
        }
        [self createDataSource];
    }];
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        cell.textLabel.font = [CustomerizedFont heiti:16];
        cell.detailTextLabel.font = [CustomerizedFont heiti:14];
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.textLabel.text = self.data[indexPath.row][@"title"];
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = self.transferTitle;
    }
    if (indexPath.row == 1){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",self.transferoOrderAmount];
    }
    if (indexPath.row == 2){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",self.transferoOrderAmount];
    }
    //    if (indexPath.row == 3){
    //
    //        _backView1 = [[UIView alloc]initWithFrame:CGRectMake(100, 0, kScreenWidth -100, 48)];
    //        [cell.contentView addSubview:self.backView1];
    //
    //        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        self.deleteBtn.frame = CGRectMake(kScreenWidth - 100 -87, 10, 20, 28);
    //        [self.deleteBtn setImage:[UIImage imageNamed:@"icon_deletes"] forState:UIControlStateNormal];
    //        [self.deleteBtn addTarget:self action:@selector(deleteBtnAction) forControlEvents:UIControlEventTouchUpInside];
    //        [self.backView1 addSubview:self.deleteBtn];
    //
    //        self.numCountLab = [[UILabel alloc]initWithFrame:CGRectMake(self.deleteBtn.right, 0, 20, 48)];
    //        self.numCountLab.textAlignment = NSTextAlignmentCenter;
    //        self.numCountLab.font = [CustomerizedFont heiti:14];
    //        self.numCountLab.text = @"5";
    //        [self.backView1 addSubview:self.numCountLab];
    //
    //        self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        self.addBtn.frame = CGRectMake(self.numCountLab.right, 10, 20, 28);
    //        [self.addBtn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    //        [self.addBtn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
    //        [self.backView1 addSubview:self.addBtn];
    //
    //        self.percentLab = [[UILabel alloc]initWithFrame:CGRectMake(self.addBtn.right, 0, 15, 48)];
    //        self.percentLab.text = @"%";
    //        self.percentLab.font = [CustomerizedFont heiti:14];
    //        self.percentLab.textAlignment = NSTextAlignmentCenter;
    //        self.percentLab.textColor = [UIColor colorWithHexString:@"#999999"];
    //        [self.backView1 addSubview:self.percentLab];
    //
    //    }
    //    if (indexPath.row == 4){
    //        cell.detailTextLabel.text = @"9991.70";
    //    }
    
    if (indexPath.row == 3) {
        
        
        _backView1 = [[UIView alloc]initWithFrame:CGRectMake(100, 0, kScreenWidth -100, 48)];
        
        [cell.contentView addSubview:self.backView1];
        
        UIImage *img = [UIImage imageNamed:@"icon_add"];
        self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addBtn.frame = CGRectMake(kScreenWidth -100- 20 - 10, 10, 20, 28);
        [self.addBtn setImage:img forState:UIControlStateNormal];
        [self.addBtn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
        self.addBtn.enabled = NO;
        [self.backView1 addSubview:self.addBtn];
        
        NSString *string =[NSString stringWithFormat:@"%.2f",self.transferoOrderAmount];
        CGSize incomeSize = [self sizeWithText:string maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:14];
        
        //        self.numCountLab = [[UILabel alloc]initWithFrame:CGRectMake(self.addBtn.left - incomeSize.width, 0, incomeSize.width, 48)];
        //        self.numCountLab.textAlignment = NSTextAlignmentCenter;
        //        self.numCountLab.font = [CustomerizedFont heiti:14];
        //        self.numCountLab.text = string;
        //        [self.backView1 addSubview:self.numCountLab];
        
        self.transferTextField = [[UITextField alloc]initWithFrame:CGRectMake(self.addBtn.left - incomeSize.width-5, 0, incomeSize.width, 48)];
        self.transferTextField.text = string;
        self.transferTextField.textAlignment = NSTextAlignmentCenter;
        self.transferTextField.font = [CustomerizedFont heiti:14];
        self.transferTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.transferTextField.delegate = self;
        // self.transferTextField.clearsOnBeginEditing = YES; //再次编辑就清空
        self.transferTextField.adjustsFontSizeToFitWidth = YES;
        [self.transferTextField addTarget:self action:@selector(changeTransferText:) forControlEvents:UIControlEventEditingDidEnd];
        [self.backView1 addSubview:self.transferTextField];
        
        
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteBtn.frame = CGRectMake(self.transferTextField.left - 25, 10, 20, 28);
        [self.deleteBtn setImage:[UIImage imageNamed:@"icon_deletes"] forState:UIControlStateNormal];
        [self.deleteBtn addTarget:self action:@selector(deleteBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.backView1 addSubview:self.deleteBtn];
        
    }
    
    if (indexPath.row == 4){
        
        cell.detailTextLabel.text = self.rate;
        
    }
    
    
    
    //    if (indexPath.row == 5){
    //
    //        _backView2 = [[UIView alloc]initWithFrame:CGRectMake(100, 0, kScreenWidth -100, 48)];
    //        [cell.contentView addSubview:self.backView2];
    //
    //        self.routineLab = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 132 - 100, 10, 120, 28)];
    //        self.routineLab.text = @"15.00";
    //        self.routineLab.textColor = [UIColor colorWithHexString:@"#999999"];
    //        self.routineLab.textAlignment = NSTextAlignmentRight;
    //        self.routineLab.font = [CustomerizedFont heiti:14];
    //        [self.backView2 addSubview:self.routineLab];
    //
    //        self.rateLab = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 132 - 100, self.routineLab.bottom - 5, 120, 10)];
    //        //        self.rateLab.text = @"当月利息*10%";
    //
    //        self.rateLab.text = [NSString stringWithFormat:@"当月利息*%@%@",self.numCountLab.text,@"%"];
    //        self.rateLab.textColor = [UIColor  colorWithHexString:@"#ea5504"];
    //        self.rateLab.textAlignment = NSTextAlignmentRight;
    //        self.rateLab.font = [CustomerizedFont heiti:10];
    //        [self.backView2 addSubview:self.rateLab];
    //
    //    }
    
    if (indexPath.row == 5){
        
        _backView2 = [[UIView alloc]initWithFrame:CGRectMake(100, 0, kScreenWidth -100, 48)];
        [cell.contentView addSubview:self.backView2];
        
        self.routineLab = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 100 - 60, 10, 45, 28)];
        self.routineLab.text = @"0.00";//（当前净值－本金）／10；
        self.routineLab.textColor = [UIColor colorWithHexString:@"#999999"];
        self.routineLab.textAlignment = NSTextAlignmentRight;
        self.routineLab.font = [CustomerizedFont heiti:14];
        [self.backView2 addSubview:self.routineLab];
        
        self.priceLab = [[UILabel alloc]initWithFrame:CGRectMake(self.routineLab.left - 30, 10, 60, 28)];
        NSString *priceString =@"12.00";
        // self.priceLab.text = priceString;
        NSAttributedString *st  = [[NSAttributedString alloc]initWithString:priceString attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSStrikethroughColorAttributeName:[UIColor colorWithHexString:@"#ea5504"]}];
        self.priceLab.attributedText = st;
        self.priceLab.textColor = [UIColor colorWithHexString:@"#ea5504"];
        self.priceLab.textAlignment = NSTextAlignmentLeft;
        self.priceLab.font = [CustomerizedFont heiti:14];
        [self.backView2 addSubview:self.priceLab];
        
        
        self.rateLab = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 132 - 100, self.routineLab.bottom - 5, 120, 10)];
        //        self.rateLab.text = @"当月利息*10%";
        
        //        self.rateLab.text = [NSString stringWithFormat:@"当月利息*%@%@",self.numCountLab.text,@"%"];
        self.rateLab.text = @"活动期间免手续费";
        self.rateLab.textColor = [UIColor  colorWithHexString:@"#ea5504"];
        self.rateLab.textAlignment = NSTextAlignmentRight;
        self.rateLab.font = [CustomerizedFont heiti:10];
        [self.backView2 addSubview:self.rateLab];
        
        
        //        if ([self.rate floatValue] >2.00) {
        //            self.rateLab.hidden = YES;
        //            self.priceLab.hidden =YES;
        //            self.routineLab.text = self.rate;
        //
        //        }
        
    }
    
    
    if (indexPath.row == 6){
        
        _backView3 = [[UIView alloc]initWithFrame:CGRectMake(100, 0, kScreenWidth -100, 48)];
        [cell.contentView addSubview:self.backView3];
        
        self.actuallyLab = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 132 - 100, 10, 120, 28)];
        //        self.actuallyLab.text = self.actuallyPrice;
        
        NSString *resu1 = self.transferTextField.text;
        NSString *resu2 = self.routineLab.text;
        CGFloat result = [resu1 floatValue] - [resu2 floatValue];
        self.actuallyLab.text =[NSString stringWithFormat:@"%.2f",result];//转让价－交易手续费
        
        self.actuallyLab.textColor = [UIColor colorWithHexString:@"#999999"];
        self.actuallyLab.textAlignment = NSTextAlignmentRight;
        self.actuallyLab.font = [CustomerizedFont heiti:14];
        [self.backView3 addSubview:self.actuallyLab];
        
        self.detailLab = [[UILabel alloc]initWithFrame:CGRectMake(0, self.routineLab.bottom - 5, kScreenWidth - 100-12, 10)];
        self.detailLab.text = @"交易价-交易手续费";
        self.detailLab.textColor = [UIColor colorWithHexString:@"#ea5504"];
        self.detailLab.textAlignment = NSTextAlignmentRight;
        self.detailLab.font = [CustomerizedFont heiti:10];
        [self.backView3 addSubview:self.detailLab];
        
    }if (indexPath.row ==7) {
        cell.detailTextLabel.text = self.actuallyRate;
    }
    
    return cell;
}


-(void)deleteBtnAction{
    
    
    self.addBtn.enabled = YES;
    float i = [self.transferTextField.text floatValue];
    if (i<10000) {
        i--;
    }else if (i>10000 && i<100000){
        i = i-2;
    }else{
        i = i -5;
    }
    if (i <= (self.transferoOrderAmount - 10)) {
        self.deleteBtn.enabled = NO;
    }else{
        self.deleteBtn.enabled = YES;
    }
    self.transferTextField.text = [NSString stringWithFormat:@"%.2f",i];
    // self.rateLab.text = [NSString stringWithFormat:@"当月利息*%@%@",self.numCountLab.text,@"%"];
    
    CGFloat result = [self.transferTextField.text floatValue] - [self.routineLab.text floatValue];
    self.actuallyLab.text = [NSString stringWithFormat:@"%.2f",result];
    
}

-(void)addBtnAction{
    
    self.deleteBtn.enabled = YES;
    float i = [self.transferTextField.text floatValue];
    if (i<10000) {
        i++;
    }else if (i>10000 && i<100000){
        i = i+2;
    }else{
        i = i+5;
    }
    if (i >= self.transferoOrderAmount) {
        self.addBtn.enabled = NO;
    }
    self.transferTextField.text = [NSString stringWithFormat:@"%.2f",i];
    
    //self.rateLab.text = [NSString stringWithFormat:@"当月利息*%@%@",self.numCountLab.text,@"%"];
    
    CGFloat result = [self.transferTextField.text floatValue] - [self.routineLab.text floatValue];
    self.actuallyLab.text = [NSString stringWithFormat:@"%.2f",result];
    
}



-(UIView *)createFootView{
    self.footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    
    
    self.nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(20,25, kScreenWidth - 40, 40)];
    [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"confirmButton"] forState:UIControlStateNormal];
    [self.nextBtn addTarget:self action:@selector(nextDetail) forControlEvents:UIControlEventTouchUpInside];
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.layer.cornerRadius = 5;
    
    [self.footView addSubview:self.nextBtn];
    
    return _footView;
}

-(void)nextDetail{
    NSLog(@"......................%@",self.transferTextField.text);
    NSLog(@"......................%@",self.rateLab.text);
    
    ConfirmTransferController *confirm = [[ConfirmTransferController alloc]initTransferProductName:self.transferTitle ProductId:self.productId ProductNetValue:self.transferoOrderAmount TransferPrice:[self.transferTextField.text floatValue]RateOfReturn:[self.rate floatValue] ProductPoundage:[self.routineLab.text floatValue] ActuallyGetAmount:[self.actuallyPrice doubleValue]];
    
    [self.navigationController pushViewController:confirm animated:YES];
    
    
    
}

//计算文字的大小
- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize
{
    
    CGSize nameSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return nameSize;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)changeTransferText:(id)sender{
    
    UITextField *field = (UITextField *)sender;
    
    if ([field.text doubleValue] > self.transferoOrderAmount) {
        self.addBtn.enabled = NO;
        self.deleteBtn.enabled = YES;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"转让金额不能高于当前净值" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            self.transferTextField.text = [NSString stringWithFormat:@"%.2f",self.transferoOrderAmount];
        }];
        
        
    }else if ([field.text doubleValue] < (self.transferoOrderAmount - 10)){
        self.deleteBtn.enabled = NO;
        self.addBtn.enabled = YES;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"转让项目收益率不能高于24%" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            self.transferTextField.text = [NSString stringWithFormat:@"%.2f",(self.transferoOrderAmount - 10)];
        }];
    }else{
        self.addBtn.enabled = YES;
        self.deleteBtn.enabled = YES;
        self.transferTextField.text = [NSString stringWithFormat:@"%.2f",[field.text doubleValue]];
    }
    
    CGFloat result = [self.transferTextField.text floatValue] - [self.routineLab.text floatValue];
    self.actuallyLab.text = [NSString stringWithFormat:@"%.2f",result];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        _isHaveDecimalPoint = NO;
    }
    
    if (string.length > 0) {
        unichar single = [string characterAtIndex:0];
        if ((single >= '0' && single <= '9') || single == '.') {
            if (textField.text.length == 0 && single == '0') {
                [LTNUtilsHelper boxShowWithMessage:@"第一个数字不能为0"];
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        
        if (single == '.')
        {
            if(!_isHaveDecimalPoint)//text中还没有小数点
            {
                _isHaveDecimalPoint=YES;
                return YES;
            }else
            {
                [LTNUtilsHelper boxShowWithMessage:@"您已经输了小数点"];
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        else
        {
            if (_isHaveDecimalPoint)//存在小数点
            {
                //判断小数点的位数
                NSRange ran = [textField.text rangeOfString:@"."];
                NSInteger tt = range.location - ran.location;
                if (tt <= 2){
                    return YES;
                }else{
                    [LTNUtilsHelper boxShowWithMessage:@"最多为小数位两位"];
                    return NO;
                }
            }
            else
            {
                return YES;
            }
        }
        
    }
    
    return YES;
    
    
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
