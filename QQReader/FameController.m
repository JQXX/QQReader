//
//  MingRenTangViewController.m
//  QQReader
//
//  Created by mac on 16/7/12.
//  Copyright © 2016年 Karen. All rights reserved.
//

#import "FameController.h"
#import "UIImageView+WebCache.h"
#import "UIKit+AFNetworking.h"
#import "AFNetworking.h"
#import "HallList.h"
#import "Fames.h"
#import "FamesTableViewCell.h"
#import "AuthorViewController.h"

#define FENZU @"http://ios.reader.qq.com/v5_9/listdispatch?action=fame&actionTag=&actionId=%@&page=1"

@interface FameController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) NSMutableArray *hallListDataSource;
@property (strong,nonatomic) NSMutableArray *buttonDataSource;
@property (strong,nonatomic) NSMutableArray *famesDataSource;
@property (strong,nonatomic) NSMutableArray *moreDataSource;
@property (strong,nonatomic) UIScrollView *hallListScrollView;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) UITableView *moreTableView;
@end

@implementation FameController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createDataSource];
    [self customSrollView];
    [self customMoreTableView];
    [self customTableView];
    [self customNavigationItem];
    [self analysize];
    
    
}

#pragma mark - 数据源
- (void)createDataSource{
    self.hallListDataSource = [NSMutableArray array];
    self.buttonDataSource = [NSMutableArray array];
    self.famesDataSource = [NSMutableArray array];
    self.moreDataSource = [NSMutableArray array];
}

#pragma mark - 滚动视图
- (void)customSrollView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.hallListScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, 75, 603)];
    [self.view addSubview:self.hallListScrollView];
    self.hallListScrollView.backgroundColor = [UIColor whiteColor];
    self.hallListScrollView.showsVerticalScrollIndicator = NO;
}

- (void)customButton{
    for (int i = 0; i < self.hallListDataSource.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 45*i, 75, 44)];
        [self.hallListScrollView addSubview:button];
        [self setDeselected:button];
        [button setTitle:[self.hallListDataSource[i] name] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:51.0/255.0 green:161.0/255.0 blue:201.0/255.0 alpha:1] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonDataSource addObject:button];
    }
    UIButton *button = self.buttonDataSource.firstObject;
    [self setSelected:button];
}

- (void)buttonClick:(UIButton *)selectedButton{
    for (UIButton *button in self.buttonDataSource) {
        [self setDeselected:button];
    }
    [self setSelected:selectedButton];
}


- (void)setDeselected:(UIButton *)button{
    button.selected = NO;
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)setSelected:(UIButton *)button{
    button.selected = YES;
    button.backgroundColor = [UIColor whiteColor];
    [self analysizeTableViewData];
}

#pragma mark - 表格视图
- (void)customTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(75, 64, 300, 603) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"FamesTableViewCell" bundle:nil] forCellReuseIdentifier:@"famesCell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self customFooterView];
}

- (void)customFooterView{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 30)];
    label.text = @"没有更多了";
    label.enabled = NO;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12];
    self.tableView.tableFooterView = label;
}

- (void)customMoreTableView{
    self.moreTableView = [[UITableView alloc]initWithFrame:CGRectMake(75, 64, 300, 603) style:UITableViewStylePlain];
    [self.view addSubview:self.moreTableView];
    self.moreTableView.delegate = self;
    self.moreTableView.dataSource = self;
    self.moreTableView.showsVerticalScrollIndicator = NO;
}






#pragma mark dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        return  self.famesDataSource.count;
    }
    else{
        return self.moreDataSource.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        FamesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"famesCell" forIndexPath:indexPath];
        [cell customCell:self.famesDataSource[indexPath.row]];
        return cell;
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"moreCell"];
        }
        cell.textLabel.text = self.moreDataSource[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    }
}


#pragma mark delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        return 80;
    }
    else{
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        AuthorViewController *avc = [[AuthorViewController alloc]init];
        [self.navigationController pushViewController:avc animated:YES];
        avc.valuee = [self.famesDataSource[indexPath.row] valuee];
    }
}

#pragma mark - 解析
- (void)analysize{
    [self analysizeHallList];
}

- (void)analysizeHallList{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:FENZU,@""] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (!json) {
            return;
        }
        NSArray *halllist = json[@"halllist"];
        for (NSDictionary *dic in halllist) {
            HallList *model = [HallList hallListWithDic:dic];
            [self.hallListDataSource addObject:model];
        }
        self.hallListScrollView.contentSize = CGSizeMake(75, self.hallListDataSource.count*45-1);
        [self customButton];
        [self analysizeTableViewData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

- (void)analysizeTableViewData{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    static NSUInteger index;
    for (UIButton *button in self.buttonDataSource) {
        if (button.selected) {
            index = [self.buttonDataSource indexOfObject:button];
            break;
        }
    }
    [manager GET:[NSString stringWithFormat:FENZU,[self.hallListDataSource[index] identifier]] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (!json) {
            return;
        }
        if (index == self.buttonDataSource.count-1) {
            [self moreData:json];
        }
        else{
            [self famesData:json];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

- (void)famesData:(NSDictionary *)json{
    [self.famesDataSource removeAllObjects];
    NSDictionary *hall = json[@"hall"];
    NSArray *fames = hall[@"fames"];
    for (NSDictionary *dic in fames) {
        Fames *model = [Fames famesWithDic:dic];
        [self.famesDataSource addObject:model];
    }
    [self.tableView reloadData];
    [self.view bringSubviewToFront:self.tableView];
}

- (void)moreData:(NSDictionary *)json{
    [self.moreDataSource removeAllObjects];
    NSArray *names = json[@"names"];
    self.moreDataSource = [names mutableCopy];
    [self.moreTableView reloadData];
    [self.view bringSubviewToFront:self.moreTableView];
}


#pragma mark - 导航栏
- (void)customNavigationItem{
    self.navigationItem.title = @"名人堂";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self.moreTableView deselectRowAtIndexPath:[self.moreTableView indexPathForSelectedRow] animated:YES];
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
