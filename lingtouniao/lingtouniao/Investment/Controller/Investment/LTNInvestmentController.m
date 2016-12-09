//
//  LTNInvestmentController.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/11/11.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNInvestmentController.h"
#import "LTNProductListCell.h"
#import "LTNProductDetailController.h"
#import "LTNServerConstant.h"
#import "LTNMyCurrentDepositController.h"
#import "LTNProductList.h"
#import "ProductSectionHeader.h"

@interface LTNInvestmentController ()<LTNProductDetailControllerDelegate, LTNMyCurrentDepositControllerDelegate>

@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) NSTimeInterval refreshTime;
@property (nonatomic, strong) NSIndexPath * selectedIndexPath;

// 体验标
@property (nonatomic,strong)NSMutableArray *TYBArray;
// 新手标
@property (nonatomic,strong)NSMutableArray *XSBArray;
// 乐巢投
@property (nonatomic,strong)NSMutableArray *DQArray;
// 乐巢投系列
@property (nonatomic,strong)NSMutableArray *ZCQArray;
// 活期
@property (nonatomic,strong)NSMutableArray *HQArray;
// 已结束
@property (nonatomic,strong)NSMutableArray *FinishedArray;
// 募集中，乐巢投和乐巢投系列合并后
@property (nonatomic, strong)NSMutableArray * MJZArray;

@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)NSMutableArray *cellArray;

@end

@implementation LTNInvestmentController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kNeedToRefreshInvestPage] || now - self.refreshTime > 30 * 60) {
        self.refreshTime = 0;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kNeedToRefreshInvestPage];
        [self pullReload];
    }
}

-(void)initUIView{
    
    self.title = locationString(@"tab_investiment1");
    
    self.view.backgroundColor= [UIColor colorWithHexString:@"#f3f5f7x"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.TYBArray = [NSMutableArray array];
    self.XSBArray = [NSMutableArray array];
    self.DQArray = [NSMutableArray array];
    self.ZCQArray = [NSMutableArray array];
    self.HQArray = [NSMutableArray array];
    self.FinishedArray = [NSMutableArray array];
    self.MJZArray = [NSMutableArray array];
    
    self.cellArray=[NSMutableArray array];
    
    self.dataArray=@[@{@"type":@"TYB",
        @"title":locationString(@"inverstime_tyb"),
        @"list":self.TYBArray},
      @{@"type":@"XSB",
        @"title":locationString(@"inverstime_xsb"),
        @"list":self.XSBArray},
      @{@"type":@"MJZ",
        @"title":locationString(@"inverstime_mjz"),
        @"list":self.MJZArray},
      @{@"type":@"HQ",
        @"title":locationString(@"inverstime_sxt"),
        @"list":self.HQArray},
      @{@"type":@"YJS",
        @"title":locationString(@"inverstime_gqb"),
        @"list":self.FinishedArray},
      ];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pullReload) name:kNeedToRefreshProducts object:nil];
    [self pullReload];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)pullReload
{
    [self removeAllArrayData];
    [super pullReload];
}

-(void)removeAllArrayData{
    [self.TYBArray removeAllObjects];
    [self.XSBArray removeAllObjects];
    [self.DQArray removeAllObjects];
    [self.ZCQArray removeAllObjects];
    [self.HQArray removeAllObjects];
    [self.FinishedArray removeAllObjects];
    [self.MJZArray removeAllObjects];
}

/*
 1 是否有体验标
 
 有 sectionheader  0 体验标
 
 2
 
 */
-(void)addDataList:(NSArray *)list{
    [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LTNProduct *product=(LTNProduct *)obj;
        if([product isKindOfClass:[LTNProduct class]]){
            
            if([product.productType isEqualToString:@"TYB"]){
                [self.TYBArray addObject:product];
            } else if(product.productStatus < 2){
                if ([product.productType isEqualToString:@"XSB"]) {
                    [self.XSBArray addObject:product];
                } else if([product.productType isEqualToString:@"LCT"]){
                    [self.DQArray addObject:product];
                }else if([product.productType isEqualToString:@"LCTXL"]){
                    [self.ZCQArray addObject:product];
                }else if([product.productType isEqualToString:@"SXT"]){
                    [self.HQArray addObject:product];
                }
            }else{
                [self.FinishedArray addObject:product];
            }
        }
        
    }];
    
    NSArray *tempArray = [LTNProductList sortArray:self.XSBArray];
    [self.XSBArray removeAllObjects];
    [self.XSBArray addObjectsFromArray:tempArray];
    
    tempArray = [LTNProductList sortArray:self.DQArray];
    [self.DQArray removeAllObjects];
    [self.DQArray addObjectsFromArray:tempArray];
    
    tempArray=[LTNProductList sortArray:self.ZCQArray];
    [self.ZCQArray removeAllObjects];
    [self.ZCQArray addObjectsFromArray:tempArray];
    
    [self.MJZArray removeAllObjects];
    [self.MJZArray addObjectsFromArray:self.DQArray];
    [self.MJZArray addObjectsFromArray:self.ZCQArray];
    
    [self.cellArray removeAllObjects];
    for(int i=0;i<[self.dataArray count];i++){
        NSDictionary *dic=(NSDictionary *)self.dataArray[i];
        if([dic[@"list"] count]>0)
           [self.cellArray addObject:dic];
    }
    
    [self.tableView reloadData];
    [self testRepeatData:list];
}

