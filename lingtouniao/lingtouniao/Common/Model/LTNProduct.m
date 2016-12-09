//
//  LTNProduct.m
//  111
//
//  Created by LiuFeifei on 15/12/8.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNProduct.h"

@implementation LTNProduct


//起投金额 标的起投金额与标的剩余金额最小值
-(double)startAmount{
    return MIN(self.staInvestAmount, self.productRemainAmount);
}

//此标的用户最大可投金额
-(double)getOnceMaxAccount{
    
    
//    第一步，确定起投金额，一般就是1000，但如果标的剩余金额小于1000，那么起投金额就是标的剩余的金额
    
    double aAmount=[self startAmount];
    
//    第二步，确定用户自己最大的可投金额：若余额 > 鸟币 * 5，默认值 = 余额 + 鸟币，向下取整；若余额 < 鸟币 * 5，默认值 = 余额 * 1.2，向下取整
    
    
    // 可用余额
    double usableBalance = [CurrentUser mine].accountInfo.usableBalance;
    double bAmount=usableBalance;
    
    if(self.useBirdCoinTag){
        // 鸟币
        double birdCoin = [CurrentUser mine].accountInfo.birdCoin;
        bAmount=usableBalance >= birdCoin * 5 ? floor(usableBalance + birdCoin) : floor(usableBalance * 1.2);
    }
    
//    第三步，确定项目当前的剩余金额
    
    double cAmount=self.productRemainAmount;
    
//    第四步，确定项目是否存在单笔投资上限
    
    double dAmount= [self hasSingleLimitAmount] ? self.singleLimitAmount : MAXFLOAT;
    
//    第五步，确定项目是否存在单人上限，计算出用户剩下可以投的金额
    
    double eAmount= [self hasTotalLimitAmount] ? self.lastAmount : MAXFLOAT;
    
    //若b < a，或e < a，都取a；当b和e同时大于a，取b，c，d，e中的最小值
    
    double purchaseMaxAmount;
    if(bAmount<=aAmount||eAmount<=aAmount){
        purchaseMaxAmount=aAmount;
    }else{
        NSArray *array=@[@(bAmount),@(cAmount),@(dAmount),@(eAmount)];
        purchaseMaxAmount = [[array valueForKeyPath:@"@min.doubleValue"] doubleValue];
        
    }
    
    
    return purchaseMaxAmount;
    
//    //第一步：算出用户自己可投金额： b
//    //可用余额大于鸟币5倍，用户可投金额为 鸟币加可用余额 ；  否则，可用余额的1.2倍
//    double usableAmount = usableBalance >= birdCoin * 5 ? floor(usableBalance + birdCoin) : floor(usableBalance * 1.2);
//    //第二步：可投金额 与标的比较 ，算出本用户 此标的最大可投
//    
//    //用户可投金额小于此标的起投金额，取起投金额 ，否则 取用户可投金额与标的剩余金额最小值
//    double startAmountTemp=[self startAmount];
//    double purchaseOnceAmount = usableAmount < startAmountTemp ? startAmountTemp : floor(MIN(usableAmount, self.productRemainAmount));
    
    
   // return purchaseOnceAmount;
    

}




-(BOOL)hasSingleLimitAmount{
    if(self.singleLimitAmount==0.0)
        return NO;
    return YES;
}

-(BOOL)hasTotalLimitAmount{
    if(self.totalLimitAmount==0.0)
        return NO;
    return YES;
    
}

- (NSString *)deadlineString
{
    if (self.floatTag) {
        return [NSString stringWithFormat:@"%ld-%ld", self.standardConvertDay, self.convertDay];
    } else {
        return [NSString stringWithFormat:@"%ld", self.productDeadline];
    }
}

@end

