
//
//  AddressPickerView.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/11/3.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "AddressPickerView.h"

#define SHAddressPickerViewHeight 216

@interface AddressPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSArray   *_provinces;
    NSArray   *_citys;
    NSArray   *_areas;
    
    NSString  *_currentProvince;
    NSString  *_currentCity;
    NSString  *_currentDistrict;
    
    UIView        *_wholeView;
    UIView        *_topView;
    UIPickerView  *_pickerView;
}

@end

@implementation AddressPickerView

+ (id)shareInstance
{
    static AddressPickerView *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[AddressPickerView alloc] init];
    });
    
    return shareInstance;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenBottomView)];
        [self addGestureRecognizer:tap];
        
        [self createData];
        [self createView];
    }
    return self;
}

- (void)createData
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
    NSArray *data = [[NSArray alloc]initWithContentsOfFile:plistPath];
    
    _provinces = data;
    
    // 第一个省分对应的全部市
    _citys = [[_provinces objectAtIndex:0] objectForKey:@"cities"];
    // 第一个省份
    _currentProvince = [[_provinces objectAtIndex:0] objectForKey:@"state"];
    // 第一个省份对应的第一个市
    _currentCity = [[_citys objectAtIndex:0] objectForKey:@"city"];
    // 第一个省份对应的第一个市对应的第一个区
    _areas = [[_citys objectAtIndex:0] objectForKey:@"areas"];
    if (_areas.count > 0) {
        _currentDistrict = [_areas objectAtIndex:0];
    } else {
        _currentDistrict = @"";
    }
}

- (void)createView
{
    // 弹出的整个视图
    _wholeView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 300)];
    [self addSubview:_wholeView];
    
    // 头部按钮视图
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [_wholeView addSubview:line];
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, kScreenWidth, 40)];
    _topView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];;
    [_wholeView addSubview:_topView];
    
    // 防止点击事件触发
    UITapGestureRecognizer *topTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    [_topView addGestureRecognizer:topTap];
    
    NSArray *buttonTitleArray = @[locationString(@"btn_cancel"),locationString(@"btn_confirm")];
    for (int i = 0; i <buttonTitleArray.count ; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(kScreenWidth-70), 0, 70, 40);
        [button setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
        [button setTitle:buttonTitleArray[i] forState:UIControlStateNormal];
        [_topView addSubview:button];
        
        button.tag = i;
        [button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // pickerView
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, 260)];
    _pickerView.showsSelectionIndicator=YES;
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [_wholeView addSubview:_pickerView];
}

- (void)buttonEvent:(UIButton *)button
{
    // 点击确定回调block
    if (button.tag == 1)
    {
        if (_block) {
            _block(_currentProvince, _currentCity, _currentDistrict);
        }
    }
    
    [self hiddenBottomView];
}

- (void)showBottomView
{
    [UIView animateWithDuration:0.3 animations:^
     {
         _wholeView.frame = CGRectMake(0, kScreenHeight-300, kScreenWidth, 300);
         
     } completion:^(BOOL finished) {}];
    

}
- (void)hiddenBottomView
{
    [UIView animateWithDuration:0.3 animations:^
     {
         _wholeView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 300);
         
     } completion:^(BOOL finished) {
         [self removeFromSuperview];
     }];
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [_provinces count];
            break;
        case 1:
            return [_citys count];
            break;
        case 2:
            
            return [_areas count];
            break;
            
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
            return [[_provinces objectAtIndex:row] objectForKey:@"state"];
            break;
        case 1:
            return [[_citys objectAtIndex:row] objectForKey:@"city"];
            break;
        case 2:
            if ([_areas count] > 0) {
                return [_areas objectAtIndex:row];
                break;
            }
        default:
            return  @"";
            break;
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [pickerView selectRow:row inComponent:component animated:YES];
    
    switch (component)
    {
        case 0:
            
            _citys = [[_provinces objectAtIndex:row] objectForKey:@"cities"];
            [_pickerView selectRow:0 inComponent:1 animated:YES];
            [_pickerView reloadComponent:1];
            
            _areas = [[_citys objectAtIndex:0] objectForKey:@"areas"];
            [_pickerView selectRow:0 inComponent:2 animated:YES];
            [_pickerView reloadComponent:2];
            
            _currentProvince = [[_provinces objectAtIndex:row] objectForKey:@"state"];
            _currentCity = [[_citys objectAtIndex:0] objectForKey:@"city"];
            if ([_areas count] > 0) {
                _currentDistrict = [_areas objectAtIndex:0];
            } else{
                _currentDistrict = @"";
            }
            break;
            
        case 1:
            
            _areas = [[_citys objectAtIndex:row] objectForKey:@"areas"];
            [_pickerView selectRow:0 inComponent:2 animated:YES];
            [_pickerView reloadComponent:2];
            
            _currentCity = [[_citys objectAtIndex:row] objectForKey:@"city"];
            if ([_areas count] > 0) {
                _currentDistrict = [_areas objectAtIndex:0];
            } else {
                _currentDistrict = @"";
            }
            break;
            
        case 2:
            
            if ([_areas count] > 0) {
                _currentDistrict = [_areas objectAtIndex:row];
            } else{
                _currentDistrict = @"";
            }
            break;
            
        default:
            break;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerLabel = (UILabel *)view;
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setFont:[UIFont systemFontOfSize:16]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    return pickerLabel;
}


@end
