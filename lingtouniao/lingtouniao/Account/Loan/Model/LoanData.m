//
//  LoanData.m
//  lingtouniao
//
//  Created by zhangtongke on 16/4/5.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LoanData.h"

NSString *appendWanUnit(NSString *numstring){
    return [numstring stringByAppendingString:locationString(@"ten_thousand")];
}
NSString *appendBelowWan(NSString *numstring){
    return [numstring stringByAppendingString:locationString(@"below_ten_thousand")];
}


NSArray * LoanAmountsList(NSString *type){
    
    NSArray *array;
    if([type isEqualToString:@"1"]){//筑巢贷
        
        
        array=@[appendBelowWan(@"10"),
                         appendWanUnit(@"10-30"),
                         appendWanUnit(@"30-60"),
                         appendWanUnit(@"60-80"),
                         appendWanUnit(@"80-100")
                         ];
        
    }else if([type isEqualToString:@"2"]){//首付垫
        array=@[appendBelowWan(@"100"),
                appendWanUnit(@"100-200"),
                appendWanUnit(@"200-300"),
                appendWanUnit(@"300-400"),
                appendWanUnit(@"400-500")
                ];
    }else if([type isEqualToString:@"3"]){//乐巢贷
        array=@[appendBelowWan(@"500"),
                appendWanUnit(@"500-800"),
                appendWanUnit(@"800-1100"),
                appendWanUnit(@"1100-1300"),
                appendWanUnit(@"1300-1500")
                ];
    }else if([type isEqualToString:@"4"]){//尾款垫
        array=@[appendBelowWan(@"100"),
                appendWanUnit(@"100-300"),
                appendWanUnit(@"300-600"),
                appendWanUnit(@"600-800"),
                appendWanUnit(@"800-1000")
                ];
    }else if([type isEqualToString:@"5"]){//安翼贷
        array=@[appendWanUnit(@"10-20"),
                appendWanUnit(@"20-30"),
                appendWanUnit(@"30-40"),
                appendWanUnit(@"40-50"),
              
                ];
    }
    
    
    NSMutableArray *dicArray=[NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [dicArray addObject:@{@"key":obj,
                             @"value":obj}];
        
    }];
    
    return dicArray;
    
    
}



/*
"ten_thousand" = "万";
"below_ten_thousand" = "万以内";
 */

//@implementation LoanData
//
//@end
