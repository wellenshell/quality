//
//  AppDelegate.h
//  LuxShareApp
//
//  Created by MingMing on 17/2/9.
//  Copyright © 2017年 Luxshare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

static NSString *appKey = @"530a3f0481a88faebfd43f47";
static NSString *channel = @"channel";
static BOOL isProduction = NO;
@interface AppDelegate : UIResponder <UIApplicationDelegate,AMapLocationManagerDelegate>
@property(nonatomic,strong)AMapLocationManager*locationManager;
@property (strong, nonatomic) UIWindow *window;


@end

