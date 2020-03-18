//
//  Tag.h
//  remind
//
//  Created by 程恒 on 2020/3/8.
//  Copyright © 2020 程恒. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"
NS_ASSUME_NONNULL_BEGIN

@interface Tag : NSObject
@property (nonatomic, strong) NSString *tagId;

@property (nonatomic, strong) NSString *tagName;

@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, strong) UIColor *textColor;

-(instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
