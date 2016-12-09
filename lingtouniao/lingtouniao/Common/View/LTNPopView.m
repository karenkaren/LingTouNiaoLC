
//
//  LTNPopView.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/11/2.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNPopView.h"

#define kArrowHeight 10.0f
#define kRowHeight 35.0f

@interface LTNPopView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (assign, nonatomic) CGFloat cellHeight;
@property (nonatomic) CGPoint showPoint;
@property (nonatomic) CGRect viewFrame;
@property (assign, nonatomic) CGFloat popWidth;

@property (nonatomic, strong) UIButton *buttonView;

@end

@implementation LTNPopView

-(id)initWithTouchView:(id)view popWidth:(CGFloat)width
{
    self = [super init];
    if (self) {
        self.borderColor = [UIColor colorWithHexString:@"#e2e2e2"];
        self.backgroundColor = [UIColor clearColor];
    
        self.cellHeight = kRowHeight;
        UIView *tpView = (UIView*)view;
        self.showPoint = tpView.center;
        self.viewFrame = tpView.frame;
        self.popWidth = width;
        self.frame = [self fetchViewFrame];
        [self addSubview:self.tableView];
    }
    return self;
}
-(CGRect)fetchViewFrame
{
    CGRect frame = CGRectZero;
    frame.size.height =  _titleArray.count * _cellHeight  + kArrowHeight +5;
    frame.size.width = _popWidth;
    frame.origin.x = kScreenWidth - 140 ;//改变self x值
    frame.origin.y = CGRectGetMaxY(self.viewFrame) +105;//改变self y值
   
    return frame;
}

- (void)drawRect:(CGRect)rect
{
    [self.borderColor set];
    
    CGRect frame = CGRectMake(0, kArrowHeight*2-5, self.bounds.size.width,self.bounds.size.height - kArrowHeight*2 +5 );
    
    float xMin = CGRectGetMinX(frame);
    float yMin = CGRectGetMinY(frame);
    float xMax = CGRectGetMaxX(frame);
    float yMax = CGRectGetMaxY(frame);
    
    CGPoint covertPoint = CGPointMake(self.showPoint.x, CGRectGetMaxY(self.viewFrame));
    CGPoint arrowPoint = [self convertPoint:covertPoint fromView:_buttonView];
    
    arrowPoint = CGPointMake(xMax-kArrowHeight*5, arrowPoint.y);
    
    UIBezierPath *popoverPath = [UIBezierPath bezierPath];
    
    // 开始 point
    [popoverPath moveToPoint:CGPointMake(xMin, yMin)];
    
    //上边线
    [popoverPath addLineToPoint:CGPointMake(arrowPoint.x - kArrowHeight/2, yMin)];
    [popoverPath addLineToPoint:CGPointMake(arrowPoint.x + kArrowHeight/4, 0)];
    [popoverPath addLineToPoint:CGPointMake(arrowPoint.x +kArrowHeight, yMin)];
    [popoverPath addLineToPoint:CGPointMake(xMax, yMin)];
    
    //右边竖线
    [popoverPath addLineToPoint:CGPointMake(xMax, yMax)];
    //左边竖线
    [popoverPath addLineToPoint:CGPointMake(xMin, yMax)];
    
    [[UIColor whiteColor] setFill];
    [popoverPath fill];
    popoverPath.lineWidth = 0.5;
    [popoverPath closePath];
    [popoverPath stroke];
    
    
}

#pragma mark - setter and getter
- (void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
}

- (void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
}

-(UITableView *)tableView
{
    if (_tableView != nil) {
        return _tableView;
    }
    CGRect rect = self.frame;
    rect.origin.x = 0.5;
    rect.origin.y = kArrowHeight+5;
    rect.size.width -= 1;
    rect.size.height = CGRectGetHeight(rect)- kArrowHeight - 5;
    
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.alwaysBounceHorizontal = NO;
    _tableView.alwaysBounceVertical = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    _tableView.separatorColor = [UIColor colorWithHexString:@"#e2e2e2"];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return _tableView;
}
-(void)show
{
    _buttonView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonView setFrame:[UIScreen mainScreen].bounds];
    [_buttonView setBackgroundColor:[UIColor clearColor]];
    [_buttonView addTarget:self action:@selector(dismiss)
          forControlEvents:UIControlEventTouchUpInside];
    [_buttonView addSubview:self];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_buttonView];
    
    CGPoint covertPoint = CGPointMake(self.showPoint.x, CGRectGetMaxY(self.viewFrame));
    CGPoint arrowPoint = [self convertPoint:covertPoint fromView:_buttonView];
    self.layer.anchorPoint = CGPointMake(arrowPoint.x / self.frame.size.width,
                                         arrowPoint.y / self.frame.size.height);
    self.frame = [self fetchViewFrame];
    
    
    self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
    self.alpha = 1.f;
    self.transform = CGAffineTransformIdentity;
    
    
}

-(void)dismiss
{
    [_buttonView removeFromSuperview];
}

#pragma mark - UITableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titleArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
    }
    
    cell.backgroundView = [[UIView alloc] init];
    cell.backgroundView.backgroundColor = [UIColor clearColor];
    
    if ([_imageArray count] == [_titleArray count]) {
        cell.imageView.image = [UIImage imageNamed:[_imageArray objectAtIndex:indexPath.row]];
    }
    cell.textLabel.text = [_titleArray objectAtIndex:indexPath.row];
    cell.textLabel.font = kFont(16);
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == (_titleArray.count - 1)) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, kRowHeight-0.5, kRowHeight, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
        [cell.contentView addSubview:line];
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.selectRowAtIndex) {
        self.selectRowAtIndex(indexPath.row);
    }
    [self dismiss];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellHeight;
}



@end
