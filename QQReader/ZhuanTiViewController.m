//
//  ZhuanTiViewController.m
//  QQReader
//
//  Created by LcyLHt on 16/7/14.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import "ZhuanTiViewController.h"

#import "ZTTableViewCell.h"
#import "zhuantiModel.h"

#import "UIImageView+WebCache.h"
#import "MMProgressHUD.h"
#import "UIKit+AFNetworking.h"
#import "AFNetworking.h"



@interface ZhuanTiViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>

{
    UIView *_naviView;
    
    UIScrollView *_zhuantiScrollView;
    
    UITableView *_zuixinTableView;
    
    UITableView *_jingdianTableView;
    
    NSMutableArray *_zuixinDataSource;
    
    NSMutableArray *_jingdianDataSource;
    
    UIButton *_zuixinBtn;
    
    UIButton *_jingdianBtn;
    
    UIRefreshControl *_zuixinRefreshControl;
    
    UIRefreshControl *_jingdianRefreshControl;
    
    BOOL _zuixinIsLoading;
    
    BOOL _jingdianIsLoading;
    
}



@end

@implementation ZhuanTiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self customNavigationItem];
    
    [self createDataSource];
    
    [self createZTScrollview];
    
    [self createZXTableview];
    
    [self createJDTableview];
    
    [self createRefreshControl];
    
    [self analysizeZXData];
    
    [self analysizeJDData];
}


#pragma mark 定制导航

