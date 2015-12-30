//
//  NewCarViewController.m
//  MyItem
//
//  Created by qianfeng007 on 15/12/14.
//  Copyright © 2015年 李东亚. All rights reserved.
//

#import "NewCarViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "NewCarModel.h"
#import "NewCarCell.h"
#import "WKNewCarView.h"
#import <MJRefresh/MJRefresh.h>
#import "PicReadViewController.h"
#import "NSString+Common.h"
#import "JWCache.h"
#import <MBProgressHUD.h>
@interface NewCarViewController ()<UITableViewDelegate, UITableViewDataSource,NewCarDelegate> {
    UITableView *_tableView;
    NSMutableArray *_dataSource;
}

@end

@implementation NewCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    _dataSource = [[NSMutableArray alloc] init];
    
}
- (void)loadDataFromNet:(BOOL)isMore {
    
    NSInteger page = 1;
    if (isMore) {
      page = _dataSource.count/20+1;
    }
    NSString *url = [NSString stringWithFormat:@"http://baojia.qichecdn.com/priceapi3.9.16/services/newcars/get?pageindex=%ld&pagesize=20",page];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSData *cacheData = [JWCache objectForKey:MD5Hash(url)];
    if (cacheData) {
        NewCarModel *model = [[NewCarModel alloc] initWithData:cacheData error:nil];
        if (isMore) {
            [_dataSource addObjectsFromArray:model.result.serieslist];
        }else {
            [_dataSource removeAllObjects];
            [_tableView reloadData];
            _dataSource = model.result.serieslist;
        }
        [_tableView reloadData];
        // 隐藏 loading 提示框
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        isMore?[_tableView.mj_footer endRefreshing]:[_tableView.mj_header endRefreshing];
        return;
    }

    AFHTTPRequestOperationManager *mannger = [AFHTTPRequestOperationManager manager];
    mannger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [mannger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!isMore) {
            [_dataSource removeAllObjects];
            [_tableView reloadData];
        }
        NewCarModel *model = [[NewCarModel alloc] initWithData:responseObject error:nil];
        [_dataSource addObjectsFromArray:model.result.serieslist];
        [_tableView reloadData];
       isMore?[_tableView.mj_footer endRefreshing]:[_tableView.mj_header endRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        // 把数据进行缓存
        [JWCache setObject:responseObject forKey:MD5Hash(url)];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        isMore?[_tableView.mj_footer endRefreshing]:[_tableView.mj_header endRefreshing];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
- (void)sentSerid:(NSString *)Serid withTitle:(NSString *)title url:(NSString *)url {
    PicReadViewController *pic = [PicReadViewController new];
    pic.seriesid = Serid;
    pic.titles = title;
    pic.imageUrl = url;
    [self.navigationController pushViewController:pic animated:YES];
}
- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataFromNet:NO];
    }];
    
    _tableView.mj_header = header;
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataFromNet:YES];
    }];
    _tableView.mj_footer = footer;
    
    [_tableView.mj_header beginRefreshing];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cellID";
    NewCarCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NewCarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.delegate = self;
    cell.model = _dataSource[indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 120;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SerListModel *model = _dataSource[indexPath.row];
    WKNewCarView *view = [WKNewCarView new];
    view.hidesBottomBarWhenPushed = YES;
    view.URL = model.newsurl;
    [self.navigationController pushViewController:view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
