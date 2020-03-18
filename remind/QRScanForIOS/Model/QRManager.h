//
//  QRManager.h
//  DISLabPrimarySchool
//
//  Created by MacBook on 2017/8/16.
//  Copyright © 2017年 豢龙氏磊. All rights reserved.
//


//二维码扫码控制中心
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^finishBlock)(BOOL finish,NSError * error);

@interface QRManager : NSObject
/**
 初始化QRManager单例类
 
 @return QRManager单例类
 */
+ (QRManager *)sharedManager;


/**
 初始化扫码Manange

 @param delegate 代理
 @param block 返回Block
 */
- (void)initQrManagerWithDelegateL:(id)delegate
                   finishInitBlock:(finishBlock)block;


/**
 设置扫码区域的相关参数

 @param supView 父视图
 @param viewFrame 扫码区域的大小
 */
- (void)setPreviewLayerWithSupview:(UIView *)supView
                     withViewFrame:(CGRect)viewFrame;

//开始扫描
- (void)startScan;

//停止扫描
- (void)stopScan;
@end
