//
//  ReadPicModel.h
//  MyItem
//
//  Created by qianfeng007 on 15/12/15.
//  Copyright © 2015年 李东亚. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol SpecModel

@end

@interface SpecModel : JSONModel

@property (nonatomic, copy) NSString *smallpic;

@end

@interface ResModel : JSONModel

@property (nonatomic, strong) NSMutableArray<SpecModel> *list;
@end

@interface ReadPicModel : JSONModel
@property (nonatomic, strong) ResModel *result;

@end
