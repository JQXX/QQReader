//
//  BaoYueViewController.m
//  QQReader
//
//  Created by LcyLHt on 16/7/15.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import "BaoYueViewController.h"

@interface BaoYueViewController ()

@end

@implementation BaoYueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self customNavigationItem];
    
}

#pragma mark 定制导航

- (void)customNavigationItem {
    self.navigationItem.title = @"男生包月";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"bookcity_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
}

- (void)leftBtnClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = NO;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
