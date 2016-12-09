//
//  ConfirmTransferController.h
//  lingtouniao
//
//  Created by 郑程锋 on 16/11/15.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BaseViewController.h"

@interface ConfirmTransferController : BaseViewController

//产品名称、当前净值、转让价、挂牌收益率、交易手续费、实际到账金额

-(id)initTransferProductName:(NSString *)productName ProductId:(NSInteger)productId ProductNetValue:(float)netValue TransferPrice:(float)transferPrice RateOfReturn:(float)rate ProductPoundage:(float)poundage ActuallyGetAmount:(double)getAmount;

@end


@interface TransferSuccessViewController : BaseViewController

@end
