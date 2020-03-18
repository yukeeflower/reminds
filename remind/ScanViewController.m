//
//  ScanViewController.m
//  remind
//
//  Created by 程恒 on 2020/2/22.
//  Copyright © 2020 程恒. All rights reserved.
//

#import "ScanViewController.h"
#import "AFNetworking.h"

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * start = [[UIButton alloc]init];
    start.frame = CGRectMake(20, 300, 300, 50);
    start.titleLabel.text = @"开始";
    start.backgroundColor = [UIColor redColor];
    [start addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:start];
    
    UIButton * stop = [[UIButton alloc]init];
    stop.frame = CGRectMake(20, 600, 300, 50);
    stop.backgroundColor = [UIColor redColor];
    stop.titleLabel.text = @"停止";
    [stop addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [stop addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stop];
}
-(void)start{
    [self.view.layer addSublayer:self.videoPreviewLayer];
       _videoPreviewLayer.frame = self.view.bounds;
    [self startCapture];
}
-(void)stop{
    _videoPreviewLayer.frame = CGRectMake(0, 0, 0, 0 );
    
    
}


-(void)result:(NSString *)barcode{
    _videoPreviewLayer.frame = CGRectMake(0, 0, 0, 0 );

    UILabel *lb = [[UILabel alloc]init];
    lb.frame =CGRectMake(20, 200, 375   , 50);
    lb.text = [NSString stringWithFormat:@"获取到的code为:%@",barcode];
    [self.view addSubview:lb];
    
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        mgr.responseSerializer = [AFJSONResponseSerializer serializer];
        mgr.requestSerializer=[AFJSONRequestSerializer serializer];
        NSMutableDictionary *paras = [NSMutableDictionary dictionary];
        NSString *url = [NSString stringWithFormat:@"http://192.168.31.191:8082/barcode?barcode=%@",barcode];
        [mgr GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,NSDictionary  *responseObject){
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqualToString:@"0"]) {
                NSDictionary *data = [responseObject valueForKey:@"data"];
                NSLog(@"name is%@",data[@"goodsName"]);
                
//                QQTabbarViewController *tab = [[QQTabbarViewController alloc]init];
//                [self presentViewController:tab animated:YES completion:nil];
                
            }
            else{
                NSString *message = [responseObject valueForKey:@"msg"];
                NSLog(@"%@",message);
            }
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"%@", error);
        }];
    
}


- (AVCaptureSession *)captureSession{
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
        _captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    }
    return _captureSession;
}
- (AVCaptureDeviceInput *)deviceInput{
    if (!_deviceInput) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        _deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
        if (error) {
            return nil;
        }
    }
    return _deviceInput;
}
- (AVCaptureMetadataOutput *)metaDataOutput{
    if (!_metaDataOutput) {
        _metaDataOutput = [[AVCaptureMetadataOutput alloc] init];
        [_metaDataOutput setMetadataObjectsDelegate:self queue:        dispatch_get_main_queue()];
 
    }
    return _metaDataOutput;
}
- (AVCaptureVideoPreviewLayer *)videoPreviewLayer{
    if (!_videoPreviewLayer) {
        _videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        _videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _videoPreviewLayer.frame = self.view.bounds;
        
    }
    return _videoPreviewLayer;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    //获取到扫描的数据
    AVMetadataMachineReadableCodeObject *dateObject = (AVMetadataMachineReadableCodeObject *) [metadataObjects lastObject];
    NSLog(@"metadataObjects[last]==%@",dateObject.stringValue);
    
    
    [self stopCapture];
    [self result:dateObject.stringValue];
    

    
}
#pragma makr - 请求权限
- (BOOL)requestDeviceAuthorization{
    
    AVAuthorizationStatus deviceStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (deviceStatus == AVAuthorizationStatusRestricted ||
        deviceStatus ==AVAuthorizationStatusDenied){
        return NO;
    }
    return YES;
}

//开始扫描
- (void)startCapture{
    if (![self requestDeviceAuthorization]) {
        NSLog(@"没有访问相机权限！");
        return;
    }
    [self.captureSession beginConfiguration];
    if ([self.captureSession canAddInput:self.deviceInput]) {
        [self.captureSession addInput:self.deviceInput];
    }
    // 设置数据输出类型，需要将数据输出添加到会话后，才能指定元数据类型，否则会报错
    if ([self.captureSession canAddOutput:self.metaDataOutput]) {
        [self.captureSession addOutput:self.metaDataOutput];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        NSArray *types = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeCode93Code];
        self.metaDataOutput.metadataObjectTypes =types;
//        NSArray *metadatTypes =  [_metaDataOutput availableMetadataObjectTypes];
//        NSLog(@"metadatTypes == %@",metadatTypes);
    }
    [self.captureSession commitConfiguration];
    
    [self.captureSession startRunning];
}
//停止扫描
- (void)stopCapture{
    [self.captureSession stopRunning];
}
- (void)dealloc{
    [self.captureSession stopRunning];
    self.deviceInput = nil;
    self.metaDataOutput = nil;
    self.captureSession = nil;
    self.videoPreviewLayer = nil;
}

@end
