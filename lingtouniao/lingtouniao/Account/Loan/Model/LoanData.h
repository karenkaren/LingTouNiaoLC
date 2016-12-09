//
//  LoanData.h
//  lingtouniao
//
//  Created by zhangtongke on 16/4/5.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <Foundation/Foundation.h>



#pragma mark enum defines
typedef enum {
    SexMale,
    SexFemale,
    
} Sex;

static inline NSString *SexTitle(Sex sex) {
    NSString *sexTitle = locationString(@"loan_boy");
    if(sex==SexFemale)
        sexTitle=locationString(@"loan_girl");
    return sexTitle;
}

static inline NSArray *LoanCitys(NSString *loanType) {
    
    if([loanType isEqualToString:@"1"]||[loanType isEqualToString:@"5"]){
        return @[@{@"key":@"0021",@"value":locationString(@"load_details_city_hint")},];
    }
    return @[@{@"key":@"0021",@"value":locationString(@"load_details_city_hint")},
             @{@"key":@"0571",@"value":locationString(@"load_details_city_hint2")},
             @{@"key":@"0574",@"value":locationString(@"load_details_city_hint3")},];
}



static inline NSString *CityName(NSString *cityCode) {
    //TODO:默认取最全列表
    NSArray *citys=LoanCitys(@"2");
    __block NSString *cityName=@"";
    for(int i=0;i<[citys count];i++){
        NSDictionary *cityDic=citys[i];
        if([cityDic[@"key"] isEqualToString:cityCode]){
            cityName=cityDic[@"value"];
            break;
        }
    }
    
    return cityName;
    
}

extern NSArray * LoanAmountsList(NSString *type);


#pragma mark end


