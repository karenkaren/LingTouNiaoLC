//
//  SplashModel.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/8/17.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BaseModel.h"

/*
{
    "data": {
        "startPageList": [
                          {
                              "createDate": 1471398479000,
                              "endDate": 1471571296000,
                              "id": 1,
                              "isClose": 1,
                              "isSkip": 1,
                              "pageStatus": 1,
                              "pageTitle": "测试启动页",
                              "pageUrl": "http://120.55.184.234:8080/img/banner/hhr.jpg",
                              "skipModel": "www.baidu.com",
                              "sort": 1,
                              "startDate": 1471312093000,
                              "updateDate": 1471398481000,
                              "version": "1.0.0"
                          }
                          ],
        "version": "1.0.0"
    },
    "resultCode": "0"
}
*/

@interface Splash : BaseModel

/*
 createDate		number	创建时间@mock=1471398479000
 endDate		number	结束时间@mock=1471571296000
 id		number	@mock=1
 isClose		number	是否支持跳过 0-不支持 1-支持@mock=1
 isSkip		number	是否跳转， 0-不跳转 1-h5 2-原生模块@mock=1
 pageStatus		number	启动页状态 0-无效 1-有效@mock=1
 pageTitle		string	启动页标题@mock=测试启动页
 pageUrl		string	启动页图片URL@mock=http://120.55.184.234:8080/img/banner/hhr.jpg
 skipModel		string	IS_SKIP 1：h5url 2：模块--@mock=www.baidu.com
 sort		number	排序字段@mock=1
 startDate		number	开始时间@mock=1471312093000
 updateDate		number	@mock=1471398481000
 version		string	图片版本号（这个字段没用）@mock=1.0.0
 */

@property(nonatomic, assign) NSTimeInterval createDate;//创建时间
@property(nonatomic, assign) NSTimeInterval endDate;//结束时间
@property(nonatomic, assign) NSInteger ID;
@property(nonatomic, assign) BOOL isClose;//是否支持跳过 0-不支持 1-支持
@property(nonatomic, assign) NSInteger isSkip;//是否跳转， 0-不跳转 1-h5 2-原生模块
@property(nonatomic, assign) BOOL pageStatus;//启动页状态 0-无效 1-有效
@property(nonatomic, copy) NSString * pageTitle;//启动页标题
@property(nonatomic, copy) NSString * pageUrl;//启动页图片URL
@property(nonatomic, copy) NSString * skipModel;//IS_SKIP 1：h5url 2：模块
@property(nonatomic, assign) NSInteger sort;//排序字段,暂不用
@property(nonatomic, assign) NSTimeInterval startDate;//开始时间,暂不用
@property(nonatomic, assign) NSTimeInterval updateDate;//暂不用
@property(nonatomic, copy) NSString * version;//图片版本号（这个字段没用）

@end

@interface SplashModel : BaseModel

@property (nonatomic, strong) NSArray * startPageList;
@property(nonatomic, copy) NSString * version;
@property(nonatomic, strong) Splash * splash;

+ (SplashModel *)sharedSplash;

@end
