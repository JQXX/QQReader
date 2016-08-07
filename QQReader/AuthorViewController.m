//
//  AuthorViewController.m
//  QQReader
//
//  Created by mac on 16/7/13.
//  Copyright © 2016年 Karen. All rights reserved.
//

#import "AuthorViewController.h"
#import "UIKit+AFNetworking.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "Author.h"
#import "AuthorCell.h"
#import "HeaderView.h"

#define MINGREN @"http://ios.reader.qq.com/v5_9/topic?tid=%@&itemid=undefined&formatTime=1&rtt=0&sid=1467942794152216&usid=SJ6FUHeBf5Lcl3eJLGu2CNiElpjElij6CgF3j9a_IXJdmeJ1amzEuYZkFt3NKlwc23MLWGwQDrV_DRvjl0QCMduGTL1I-6stoo2Jky5mN0U&version=qqreader_5.9.0.0188_iphone&origin=304114&qimei=02bde5c8-f0ad-40ab-9e43-8d299f1a5a18&loginType=2&uid=115002655232&tt=8680"

@interface AuthorViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) NSMutableArray *dataSource;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) HeaderView *headerView;
@property (strong,nonatomic) UIButton *naviButton;
@end

@implementation AuthorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createDataSource];
    [self customTableView];
    [self customNavigationItem];
    [self analysize];
}

#pragma mark - 数据源
- (void)createDataSource{
    self.dataSource = [NSMutableArray array];
}

#pragma mark - 表格视图
- (void)customTableView{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"AuthorCell" bundle:nil] forCellReuseIdentifier:@"authorCell"];
    self.tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
    self.tableView.showsVerticalScrollIndicator = NO;
}

- (void)customHeaderView{
    self.headerView = [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:nil options:nil].firstObject;
    self.headerView.frame = CGRectMake(0, -self.headerView.frame.size.height, 375, self.headerView.frame.size.height);
    [self.tableView addSubview:self.headerView];
}


#pragma mark dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count-1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AuthorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"authorCell" forIndexPath:indexPath];
    [cell customCell:self.dataSource[indexPath.row+1]];
    return cell;
}

#pragma mark delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

#pragma mark scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    self.headerView.frame = CGRectMake(0, self.tableView.contentOffset.y, 375, -self.tableView.contentOffset.y);
    if (self.tableView.contentOffset.y > -64) {
        self.headerView.frame = CGRectMake(0, self.tableView.contentOffset.y, 375, 64);
        self.naviButton.enabled = YES;
    } else {
        self.naviButton.enabled = NO;
    }
    
    [self.headerView changeSize];
}

#pragma mark - 解析
- (void)analysize{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:MINGREN,self.valuee] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (!json) {
            return;
        }
        NSDictionary *topic = json[@"topic"];
        NSArray *elements = topic[@"elements"];
        Author *naviModel = [Author authorWithDic:elements.firstObject];
        Author *model = [Author authorWithDic:elements[1]];
        [self.dataSource addObject:naviModel];
        [self.dataSource addObject:model];
        for (int i = 0; i < 100; i++) {
            NSDictionary *testDic = @{@"title":[NSString stringWithFormat:@"TEST - %.2d",i+1]};
            Author *testModel = [Author authorWithDic:testDic];
            [self.dataSource addObject:testModel];//---------------------------------------------test
        }
        [self.tableView reloadData];
        [self customHeaderView];
        [self.headerView customHeaderView:self.dataSource.firstObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
    
}

- (void)customNavigationItem{
    self.naviButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 42, 42)];
    self.naviButton.layer.cornerRadius = 21;
    self.navigationItem.titleView = self.naviButton;
    [self.naviButton addTarget:self action:@selector(naviButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.naviButton.enabled = NO;
}


- (void)naviButtonClick:(UIButton *)button{
    [self.tableView setContentOffset:CGPointMake(0, -264) animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.subviews.firstObject.alpha = 0;
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.subviews.firstObject.alpha = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
