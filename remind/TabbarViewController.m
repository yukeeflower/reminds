//
//  TabbarViewController.m
//  remind
//
//  Created by 程恒 on 2020/2/22.
//  Copyright © 2020 程恒. All rights reserved.
//

#import "TabbarViewController.h"
#import "ViewController.h"
#import "ProfileViewController.h"
#import "ScanViewController.h"
#import "QRViewController.h"
@interface TabbarViewController ()

@end


@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0]];
    [UITabBar appearance].translucent = NO;
    
    self.navigationController.navigationBar.hidden = YES;
    
 
    ViewController *index = [[ViewController alloc]init];
    [self addChildVc:index title:@"首页" image:@"index" selectImage:@"index_HL"];

//    ScanViewController *scan = [[ScanViewController alloc]init];
    
    QRViewController *scan = [[QRViewController alloc]init];

       [self addChildVc:scan title:@"" image:@"scan_HL" selectImage:@"scan_HL"];
    
    ProfileViewController *profile = [[ProfileViewController alloc]init];
    [self addChildVc:profile title:@"我的" image:@"profile" selectImage:@"profile_HL"];
}
#pragma 修改tabbar高度
- (void)viewWillLayoutSubviews{
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = 100;
//    tabFrame.origin.y = self.view.frame.size.height - 91;
    self.tabBar.frame = tabFrame;
}

-(void )addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectedImage
{
    //设置子控制器颜色图片
    //    childVc.tabBarItem.title = title;    设置tabbar标题
    //    childVc.navigationItem.title = title;  设置nav标题
    childVc.title = title;                  //同时设置tabbar和nav标题
    childVc.tabBarItem.image = [[UIImage imageNamed:image]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage=[[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSMutableDictionary *textarr = [NSMutableDictionary dictionary];
    textarr[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    
    NSMutableDictionary *selectedtextarr = [NSMutableDictionary dictionary];
    selectedtextarr[NSForegroundColorAttributeName] = [UIColor colorWithRed:89/255.0 green:73/255.0 blue:252/255.0 alpha:1/1.0];
    
    [childVc.tabBarItem setTitleTextAttributes:textarr forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectedtextarr forState:UIControlStateSelected];

    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:childVc];
    nav.navigationBar.barTintColor = [UIColor colorWithRed:82/255.0 green:73/255.0 blue:252/255.0 alpha:1/1.0];
//    nav.navigationBar.backgroundColor = [UIColor colorWithRed:82/255.0 green:73/255.0 blue:252/255.0 alpha:1/1.0];
    nav.navigationBar.barStyle = UIStatusBarStyleLightContent;
    [self addChildViewController:nav];
}


#pragma 改变状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle {

      return UIStatusBarStyleLightContent;

}

@end