-(void)testRepeatData:(NSArray *)list{
#if (defined(DEBUG) || defined(ADHOC))
        ESDispatchOnBackgroundQueue(^{
    
            [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                LTNProduct *product=(LTNProduct *)obj;
                int n=0;
                for(LTNProduct *product1 in self.FinishedArray){
                    if(product.productId==product1.productId){
                        n++;
                        if(n>1)
                        {
                            NSLog(@"currentPage＝＝＝%d",self.currentPage);
                            NSLog(@"chongfu shuju ");
                            [LTNUtilsHelper boxShowWithMessage:locationString(@"datas_repeat") duration:2.0f];
    
                        }
                    }
                }
                
            }];
        });
#endif

//    ESDispatchOnBackgroundQueue(^{
//    
//        [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            LTNProduct *product=(LTNProduct *)obj;
//            int n=0;
//            for(LTNProduct *product1 in self.FinishedArray){
//                if(product.productId==product1.productId){
//                    n++;
//                    if(n>1)
//                    {
//                        NSLog(@"currentPage＝＝＝%d",self.currentPage);
//                        NSLog(@"chongfu shuju ");
//                        
//                    }
//                }
//            }
//            
//        }];
//    });
    
}

#pragma mark - tableview数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.cellArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section < [self.cellArray count])
        return [self.cellArray[section][@"list"] count];
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"InvestmentCell";
    LTNProductListCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[LTNProductListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if(indexPath.section<[self.cellArray count]){
        NSArray *list=self.cellArray[indexPath.section][@"list"];
        if(indexPath.row<[list count])
            cell.product =list[indexPath.row];
    }
    //cell.product = self.cellArray[indexPath.section][@"list"][indexPath.row];
    return cell;
}

#pragma mark - tableview代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LTNProductListCell * selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    LTNProduct * selectedProduct = selectedCell.product;
    self.selectedIndexPath = indexPath;
    
    //跳到随心投页面
    if ([selectedProduct.productType isEqualToString:@"SXT"]) {
        
        kWeakSelf
        [LTNUtilsHelper actionWhenLogin:^(){
            LTNMyCurrentDepositController *current = [[LTNMyCurrentDepositController alloc] init];
            current.delegate = self;
            current.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:current animated:YES];
        } onVC:self];
        
        return;
    }
    [self pushProductDetailController:selectedProduct];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.cellArray[indexPath.section][@"list"] count]==indexPath.row+1)
        return kProductListCellHeight;
    else
        return kProductListCellHeight+16;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    ProductSectionHeader *sectionHeader=[[ProductSectionHeader alloc] init];
    [sectionHeader setTitle:self.cellArray[section][@"title"]];
    return sectionHeader;
}

#pragma mark detail controller delegate
- (void)needsRefreshWithProduct:(LTNProduct *)product
{
    if (self.selectedIndexPath) {
        self.cellArray[self.selectedIndexPath.section][@"list"][self.selectedIndexPath.row] = product;
        [self.tableView reloadRowsAtIndexPaths:@[self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        self.selectedIndexPath = nil;
        return;
    }
    [self pullReload];
}

#pragma mark currentDeposit delegate
- (void)refreshMyCurrentDepositWithRemainAmount:(double)remainAmount
{
    if (self.selectedIndexPath) {
        LTNProductListCell * currentCell = [self.tableView cellForRowAtIndexPath:self.selectedIndexPath];
        LTNProduct * currentProduct = currentCell.product;
        currentProduct.productRemainAmount = remainAmount;
        self.cellArray[self.selectedIndexPath.section][@"list"][self.selectedIndexPath.row] = currentProduct;
        [self.tableView reloadRowsAtIndexPaths:@[self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        self.selectedIndexPath = nil;
    }
}

#pragma mark 私有方法
//ztkztk TODO:传递productID不传model
-(void)pushProductDetailControllerWithproductID:(NSString *)productID{
    
    LTNProductDetailController * detailController = [[LTNProductDetailController alloc] init];
    detailController.delegate = self;
    detailController.productId = esInteger(productID);
    detailController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailController animated:YES];
    
}

-(void)pushProductDetailController:(LTNProduct *)product{
    
    LTNProductDetailController * detailController = [[LTNProductDetailController alloc] init];
    detailController.delegate = self;
    detailController.product = product;
    detailController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailController animated:YES];
}

- (void)getServiceData:(BOOL)isGetMore {
    [super getServiceData:isGetMore];

    kWeakSelf
    [self apiForPath:kProductsListUrl method:kGetMethod parameter:nil responseModelClass:[LTNProductList class] onComplete:^(id response, id data, NSError *error) {
        self.refreshTime = [[NSDate date] timeIntervalSince1970];
        LTNProductList *products = (LTNProductList *)data;
        if ([products isKindOfClass:[LTNProductList class]]) {
            [weakSelf.data addObjectsFromArray:products.productList];
            [self addDataList:products.productList];
        }else if(!isGetMore&&[weakSelf.data count]>0){
            [self addDataList:weakSelf.data];
        }
    }];
}

@end
