//
//  ScanViewController.h
//  remind
//
//  Created by 程恒 on 2020/2/22.
//  Copyright © 2020 程恒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface ScanViewController : UIViewController

@property (nonatomic,strong) AVCaptureSession *captureSession;//捕捉会话

@property (nonatomic,strong) AVCaptureDeviceInput *deviceInput;//输入流

@property (nonatomic,strong) AVCaptureMetadataOutput *metaDataOutput;//输出流

@property (nonatomic,strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;//预览涂层
@end

NS_ASSUME_NONNULL_END
