//
//  GoodsCellModel.m
//  remind
//
//  Created by 程恒 on 2020/3/8.
//  Copyright © 2020 程恒. All rights reserved.
//

#import "GoodsCellModel.h"

@implementation GoodsCellModel




-(instancetype)initWithDictionary:(NSDictionary *)dict{
      NSLog(@"-initWithDictionary方法被调了");
    if(self == [super init]){
        self.goodsNo = dict[@"goodsNo"];
        self.imgUrl = dict[@"imgUrl"];
        self.tag = [[Tag alloc]initWithDictionary:dict[@"tag"]];
        self.goodsName = dict[@"goodsName"];
        self.expired = dict[@"expired"];
        self.expiredInfo = [[ExpiredInfo alloc]initWithDictionary:dict[@"expiredInfo"]];
    }
    return self;
}


//+(instancetype)initWithDictionary:(NSDictionary *)dict{
//    NSLog(@"方法被调了");
//    return [self initWithDictionary:dict];
//}


-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self == [super init]){
        self.goodsNo = [aDecoder decodeObjectForKey:@"goodsNo"];
        self.imgUrl = [aDecoder decodeObjectForKey:@"imgUrl"];
        self.tag = [aDecoder decodeObjectForKey:@"tag"];
        self.goodsName = [aDecoder decodeObjectForKey:@"goodsName"];
        self.expired = [aDecoder decodeObjectForKey:@"expired"];
        self.expiredInfo = [aDecoder decodeObjectForKey:@"expiredInfo"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.goodsNo forKey:@"goodsNo"];
    [aCoder encodeObject:self.imgUrl forKey:@"imgUrl"];
    [aCoder encodeObject:self.tag forKey:@"tag"];
    [aCoder encodeObject:self.goodsName forKey:@"goodsName"];
    [aCoder encodeBool:self.expired forKey:@"expired"];
    [aCoder encodeObject:self.expiredInfo forKey:@"expiredInfo"];
}
- (NSString *)description{
    return [NSString stringWithFormat:@"GoodsCellModel:%@--%@--%@",self.goodsNo,self.imgUrl,self.goodsName];
}





+(UIColor *)strColorToUIColor:(NSString *)color{
    NSArray *arr = [color componentsSeparatedByString:color];
    return [UIColor colorWithRed:(int)arr[0] green:(int)arr[1] blue:(int)arr[2] alpha:(int)arr[3]];
}
@end
