//
//  NetWorkRequest.m
//  remind
//
//  Created by 程恒 on 2020/3/1.
//  Copyright © 2020 程恒. All rights reserved.
//

#import "NetWorkRequest.h"
#import "AFNetworking.h"
#define BASE_URL @"http://param.optzg.cn"

//#define BASE_URL @"http://192.168.31.191:8082"
@implementation NetWorkRequest

+(NSDictionary  *)requestBarCode:(NSString *)barCodeNo{

    static NSDictionary * dict = nil;
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *url =[NSString stringWithFormat:@"%@%@barcode=%@",BASE_URL,@"/remind/barcode/info?",barCodeNo];
    NSLog(@"即将开始请求后端获取二维码信息，请求url:%@",url);
    [mgr GET:url parameters:nil success:^(AFHTTPRequestOperation *operation , NSDictionary *responseObject){
        NSString *code = [responseObject valueForKey:@"code"];
        NSString *message = [responseObject valueForKey:@"msg"];
        if ([code isEqualToString:@"0"]) {
            if (![message isEqualToString:@"暂未收录此商品"]) {
                 dict = responseObject[@"data"];
                         NSLog(@"请求成功，返回的结果是:%@",dict);
                         dispatch_semaphore_signal(semaphore);
            }else{
                NSLog(@"服务器返回的结果:%@",message);
                dispatch_semaphore_signal(semaphore);
            }
        }
        else{
            NSLog(@"调用后端查询条码信息失败，失败原因:%@",message);
            dispatch_semaphore_signal(semaphore);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"调用后端查询条码信息过程中出现异常，原因:%@", error);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return dict;
}


+(id)getRequest:(NSString *)url{
    url = [NSString stringWithFormat:@"%@%@",BASE_URL,url];
    static id dict = nil;
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 5.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    NSLog(@"即将开始请求后端，请求url:%@",url);
    [mgr GET:url parameters:nil success:^(AFHTTPRequestOperation *operation , NSDictionary *responseObject){
        NSString *code = [responseObject valueForKey:@"code"];
        NSString *message = [responseObject valueForKey:@"msg"];
        if ([code isEqualToString:@"0"]) {
            dict = responseObject[@"data"];
            NSLog(@"请求成功，返回的结果是:%@",dict);
            dispatch_semaphore_signal(semaphore);
        }
        else{
            NSLog(@"调用后端返回的s信息为失败，失败原因:%@",message);
            dispatch_semaphore_signal(semaphore);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"调用过程中出现异常，原因:%@", error);
        
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return dict;
}


+(NSDictionary  *)postRequest:(NSString *)url param:(NSMutableDictionary *)params{
    url = [NSString stringWithFormat:@"%@%@",BASE_URL,url];
    static NSDictionary * dict = nil;
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 5.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSLog(@"post请求即将开始请求后端，请求url:%@,参数:%@",url,params);
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation , NSDictionary *responseObject){
        NSString *code = [responseObject valueForKey:@"code"];
        NSString *message = [responseObject valueForKey:@"msg"];
        if ([code isEqualToString:@"0"]) {
            dict = responseObject[@"data"];
            NSLog(@"请求成功，返回的结果是:%@",dict);
            dispatch_semaphore_signal(semaphore);
        }
        else{
            NSLog(@"调用返回的结果是失败，失败原因:%@",message);
            dispatch_semaphore_signal(semaphore);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"调用后端过程中出现异常，原因:%@", error);
        
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return dict;
}


+(NSDictionary  *)postRequestParam:(NSString *)url param:(NSMutableDictionary *)params{
    url = [NSString stringWithFormat:@"%@%@",BASE_URL,url];
    static NSDictionary * dict = nil;
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 5.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFHTTPRequestSerializer serializer];
    NSLog(@"post请求即将开始请求后端，请求url:%@,参数:%@",url,params);
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation , NSDictionary *responseObject){
        NSString *code = [responseObject valueForKey:@"code"];
        NSString *message = [responseObject valueForKey:@"msg"];
        if ([code isEqualToString:@"0"]) {
            dict = responseObject[@"data"];
            NSLog(@"请求成功，返回的结果是:%@",dict);
            dispatch_semaphore_signal(semaphore);
        }
        else{
            NSLog(@"调用返回的结果是失败，失败原因:%@",message);
            dispatch_semaphore_signal(semaphore);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"调用后端过程中出现异常，原因:%@", error);
        
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return dict;
}



@end
