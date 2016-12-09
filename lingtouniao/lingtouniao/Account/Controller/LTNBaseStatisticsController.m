//
//  LTNBaseStatisticsController.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/3/17.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNBaseStatisticsController.h"
#import "lingtouniao-Swift.h"
#import "LTNBaseStatisticsModel.h"
#import "PieLegendCell.h"

#define kTableHeaderHeight 320

@interface LTNBaseStatisticsController ()<ChartViewDelegate>

{
@protected
    NSMutableArray *parties;
}
@property (nonatomic, strong) PieChartView * chartView;
@property (nonatomic, copy) NSString * total;
@property (nonatomic, strong) NSIndexPath * selectedIndexPath;
@property (nonatomic, assign) BOOL loadSucceeds;

@end

@implementation LTNBaseStatisticsController

- (void)back{
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.loadSucceeds) {
        [self pullReload];
    }
}

- (void)refreshIfNeeded {
    if (!self.loadSucceeds) {
        [self pullReload];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.naviTitle;
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    self.tableView.hidden = YES;
    
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}

- (void)setupTableHeader
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kTableHeaderHeight)];
    
    UIView * containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, self.view.width, kTableHeaderHeight - 15)];
    containerView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:containerView];
    
    [containerView addSubview:self.chartView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.selectedIndexPath) {
            ChartHighlight * highlight = [[ChartHighlight alloc] initWithXIndex:self.selectedIndexPath.row dataSetIndex:0];
            [_chartView highlightValue:highlight];
            
        }
    });
    
    UIImage * lineImage = [UIImage imageNamed:@"Line_xu"];
    UIImageView * lineImageView = [[UIImageView alloc] initWithImage:lineImage];
    lineImageView.centerX = containerView.centerX;
    lineImageView.bottom = containerView.height - 10;
    lineImageView.backgroundColor = HexRGB(0xe2e2e2);
    [containerView addSubview:lineImageView];
    
    self.tableView.tableHeaderView = headerView;
}

- (void)setColors:(NSArray *)colors
{
    _colors = colors;
    if (!parties) {
        parties = [NSMutableArray arrayWithCapacity:self.colors.count];
    }
    for (int i = 0; i < self.colors.count; i++) {
        [parties addObject:@""];
    }
}

- (void)getServiceData:(BOOL)isGetMore
{
    [super getServiceData:isGetMore];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.extraParams];
    kWeakSelf
    [self apiForPath:self.apiPath method:kGetMethod parameter:dic responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        if (!error) {
            if (self.tableView.hidden) {
                [self setupTableHeader];
                self.tableView.hidden = NO;
            }
            
            LTNBaseStatisticsModel * model = [[LTNBaseStatisticsModel alloc] initWithData:data  withColors:self.colors];
            self.total = model.total;
            [weakSelf.data addObjectsFromArray:model.datas];
            if (self.data.count) {
                self.loadSucceeds = YES;
            }
            [self refreshChartView];
        }
    }];
}

#pragma mark piechart相关
- (void)refreshChartView
{
    [self setDataCount:parties.count];
}

- (PieChartView *)chartView{
    if(!_chartView){
        _chartView = [[PieChartView alloc] initWithFrame:CGRectMake(0, 25, 250, 250)];
        _chartView.centerX = self.view.width * 0.5;
        [self setupPieChartView:_chartView];
        _chartView.delegate = self;
        [_chartView animateWithXAxisDuration:1.0 easingOption:ChartEasingOptionEaseOutBack];
    }
    return _chartView;
}