- (void)customNavigationItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"bookcity_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
    
    UIView *titView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 125, 30)];
    titView.layer.borderColor = [UIColor whiteColor].CGColor;
    titView.layer.borderWidth = 1;
    titView.layer.cornerRadius = 15;
    _naviView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 125/2, 30)];
    [titView addSubview:_naviView];
    _naviView.layer.cornerRadius = 15;
    _naviView.backgroundColor = [UIColor whiteColor];
    
    
    self.navigationItem.titleView = titView;
    
    _zuixinBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 125/2, 30)];
    [_zuixinBtn setTitle:@"最新" forState:UIControlStateNormal];
    _zuixinBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_zuixinBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [_zuixinBtn addTarget:self action:@selector(zuixinBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _jingdianBtn = [[UIButton alloc]initWithFrame:CGRectMake(125/2, 0, 125/2, 30)];
    [_jingdianBtn setTitle:@"经典" forState:UIControlStateNormal];
    _jingdianBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_jingdianBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [_jingdianBtn addTarget:self action:@selector(jingdianBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [titView addSubview:_zuixinBtn];
    [titView addSubview:_jingdianBtn];

    
    
}

- (void)leftBtnClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    self.tabBarController.tabBar.hidden = NO;
}


- (void)zuixinBtnClick{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    _zhuantiScrollView.contentOffset = CGPointMake(0, 0);
    [_zuixinBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [_jingdianBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [UIView commitAnimations];

}

- (void)jingdianBtnClick{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    _zhuantiScrollView.contentOffset = CGPointMake(375, 0);
    [_zuixinBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [_jingdianBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [UIView commitAnimations];
}

#pragma mark 创建数据源

- (void)createDataSource{
    _zuixinDataSource = [[NSMutableArray alloc]init];
    _jingdianDataSource = [[NSMutableArray alloc]init];
}


#pragma mark 创建专题scrollview

-(void)createZTScrollview{
    _zhuantiScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 375, 603)];
    _zhuantiScrollView.contentSize = CGSizeMake(375 * 2, 0);
    _zhuantiScrollView.bounces = NO;
    [self.view addSubview:_zhuantiScrollView];
    _zhuantiScrollView.showsHorizontalScrollIndicator = NO;
    _zhuantiScrollView.pagingEnabled = YES;
    
    _zhuantiScrollView.delegate = self;
//    _zhuantiScrollView.panGestureRecognizer.delegate = self;
    
}



#pragma mark 创建最新tableview

-(void)createZXTableview{
    _zuixinTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 375, 603) style:UITableViewStyleGrouped];
    [_zhuantiScrollView addSubview:_zuixinTableView];
    _zuixinTableView.delegate = self;
    _zuixinTableView.dataSource = self;
    
    _zuixinTableView.rowHeight = 160;
    
    [_zuixinTableView registerNib:[UINib nibWithNibName:@"ZTTableViewCell" bundle:nil] forCellReuseIdentifier:@"zuixincell"];
}



#pragma mark 创建经典tableview


-(void)createJDTableview{
    _jingdianTableView = [[UITableView alloc]initWithFrame:CGRectMake(375, 0, 375, 603) style:UITableViewStyleGrouped];
    [_zhuantiScrollView addSubview:_jingdianTableView];
    _jingdianTableView.delegate = self;
    _jingdianTableView.dataSource = self;
    
    _jingdianTableView.rowHeight = 160;
    
    [_jingdianTableView registerNib:[UINib nibWithNibName:@"ZTTableViewCell" bundle:nil] forCellReuseIdentifier:@"jingdiancell"];
}

-(void)createRefreshControl{
    _zuixinRefreshControl = [[UIRefreshControl alloc]init];
    _zuixinRefreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新成功"];
    
    [_zuixinTableView addSubview:_zuixinRefreshControl];
    [_zuixinRefreshControl addTarget:self action:@selector(zuxinRefresh) forControlEvents:UIControlEventValueChanged];
    
    
    _jingdianRefreshControl = [[UIRefreshControl alloc]init];
    _jingdianRefreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新成功"];
    
    [_jingdianTableView addSubview:_jingdianRefreshControl];
    [_jingdianRefreshControl addTarget:self action:@selector(jingdianRefresh) forControlEvents:UIControlEventValueChanged];
    
}

- (void)zuxinRefresh{
    if (_zuixinIsLoading == NO) {
        _zuixinIsLoading = YES;
        [self analysizeZXData];
    }
}

- (void)jingdianRefresh{
    if (_jingdianIsLoading == NO) {
        _jingdianIsLoading = YES;
        [self analysizeJDData];
    }
}


#pragma mark 刷新结束

- (void)zuixinLoadEnd{
    _zuixinIsLoading = NO;
    [_zuixinRefreshControl endRefreshing];
}

- (void)jingdianLoadEnd{
    _jingdianIsLoading = NO;
    [_jingdianRefreshControl endRefreshing];
}


#pragma mark scrollview协议方法

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == _zhuantiScrollView) {
        _naviView.frame = CGRectMake(scrollView.contentOffset.x/375 * 125/2, 0, 125/2, 30);
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _zhuantiScrollView) {
        if (scrollView.contentOffset.x == 0) {
            [_zuixinBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
            [_jingdianBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
        }
        else{
            [_jingdianBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
            [_zuixinBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
        }

    }
}


#pragma mark 最新页面数据解析

- (void)analysizeZXData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:@"http://ios.reader.qq.com/v5_9/listdispatch?page=1&action=topicstream&actionTag=0" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [_zuixinDataSource removeAllObjects];
        
        NSDictionary *superDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *infosArr = superDic[@"infos"];
        for (NSDictionary *infosDic in infosArr) {
            NSDictionary *infoDic = infosDic[@"info"];
            zhuantiModel *model = [[zhuantiModel alloc]init];
            model.title = infoDic[@"title"];
            model.desc = infoDic[@"desc"];
            NSArray *picsArr = infoDic[@"pics"];
            NSDictionary *picsDic = [picsArr firstObject];
            model.imageurl = picsDic[@"url"];
            
            [_zuixinDataSource addObject:model];
        }
        
        [_zuixinTableView reloadData];
        
        [self zuixinLoadEnd];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}


#pragma mark 经典页面数据解析

- (void)analysizeJDData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:@"http://ios.reader.qq.com/v5_9/listdispatch?page=1&action=topicstream&actionTag=1" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [_jingdianDataSource removeAllObjects];
        
        NSDictionary *superDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *infosArr = superDic[@"infos"];
        for (NSDictionary *infosDic in infosArr) {
            NSDictionary *infoDic = infosDic[@"info"];
            zhuantiModel *model = [[zhuantiModel alloc]init];
            model.title = infoDic[@"title"];
            model.desc = infoDic[@"desc"];
            NSArray *picsArr = infoDic[@"pics"];
            NSDictionary *picsDic = [picsArr firstObject];
            model.imageurl = picsDic[@"url"];
            
            [_jingdianDataSource addObject:model];
        }
        
        [_jingdianTableView reloadData];
        
        [self jingdianLoadEnd];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}


#pragma mark 返回组数

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _zuixinTableView) {
        return _zuixinDataSource.count;
    }
    else
        return _jingdianDataSource.count;
}

#pragma mark 返回每组行数

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

#pragma mark 调整头脚高度

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

#pragma mark 将数据显示到cell上，返回cell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _zuixinTableView) {
        ZTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zuixincell" forIndexPath:indexPath];
        
        cell.titleLabel.text = [_zuixinDataSource[indexPath.section] title];
        cell.descLabel.text = [_zuixinDataSource[indexPath.section] desc];
        
        cell.urlImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_zuixinDataSource[indexPath.section] imageurl]]]];
        
        return cell;
    }
    else{
        ZTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jingdiancell" forIndexPath:indexPath];
        
        cell.titleLabel.text = [_jingdianDataSource[indexPath.section] title];
        cell.descLabel.text = [_jingdianDataSource[indexPath.section] desc];
        
        cell.urlImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_jingdianDataSource[indexPath.section] imageurl]]]];
        
        return cell;
        
    }
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
