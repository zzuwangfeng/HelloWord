//
//  NewCarModel.h
//  MyItem
//
//  Created by qianfeng007 on 15/12/15.
//  Copyright © 2015年 李东亚. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@protocol SerListModel

@end

@interface SerListModel : JSONModel
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *salestate;
@property (nonatomic, copy) NSString *newsurl;
@property (nonatomic, copy) NSString *newstitle;
@property (nonatomic, copy) NSString *imgurl;
@property (nonatomic, copy) NSString *saletime;
@end


@interface RestModel : JSONModel
@property (nonatomic, strong) NSMutableArray<SerListModel> *serieslist;

@end


@interface NewCarModel : JSONModel

@property (nonatomic, strong) RestModel *result;

@end
