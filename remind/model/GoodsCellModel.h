//
//  GoodsCellModel.h
//  remind
//
//  Created by 程恒 on 2020/3/8.
//  Copyright © 2020 程恒. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExpiredInfo.h"
#import "Tag.h"
NS_ASSUME_NONNULL_BEGIN

@interface GoodsCellModel : NSObject
@property (nonatomic, strong) NSString *goodsNo;

@property (nonatomic, strong) NSString *imgUrl;

@property (nonatomic, strong) Tag *tag;

@property (nonatomic, strong) NSString *goodsName;

@property (nonatomic, strong) ExpiredInfo *expiredInfo;

@property BOOL expired;

-(instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
