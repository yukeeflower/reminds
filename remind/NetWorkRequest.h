//
//  NetWorkRequest.h
//  remind
//
//  Created by 程恒 on 2020/3/1.
//  Copyright © 2020 程恒. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NetWorkRequest : NSObject
+(NSString *)requestBarCode:(NSString *)barCodeNo;

+(NSDictionary *)getRequest:(NSString *)url;

+(NSDictionary *)postRequest:(NSString *)url param:(NSMutableDictionary *)params;

+(NSDictionary *)postRequestParam:(NSString *)url param:(NSMutableDictionary *)params;

@end

NS_ASSUME_NONNULL_END
