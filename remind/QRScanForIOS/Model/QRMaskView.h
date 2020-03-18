//
//  QRMaskView.h
//  DISLabPrimarySchool
//
//  Created by MacBook on 2017/8/16.
//  Copyright © 2017年 豢龙氏磊. All rights reserved.
//

#import <UIKit/UIKit.h>
//周边灰色的蒙版
@interface QRMaskView : UIView

/**
 根据蒙版的大小，视图扫码区域的大小创建蒙版

 @param maskFrame 蒙版在父视图中的大小
 @param scanFrame 扫码区域的大小
 @return 返回蒙版View
 */
- (instancetype)initMaskViewWithFrame:(CGRect)maskFrame
                        withScanFrame:(CGRect)scanFrame;
@end
