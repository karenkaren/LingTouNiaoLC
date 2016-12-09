//
//  BaseTableViewController.m
//  mmbang
//
//  Created by 肖信波 on 13-8-31.
//  Copyright (c) 2013年 iyaya. All rights reserved.
//

#import "BaseTableViewController.h"
#import "BaseDataEngine.h"
#import "DtoContainer.h"

#define POST_BUTTON_HEIGHT 42.0f
#define POST_BUTTON_HIDE_HEIGHT 5.0f

@implementation BaseTableViewController

- (void)createTableView {
    if (_isTableViewStyleGrouped){
         _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    } else {
         _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    }
   
}


-(NSMutableArray *)data{
    if(!_data){
        _data = [NSMutableArray array];
        
    }
    return _data;
}

-(void)autoLoadMoreAtIndexPath:(NSIndexPath *)indexPath
{
    if (_data.count > 10 && indexPath.row == _data.count - 9 && _hasMore) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadMore];
        });
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self createTableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_tableView];
    
    if (!_hideRefreshHeader) {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -_tableView.bounds.size.height, self.view.frame.size.width, _tableView.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        [_tableView addSubview:_refreshHeaderView];
        [_refreshHeaderView refreshLastUpdatedDate];
        _refreshHeaderView.backgroundColor = self.view.backgroundColor;
    }
    
    if (!_hideLoadingView) {
        _loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, LOADING_HEIGHT)];
        _loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _loadingView.text = locationString(@"load_text1");
        _loadingView.textReady = locationString(@"load_text2");
        _loadingView.textLoading =locationString(@"loading");
    }
}

#pragma mark - Data Load

- (void)reloadFinished{
    _loading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

- (void)loadMoreFinished{
    _loading = NO;
    _loadingView.state = LoadingViewStateNormal;
    _loadingViewState = LoadingViewStateNormal;
}

#pragma mark - TableView

- (UITableViewCell *)getLoadingViewCell
{
    static NSString *loadViewReuseIdentifier = @"loadViewReuseIdentifier";
    
    UITableViewCell *cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:loadViewReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadViewReuseIdentifier];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell addSubview:_loadingView];
    [_loadingView setState:_loadingViewState];
    [_loadingView setContentView:_hasMore];
    if (_hasMore)
    {
        _loadingView.text = locationString(@"load_text1");
    }else
    {
        _loadingView.text = locationString(@"no_more_data");
    }
    return cell;
}

#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tableView) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
        
        if (_hasMore) {
            CGFloat calibrateContentHeight = MAX(_tableView.bounds.size.height, _tableView.contentSize.height);
            CGFloat loadingViewOffset = _tableView.contentOffset.y + _tableView.bounds.size.height - calibrateContentHeight;
            if (loadingViewOffset >= 0) {
                if (_tableView.dragging && _loadingView.state != LoadingViewStateLoading) {
                    [_loadingView setState:(loadingViewOffset > MIN_LOADING_OFFSET + _tableView.contentInset.bottom) ? LoadingViewStateReady : LoadingViewStateNormal];
                }
            }
            _loadingViewState = _loadingView.state;
        }
        
        _lastScrollOffset = scrollView.contentOffset.y;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _tableView) {
        if (_loadingView.state == LoadingViewStateReady && _hasMore) {
            _loadingViewState = LoadingViewStateLoading;
            [_loadingView setState:LoadingViewStateLoading];
            [self loadMore];
        }
        
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == _tableView) {
        _lastScrollOffset = scrollView.contentOffset.y;
    }
}

#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
	[self performSelector:@selector(pullReload) withObject:nil afterDelay:1];
}

- (void)pullReload
{
    if (_loading) {
        return ;
    }
    _loading = YES;
    [self getServiceData:NO];
}

- (void)loadMore
{
    if (_loading) {
        return ;
    }
    _loading = YES;
    [self getServiceData:YES];
}

- (void)getServiceData:(BOOL)isGetMore
{
    [self.params setValue:@(isGetMore) forKey:kGetMoreKey];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
	return _loading;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
	return [NSDate date];
}

#pragma mark - BottomPostViewDelegate
- (void) touchReload {
    [self pullReload];
}

- (void)apiForPath:(NSString *)path method:(NSString *)httpMethod parameter:(NSDictionary *)parameters responseModelClass:(Class)class onComplete:(APIComletionBlock)block {
    [self beforeApiInvocation:path];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [dict addEntriesFromDictionary:self.params];

    BOOL isGetMore = [[dict valueForKey:kGetMoreKey] boolValue];

#ifdef DEBUG
    NSInteger pageSize = 20;
#else
    NSInteger pageSize = 20;
#endif

    if (isGetMore) {
        if (self.commonMoreParams) {
            [dict addEntriesFromDictionary:self.commonMoreParams];
        } else {
            [self afterApiInvocation:path];
            return;
        }
    } else {
        [dict addEntriesFromDictionary:@{@"pageSize":@(pageSize), @"currentPage":@(0)}];
    }

    if (!self.data) {
        self.data = [NSMutableArray array];
    }
    kWeakSelf
    kWeakObj(path)
    [BaseDataEngine apiForPath:path method:httpMethod parameter:dict responseModelClass:class onComplete:^(id response, id data, NSError *error) {

        //cleanup
        [weakSelf afterApiInvocation:path];
        
        //if it's not caused by a OnComplete, which means a network error
        if (!response && error) {
            if (![BaseDataEngine isSilentApi:weakObj]) {
                [Utility showNetworkErrorMsg:error];
            }
        }
        
        if (!error) {
            if (!isGetMore) {
                [weakSelf.data removeAllObjects];
            }
        }
        block(response, data, error);

        if (!error) {
            //            每页显示的条数，pageSize： app每次上传, 由前端约定
            //            需要显示的页数：currentPage， app上传后，后台直接拿过去，增长由前端决
            //            定， 页数从0开始。
            //            总的条数由后台返回。
            if (class) {
                DtoContainer *dataContainer = response;
                weakSelf.hasMore = dataContainer.totalCount > self.data.count;
            } else {
                weakSelf.hasMore = [[data valueForKey:@"totalCount"] integerValue] > self.data.count;
            }
            if (weakSelf.hasMore) {
                NSInteger currentPage = self.data.count / pageSize;
                if (self.data.count > currentPage * pageSize) {
                    currentPage += 1;
                }
                weakSelf.commonMoreParams = @{@"pageSize":@(pageSize), @"currentPage":@(currentPage)};
            } else {
                weakSelf.commonMoreParams = nil;
            }

            /**
             *    handle no data
             */
            if ([self isDataEmpty]) {
                [weakSelf showDataEmptyView];
            } else {
                [weakSelf.tableView reloadData];
            }
        } else {
            /**
             *    handle error
             */
            if ([self isDataEmpty]) {
                [weakSelf showErrorViewWithError:error];
            }
        }
    }];
}

- (void)afterApiInvocation:(NSString *)path {
    [super afterApiInvocation:path];
    [self dismissNetFailView];
    [self reloadFinished];
    [self loadMoreFinished];
}

- (BOOL)isDataEmpty {
    return self.data.count == 0;
}

@end


@implementation CustomizedBaseTableViewController

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
}

@end
