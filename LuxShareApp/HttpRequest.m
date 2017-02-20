//
//  HttpRequest.m
//  LuxShareApp
//
//  Created by MingMing on 17/2/9.
//  Copyright © 2017年 Luxshare. All rights reserved.
//

#import "HttpRequest.h"
#import "Header.h"

#define kManager AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];manager.responseSerializer = [AFHTTPResponseSerializer serializer];
@implementation HttpRequest

//获取头
+(void)getUrlHeader:(void (^)(NSString* str))complete{
    
    kManager;
    [manager GET:@"" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"IsSuccess"]integerValue] == 1) {
            NSString *str = [dic objectForKey:@"Data"];
            [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"url"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }else{
            [KPromptBox showKPromptBoxWithMassage:[NSString stringWithFormat:@"%@",[dic objectForKey:@"ErrMsg"]]];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [KPromptBox showKPromptBoxWithMassage:[NSString stringWithFormat:@"%@",error]];
    }];
    
    
}

//登录
+(void)sendLoginRequest:(NSString*)code pasword:(NSString*)password uuid:(NSString*)UUID completeWithData:(void (^)(BOOL isSuccess))complete{
    kManager;
    manager.requestSerializer.timeoutInterval = 10.0f;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:code forKey:@"code"];
    [dic setObject:password forKey:@"password"];
    [dic setObject:UUID forKey:@"UUID"];
    
    [manager POST:@"http://spc.luxshare-ict.com:19999/api/Account/Login" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dicData objectForKey:@"IsSuccess"]integerValue] == 1) {
            complete(YES);
        }else{
            complete(NO);
            [KPromptBox showKPromptBoxWithMassage:[NSString stringWithFormat:@"%@",[dic objectForKey:@"ErrMsg"]]];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        complete(NO);
        if (error.code == -1001) {
             [KPromptBox showKPromptBoxWithMassage:@"请求超时"];
        }
        [manager.operationQueue cancelAllOperations];
    }];

}



//获取主页的数据
+(void)getMianPageInfo:(NSString*)userName userPasword:(NSString*)pasword Success:(void(^)(MainModel*model))success Faile:(void(^)(NSString*str))faile{
    
    kManager;
    manager.requestSerializer.timeoutInterval = 10.0f;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:userName forKey:@"userName"];
    [dic setObject:pasword forKey:@"pasword"];
    
    NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:@"url"];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dicData objectForKey:@"IsSuccess"]integerValue] == 1) {
            //            success();
        }else{
            faile([dicData objectForKey:@"ErrMsg"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        faile([NSString stringWithFormat:@"%@",error]);
        [manager.operationQueue cancelAllOperations];
    }];
    
}
@end
