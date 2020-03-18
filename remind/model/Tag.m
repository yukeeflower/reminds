//
//  Tag.m
//  remind
//
//  Created by 程恒 on 2020/3/8.
//  Copyright © 2020 程恒. All rights reserved.
//

#import "Tag.h"

@implementation Tag


-(instancetype)initWithDictionary:(NSDictionary *)dict{

    if(self == [super init]){
        self.tagId = dict[@"tagId"];
        self.tagName = dict[@"tagName"];
        self.textColor = [Utils strColorToUIColor:dict[@"textColor"]];
        self.borderColor = [Utils strColorToUIColor: dict[@"borderColor"]];
    }
    return self;
}


//+(instancetype)initWithDictionary:(NSDictionary *)dict{
//    return [Tag initWithDictionary:dict];
//}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self == [super init]){
        self.tagId = [aDecoder decodeObjectForKey:@"tagId"];
        self.tagName = [aDecoder decodeObjectForKey:@"tagName"];
        self.textColor= [aDecoder decodeObjectForKey:@"textColor"];
        self.borderColor = [aDecoder decodeObjectForKey:@"borderColor"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.tagId forKey:@"tagId"];
    [aCoder encodeObject:self.tagName forKey:@"tagName"];
    [aCoder encodeObject:self.textColor forKey:@"textColor"];
    [aCoder encodeObject:self.borderColor forKey:@"borderColor"];
}

- (NSString *)description{
    return [NSString stringWithFormat:@"tag is ===>%@--%@--%@%@",self.tagId,self.tagName,self.textColor,self.borderColor];
}
@end
