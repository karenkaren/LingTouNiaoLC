//
//  GuideController.m
//  lingtouniao
//
//  Created by  mathe on 15/12/19.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "GuideController.h"
#import "UIBarButtonItem+ClearBackground.h"


#define GuideImageNum 4

@interface GuideController ()<UIScrollViewDelegate>{
    UIScrollView *imageScroll;
    UIPageControl *pageControl;
}

@property (nonatomic)BOOL firstLand;

@end

@implementation GuideController

+(id)guideController:(BOOL)firstLand{
    GuideController *guideController=[[GuideController alloc] init];
    guideController.firstLand=firstLand;
    //ClearNavigationController * navController = [[ClearNavigationController alloc] initWithRootViewController:guideController];
    return guideController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!_firstLand){
        UIBarButtonItem *backButton = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"nav_return"] highlightImage:nil target:self action:@selector(back)];
        self.navigationItem.leftBarButtonItem = backButton;
    }
}


-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadGuideScrollView];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[PiwikTracker sharedInstance] sendViews:NSStringFromClass([self class]), self.title, nil];
}


-(void)loadGuideScrollView{
    
    if(imageScroll)
        return;
    
    imageScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    imageScroll.userInteractionEnabled = YES;
    imageScroll.directionalLockEnabled = YES;
    imageScroll.pagingEnabled = YES;
    imageScroll.backgroundColor=[UIColor clearColor];
    imageScroll.showsVerticalScrollIndicator =NO;
    imageScroll.showsHorizontalScrollIndicator = NO;
    imageScroll.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    imageScroll.delegate = self;
    [imageScroll setContentSize:CGSizeMake(self.view.width*GuideImageNum, self.view.height)];
    [self creatScrollView];
    [self.view addSubview:imageScroll];
    
    
    pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.height-30, 100, 10)];
    pageControl.hidesForSinglePage = YES;
    pageControl.userInteractionEnabled = NO;
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.numberOfPages = GuideImageNum;
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#ea5504"];
    pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#cccccc"];

    [self.view addSubview:pageControl];
    
    pageControl.centerX=self.view.width/2;
    
    
    
    
    
    //pageControl.backgroundColor=[UIColor redColor];
    
    /*
    
    ESButton *exitLeadBtn=[ESButton buttonWithTitle:@"跳过"];
    exitLeadBtn.color = ESButtonColorBlue;
    exitLeadBtn.frame=CGRectMake(220,25,80,30);
    
    
    [exitLeadBtn addTarget:self
                    action:@selector(exitLead)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitLeadBtn];
     
     */
}

-(void)exitLead
{
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"HadShowLeadView"];
    [LTNCore gesturePasswordController];
    [[LTNCore globleCore] loadMainTabbarController];
}

-(void)creatScrollView
{
    NSString *scale;
    int distance = 5;
    if(kScreenHeight==480){
        scale=@"(640x960)";
        distance = 5;
    }else if(kScreenHeight==568){
        scale=@"(640x1136)";
        distance = 38;
    }else if(kScreenHeight==667){
        scale=@"(750x1334)";
        distance = 45;
    }else if(kScreenHeight==736){
        scale=@"(1242x2208)";
        distance = 50;
    }
    for(int i=0;i<GuideImageNum;i++)
    {
        UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"0%i%@.jpg",i+1,scale]];
        UIImageView *imageView= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image=image;
        imageView.left=i*self.view.width;
        
        [imageScroll addSubview:imageView];
        
        if(_firstLand&&i==GuideImageNum-1){
     
            // 投资button
            UIButton * investmentButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0, DimensionBaseIphone6(210), DimensionBaseIphone6(51))];
            investmentButton.centerX = kScreenWidth * 0.5;
            
        
            
//            if(kScreenHeight==480){
//                investmentButton.bottom=self.view.height-110;
//            }else if(kScreenHeight==568){
//                investmentButton.bottom=self.view.height-120;
//            }else if(kScreenHeight==667){
//                investmentButton.bottom=self.view.height-140;
//            }else if(kScreenHeight==736){
//                investmentButton.bottom=self.view.height-160;
//            }
            
            investmentButton.bottom=self.view.height-DimensionBaseIphone6(43);

            
//            investmentButton.backgroundColor = [UIColor orangeColor];
//            investmentButton.layer.cornerRadius = 22;
//            investmentButton.layer.masksToBounds = YES;
//            
//            
            investmentButton.layer.borderWidth =1;
            investmentButton.layer.borderColor = [UIColor colorWithHexString:@"#ea5504"].CGColor;
            investmentButton.backgroundColor =[UIColor whiteColor];
            investmentButton.alpha=0.8;
            investmentButton.layer.cornerRadius = 22;
            investmentButton.clipsToBounds =YES;
            
            [investmentButton setTitle:locationString(@"go_taste") forState:UIControlStateNormal];
            [investmentButton setTitleColor:[UIColor colorWithHexString:@"#ea5504"] forState:UIControlStateNormal];
            [investmentButton addTarget:self action:@selector(exitLead) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:investmentButton];
            
            imageView.userInteractionEnabled=YES;

            
        }
        
    }
}


- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = fabs(scrollView.contentOffset.x)/self.view.frame.size.width;
    pageControl.currentPage = index;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = fabs(scrollView.contentOffset.x)/self.view.frame.size.width;
    pageControl.currentPage = index;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"scrollView.contentOffset.x==%f",scrollView.contentOffset.x);
//    if(scrollView.contentOffset.x>self.view.width*2+10)
//    {
//        [self exitLead];
//    }
    
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
