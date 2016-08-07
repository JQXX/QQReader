//
//  DiscoverController.m
//  QQReader
//
//  Created by WangHao on 16/7/8.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import "DiscoverController.h"

#import "RankViewController.h"
#import "ZoneListViewController.h"
#import "ZhuanTiViewController.h"
#import "BaoYueViewController.h"
#import "JinRiController.h"
#import "FameController.h"

#import "ShouYeTableViewCell.h"
#import "ShouYeTableViewModel.h"

#import "UIImageView+WebCache.h"
#import "MMProgressHUD.h"
#import "UIKit+AFNetworking.h"
#import "AFNetworking.h"

@interface DiscoverController ()<UITableViewDataSource,UITableViewDelegate>
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
/** Refresh */
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, assign, getter=isLoading) BOOL loading;
@end

@implementation DiscoverController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customNavigationBar];
    [self createDataSource];
    [self createTableView];
    [self createRefreshControl];
    [self analysizeData];
}

#pragma mark 创建数据源

- (void)createDataSource
{
    _dataSource = [[NSMutableArray alloc]init];
}

#pragma mark 创建tableView

- (void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 375, 554) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
    _tableView.rowHeight = 50;
    
    [_tableView registerNib:[UINib nibWithNibName:@"ShouYeTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShouYeTableViewCell"];
}

#pragma mark 下拉刷新
- (void)createRefreshControl
{
    _refreshControl = [[UIRefreshControl alloc]init];
    _refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新成功"];
    
    [_tableView addSubview:_refreshControl];
    [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
}

- (void)refresh:(UIRefreshControl*)refreshCotrl
{
    if (_loading == NO) {
        _loading = YES;
        [self analysizeData];
    }
}


#pragma mark 刷新结束
- (void)loadEnd
{
    _loading = NO;
    [_refreshControl endRefreshing];
}


#pragma mark 解析数据
- (void)analysizeData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://ios.reader.qq.com/v5_9/discover" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [_dataSource removeAllObjects];
        NSDictionary *superDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *listArr = superDic[@"list"];
        
        for (NSDictionary *listDic in listArr)
        {
            NSArray *adListArr = listDic[@"adList"];
            NSMutableArray *sectionArr = [[NSMutableArray alloc]init];
            
            for (NSDictionary *adListDic in adListArr) {
                ShouYeTableViewModel *model = [[ShouYeTableViewModel alloc]init];
                model.imageUrl = adListDic[@"imageUrl"];
                model.title = adListDic[@"title"];
                model.intro = adListDic[@"intro"];
                [sectionArr addObject:model];
            }
            
            [_dataSource addObject:sectionArr];
        }
        
        [_tableView reloadData];
        [self loadEnd];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}


#pragma mark - <UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 2;
    } else {
        return [_dataSource[section] count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShouYeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShouYeTableViewCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            cell.imgView.image = [UIImage imageNamed:@"found_icon_bookcomment"];
            cell.tetLabel.text = @"书评广场";
            cell.deTextLabel.text = @"大神进化论";
            cell.deTextLabel.textColor = [UIColor lightGrayColor];
        } else if (indexPath.row == 1){
            cell.imgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_dataSource[indexPath.section][indexPath.row-1] imageUrl]]]];
            cell.tetLabel.text = [_dataSource[indexPath.section][indexPath.row-1] title];
            cell.deTextLabel.text = [_dataSource[indexPath.section][indexPath.row-1] intro];
            cell.deTextLabel.textColor = [UIColor lightGrayColor];
        }
        
    } else {
        
        cell.imgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_dataSource[indexPath.section][indexPath.row] imageUrl]]]];
        cell.tetLabel.text = [_dataSource[indexPath.section][indexPath.row] title];
        cell.deTextLabel.text = [_dataSource[indexPath.section][indexPath.row] intro];
        cell.deTextLabel.textColor = [UIColor lightGrayColor];
    }
    
    return cell;
    
}

#pragma mark 点击cell跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        RankViewController *rankVC = [[RankViewController alloc]init];
        [self.navigationController pushViewController:rankVC animated:YES];
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            ZoneListViewController *zoneListVC = [[ZoneListViewController alloc]init];
            [self.navigationController pushViewController:zoneListVC animated:YES];
        } else if (indexPath.row == 1) {
            ZhuanTiViewController *ztVC = [[ZhuanTiViewController alloc]init];
            [self.navigationController pushViewController:ztVC animated:YES];
        }
        
    } else if (indexPath.section == 2){
        
        if (indexPath.row == 0) {
            BaoYueViewController *byVC = [[BaoYueViewController alloc]init];
            [self.navigationController pushViewController:byVC animated:YES];
        } else if (indexPath.row == 1) {
            JinRiController *jinRi = [[JinRiController alloc]init];
            [self.navigationController pushViewController:jinRi animated:YES];
        } else if (indexPath.row == 2) {
            FameController *fame = [[FameController alloc]init];
            [self.navigationController pushViewController:fame animated:YES];
        }
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark 定制导航
- (void)customNavigationBar
{
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed:@"toolbar_bkg"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.title = @"发现";
}

@end
