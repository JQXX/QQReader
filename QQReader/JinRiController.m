//
//  JinRiController.m
//  QQReader
//
//  Created by WangHao on 16/7/28.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import "JinRiController.h"

@interface JinRiController ()

@end

@implementation JinRiController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customNavigationItem];
}

#pragma mark 定制导航
- (void)customNavigationItem {
    self.navigationItem.title = @"今日免费";
    
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
