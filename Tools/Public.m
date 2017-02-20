//
//  Public.m
//  NewAPP
//
//  Created by MingMing on 16/11/2.
//  Copyright © 2016年 Luxshare. All rights reserved.
//

#import "Public.h"
#import <Security/Security.h>
#import "Header.h"
#import <SystemConfiguration/CaptiveNetwork.h>
//在Keychain中的标识，这里取bundleIdentifier + UUID
#define KEYCHAIN_IDENTIFIER(a)  ([NSString stringWithFormat:@"%@_%@",[[NSBundle mainBundle] bundleIdentifier],a])

#define isNull(a) (a==nil ||\
a==NULL ||\
(NSNull *)(a)==[NSNull null] ||\
((NSString *)a).length==0)

@implementation Public
//适配字体大小
+(CGFloat)fontWithDevice:(CGFloat)fontSize{
    float with = [UIScreen mainScreen].bounds.size.width;
    if (with>375) {
        fontSize = fontSize+3;
    }else if (with == 375){
        fontSize = fontSize+1.5;
    }else if (with == 320){
        fontSize = fontSize;
    }
    return fontSize;
}


//获取设备UUID
+ (NSString *)getUUID
{
    //读取keychain缓存
    NSString *deviceID = [self load:KEYCHAIN_IDENTIFIER(@"UUID")];
    //不存在，生成UUID
    if (isNull(deviceID))
    {
        CFUUIDRef uuid_ref = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef uuid_string_ref= CFUUIDCreateString(kCFAllocatorDefault, uuid_ref);
        
        CFRelease(uuid_ref);
        deviceID = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
        deviceID = [deviceID lowercaseString];
        if (!isNull(deviceID))
        {
            [self save:KEYCHAIN_IDENTIFIER(@"UUID") data:deviceID];
        }
        CFRelease(uuid_string_ref);
    }
    if (isNull(deviceID)) {
        NSLog(@"get deviceID error!");
    }
    return deviceID;
}


+ (void)deleteDeviceID
{
    [self delete:KEYCHAIN_IDENTIFIER(@"UUID")];
    [self delete:KEYCHAIN_IDENTIFIER(@"OpenUDID")];
}


#pragma mark - Private Method Keychain相关
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)(kSecClassGenericPassword),kSecClass,
            service, kSecAttrService,
            service, kSecAttrAccount,
            kSecAttrAccessibleAfterFirstUnlock,kSecAttrAccessible,nil];//第一次解锁后可访问，备份
}

+ (void)save:(NSString *)service data:(id)data
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge CFDictionaryRef)(keychainQuery));
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data]
                      forKey:(__bridge id<NSCopying>)(kSecValueData)];
    SecItemAdd((__bridge CFDictionaryRef)(keychainQuery), NULL);
}

+ (id)load:(NSString *)service
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id<NSCopying>)(kSecReturnData)];
    [keychainQuery setObject:(__bridge id)(kSecMatchLimitOne) forKey:(__bridge id<NSCopying>)(kSecMatchLimit)];
    
    CFTypeRef result = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, &result) == noErr)
    {
        ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData*)result];
    }
    return ret;
}

+ (void)delete:(NSString *)service
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge CFDictionaryRef)(keychainQuery));
}


//判断是否有网
+(void)getInternetInfo;{
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [KPromptBox showKPromptBoxWithMassage:@"您已断开网络连接"];
            
        }else if(status == AFNetworkReachabilityStatusReachableViaWWAN){
            [KPromptBox showKPromptBoxWithMassage:@"您现在使用的是蜂窝移动数据"];
        }else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
            NSDictionary *dict = [self SSIDInfo];
            NSString *SSID = dict[@"SSID"];
            [KPromptBox showKPromptBoxWithMassage:[NSString stringWithFormat:@"当前的wifi为%@",SSID]];
        }
    }];
}
//获取wifi名称
+(NSDictionary *)SSIDInfo{
    
    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
    NSDictionary *info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    return info;
}

@end
