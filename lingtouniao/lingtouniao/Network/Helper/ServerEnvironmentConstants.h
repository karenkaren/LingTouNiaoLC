//
//  ServerEnvironmentConstants.h
//  mmbang
//
//  Created by CuiPanJun on 14-10-20.
//  Copyright (c) 2014年 iyaya. All rights reserved.
//

#ifndef mmbang_ServerEnvironmentConstants_h
#define mmbang_ServerEnvironmentConstants_h

//add the following as we pass the definitions from Makefile
#if !defined BUILD_FOR_DEVELOP && !defined BUILD_FOR_TEST && !defined BUILD_FOR_RELEASE

//#define BUILD_FOR_DEVELOP

//使用测试室服务器
//#define BUILD_FOR_TEST

//使用生产服务器,
#define BUILD_FOR_RELEASE

#endif

#ifdef BUILD_FOR_DEVELOP

#define API_BASE_URL_Internal    @"http://192.168.18.194:8080"

#endif

#ifdef BUILD_FOR_TEST

#define API_BASE_URL_Internal    @"http://120.55.184.234:8080"//阿里云测试
#endif

#ifdef BUILD_FOR_RELEASE

#define API_BASE_URL_Internal @"https://www.lingtouniao.com/v3"

#endif

#if (defined(DEBUG) || defined(ADHOC ))

#define ISPostAddress [[NSUserDefaults standardUserDefaults] dictionaryForKey:kDefaults_NetAddress][kDefaults_POST_ADDR]
#define  API_BASE_URL            (ISPostAddress ?: API_BASE_URL_Internal)

#else

#define API_BASE_URL API_BASE_URL_Internal

#endif

#endif
