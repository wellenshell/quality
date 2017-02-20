//
//  HttpRequest.h
//  LuxShareApp
//
//  Created by MingMing on 17/2/9.
//  Copyright © 2017年 Luxshare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainModel.h"
@interface HttpRequest : NSObject
//获取头
+(void)getUrlHeader:(void (^)(NSString* str))complete;
//登录
+(void)sendLoginRequest:(NSString*)code pasword:(NSString*)password uuid:(NSString*)UUID completeWithData:(void (^)(BOOL isSuccess))complete;
//获取主页的数据
+(void)getMianPageInfo:(NSString*)userName userPasword:(NSString*)pasword Success:(void(^)(MainModel*model))success Faile:(void(^)(NSString*str))faile;
@end
