//
//  HomeModel.h
//  MyItem
//
//  Created by qianfeng007 on 15/12/14.
//  Copyright © 2015年 李东亚. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol ListModel

@end

@interface ListModel : JSONModel
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imgurl;
@property (nonatomic, copy) NSString *brandid;
@property (nonatomic, copy) NSString *firstletter;

@end

@protocol BrandModel
@end
@interface BrandModel : JSONModel
@property (nonatomic, copy) NSString *letter;
@property (nonatomic, strong) NSMutableArray<ListModel> *list;

@end

@interface ResultModel : JSONModel

@property (nonatomic, copy) NSString *timestamp;

@property (nonatomic, strong) NSMutableArray<BrandModel> *brandlist;

@end

@interface HomeModel : JSONModel

@property (nonatomic, strong) ResultModel *result;

@end
