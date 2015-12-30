//
//  HotModel.h
//  MyItem
//
//  Created by qianfeng007 on 15/12/15.
//  Copyright © 2015年 李东亚. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@protocol SeriModel

@end

@interface SeriModel : JSONModel
@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *imgurl;

@property (nonatomic, copy) NSString *ordercount;

@property (nonatomic, copy) NSString *price;

@end

@protocol HotCarList

@end
@interface HotCarList : JSONModel
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableArray<SeriModel> *serieslist;
@end

@interface RecModel : JSONModel
@property (nonatomic, strong) NSMutableArray<HotCarList> *hotcarlist;

@end

@interface HotModel : JSONModel

@property (nonatomic, strong) RecModel *result;

@end
