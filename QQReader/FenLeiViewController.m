//
//  FenLeiViewController.m
//  QQReader
//
//  Created by 邵邵函昊 on 16/7/14.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import "FenLeiViewController.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "FenLeiModel.h"
#import "FenLeiTableViewCell.h"

@interface FenLeiViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataSource;
    NSArray *_dataSource1;
    UIScrollView *_headScrollView;
    UITableView *_mainTableView;
    UIView *_drawerView;
    UILabel *_headerLabel;
}
@end

@implementation FenLeiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = self.naviTitle;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"bookcity_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
    [self afnetWorkingAnalysizeTableView];
    [self createFenLeiHeadScrollView];
    [self createDrawerView];
    [self createMainTableView];
    
}
- (void)leftBtnClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    self.tabBarController.tabBar.hidden = NO;
}
#pragma mark 创建头部滚动视图
- (void)createFenLeiHeadScrollView{
    _dataSource1 = @[@"全部类别",@"世界名著",@"官场",@"作品集",@"财经",@"惊悚/恐怖",@"武侠",@"四大名著",@"影视小说",@"乡土",@"职场",@"科幻",@"魔幻",@"社会",@"中国当代小说",@"军事",@"都市",@"历史",@"侦探/悬疑/推理",@"情感",@"中国古典小说",@"中国近现代小说",@"外国小说"];
    _headScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 375, 45)];
    _headScrollView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.5 alpha:0.5];
    _headScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_headScrollView];
    int k = 0,l = 0,i = 0;
    for (; i < _dataSource1.count; i++) {
        for (int j = 0; j <= i; j++) {
            if (j == 0) {
                k = 0;
            }
            else{
                k += [_dataSource1[j-1] length];
            }
        }
        l = (int)[_dataSource1[i] length];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(k*14+i*15+20*i+20, 7, l*14+15, 30)];
        [btn setTitle:_dataSource1[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        btn.layer.borderWidth = 0;
        btn.layer.cornerRadius = 30/2;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = i + 1;
        if (i == 0) {
            btn.layer.borderWidth = 1;
        }
        [btn addTarget:self action:@selector(btnBeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_headScrollView addSubview:btn];
        
    }
    _headScrollView.contentSize = CGSizeMake(k*15+20*i+340, -45);
    
}
- (void)btnBeClicked:(UIButton *)btn{
    for (int i = 0; i < _dataSource1.count; i++) {
        UIButton *btn = [self.view viewWithTag:i+1];
        btn.layer.borderWidth = 0;
    }
    btn.layer.borderWidth = 1;
}
#pragma mark 创建头视图抽屉
- (void)createDrawerView{
    _drawerView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, 375, 45*3)];
    [self.view addSubview:_drawerView];
    [self.view sendSubviewToBack:_drawerView];
    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, i*45, 345, 1)];
        label.backgroundColor = [UIColor grayColor];
        [_drawerView addSubview:label];
    }
    _drawerView.backgroundColor = [UIColor colorWithRed:0  green:0 blue:0.5 alpha:0.5];
    NSArray *arr1 = @[@"全部",@"免费",@"包月",@"收费",@"全部",@"完结",@"连载",@"节选"];
    NSArray *arr2 = @[@"按人气",@"按最新",@"按收藏",@"按字数"];
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 4; j++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(j*(28+15+20)+20, i*45+7, 28+15, 30)];
            [btn setTitle:arr1[i*4+j] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.layer.borderColor = [UIColor whiteColor].CGColor;
            btn.layer.borderWidth = 0;
            btn.layer.cornerRadius = 30/2;
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.tag = i*4+j+100;
            if (i*4+j == 0 || i*4+j == 4) {
                btn.layer.borderWidth = 1;
            }
            [btn addTarget:self action:@selector(btn2BeClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_drawerView addSubview:btn];
        }
    }
    _headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 375, 45)];
    _headerLabel.backgroundColor = [UIColor colorWithRed:0  green:0 blue:0.5 alpha:0];
    _headerLabel.textColor = [UIColor whiteColor];
    _headerLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_headerLabel];
    [self.view sendSubviewToBack:_headerLabel];
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*(28+14+15+20)+20, 90+7, 28+29, 30)];
        [btn setTitle:arr2[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        btn.layer.borderWidth = 0;
        btn.layer.cornerRadius = 30/2;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = i+200;
        if (i == 0) {
            btn.layer.borderWidth = 1;
            _headerLabel.text = btn.titleLabel.text;
        }
        [btn addTarget:self action:@selector(btn3BeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_drawerView addSubview:btn];
    }
    
}
- (void)btn2BeClicked:(UIButton *)btn{
    if (btn.tag < 104) {
        for (int i = 0; i < 4; i++) {
            UIButton *btn = [self.view viewWithTag:i+100];
            btn.layer.borderWidth = 0;
        }
        btn.layer.borderWidth = 1;
    }
    else{
        for (int i = 4; i < 8; i++) {
            UIButton *btn = [self.view viewWithTag:i+100];
            btn.layer.borderWidth = 0;
        }
        btn.layer.borderWidth = 1;
    }
}
- (void)btn3BeClicked:(UIButton *)btn{
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [self.view viewWithTag:i+200];
        btn.layer.borderWidth = 0;
    }
    btn.layer.borderWidth = 1;
    _headerLabel.text = btn.titleLabel.text;
}
#pragma mark 解析tableView数据
- (void)afnetWorkingAnalysizeTableView{
    _dataSource = [[NSMutableArray alloc]init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://ios.reader.qq.com/v5_9/listdispatch?pagestamp=1&actionTag=-1,-1,6&actionId=13100&action=category" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //成功获取数据后的处理
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (dic == nil) {
            return ;
        }
        
        NSArray *arr1 = dic[@"bookList"];
        for (NSDictionary *d in arr1) {
            FenLeiModel *model = [[FenLeiModel alloc]init];
            model.cover = d[@"cover"];
            model.lpushname = d[@"lpushname"];
            model.author = d[@"author"];
            model.hotNum = d[@"hotNum"];
            model.title = d[@"title"];
            [_dataSource addObject:model];
        }
        
        [_mainTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
#pragma mark 创建主视图tableView
- (void)createMainTableView{
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45*4, 375, 603-45)];
    [self.view addSubview:_mainTableView];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    [_mainTableView registerNib:[UINib nibWithNibName:@"FenLeiTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellFenLei"];

}
#pragma mark tableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FenLeiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellFenLei" forIndexPath:indexPath];
    FenLeiModel *model = _dataSource[indexPath.row];
    [cell setModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105.7;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _mainTableView) {
        
        if (_mainTableView.contentOffset.y > 10){
            [UIView animateWithDuration:0.3 animations:^{
                _mainTableView.frame = CGRectMake(0, 45, 375, 603 - 45);
            } completion:^(BOOL finished) {
                [self.view bringSubviewToFront:_headerLabel];
                _headerLabel.backgroundColor = [UIColor colorWithRed:0  green:0 blue:0.5 alpha:0.5];
                _headScrollView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.5 alpha:0];

            }];
            
        } else {
            
            [UIView animateWithDuration:0.3 animations:^{
                _mainTableView.frame = CGRectMake(0, 4 * 45, 375, 603 - 45);
            } completion:^(BOOL finished) {
                [self.view sendSubviewToBack:_headerLabel];
                _headerLabel.backgroundColor = [UIColor colorWithRed:0  green:0 blue:0.5 alpha:0];
                _headScrollView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.5 alpha:0.5];
                
            }];
        }
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
