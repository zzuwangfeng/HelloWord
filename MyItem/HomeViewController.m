//
//  HomeViewController.m
//  MyItem
//
//  Created by qianfeng007 on 15/12/14.
//  Copyright © 2015年 李东亚. All rights reserved.
//

#import "HomeViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "HomeModel.h"
#import <UIImageView+WebCache.h>
#import "DetailViewController.h"
@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate> {
    UITableView *_tableView;
    NSMutableArray *_dataSource;
    NSMutableArray *_sections;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    _dataSource = [[NSMutableArray alloc] init];
    _sections = [[NSMutableArray alloc] init];
    [self loadDataFromNet];
}
- (void)loadDataFromNet {
    NSString *url = @"http://baojia.qichecdn.com/priceapi3.9.16/services/cars/brands?ts=0&app=2&platform=1&version=3.9.16";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HomeModel *model = [[HomeModel alloc] initWithData:responseObject error:nil];
         _sections = model.result.brandlist;
        for (int i=0; i<_sections.count; i++) {
            NSMutableArray *section = [[NSMutableArray alloc] init];
            BrandModel *mode = _sections[i];
            for (int j=0; j<mode.list.count; j++) {
                ListModel *model1 = mode.list[j];
                [section addObject:model1];
            }
            [_dataSource addObject:section];
        }
        
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}
#pragma make -TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sections.count;
}
- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    BrandModel *model = _sections[section];
    ListModel *mode = model.list[row];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:mode.imgurl] placeholderImage:[UIImage imageNamed:@"account_collect@2x"]];
    NSString *name = [NSString stringWithFormat:@"(%@)-%@",model.letter,mode.name];
    cell.textLabel.text = name;
    cell.textLabel.textColor = [UIColor redColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    BrandModel *model = _sections[section];
    
    return model.letter;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *detail = [DetailViewController new];
    BrandModel *model = _sections[indexPath.section];
    detail.model = model.list[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
    
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
