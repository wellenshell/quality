//
//  Public.h
//  NewAPP
//
//  Created by MingMing on 16/11/2.
//  Copyright © 2016年 Luxshare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Public : NSObject


//适配字体大小
+(CGFloat)fontWithDevice:(CGFloat)fontSize;
//获取设备UUID
+ (NSString *)getUUID;
//判断是否有网
+(void)getInternetInfo;


@end
