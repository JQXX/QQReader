//
//  StackController.m
//  QQReader
//
//  Created by WangHao on 16/7/8.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import "StackController.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "StackTableViewCell.h"
#import "StackModel.h"
#import "MyScrollView.h"
#import "FenLeiViewController.h"

@interface StackController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    MyScrollView *_mainScrollView;
    UIScrollView *_HeaderScrollView;
    UITableView *_tableViewLeft;
    UITableView *_tableviewRight;
    NSMutableArray *_dataSource1;
    NSMutableArray *_dataSource2;
    NSMutableArray *_dataSource3;
    NSMutableArray *_dataSource4;
    UIPageControl *_pagec;
    UIButton *_btnLeft;
    UIButton *_btnRight;
    UIView *_naviView;
}
@end

@implementation StackController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"toolbar_bkg"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    [self createDataSource];
    [self afnetWorkingAnalysizeTableViewLeft];
    [self afnetWorkingAnalysizeTableViewRight];
    [self createHeaderViewSegment];
    [self createMainScroolView];
    [self crateTableViewLeft];
    [self createHeadScrollView];
    [self createRightTableView];

    
    
}
#pragma mark 创建数据源
- (void)createDataSource{
    _dataSource1 = [[NSMutableArray alloc]init];
    _dataSource2 = [[NSMutableArray alloc]init];
    _dataSource3 = [[NSMutableArray alloc]init];
    _dataSource4 = [[NSMutableArray alloc]init];

}
#pragma mark 创建导航栏标题视图
- (void)createHeaderViewSegment{
    UIView *viewNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 175, 30)];
    
    viewNavi.layer.borderColor = [UIColor whiteColor].CGColor;
    viewNavi.layer.borderWidth = 1;
    viewNavi.layer.cornerRadius = 15;
    _naviView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 175/2, 30)];
    [viewNavi addSubview:_naviView];
    _naviView.layer.cornerRadius = 15;
    _naviView.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = viewNavi;
    
    _btnLeft = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 175/2, 30)];
    [_btnLeft setTitle:@"出版图书" forState:UIControlStateNormal];
    _btnLeft.titleLabel.font = [UIFont systemFontOfSize:15];
    [_btnLeft setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [_btnLeft addTarget:self action:@selector(btnLeftBeClicked) forControlEvents:UIControlEventTouchUpInside];
    _btnRight = [[UIButton alloc]initWithFrame:CGRectMake(175/2, 0, 175/2, 30)];
    [_btnRight setTitle:@"原创文学" forState:UIControlStateNormal];
    _btnRight.titleLabel.font = [UIFont systemFontOfSize:15];
    [_btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnRight addTarget:self action:@selector(btnRightBeClicked) forControlEvents:UIControlEventTouchUpInside];
    [viewNavi addSubview:_btnLeft];
    [viewNavi addSubview:_btnRight];

}
- (void)btnLeftBeClicked{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    _mainScrollView.contentOffset = CGPointMake(0, 0);
    [_btnLeft setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [_btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [UIView commitAnimations];
}
- (void)btnRightBeClicked{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    _mainScrollView.contentOffset = CGPointMake(375, 0);
    [_btnRight setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [_btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [UIView commitAnimations];
}
#pragma mark 创建主滚动视图
- (void)createMainScroolView{
    _mainScrollView = [[MyScrollView alloc]initWithFrame:CGRectMake(0, 0, 375, 554)];
    _mainScrollView.contentSize = CGSizeMake(375*2, 0);
    _mainScrollView.bounces = NO;
    [self.view addSubview:_mainScrollView];
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.delegate = self;
    
}


#pragma mark 创建左边TableView
- (void)crateTableViewLeft{
    _tableViewLeft = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 375, 554) style:UITableViewStylePlain];
    [_mainScrollView addSubview:_tableViewLeft];
    _tableViewLeft.delegate = self;
    _tableViewLeft.dataSource = self;
    [_tableViewLeft registerNib:[UINib nibWithNibName:@"StackTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellLeft"];
}
#pragma mark 创建头部滚动视图
- (void)createHeadScrollView{
    _HeaderScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 375, 100)];
    _HeaderScrollView.contentSize = CGSizeMake(375*6, 0);
    _HeaderScrollView.contentOffset = CGPointMake(375, 0);
    _tableViewLeft.tableHeaderView = _HeaderScrollView;
    _HeaderScrollView.pagingEnabled = YES;
    _HeaderScrollView.showsHorizontalScrollIndicator = NO;
    _HeaderScrollView.delegate = self;
    [self afnetWorkingAnalysize];
    [self createPageControl];
}
#pragma mark 创建右边TableView
- (void)createRightTableView{
    _tableviewRight = [[UITableView alloc]initWithFrame:CGRectMake(375, 0, 375, 554) style:UITableViewStylePlain];
    [_mainScrollView addSubview:_tableviewRight];
    _tableviewRight.delegate = self;
    _tableviewRight.dataSource = self;
    [_tableviewRight registerNib:[UINib nibWithNibName:@"StackTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellRight"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
#pragma mark tableView协议方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _mainScrollView) {
        _naviView.frame = CGRectMake(_mainScrollView.contentOffset.x/375*175/2, 0, 175/2, 30);
        if (_mainScrollView.contentOffset.x == 0) {
            [_btnLeft setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
        }
        else if (_mainScrollView.contentOffset.x == 375){
            [_btnRight setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
        }
        else{
            [_btnLeft setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_btnRight setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _tableViewLeft) {
        if (_dataSource1.count == 0) {
            return nil;
        }
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 375, 25)];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 15, 15)];
        imageView.image = [UIImage imageNamed:@"bookstacks_book"];
        [headView addSubview:imageView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(24, 5, 250, 15)];
//        NSString *str100 = [NSString stringWithFormat:@"出版分类共%@册，本周新增%@册",_dataSource1[0],_dataSource1[1]];
//        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:str100];
//        attributedStr addAttributes:{[]} range:<#(NSRange)#>
        label.text = [NSString stringWithFormat:@"出版分类共%@册，本周新增%@册",_dataSource1[0],_dataSource1[1]];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:12];
        headView.backgroundColor = [UIColor whiteColor];
        [headView addSubview:label];
        return headView;
    }
    else{
        if (section == 0) {
            UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 375, 25)];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 15, 15)];
            imageView.image = [UIImage imageNamed:@"bookstacks_book"];
            [headView addSubview:imageView];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(24, 5, 250, 15)];
            label.text = [NSString stringWithFormat:@"出版分类共%@册，本周新增%@册",_dataSource3[0][0],_dataSource3[0][1]];
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:12];
            headView.backgroundColor = [UIColor whiteColor];
            [headView addSubview:label];
            return headView;
        }
        else{
            UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 375, 25)];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, 175, 15)];
            label.text = _dataSource3[1][0];
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            headView.backgroundColor = [UIColor whiteColor];
            [headView addSubview:label];
            return headView;
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _tableViewLeft) {
        return 1;
    }
    else{
        return _dataSource4.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableViewLeft) {
        return _dataSource2.count;
    }
    else{
        return [_dataSource4[section] count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableViewLeft) {
        StackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellLeft" forIndexPath:indexPath];
        StackModel *model = _dataSource2[indexPath.row];
        [cell setModel:model];
        return cell;
    }
    else{
        StackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellRight" forIndexPath:indexPath];
        StackModel *model = _dataSource4[indexPath.section][indexPath.row];
        [cell setModel:model];
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

#pragma mark ScrollView协议方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _mainScrollView) {
        if (_mainScrollView.contentOffset.x == 375) {
            [_btnRight setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
            [_btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else{
            [_btnLeft setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
            [_btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    else{
        if (_HeaderScrollView.contentOffset.x > 4*375) {
            _HeaderScrollView.contentOffset = CGPointMake(375, 0);
        }
        else if (_HeaderScrollView.contentOffset.x < 375){
            _HeaderScrollView.contentOffset = CGPointMake(4*375, 0);
        }
        _pagec.currentPage = _HeaderScrollView.contentOffset.x/375 - 1;
    }
}
#pragma mark 解析头视图数据
- (void)afnetWorkingAnalysize{
    NSArray *imgArr = @[@"http://wfqqreader.3g.qq.com/cover/topic/119201207_67491699_1466422364238.jpg",@"http://wfqqreader.3g.qq.com/cover/topic/119201207_67768965_1467887249771.jpg",@"http://wfqqreader.3g.qq.com/cover/topic/119201207_67768964_1467887147498.jpg",@"http://wfqqreader.3g.qq.com/cover/topic/119201207_67768945_1467886597775.jpg",@"http://wfqqreader.3g.qq.com/cover/topic/119201207_67491699_1466422364238.jpg",@"http://wfqqreader.3g.qq.com/cover/topic/119201207_67768965_1467887249771.jpg"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://qt.qq.com/static/pages/news/phone/c12_list_1.shtml" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //成功获取数据后的处理
        for (int i = 0; i < imgArr.count; i++) {
            NSURL *imgUrl = [NSURL URLWithString:imgArr[i]];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*375, 0, 375, 100)];
            [imageView sd_setImageWithURL:imgUrl placeholderImage:nil];
            [_HeaderScrollView addSubview:imageView];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark 解析左边tableView数据
- (void)afnetWorkingAnalysizeTableViewLeft{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://ios.reader.qq.com/v5_9/category" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //成功获取数据后的处理
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (dic == nil) {
            return ;
        }

        NSString *str1 = [NSString stringWithString:[dic[@"count"][@"bookCount"] stringValue]];
        NSString *str2 = [NSString stringWithString:[dic[@"count"][@"newBookCount"] stringValue]];
        [_dataSource1 addObject:str1];
        [_dataSource1 addObject:str2];
        
        NSArray *arr1 = dic[@"publishCategoryList"];
        for (NSDictionary *d in arr1) {
            StackModel *model = [[StackModel alloc]init];
            model.categoryName = d[@"categoryName"];
            model.level3categoryName = d[@"level3categoryName"];
            model.imgUrl = d[@"img"];
            model.bookCount = [d[@"bookCount"] stringValue];
            [_dataSource2 addObject:model];
        }
        
        [_tableViewLeft reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
#pragma mark 解析右边tableView数据
- (void)afnetWorkingAnalysizeTableViewRight{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://ios.reader.qq.com/v5_9/category?categoryflag=1" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //成功获取数据后的处理
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (dic == nil) {
            return ;
        }
        
        NSMutableArray *arrZhuTou2 = [[NSMutableArray alloc]init];
        NSString *str1 = [NSString stringWithString:[dic[@"count"][@"bookCount"] stringValue]];
        NSString *str2 = [NSString stringWithString:[dic[@"count"][@"newBookCount"] stringValue]];
        [arrZhuTou2 addObject:str1];
        [arrZhuTou2 addObject:str2];
        NSMutableArray *arrZhuTou3 = [[NSMutableArray alloc]init];
        NSString *str3 = [NSString stringWithString:dic[@"line"][@"title"]];
        [arrZhuTou3 addObject:str3];
        [_dataSource3 addObject:arrZhuTou2];
        [_dataSource3 addObject:arrZhuTou3];
        
        NSMutableArray *arr2 = [[NSMutableArray alloc]init];
        NSArray *arr1 = dic[@"girlCategoryList"];
        for (NSDictionary *d in arr1) {
            StackModel *model = [[StackModel alloc]init];
            model.categoryName = d[@"categoryName"];
            model.level3categoryName = d[@"level3categoryName"];
            model.imgUrl = d[@"img"];
            model.bookCount = [d[@"bookCount"] stringValue];
            [arr2 addObject:model];
        }
        NSMutableArray *arr3 = [[NSMutableArray alloc]init];
        NSArray *arr4 = dic[@"boyCategoryList"];
        for (NSDictionary *d in arr4) {
            StackModel *model = [[StackModel alloc]init];
            model.categoryName = d[@"categoryName"];
            model.level3categoryName = d[@"level3categoryName"];
            model.imgUrl = d[@"img"];
            model.bookCount = [d[@"bookCount"] stringValue];
            [arr3 addObject:model];
        }
        [_dataSource4 addObject:arr3];
        [_dataSource4 addObject:arr2];
        
        [_tableviewRight reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
#pragma mark 创建pageControl
- (void)createPageControl{
    _pagec = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 85, 375, 15)];
    _pagec.numberOfPages = 4;
    _pagec.currentPageIndicatorTintColor = [UIColor whiteColor];
    [_tableViewLeft addSubview:_pagec];
    [_pagec addTarget:self action:@selector(valueChange) forControlEvents:UIControlEventValueChanged];
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(run) userInfo:nil repeats:YES];

}
- (void)valueChange{
    _HeaderScrollView.contentOffset = CGPointMake(375*_pagec.currentPage + 375, 0);
}
- (void)run{
    [UIView animateWithDuration:0.7 delay:0 options:0 animations:^{
        _HeaderScrollView.contentOffset = CGPointMake(_HeaderScrollView.contentOffset.x+375, 0);
    }completion:^(BOOL finished){
        if (finished) {
            [self scrollViewDidEndDecelerating:_HeaderScrollView];
        }
    }];
}
#pragma mark 每个cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FenLeiViewController *flvc = [[FenLeiViewController alloc]init];
    if (tableView == _tableViewLeft) {
        StackModel *model = _dataSource2[indexPath.row];
        flvc.naviTitle = model.categoryName;
    }
    else{
        StackModel *model = _dataSource4[indexPath.section][indexPath.row];
        flvc.naviTitle = model.categoryName;
    }
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:flvc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
