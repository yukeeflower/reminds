//
//  Utils.m
//  remind
//
//  Created by 程恒 on 2020/3/9.
//  Copyright © 2020 程恒. All rights reserved.
//

#import "Utils.h"

@implementation Utils


+(UIColor *)strColorToUIColor:(NSString *)color{
    NSArray *arr = [color componentsSeparatedByString:@","];
//    NSLog(@"rbg(%@,%@,%@)",arr[0],arr[1],arr[2]);
    NSString *r = [NSString stringWithFormat:@"%@",arr[0]];
    NSString *g = [NSString stringWithFormat:@"%@",arr[1]];
    NSString *b = [NSString stringWithFormat:@"%@",arr[2]];
    NSString *a = [NSString stringWithFormat:@"%@",arr[3]];
    UIColor *uiColor = [UIColor colorWithRed:r.intValue/255.0 green:g.intValue/255.0 blue:b.intValue/255.0 alpha:a.intValue/1.0];
    return uiColor;
}
@end
