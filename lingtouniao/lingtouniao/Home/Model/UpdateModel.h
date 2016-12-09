//
//  UpdateModel.h
//  lingtouniao
//
//  Created by peijingwu on 12/28/15.
//  Copyright © 2015 lingtouniao. All rights reserved.
//

#import "BaseModel.h"

@interface UpdateModel : BaseModel

@property (strong) NSString *downloadUrl;      //下载地址
@property (strong) NSString *updateInfo;       //提示文字
@property (strong) NSString *versionNo;    //新版本号
@property (strong) NSString *package_size;
@property (assign) BOOL hasUpdate;             //是否有更新
@property (nonatomic,assign) BOOL forceUpdate; //是否强制

@end
