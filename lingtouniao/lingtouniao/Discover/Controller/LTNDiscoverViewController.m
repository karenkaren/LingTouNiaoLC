//
//  LTNDiscoverViewController.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/9/21.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNDiscoverViewController.h"
#import "LTNCooperationListController.h"
#import "LTNCrowdfundingListController.h"
#import "LTNHotActivityCell.h"
#import "HandeUrlUtil.h"
#import "UIImageView+WebCache.h"


@interface LTNDiscoverViewController ()

@property (nonatomic) NSArray *bannerListArray;

@property (nonatomic) BOOL lookForward;

@end

@implementation LTNDiscoverViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    [self loadTableHeadView];
    [self pullReload];
    
}

- (void)viewDidLoad {
   
    [super viewDidLoad];
   
    self.title = locationString(@"tab_discover");
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    //无网时默认加载占位图片
    LTNBanner *placeHolderBanner=[[LTNBanner alloc] init];
    placeHolderBanner.bannerId=@"0";
    placeHolderBanner.bannerUrl=@"";
    [self.data addObject:placeHolderBanner];
    
    //[self loadTableHeadView];
    
    [self loadData];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isSlipping) {
        [self performSelector:@selector(scrollToActivity) withObject:nil afterDelay:0.05];
        self.isSlipping = NO;
    }
}

-(void)scrollToActivity{
    if (!self.data.count) {
        return;
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

// 请求banner数据
-(void)loadData{
    
    NSArray * bannerList = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] valueForKey:kBannerHomeAndBannerIntroduction]];
    if (bannerList) {
        [self.data removeAllObjects];
        [self.data addObjectsFromArray:bannerList];
    }
    
    
}

-(void)loadTableHeadView{

    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, DimensionBaseIphone6(340 +15))];
    backView.backgroundColor = [UIColor whiteColor];
    
//    NSArray * bannerListUp = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] valueForKey:kBannerCrowdingAndBannerIntroduction]];
//    NSArray * bannerListDown = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] valueForKey:kBannerMutualAndBannerIntroduction]];
//    
//    NSString *imgStingUp = nil;
//    NSString *imgStingDown = nil;
//    for (LTNBanner *banner in bannerListUp) {
//        imgStingUp = banner.bannerPicture;
//    }
//    for (LTNBanner *banner in bannerListDown) {
//        imgStingDown = banner.bannerPicture;
//    }
    
    for (int i =0; i<2; i++) {
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(DimensionBaseIphone6(15), DimensionBaseIphone6(15+165*i),kScreenWidth - DimensionBaseIphone6(30) , DimensionBaseIphone6(160))];
        imgV.userInteractionEnabled = YES;
        imgV.contentMode = UIViewContentModeScaleAspectFill;
        imgV.clipsToBounds = YES;
        if (i == 0) {
            
            if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isHasCrowdData"]) {
                imgV.image = [UIImage imageNamed:@"icon_crowdfunding"];
//                [imgV sd_setImageWithURL:[NSURL URLWithString:imgStingUp] placeholderImage:[UIImage imageNamed:@"icon_crowdfunding"] options:SDWebImageRetryFailed];
                self.lookForward = NO;
            }else{
                imgV.image = [UIImage imageNamed:@"home_look_forward"];
                self.lookForward = YES;
            }
            
        }else if (i == 1){
            imgV.image = [UIImage imageNamed:@"icon_Cooperation"];
//            [imgV sd_setImageWithURL:[NSURL URLWithString:imgStingDown] placeholderImage:[UIImage imageNamed:@"icon_Cooperation"] options:SDWebImageRetryFailed];
        }
        imgV.tag = 669+i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
        [imgV addGestureRecognizer:tap];
        [backView addSubview:imgV];
    }
  
    self.tableView.tableHeaderView = backView;
    
}

-(void)click:(UITapGestureRecognizer *)gesture{
    
    if (gesture.self.view.tag == 669) {
        if (self.lookForward == YES) {
            return;
        }
        [self goToCrowdfundingListController];

    }else{
        [self goToCooperationListController];
    }
}

- (void)goToCooperationListController
{
    LTNCooperationListController *CooperationList = [[LTNCooperationListController alloc]init];
    CooperationList.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:CooperationList animated:YES];
}

- (void)goToCrowdfundingListController
{
    LTNCrowdfundingListController *CrowdfundingList = [[LTNCrowdfundingListController alloc]init];
    CrowdfundingList.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:CrowdfundingList animated:YES];
}

-(void)getServiceData:(BOOL)isGetMore{
    [super getServiceData:isGetMore];
    
    kWeakSelf
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"location":@1}];
    [self apiForPath:kBannerList method:kGetMethod parameter:dic responseModelClass:[LTNBannerList class] onComplete:^(id response, id data, NSError *error) {
        
        LTNBannerList *list = (LTNBannerList *)data;
        if ([list isKindOfClass:[LTNBannerList class]]&&[list.bannerList count]>0) {
            [weakSelf.data removeAllObjects];
            [weakSelf.data addObjectsFromArray:list.bannerList];
        }
        [self loadTableHeadView];
        [weakSelf.tableView reloadData];
        

    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 185 + 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    head.backgroundColor = [UIColor whiteColor];
    UILabel * lab = [Utility createLabel:kFont(16) color:[UIColor colorWithHexString:@"#333333"]];
    lab.frame = CGRectMake((kScreenWidth - DimensionBaseIphone6(350))/2, 0, kScreenWidth, 40);
    lab.text = locationString(@"hot_Activity");
    [head addSubview:lab];
    
    return head;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"cell";
   
    LTNHotActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[LTNHotActivityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.banner = self.data[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    LTNHotActivityCell * selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    LTNBanner * selectedBanner = selectedCell.banner;
    
    if([selectedBanner.bannerId isEqualToString:@"0"])
        return;

    NSString *name = selectedBanner.shareTitle;
    NSString *linkUrl = selectedBanner.shareUrl;
    NSString *content = selectedBanner.shareContent;
    
    [HandeUrlUtil receiveOpenUrlString:selectedBanner.bannerUrl fromNavViewController:self.navigationController andHaveNav:YES andHaveBtn:selectedBanner.isShare andShareName:name andShareIcon:selectedBanner.sharePic andShareUrl:linkUrl andShareContent:content];


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
