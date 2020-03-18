//
//  QRManager.m
//  DISLabPrimarySchool
//
//  Created by MacBook on 2017/8/16.
//  Copyright © 2017年 豢龙氏磊. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "QRManager.h"

@interface QRManager ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic,strong) AVCaptureDeviceInput *deviceInput;//输入流
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
        
        NSArray *types = @[AVMetadataObjectTypeQRCode,//二维码
        //以下为条形码，如果项目只需要扫描二维码，下面都不要写
        AVMetadataObjectTypeEAN13Code,
        AVMetadataObjectTypeEAN8Code,
        AVMetadataObjectTypeUPCECode,
        AVMetadataObjectTypeCode39Code,
        AVMetadataObjectTypeCode39Mod43Code,
        AVMetadataObjectTypeCode93Code,
        AVMetadataObjectTypeCode128Code,
        AVMetadataObjectTypePDF417Code];
        self.metadataOutput.metadataObjectTypes = types;
        [self.session commitConfiguration];
        [self.session startRunning];
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

//    self.metadataOutput.rectOfInterest = intertRect;
    
}

- (void)startScan
{
    
//    if (![self requestDeviceAuthorization]) {
//        NSLog(@"没有访问相机权限！");
//        return;
//    }
//    [self.session beginConfiguration];
//    if ([self.session canAddInput:self.deviceInput]) {
//        [self.session addInput:self.deviceInput];
//    }
//    // 设置数据输出类型，需要将数据输出添加到会话后，才能指定元数据类型，否则会报错
//    if ([self.session canAddOutput:self.metadataOutput]) {
//        [self.session addOutput:self.metadataOutput];
//        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
//        NSArray *types = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeCode93Code];
//        self.metadataOutput.metadataObjectTypes =types;
////        NSArray *metadatTypes =  [_metaDataOutput availableMetadataObjectTypes];
////        NSLog(@"metadatTypes == %@",metadatTypes);
//    }
//    [self.session commitConfiguration];
    
    [self.session startRunning];
//    [self.session startRunning];
}

- (void)stopScan
{
    [self.session stopRunning];
}




//- (AVCaptureSession *)session{
//    if (!_session) {
//        _session = [[AVCaptureSession alloc] init];
//        _session.sessionPreset = AVCaptureSessionPresetHigh;
//    }
//    return _session;
//}
//- (AVCaptureDeviceInput *)deviceInput{
//    if (!_deviceInput) {
//        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//        NSError *error = nil;
//        _deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
//        if (error) {
//            return nil;
//        }
//    }
//    return _deviceInput;
//}
//- (AVCaptureMetadataOutput *)_metadataOutput{
//    if (!_metadataOutput) {
//        _metadataOutput = [[AVCaptureMetadataOutput alloc] init];
//        [_metadataOutput setMetadataObjectsDelegate:self queue:        dispatch_get_main_queue()];
//
//    }
//    return _metadataOutput;
//}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSLog(@"已经扫到吗了");
    // id 类型不能点语法,所以要先去取出数组中对象
    AVMetadataMachineReadableCodeObject *object = [metadataObjects lastObject];
 

    if (object == nil) return;
    
    if ([object.type isEqualToString:AVMetadataObjectTypeQRCode] )
    {
        NSLog(@"得到的qr字符串为：%@",object.stringValue);
        //进一步的操作
        
        // .....
        
        
        
    }
}
@end
