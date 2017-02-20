//
//  ShowViewController.m
//  LuxShareApp
//
//  Created by MingMing on 17/2/10.
//  Copyright © 2017年 Luxshare. All rights reserved.
//

#import "ShowViewController.h"
#import "Header.h"
@interface ShowViewController ()
{
    UIWebView*web;
}
@end

@implementation ShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
     web = [[UIWebView alloc]init];
     [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.strUrl]]];
   
    [self.view addSubview:web];
    web.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view,20)
    .bottomEqualToView(self.view);
   
    
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
