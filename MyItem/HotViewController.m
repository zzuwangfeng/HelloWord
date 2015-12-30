//
//  HotViewController.m
//  MyItem
//
//  Created by qianfeng007 on 15/12/14.
//  Copyright © 2015年 李东亚. All rights reserved.
//

#import "HotViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "HotModel.h"
#import "HotViewCell.h"
#import "PicReadViewController.h"
#import "NSString+Common.h"
#import "JWCache.h"
#import <MBProgressHUD.h>
@interface HotViewController ()<UITableViewDataSource, UITableViewDelegate> {
    UITableView *_tableView;
    NSMutableArray *_dataSource;
    NSMutableArray *_sectionArray;
    NSString *_url;
}

@end

@implementation HotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self createbuttons];
     _url = @"http://baojia.qichecdn.com/priceapi3.9.16/services/hotcar/get?type=1";
    _dataSource = [[NSMutableArray alloc] init];
    _sectionArray = [[NSMutableArray alloc] init];
    [self loadDataFormNet];
    
}

- (void)createbuttons {
    NSArray *titles = @[@"热门",@"豪华",@"SUV",@"其他"];
    CGFloat width = self.view.frame.size.width/4;
    for (int i = 0; i<titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
        button.tag = i+100;
        button.frame = CGRectMake(width*i, 64, width, 30);
        button.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}
- (void)buttonClick:(UIButton *)button {
    NSUInteger tag = button.tag-99;
    _url = [NSString stringWithFormat:@"http://baojia.qichecdn.com/priceapi3.9.16/services/hotcar/get?type=%lu",(unsigned long)tag];

    [_sectionArray removeAllObjects];
    [_dataSource removeAllObjects];
    [_tableView reloadData];
    [self loadDataFormNet];
    
}
- (void)loadDataFormNet {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSData *cacheData = [JWCache objectForKey:MD5Hash(_url)];
    if (cacheData) {
        HotModel *model = [[HotModel alloc] initWithData:cacheData error:nil];
        _sectionArray = model.result.hotcarlist;
        for (int i=0; i<_sectionArray.count; i++) {
            NSMutableArray *section = [[NSMutableArray alloc] init];
            HotCarList *mode = _sectionArray[i];
            for (int j=0; j<mode.serieslist.count; j++) {
                SeriModel *model1 = mode.serieslist[j];
                
                [section addObject:model1];
            }
            [_dataSource addObject:section];
        }

        [_tableView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
        return;
    }

    AFHTTPRequestOperationManager *mannger = [AFHTTPRequestOperationManager manager];
    mannger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [mannger GET:_url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HotModel *model = [[HotModel alloc] initWithData:responseObject error:nil];
       
        _sectionArray = model.result.hotcarlist;
        for (int i=0; i<_sectionArray.count; i++) {
            NSMutableArray *section = [[NSMutableArray alloc] init];
            HotCarList *mode = _sectionArray[i];
            for (int j=0; j<mode.serieslist.count; j++) {
                SeriModel *model1 = mode.serieslist[j];
               
                [section addObject:model1];
            }
            [_dataSource addObject:section];
        }
        [_tableView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        // 把数据进行缓存
        [JWCache setObject:responseObject forKey:MD5Hash(_url)];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    }];
}
//
- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height-94) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
//
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cellID";
    HotViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[HotViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    HotCarList *model = _sectionArray[section];
    SeriModel *mode = model.serieslist[row];
    cell.model = mode;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    HotCarList *model = _sectionArray[section];
    return model.name;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    HotCarList *model = _sectionArray[section];
    SeriModel *mode = model.serieslist[row];
    PicReadViewController *pic = [PicReadViewController new];
    pic.titles = mode.name;
    pic.seriesid = mode.id;
    pic.imageUrl = mode.imgurl;
    pic.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pic animated:YES];
}
//
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
