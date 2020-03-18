//
//  ExpiredInfo.m
//  remind
//
//  Created by 程恒 on 2020/3/8.
//  Copyright © 2020 程恒. All rights reserved.
//

#import "ExpiredInfo.h"

@implementation ExpiredInfo
-(instancetype)initWithDictionary:(NSDictionary *)dict{
    if(self == [super init]){
        self.goodsExpiredNameText = dict[@"goodsExpiredNameText"];
        self.goodsExpiredTimeText = dict[@"goodsExpiredTimeText"];
        self.goodsExpiredNameColor = [Utils strColorToUIColor:dict[@"goodsExpiredNameColor"]];
        self.goodsExpiredTimeColor = [Utils strColorToUIColor:dict[@"goodsExpiredTimeColor"]];
    }
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.goodsExpiredNameText forKey:@"goodsExpiredNameText"];
    [aCoder encodeObject:self.goodsExpiredTimeText forKey:@"goodsExpiredTimeText"];
    [aCoder encodeObject:self.goodsExpiredNameColor forKey:@"goodsExpiredNameColor"];
    [aCoder encodeObject:self.goodsExpiredTimeColor forKey:@"goodsExpiredTimeColor"];
}

- (NSString *)description{
    return [NSString stringWithFormat:@"tag is ===>%@--%@--%@--%@",self.goodsExpiredNameText,self.goodsExpiredTimeText,self.goodsExpiredTimeText,self.goodsExpiredTimeColor];
}
@end
