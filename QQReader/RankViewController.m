//
//  RankViewController.m
//  QQReader
//
//  Created by LcyLHt on 16/7/13.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import "RankViewController.h"


#import "RankModel.h"
#import "RankTableViewCell.h"

#import "UIImageView+WebCache.h"
#import "MMProgressHUD.h"
#import "UIKit+AFNetworking.h"
#import "AFNetworking.h"

@interface RankViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    NSMutableArray *_rankDataSource;
    
    UITableView *_rankTableView;
    
    UIImageView *_rankHeadImageView;
    
    UIRefreshControl *_rankRefreshControl;
    
    BOOL _isLoading;
}


@end

@implementation RankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self customNavigationItem];
    
    [self createRankDS];
    
    [self createTableView];
    
    [self createRefreshControl];
    
    [self analysizeRankData];
}

#pragma mark 定制导航

- (void)customNavigationItem {
    self.navigationItem.title = @"排行榜";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"bookcity_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
}

- (void)leftBtnClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark 创建数据源

-(void)createRankDS{
    _rankDataSource = [[NSMutableArray alloc]init];
}

#pragma mark 创建tableview

- (void)createTableView{
    _rankTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 375, 647) style:UITableViewStyleGrouped];
    
    _rankTableView.dataSource = self;
    _rankTableView.delegate = self;
    
    [self.view addSubview:_rankTableView];
    
    _rankTableView.rowHeight = 85;
    
    _rankHeadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 375, 90)];
    _rankTableView.tableHeaderView = _rankHeadImageView;
    
    [_rankTableView registerNib:[UINib nibWithNibName:@"RankTableViewCell" bundle:nil] forCellReuseIdentifier:@"RankTableViewCell"];

}

#pragma mark 下拉刷新

-(void)createRefreshControl{
    _rankRefreshControl = [[UIRefreshControl alloc]init];
    _rankRefreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新成功"];
    
    [_rankTableView addSubview:_rankRefreshControl];
    [_rankRefreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)refresh:(UIRefreshControl*)refreshCotrl{
    if (_isLoading == NO) {
        _isLoading = YES;
        [self analysizeRankData];
    }
}

#pragma mark 刷新结束

- (void)loadEnd{
    _isLoading = NO;
    [_rankRefreshControl endRefreshing];
}


#pragma mark 解析数据

-(void)analysizeRankData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:@"http://ios.reader.qq.com/v5_9/queryindexrank" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [_rankDataSource removeAllObjects];
        NSArray *imgNameArr = @[@"Leaderboard_original",@"Leaderboard_research",@"Leaderboard_sellwell",@"Leaderboard_new",@"Leaderboard_month",@"Leaderboard_shang",@"Leaderboard_finish",@"Leaderboard_wangwen"];
        
        NSDictionary *superDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *colsArr = superDic[@"cols"];
        for (int i = 0; i < colsArr.count; i++) {
            NSDictionary *colsDic = colsArr[i];
            NSArray *bookListArr = colsDic[@"bookList"];
            RankModel *model = [[RankModel alloc]init];
            
            model.imgName = imgNameArr[i];
            model.firstText = bookListArr[0][@"title"];
            model.secondText = bookListArr[1][@"title"];
            model.thirdText = bookListArr[2][@"title"];
            
            [_rankDataSource addObject:model];
        }
        
        [_rankTableView reloadData];
        
        [self loadEnd];
        
        NSDictionary *adsDic = superDic[@"ads"];
        NSArray *adListArr = adsDic[@"adList"];
        NSDictionary *adListDic = [adListArr firstObject];
        _rankHeadImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:adListDic[@"imageUrl"]]]];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
    
    
}

#pragma mark 返回组数

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _rankDataSource.count;
}

#pragma mark 返回每组行数

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

#pragma mark 调整头脚高度

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}



#pragma mark 将数据显示到cell上，返回cell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RankTableViewCell" forIndexPath:indexPath];
    
    cell.imgView.image = [UIImage imageNamed:[_rankDataSource[indexPath.section] imgName]];
    cell.firstLabel.text = [_rankDataSource[indexPath.section] firstText];
    cell.secondLabel.text = [_rankDataSource[indexPath.section] secondText];
    cell.thirdLabel.text = [_rankDataSource[indexPath.section] thirdText];
    
    return cell;
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
