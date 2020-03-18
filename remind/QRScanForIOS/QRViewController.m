//
//  QRViewController.m
//  DISLabPrimarySchool
//
//  Created by admin on 2017/3/28.
//  Copyright © 2017年 董磊. All rights reserved.
//
#import "QRViewController.h"


#import "QRScanForIOSHeader.h"
#import "NetWorkRequest.h"
#import "GoodsEditViewController.h"
#import "ProfileViewController.h"


//#import "Masonry.h"



@interface QRViewController ()
{
    CGRect scan_frame_;
    QRManager * qr_scan_manager_;                       //扫码控制中心
    QRMaskView * qr_mask_view_;                         //顶部蒙版视图
    QRScanAnimationView * qr_scan_animation_view_;      //扫码动画视图
    
    BOOL isLightOn;
    UIButton *btn;
}

@property (nonatomic,weak) IBOutlet UIView * topView_;

@end

@implementation QRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isLightOn = NO;
    
    self.view.backgroundColor=[UIColor whiteColor];

    
//    qr_scan_animation_view_=[[QRScanAnimationView alloc]initWithFrame:
//                             CGRectMake(self.view.center.x-self.view.frame.size.height/4,
//                                        self.view.center.y-self.view.frame.size.height/4,
//                                        self.view.frame.size.height/2,
//                                        self.view.frame.size.height/2)
    qr_scan_animation_view_ = [[QRScanAnimationView alloc]initWithFrame:CGRectMake(39,329,305, 200)];
    
    [self.view addSubview:qr_scan_animation_view_];
    
    
    
    
    //这个是用来设置扫描区域的frame的，这个frame需要注意的是，必须是AVCaptureVideoPreviewLayer所在的layer上的frame，在当前软件中，因为顶部有一个topview，所以应该要在原有的self.view.center.y的基础上下移20+64个像素
    
        scan_frame_ = CGRectMake(qr_scan_animation_view_.frame.origin.x,
                             qr_scan_animation_view_.frame.origin.y-84,
                             qr_scan_animation_view_.bounds.size.width,
                             qr_scan_animation_view_.bounds.size.height) ;

    
    
    qr_mask_view_=[[QRMaskView alloc]initMaskViewWithFrame:CGRectMake(0, 84, self.view.frame.size.width, self.view.frame.size.height - 84) withScanFrame:scan_frame_];
    
    [self.view addSubview:qr_mask_view_];
    
   

    qr_scan_manager_ = [QRManager sharedManager];
    
    [qr_scan_manager_ initQrManagerWithDelegateL:self finishInitBlock:^(BOOL finish, NSError *error) {
        if (finish) {
            //开启成功，开始设置扫码参数并开始进行扫码
            [qr_scan_manager_ setPreviewLayerWithSupview:self.view withViewFrame:scan_frame_];
        }
        else
        {
            NSString * qr_error_string_  =[NSString stringWithFormat:@"错误信息：%@",error];
            
            UIAlertController * alertController=[UIAlertController alertControllerWithTitle:@"扫描启动失败！" message:qr_error_string_ preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
    
    
//    [self creatUI];
    btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(107, 544, 174, 48);
    btn.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1/1.0];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"开启"forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [qr_scan_manager_ startScan];
    
    
}


-(void)btnClick:(UIButton *)btn{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        [device lockForConfiguration:nil];
        if (isLightOn) {
            [device setTorchMode:AVCaptureTorchModeOff];
            [device setFlashMode:AVCaptureFlashModeOff];
            isLightOn = NO;
            [btn setTitle:@"开启" forState:UIControlStateNormal];
        }else{
           [device setTorchMode:AVCaptureTorchModeOn];
           [device setFlashMode:AVCaptureFlashModeOn];
           isLightOn = YES;
           [btn setTitle:@"关闭" forState:UIControlStateNormal];
        }
        [device unlockForConfiguration];
    }
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   
    //界面进入后需要开始进行扫码
    [qr_scan_manager_ startScan];
    //开启动画
    [qr_scan_animation_view_ startAnimation];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    //界面退出前停止扫码
    [qr_scan_manager_ stopScan];
    //停止动画
    [qr_scan_animation_view_ stopAnimation];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    // id 类型不能点语法,所以要先去取出数组中对象
    AVMetadataMachineReadableCodeObject *object = [metadataObjects lastObject];
    if (object == nil) return;
    if (![object.type isEqualToString:AVMetadataObjectTypeQRCode] )
    {
        NSLog(@"得到的qr字符串为：%@",object.stringValue);
        [qr_scan_manager_ stopScan];
         //停止动画
        [qr_scan_animation_view_ stopAnimation];

        NSDictionary * dict = [NetWorkRequest requestBarCode:object.stringValue];
        if(dict == nil){
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"扫码结果" message:@"商品未收录或请求服务器失败!" preferredStyle:UIAlertControllerStyleAlert];

            [alertController addAction:[UIAlertAction actionWithTitle:@"重新扫码" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

            [self->qr_scan_manager_ startScan];
            [self->qr_scan_animation_view_ startAnimation];
            }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"手动录入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                           NSLog(@"点击确认");
                GoodsEditViewController *goods = [[GoodsEditViewController alloc]init];
                goods.hidesBottomBarWhenPushed = YES;
                goods.navigationItem.title = @"添加物品";
                [goods setGoodsNo:@"暂无"];
                [goods setGoodsName:@"暂不支持"];
                [self.navigationController pushViewController:goods animated:YES];
                       }]];
            [self presentViewController:alertController animated:YES completion:nil];

            
            
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"扫码结果" message:dict[@"goodsName"] preferredStyle:UIAlertControllerStyleAlert];

            [alertController addAction:[UIAlertAction actionWithTitle:@"重新扫码" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

            [self->qr_scan_manager_ startScan];
            [self->qr_scan_animation_view_ startAnimation];

            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                   NSLog(@"点击确认");
                GoodsEditViewController *goods = [[GoodsEditViewController alloc]init];
                goods.hidesBottomBarWhenPushed = YES;
                goods.navigationItem.title = @"添加物品";
    //            goods.navigationController.bac
                [goods setGoodsNo:dict[@"goodsNo"]];
                [goods setGoodsName:dict[@"goodsName"]];
                [self.navigationController pushViewController:goods animated:YES];
                
    //            [self presentViewController:goods animated:YES completion:nil];

               }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }

    }else{
        NSLog(@"扫码得到的不是条码!%@",object.stringValue);
    }
}

- (void)backClick:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
