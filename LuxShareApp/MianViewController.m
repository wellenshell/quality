//
//  MianViewController.m
//  LuxShareApp
//
//  Created by MingMing on 17/2/9.
//  Copyright © 2017年 Luxshare. All rights reserved.
//

#import "MianViewController.h"
#import "Header.h"
@interface MianViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIScrollView *bigScrol;
    NSArray *titleAr ,*imgArr;
    UICollectionView * collect;
    UILabel* labYiChang ;
   
}
@property(nonatomic,strong)NSMutableArray*strArr;
@end

@implementation MianViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"立讯精密";
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //请求图片 文字 编号
       
    imgArr = [[NSArray alloc]initWithObjects:@"cangkubeiliao",@"songliao",@"pinzhibaobiao",@"QCjianyan",@"chengpinruku",nil];
    titleAr = [[NSArray alloc]initWithObjects:@"仓库备料",@"送料",@"品质报表",@"QC检验",@"成品入库", nil];
  
    [self creatScrol];
    
    UIButton* buttonPerson = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonPerson addTarget:self action:@selector(personButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [buttonPerson setBackgroundImage:[UIImage imageNamed:@"user"] forState:UIControlStateNormal];
    buttonPerson.sd_layout
    .rightSpaceToView(self.view,10)
    .topSpaceToView(self.view,20)
    .heightIs(30)
    .widthIs(30);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:buttonPerson];
    
    
    UIImageView*image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"Wall_Luxshare-ICT_OL"];
    image.frame = CGRectMake(0, 0, SCREENWIDTH/3, 44);
    [self.view addSubview:image];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:image];
   
}

-(void)personButtonClick{
    UIAlertController*alert = [UIAlertController alertControllerWithTitle:@"是否退出登录" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"key"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        if (_comfrom == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            LoginViewController*login = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:login animated:YES];
        }
        
    }];
    [alert addAction:action1];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        return ;
    }];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)creatScrol{
    
    bigScrol = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64)];
    bigScrol.showsVerticalScrollIndicator = NO;
    [self.view addSubview:bigScrol];
    
    NSMutableArray *images = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"pic1"],[UIImage imageNamed:@"pic2"],[UIImage imageNamed:@"pic3"],[UIImage imageNamed:@"pic4"], nil];
    SDCycleScrollView* scroll = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT*0.25) imageNamesGroup:images];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [bigScrol addSubview:scroll];
    [bigScrol addSubview:[self creatCollectionView]] ;
    
    //点击轮播图加载对应的内容
    scroll.clickItemOperationBlock = ^(NSInteger integer){
        NSLog(@"----%ld",integer);
    };
    
    
    if (titleAr.count%4 != /* DISABLES CODE */ (0)) {
        bigScrol.contentSize = CGSizeMake(SCREENWIDTH, 340+(titleAr.count/4+1)*((SCREENWIDTH-1)/4));
    }else{
        bigScrol.contentSize = CGSizeMake(SCREENWIDTH, 340+(titleAr.count/4)*((SCREENWIDTH-1)/4));
    }
    
}


//添加分区的瀑布流
-(UICollectionView*)creatCollectionView{
    if (!collect) {
        //创建一个layout布局类
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        //设置布局方向为垂直流布局
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake((SCREENWIDTH-0.5)/4, (SCREENWIDTH-0.5)/4);
        layout. minimumInteritemSpacing = 0.1;
        layout.minimumLineSpacing = 0.1;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //创建collectionView 通过一个布局策略layout来创建
        collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0.1,SCREENHEIGHT*0.25+0.1, SCREENWIDTH-0.2, 20+(titleAr.count/4+1)*((SCREENWIDTH-0.5)/4)) collectionViewLayout:layout];
        collect.scrollEnabled = NO;
        collect.backgroundColor = [UIColor whiteColor];
        
        //代理设置
        collect.delegate=self;
        collect.dataSource=self;
        //注册item类型 这里使用系统的类型
        [collect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    }
    return collect;
    
}


// 每个区有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return titleAr.count;
}
//加载每一个cell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell* cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    
    UIImageView*imagee = [cell viewWithTag:100];
    imagee.image = [UIImage imageNamed:@""];
    UILabel *labb = [cell viewWithTag:200];
    [labb removeFromSuperview];
    
    
    
    //设置cell的样式 标题和图片
    cell.layer.borderColor=[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1].CGColor;
    cell.layer.borderWidth= 1;
    
    
    //在cell上添加图片
    UIImageView *image = [[UIImageView alloc]init];
    image.tag = 100;
    image.image = [UIImage imageNamed:imgArr[indexPath.row]];
    image.userInteractionEnabled = YES;
    [cell addSubview:image];
    image.sd_layout
    .leftSpaceToView(cell,cell.frame.size.width/3)
    .widthIs(cell.frame.size.width/3)
    .heightEqualToWidth()
    .topSpaceToView(cell,20);
  
      
    //在cell上添加文字
    UILabel *lab  = [[UILabel alloc]init];
    lab.tag = 200;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont fontWithName:@"Helvetica" size:14];
    lab.textColor = [UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1];
    lab.text = titleAr[indexPath.item];
    [cell addSubview:lab];
    lab.sd_layout
    .leftSpaceToView(cell,0)
    .rightEqualToView(cell)
    .heightIs(30)
    .topSpaceToView(image,5);
    
    
    return cell;
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
  
    //获取到 谁 操作时间 操作的模块 手机的位置 当前的网络
    //找到model的链接
    ShowViewController*show = [[ShowViewController alloc]init];
    show.strUrl = @"";
    [self.navigationController pushViewController:show animated:YES];
   
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
