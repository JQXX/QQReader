//
//  ZoneListViewController.m
//  QQReader
//
//  Created by LcyLHt on 16/7/13.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import "ZoneListViewController.h"

#import "ZLPLModel.h"
#import "ZLBDModel.h"
#import "ZLGZTableViewCell.h"
#import "ZLPLTableViewCell.h"
#import "ZLBDTableViewCell.h"
#import "BDTableViewCell.h"


#import "UIImageView+WebCache.h"
#import "MMProgressHUD.h"
#import "UIKit+AFNetworking.h"
#import "AFNetworking.h"


@interface ZoneListViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    NSMutableArray *_RMPLDataSource;
    
    NSMutableArray *_HYDDataSource;
    
    UITableView *_zoneListTableView;
    
    UIView *_HDView;
    
    UIRefreshControl *_zoneListRefreshControl;
    
    BOOL _isLoading;
}


@end

@implementation ZoneListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self customNavigationItem];
    
    [self createDataSource];
    
    [self createView];
    
    [self createRefreshControl];
    
    [self analysizeData];
}

#pragma mark 定制导航

- (void)customNavigationItem {
    self.navigationItem.title = @"书评广场";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"bookcity_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
}

- (void)leftBtnClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = NO;
}


#pragma  mark 创建数据源

-(void)createDataSource{
    _RMPLDataSource = [[NSMutableArray alloc]init];
    _HYDDataSource = [[NSMutableArray alloc]init];
}

#pragma mark 创建view

- (void)createView{
    _zoneListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 375, 647) style:UITableViewStyleGrouped];
    [self.view addSubview:_zoneListTableView];
    _zoneListTableView.dataSource = self;
    _zoneListTableView.delegate = self;
    _zoneListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _HDView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 375, 140)];
    _HDView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _zoneListTableView.tableHeaderView = _HDView;
    
    [_zoneListTableView registerNib:[UINib nibWithNibName:@"ZLGZTableViewCell" bundle:nil] forCellReuseIdentifier:@"GZCell"];
    [_zoneListTableView registerNib:[UINib nibWithNibName:@"ZLPLTableViewCell" bundle:nil] forCellReuseIdentifier:@"PLCell"];
    [_zoneListTableView registerNib:[UINib nibWithNibName:@"ZLBDTableViewCell" bundle:nil] forCellReuseIdentifier:@"BDCell"];
    [_zoneListTableView registerNib:[UINib nibWithNibName:@"BDTableViewCell" bundle:nil] forCellReuseIdentifier:@"BDTVCell"];
    
    
}

