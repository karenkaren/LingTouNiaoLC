//
//  EditAddressViewController.h
//  lingtouniao
//
//  Created by 郑程锋 on 16/11/3.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LTNAddressModel.h"


@interface EditAddressViewController : BaseTableViewController

@property (nonatomic) BOOL isEditAddress;//是否是编辑状态

@property (nonatomic) LTNAddressModel *addressModel;

@end
