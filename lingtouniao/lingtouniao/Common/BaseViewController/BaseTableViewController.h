//
//  BaseTableViewController.h
//  mmbang
//
//  Created by 肖信波 on 13-8-31.
//  Copyright (c) 2013年 iyaya. All rights reserved.
//

#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "LoadingView.h"


#define kGetMoreKey @"isGetMore"

@interface BaseTableViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate>
{
    UITableView *_tableView;
    
    LoadingView *_loadingView;
    LoadingViewState _loadingViewState;
    EGORefreshTableHeaderView *_refreshHeaderView;
    CGFloat _lastScrollOffset;
    NSMutableArray *_data;
}

@property (nonatomic) NSMutableArray *data;

@property (assign) BOOL hideRefreshHeader;
@property (assign) BOOL hideLoadingView;
@property (nonatomic,assign) LoadingViewState loadingViewState;

@property (nonatomic) UITableView *tableView;

@property (nonatomic) BOOL isTableViewStyleGrouped;

@property (nonatomic) BOOL hasMore;
@property (nonatomic) NSDictionary *commonMoreParams;

- (UITableViewCell *)getLoadingViewCell;
- (void)loadMore;
- (void)pullReload;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)autoLoadMoreAtIndexPath:(NSIndexPath *)indexPath;

- (void)reloadFinished;
- (void)loadMoreFinished;

- (void)getServiceData:(BOOL)isGetMore;

- (BOOL)isDataEmpty;  //some child vc may not use self.data.count to judge weather there is no data, let them override this

@end

@interface CustomizedBaseTableViewController : BaseTableViewController

- (void)createTableView;

@end

