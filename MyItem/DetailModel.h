//
//  DetailModel.h
//  MyItem
//
//  Created by qianfeng007 on 15/12/14.
//  Copyright © 2015年 李东亚. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@protocol SeriesModel

@end
@interface SeriesModel : JSONModel
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *imgurl;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *levelname;
@property (nonatomic, copy) NSString *levelid;
@property (nonatomic, copy) NSString *salestate;


@end


@protocol LstModel

@end

@interface LstModel : JSONModel

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSMutableArray<SeriesModel> *serieslist;

@end

@interface ResulModel : JSONModel

@property (nonatomic, strong) NSMutableArray<LstModel> *fctlist;

@end

@interface DetailModel : JSONModel
@property (nonatomic, strong) ResulModel *result;
@end
