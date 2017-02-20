//
//  LoginViewController.m
//  LuxShareApp
//
//  Created by MingMing on 17/2/9.
//  Copyright © 2017年 Luxshare. All rights reserved.
//

#import "LoginViewController.h"
#import "Header.h"
@interface LoginViewController ()<UITextFieldDelegate>
{
    
    UITextField *_tfName,*_tfPsw;
    UISwitch *_swi;
    
}

@end

@implementation LoginViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"用户登录";
    [self.navigationItem setHidesBackButton:YES];
    [self changeState];
}
//判断是否记住密码 并显示
-(void)changeState{
    
    NSString *on =[[NSUserDefaults standardUserDefaults]objectForKey:@"on"];
    //判断首先看是否已注销（如果注销就将输入框清空 wei置为off） 如果没有就判断上次swi是否打开（如果打开就将wei置为on 并且输入框有内容）
    NSString *name = [[NSUserDefaults standardUserDefaults]objectForKey:@"tfName"];
    NSString *psw = [[NSUserDefaults standardUserDefaults]objectForKey:@"tfPsw"];
    
    if (on) {
        _swi.on = YES;
        _tfName.text = name;
        _tfPsw.text = psw;
    }else{
        _swi.on = NO;
        _tfName.text = nil;
        _tfPsw.text = nil;
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatLoginView];
    [Public getInternetInfo];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
}

//添加视图
-(void)creatLoginView{
    
    UIImageView *imageLogin = [[UIImageView alloc]initWithFrame:CGRectMake(30, 70,self.view.frame.size.width-60, 80)];
    imageLogin.image = [UIImage imageNamed:@"luxshare_logo"];
    [self.view addSubview:imageLogin];
    
    
    
    _tfName = [[UITextField alloc]initWithFrame:CGRectMake(30, 200, self.view.frame.size.width-60, 40)];
    _tfName.placeholder = @"请输入用户名";
    _tfName.borderStyle = UITextBorderStyleBezel;
    _tfName.tag = 10;
    _tfName.clearButtonMode = UITextFieldViewModeUnlessEditing;
    _tfName.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user"]];
    _tfName.leftViewMode = UITextFieldViewModeAlways;
    _tfName.delegate = self;
    [self.view addSubview:_tfName];
    
    
    
    _tfPsw = [[UITextField alloc]initWithFrame:CGRectMake(30, _tfName.frame.origin.y+60, self.view.frame.size.width-60, 40)];
    _tfPsw.placeholder = @"请输入密码";
    _tfPsw.borderStyle = UITextBorderStyleBezel;
    _tfPsw.tag = 20;
    _tfPsw.delegate = self;
    _tfPsw.secureTextEntry = YES;
    _tfPsw.clearButtonMode = UITextFieldViewModeUnlessEditing;
    _tfPsw.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password"]];
    _tfPsw.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_tfPsw];
    

    
    UILabel *lab = [[UILabel alloc]init];
    lab.text = @"记住我";
    lab.font = [UIFont systemFontOfSize:13];
    lab.textColor = [UIColor blackColor];
    [self.view addSubview:lab];
    
    lab.sd_layout
    .rightSpaceToView(self.view,110)
    .topSpaceToView(_tfPsw,25)
    .heightIs(30)
    .widthIs(40);
    
    
    _swi = [[UISwitch alloc]init];
    _swi.onTintColor
    = [UIColor colorWithRed:31.0/255.0 green:120.0/255.0 blue:189.0/255.0 alpha:1];
    [self.view addSubview:_swi];
    
    _swi.sd_layout
    .rightSpaceToView(self.view,40)
    .topSpaceToView(_tfPsw,25)
    .heightIs(30)
    .widthIs(70);
    
    
    UIButton *button = [[UIButton alloc]init];
    [button setBackgroundColor:[UIColor colorWithRed:31.0/255.0 green:120.0/255.0 blue:189.0/255.0 alpha:1]];
    [button setTitle:@"登录" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 10;
    [self.view addSubview:button];
    
    button.sd_layout
    .leftSpaceToView(self.view,50)
    .rightSpaceToView(self.view,50)
    .topSpaceToView(_swi,30)
    .heightIs(40);
    
    
    NSString *strVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    UILabel*labVersion = [[UILabel alloc]init];
    labVersion.text = [NSString stringWithFormat:@"当前版本%@",strVersion];
    labVersion.textColor = [UIColor colorWithRed:31.0/255.0 green:120.0/255.0 blue:189.0/255.0 alpha:1];
    labVersion.textAlignment = NSTextAlignmentCenter;
    labVersion.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:labVersion];
    labVersion.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(25)
    .bottomSpaceToView(self.view,10);
    
}

-(void)buttonClick{
    
    if (_tfName.text.length == 0 || _tfPsw.text.length == 0) {
        [KPromptBox showKPromptBoxWithMassage:@"账号和密码不能为空"];
    }else{
        
        NSString *newString = [_tfName.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *newPsw = [_tfPsw.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        // 判断输入的字符串中是否含有最特殊字符 进行处理
        NSString *str1 =@"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
        NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str1];
        if (![emailTest evaluateWithObject:newString]) {
            [KPromptBox showKPromptBoxWithMassage:@" 请检查输入是否正确! 请不要含有空格等特殊字符"];
            
            return;
        }
        unichar c = [newString characterAtIndex:0];
        if (c >=0x4E00 && c <=0x9FFF)
        {
            [KPromptBox showKPromptBoxWithMassage:@"请输入正确的工号"];
            return;
        }else{
            [SVProgressHUD showWithStatus:@"努力登录中..."];
                        
            
            NSString *UUID = [Public getUUID];
            [HttpRequest sendLoginRequest:newString pasword:newPsw uuid:UUID completeWithData:^(BOOL isSuccess) {
                // 登录成功
                if (isSuccess == YES) {
                    if (_swi.on == YES) {
                        
                        //只是为了判断是否打开
                        [[NSUserDefaults standardUserDefaults]setObject:@"on" forKey:@"on"];
                    }else{
                        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"on"];
                    }
                    
                    [SVProgressHUD dismiss];
                    MianViewController*home = [[MianViewController alloc]init];
                    home.comfrom = 1;
                    [self.navigationController pushViewController:home animated:YES];
            
                    //将账号密码存储在本地
                    [[NSUserDefaults standardUserDefaults]setObject:[[newString capitalizedString] stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"tfName"];
                    [[NSUserDefaults standardUserDefaults]setObject:[newPsw stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"tfPsw"];
                    NSLog(@"---%@---%@",[[newString capitalizedString] stringByReplacingOccurrencesOfString:@" " withString:@""],[newPsw stringByReplacingOccurrencesOfString:@" " withString:@""]);
                    
                    //退出登录的时候删除
                    [[NSUserDefaults standardUserDefaults]setObject:@"key" forKey:@"key"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                  
                    
                }else{
                    
                    [SVProgressHUD dismiss];
                    
                }
            }];
        }
        
        
    }
    
    
}

//按回车键时输入框的光标移移动
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 10) {
        
        [_tfName resignFirstResponder];
        [_tfPsw  becomeFirstResponder];
        
    }else{
        [_tfPsw resignFirstResponder];
    }
    
    return YES;
}










- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
