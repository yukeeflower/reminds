//
//  ProfileViewController.m
//  remind
//
//  Created by 程恒 on 2020/2/22.
//  Copyright © 2020 程恒. All rights reserved.
//

#import "ProfileViewController.h"
@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    UIImage *image = [UIImage imageNamed:@"goods.png"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 375, 2000)];
    imageView.image = image;
    
    UIScrollView *view = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 375, 900)];
//       view.backgroundColor = [UIColor redColor];
       view.scrollEnabled = YES;
       view.contentInset = UIEdgeInsetsMake(10, 20, 10, 20);
    view.contentSize = imageView.frame.size;
    [view addSubview:imageView];
    [self.view addSubview: view];
    
    [view addSubview:imageView];

    
   
    
    UIButton * btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(30, 300, 200, 30);
    btn.backgroundColor = [UIColor blueColor];
    [btn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)test{
   
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
