//
//  DetailViewController.m
//  MyItem
//
//  Created by qianfeng007 on 15/12/14.
//  Copyright © 2015年 李东亚. All rights reserved.
//

#import "DetailViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "DetailModel.h"
#import "DetailCell.h"
#import "PicReadViewController.h"
#import "JWCache.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "NSString+Common.h"
@interface DetailViewController ()<UITableViewDataSource, UITableViewDelegate> {
    UITableView *_tableView;
    NSMutableArray *_dataSource;
}

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"相关系列";
    self.view.backgroundColor = [UIColor redColor];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(buttonClick)];
    self.navigationItem.leftBarButtonItem = button;
    [self createTableView];

    _dataSource = [[NSMutableArray alloc] init];
    [self loadDataFromNet];
}
- (void)loadDataFromNet {
     NSString *url = [NSString stringWithFormat:@"http://baojia.qichecdn.com/priceapi3.9.16/services/seriesprice/get?brandid=%@&salestate=1&cityid=0",_model.brandid];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSData *cacheData = [JWCache objectForKey:MD5Hash(url)];
    if (cacheData) {
        DetailModel *model = [[DetailModel alloc] initWithData:cacheData error:nil];
        for (LstModel *mode in model.result.fctlist) {
            for (SeriesModel *mode1 in mode.serieslist) {
                [_dataSource addObject:mode1];
            }
        }
        [_tableView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
               return;
    }
   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DetailModel *model = [[DetailModel alloc] initWithData:responseObject error:nil];

        for (LstModel *mode in model.result.fctlist) {
            for (SeriesModel *mode1 in mode.serieslist) {
                [_dataSource addObject:mode1];
            }
        }
        [_tableView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        // 把数据进行缓存
        [JWCache setObject:responseObject forKey:MD5Hash(url)];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}
#pragma make -TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cellID";
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[DetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.model = _dataSource[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PicReadViewController *pic = [PicReadViewController new];
    SeriesModel *model = _dataSource[indexPath.row];
    pic.titles = model.name;
    pic.seriesid = model.id;
    pic.imageUrl = model.imgurl;
    [self.navigationController pushViewController:pic animated:YES];
}

- (void)buttonClick {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
