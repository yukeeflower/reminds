//
//  ExpiredInfo.h
//  remind
//
//  Created by 程恒 on 2020/3/8.
//  Copyright © 2020 程恒. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExpiredInfo : NSObject
@property (nonatomic, strong) NSString *goodsExpiredNameText;

@property (nonatomic, strong) NSString *goodsExpiredTimeText;

@property (nonatomic, strong) UIColor *goodsExpiredNameColor;

@property (nonatomic, strong) UIColor *goodsExpiredTimeColor;


-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