- (void)setDataCount:(NSInteger)count
{
    if (!self.data.count) {
        return;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineSpacing = 5;
    
    NSString * string = [NSString stringWithFormat:@"%@\n%@", self.centerText, self.total];
    NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:string];
    [centerText setAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:18.f],
                                NSParagraphStyleAttributeName: paragraphStyle,
                                NSForegroundColorAttributeName : [UIColor grayColor]
                                } range:NSMakeRange(0, 3)];
    [centerText addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:20.f],
                                NSParagraphStyleAttributeName: paragraphStyle,
                                NSForegroundColorAttributeName: UIColor.orangeColor
                                } range:NSMakeRange(3, centerText.length - 3)];
    _chartView.centerAttributedText = centerText;
    
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    NSMutableArray * colors = [[NSMutableArray alloc] init];
    // 如果总额为0，则其余数据必为0
    if (![self.total doubleValue]) {
        for (int i = 0; i < count; i++)
        {
            [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:1 xIndex:i]];
            [colors addObject:HexRGB(0xe2e2e2)];
        }
    } else {
        [colors addObjectsFromArray:self.colors];
        // 解析数据，如果占比小于1/72，则占比为总值的1/72＋原有值
        double minAmount = [self.total doubleValue] / 72;
        for (int i = 0; i < count; i++)
        {
            double amount = [self.data[i][@"amount"] doubleValue];
            if (!amount) {
                [colors setObject:HexRGB(0xe2e2e2) atIndexedSubscript:i];
            }
            amount = amount < minAmount ? amount + minAmount : amount;
            [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:amount xIndex:i]];
        }
    }
    
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:parties[i % parties.count]];
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithYVals:yVals1 label:nil];
    // 设置各value块直接的间距
    dataSet.sliceSpace = 2.0;
    // indicates the selection distance of a pie slice
    dataSet.selectionShift = 7;

    // 设置各value对应的颜色块
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithXVals:xVals dataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = kCFNumberFormatterDecimalStyle;
    // 设置小数点位数
    pFormatter.maximumFractionDigits = 2;
    pFormatter.multiplier = @1.f;
    //    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:pFormatter];
    // 设置标注文字的字体
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10]];
    // 设置标注文字的颜色，如果不想现实，可将颜色设置为clearColor
    [data setValueTextColor:UIColor.clearColor];
    
    _chartView.data = data;
}

- (void)setupPieChartView:(PieChartView *)chartView
{
    // 用百分比显示
    //    chartView.usePercentValuesEnabled = YES;
    chartView.drawSlicesUnderHoleEnabled = NO;
    // 内圆的半径比例
    chartView.holeRadiusPercent = 0.57;
    // 透明圆的半径比例
//    chartView.transparentCircleRadiusPercent = 0.61;
    // 右下角的描述文字
    chartView.descriptionText = @"";
    // 设置额外的偏移
    //    [chartView setExtraOffsetsWithLeft:-5.f top:-5.f right:-5.f bottom:-5.f];
    chartView.drawCenterTextEnabled = YES;
    
    // 是否显示中间的圆
    chartView.drawHoleEnabled = YES;
    // 说明饼图从何处开始旋转，值为0-360
    chartView.rotationAngle = 180;
    // 设置是否可以旋转饼图
    chartView.rotationEnabled = YES;
    // 点击该区域是否放大
    chartView.highlightPerTapEnabled = YES;
    // 启用或禁用图例
    chartView.legend.enabled = NO;
    
//    ChartLegend *l = chartView.legend;
//    // 饼图说明的位置
//    l.position = ChartLegendPositionBelowChartCenter;
//    // 图例颜色块的大小
//    l.formSize = 10;
//    // 图例显示方向
//    //    l.direction = ChartLegendDirectionRightToLeft;
//    // 设置图例颜色块的样式
//    l.form = ChartLegendFormCircle;
//    //    l.xEntrySpace = 50.0;
//    //    l.yEntrySpace = 50.0;
//    // 图例在默认值的基础上进行y轴偏移
//    l.yOffset = 0.0;
//    l.formLineWidth = 10;
}

- (void)chartValueSelected:(ChartViewBase *)chartView entry:(ChartDataEntry *)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight *)highlight
{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:entry.xIndex inSection:0];
    [self changeChartHighlightWithIndexPath:indexPath];
}

- (void)chartValueNothingSelected:(ChartViewBase *)chartView
{
    PieLegendCell * selectedCell = [self.tableView cellForRowAtIndexPath:self.selectedIndexPath];
    selectedCell.isSelected = NO;
    self.selectedIndexPath = nil;
}

#pragma mark tableview相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"PieLegendCell";
    PieLegendCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PieLegendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.data = self.data[indexPath.row];
    cell.isSelected = [self.selectedIndexPath isEqual:indexPath] ? YES : NO;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self changeChartHighlightWithIndexPath:indexPath];
}




-(void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath{
    _selectedIndexPath = selectedIndexPath;
    if (selectedIndexPath) {
        ChartHighlight * highlight = [[ChartHighlight alloc] initWithXIndex:selectedIndexPath.row dataSetIndex:0];
        [_chartView highlightValue:highlight];
    } else {
        [_chartView highlightValue:nil];
    }
    [self.tableView reloadData];
}

#pragma mark 私有方法
- (void)changeChartHighlightWithIndexPath:(NSIndexPath *)indexPath
{
    if ([self.selectedIndexPath isEqual:indexPath]) {
        self.selectedIndexPath = nil;
    }else{
        self.selectedIndexPath = indexPath;
    }
}

@end