-(void)createRefreshControl{
    _zoneListRefreshControl = [[UIRefreshControl alloc]init];
    _zoneListRefreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新成功"];
    
    [_zoneListTableView addSubview:_zoneListRefreshControl];
    [_zoneListRefreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)refresh:(UIRefreshControl*)refreshCotrl{
    if (_isLoading == NO) {
        _isLoading = YES;
        [self analysizeData];
    }
}

#pragma mark 刷新结束

- (void)loadEnd{
    _isLoading = NO;
    [_zoneListRefreshControl endRefreshing];
}


#pragma mark 解析数据

-(void)analysizeData{
    [self createHeaderView];
    [self analysizeRMPLData];
    [self analysizeHYDData];
    
    [self loadEnd];
}

#pragma mark 头视图创建

- (void)createHeaderView{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://ios.reader.qq.com/v5_9/nativepage/comment/zonelist" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *superDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *commonzonelistArr = superDic[@"commonzonelist"];
        for (int i = 0; i < commonzonelistArr.count; i++) {
            NSDictionary *commonzonelistDic = commonzonelistArr[i];
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(125*i, 0, 125, 120)];
            UIImageView *btnIView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 15, 40, 40)];
            btnIView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:commonzonelistDic[@"icon"]]]];
            UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(30, 60, 60, 30)];
            UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(30, 80, 60, 35)];
            
            label1.text = commonzonelistDic[@"title"];
            label2.text = [NSString stringWithFormat:@"%ld",[commonzonelistDic[@"commentcount"] integerValue]];
            label2.textAlignment = NSTextAlignmentCenter;
            
            label1.font = [UIFont systemFontOfSize:15];
            label2.font = [UIFont systemFontOfSize:12];
            
            [btn addSubview:btnIView];
            [btn addSubview:label1];
            [btn addSubview:label2];
            
            [btn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            btn.backgroundColor = [UIColor whiteColor];
            
            [_HDView addSubview:btn];
        }
        
        [_zoneListTableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

- (void)headBtnClick:(UIButton *)btn{
    
}


#pragma mark 评论视图

-(void)analysizeRMPLData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://ios.reader.qq.com/v5_9/nativepage/comment/zonelist" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *superDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        [_RMPLDataSource removeAllObjects];
        
        NSArray *hotcommentlistArr = superDic[@"hotcommentlist"];
        for (NSDictionary *hotcommentlistDic in hotcommentlistArr) {
            ZLPLModel *model = [[ZLPLModel alloc]init];
            NSDictionary *userDic = hotcommentlistDic[@"user"];
            model.plNickname = userDic[@"nickname"];
            model.plTitle = hotcommentlistDic[@"title"];
            model.plContent = hotcommentlistDic[@"content"];
            model.plPlatformname = hotcommentlistDic[@"platformname"];
            
            [_RMPLDataSource addObject:model];
        }
        [_zoneListTableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

#pragma mark 榜单视图

-(void)analysizeHYDData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://ios.reader.qq.com/v5_9/nativepage/comment/zonelist" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *superDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [_HYDDataSource removeAllObjects];
        
        NSArray *activitylistArr = superDic[@"activitylist"];
        for (NSDictionary *activitylistDic in activitylistArr) {
            ZLBDModel *model = [[ZLBDModel alloc]init];
            model.bdCover = activitylistDic[@"cover"];
            model.bdName = activitylistDic[@"name"];
            
            [_HYDDataSource addObject:model];
        }
        [_zoneListTableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

#pragma mark 返回组数

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

#pragma mark 返回每组行数

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    if (section == 1){
        return _RMPLDataSource.count;
    }
    else {
        return _HYDDataSource.count - 2;
    }
}



#pragma mark 调整高度

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 220;
    }
    if (indexPath.section ==1) {
        return 177;
    }
    else{
        if (indexPath.row == 0) {
            return 240;
        }
        else{
            return 60;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    
    return 55;
}


#pragma mark 定制组头组尾

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
    headLabel.backgroundColor = [UIColor whiteColor];
    headLabel.font = [UIFont systemFontOfSize:18];
    
    if (section == 0) {
        headLabel.text = @"      我关注的";
    }
    if (section == 1){
        headLabel.text = @"      热门评论";
    }
    if (section == 2) {
        headLabel.text = @"      活跃度排行榜";
    }
    return headLabel;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 375, 55)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIButton *footbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 375, 40)];
    footbtn.titleLabel.font = [UIFont systemFontOfSize:16];
    footbtn.backgroundColor = [UIColor whiteColor];
    [footbtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [footbtn setTitle:@"查看更多" forState:UIControlStateNormal];
    [footbtn addTarget:self action:@selector(footBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:footbtn];
    
    if (section == 0) {
        return nil;
    }
    else
        return view;
}

-(void)footBtnClick{
    
}

#pragma mark 数据显示

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ZLGZTableViewCell *gzcell = [tableView dequeueReusableCellWithIdentifier:@"GZCell" forIndexPath:indexPath];
        gzcell.gzLabel.text = @"关注喜欢的书评区";
        return gzcell;
    }
    if (indexPath.section == 1) {
        ZLPLTableViewCell *plcell = [tableView dequeueReusableCellWithIdentifier:@"PLCell" forIndexPath:indexPath];
        plcell.nicknameLabel.text = [_RMPLDataSource[indexPath.row] plNickname];
        plcell.titleLabel.text = [_RMPLDataSource[indexPath.row] plTitle];
        plcell.contentLabel.text = [_RMPLDataSource[indexPath.row] plContent];
        plcell.platformnameLabel.text = [_RMPLDataSource[indexPath.row] plPlatformname];
        return plcell;
    }
    else {
        if (indexPath.row == 0) {
            BDTableViewCell *bdcell = [tableView dequeueReusableCellWithIdentifier:@"BDTVCell" forIndexPath:indexPath];
            [bdcell.firBtn setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_HYDDataSource[0] bdCover]]]] forState:UIControlStateNormal];
            [bdcell.secBtn setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_HYDDataSource[1] bdCover]]]] forState:UIControlStateNormal];
            [bdcell.thBtn setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_HYDDataSource[2] bdCover]]]] forState:UIControlStateNormal];
            
            [bdcell.firBtn addTarget:self action:@selector(bdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bdcell.secBtn addTarget:self action:@selector(bdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bdcell.thBtn addTarget:self action:@selector(bdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            bdcell.firLabel.text = [_HYDDataSource[0] bdName];
            bdcell.secLabel.text = [_HYDDataSource[1] bdName];
            bdcell.thLabel.text = [_HYDDataSource[2] bdName];
            
            
            return bdcell;
        }
        else{
            ZLBDTableViewCell *bdcell = [tableView dequeueReusableCellWithIdentifier:@"BDCell" forIndexPath:indexPath];
            
            bdcell.coverImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_HYDDataSource[indexPath.row + 2] bdCover]]]];
            bdcell.nameLabel.text = [_HYDDataSource[indexPath.row + 2] bdName];
            
            bdcell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            return bdcell;
        }
    }
}

- (void)bdBtnClick:(UIButton *)btn{
    
}


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0);
{
    if (indexPath.section == 2 && indexPath.row == 0)
    {
        return NO;
    }
    
    return YES;
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
