//
//  QRManager.m
//  DISLabPrimarySchool
//
//  Created by MacBook on 2017/8/16.
//  Copyright © 2017年 豢龙氏磊. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "QRManager.h"

@interface QRManager ()

@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) AVCaptureMetadataOutput *metadataOutput;
@end

@implementation QRManager

static QRManager * qr_manager_ = nil;

/**
 初始化QRManager单例类
 
 @return QRManager单例类
 */
+ (QRManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        qr_manager_=[[QRManager alloc]init];
    });
    
    return qr_manager_;
}

- (instancetype)init
{
    self =  [super init];
    
    if (self) {

    }
    return self;
}

/**
 初始化扫码Manange
 
 @param delegate 代理
 @param block 返回Block
 */
- (void)initQrManagerWithDelegateL:(id)delegate
                   finishInitBlock:(finishBlock)block
{
    
    
    _session = [[AVCaptureSession alloc] init];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (deviceInput) {
        [_session addInput:deviceInput];
        
        self.metadataOutput = [[AVCaptureMetadataOutput alloc] init];
        [self.metadataOutput setMetadataObjectsDelegate:delegate queue:dispatch_get_main_queue()];
        [_session addOutput:self.metadataOutput]; // 这行代码要在设置 metadataObjectTypes 前
        self.metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        
        block(YES,nil);
        
    }
    else
    {
        NSLog(@"%@", error);
        block(NO,error);
    }

}
/**
 设置扫码区域的相关参数
 
 @param supView 父视图
 @param viewFrame 扫码区域的大小
 */
- (void)setPreviewLayerWithSupview:(UIView *)supView
                     withViewFrame:(CGRect)viewFrame
{
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = CGRectMake(0, 84, supView.frame.size.width, supView.frame.size.height-84);
    
    
    [supView.layer insertSublayer:previewLayer atIndex:0];
    
    //获取到AVCaptureVideoPreviewLayer的方向并进行修正
    AVCaptureConnection *previewLayerConnection=previewLayer.connection;
    
    if ([previewLayerConnection isVideoOrientationSupported])
        [previewLayerConnection setVideoOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    CGRect intertRect = [previewLayer metadataOutputRectOfInterestForRect:viewFrame];
    
    self.metadataOutput.rectOfInterest = intertRect;
    
}

- (void)startScan
{
    [self.session startRunning];
}

- (void)stopScan
{
    [self.session stopRunning];
}
@end
