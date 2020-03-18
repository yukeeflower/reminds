//
//  QRScanAnimationView.m
//  DISLabPrimarySchool
//
//  Created by MacBook on 2017/8/16.
//  Copyright © 2017年 豢龙氏磊. All rights reserved.
//

#import "QRScanAnimationView.h"

#define PI 3.1415926

@interface QRScanAnimationView ()
{
    UIImageView * line_imageView_ ;
    NSTimer * animation_timer_;
    int addOrCut_;
}

@end
@implementation QRScanAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {


        
        [self setBackgroundColor:[UIColor clearColor]];
        
        line_imageView_=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"qrcode_Scan_weixin_Line@2x.png"]];
        [self addSubview:line_imageView_];
        
        [line_imageView_ setFrame:CGRectMake(0, self.bounds.size.height/4, self.bounds.size.width, 20)];
    }
    return self;
}

- (void)creatUI
{
    

    CGFloat weight_ = self.frame.size.width;        //视图宽度
    CGFloat height_ = self.frame.size.height;       //视图高度
    
    CGFloat view_height_ = 10;                      //横向线段高度
    CGFloat view_weight_ = 10;                      //纵向线段宽度
    
    CGFloat view_long_ = weight_/10;                //线段长度
    
    UIColor *line_color_ = [UIColor greenColor];
    
    //上，左，顶
    UIView * top_left_up_ = [[UIView alloc]initWithFrame:CGRectMake(0, 0, view_long_, view_height_)];
    top_left_up_.backgroundColor=line_color_;
    
    [self addSubview:top_left_up_];
    
    //上，左，左
    UIView * top_left_left_ = [[UIView alloc]initWithFrame:CGRectMake(0, 0, view_weight_ , view_long_)];
    top_left_left_.backgroundColor=line_color_;
    
    [self addSubview:top_left_left_];
    
    //上，右，顶
    UIView * top_right_top_ = [[UIView alloc]initWithFrame:CGRectMake(weight_-view_long_, 0, view_long_ , view_height_)];
    top_right_top_.backgroundColor=line_color_;
    
    [self addSubview:top_right_top_];

    //上，右，右
    UIView * top_right_right_ = [[UIView alloc]initWithFrame:CGRectMake(weight_-view_weight_, 0, view_weight_ , view_long_)];
    top_right_right_.backgroundColor=line_color_;
    
    [self addSubview:top_right_right_];
    
    //下，左，左
    UIView * down_left_left_ = [[UIView alloc]initWithFrame:CGRectMake(0, height_-view_long_, view_weight_ , view_long_)];
    down_left_left_.backgroundColor=line_color_;
    
    [self addSubview:down_left_left_];
    
    //下，左，底
    UIView * down_left_bottom_ = [[UIView alloc]initWithFrame:CGRectMake(0, height_-view_height_, view_long_ , view_height_)];
    down_left_bottom_.backgroundColor=line_color_;
    
    [self addSubview:down_left_bottom_];
    
    //下，右，右
    UIView * down_right_right_ = [[UIView alloc]initWithFrame:CGRectMake(weight_-view_weight_, height_-view_long_, view_weight_ , view_long_)];
    down_right_right_.backgroundColor=line_color_;
    
    [self addSubview:down_right_right_];
    
    //下，右，底
    UIView * down_right_bottom_ = [[UIView alloc]initWithFrame:CGRectMake(weight_-view_long_, height_-view_height_, view_long_ , view_height_)];
    down_right_bottom_.backgroundColor=line_color_;
    
    [self addSubview:down_right_bottom_];

}

// 覆盖drawRect方法，你可以在此自定义绘画和动画
- (void)drawRect:(CGRect)rect
{
    //An opaque type that represents a Quartz 2D drawing environment.
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGFloat weight_ = self.frame.size.width;        //视图宽度
    CGFloat height_ = self.frame.size.height;       //视图高度
    
    CGFloat view_height_ = 10;
    CGFloat view_weight_ = 10;                      //纵向线段宽度
    
    CGFloat view_long_ = weight_/10;                //线段长度
    


    CGContextRef context = UIGraphicsGetCurrentContext();
    
   
    CGContextSetRGBFillColor (context,  0, 1, 0, 1.0);//设置填充颜色
    
    
    CGContextSetRGBStrokeColor(context,0, 1, 0, 1.0);//画笔线的颜色
    
    CGContextSetLineWidth(context, view_height_);


    
    
    //上，左，顶

    CGPoint aPoints[2];//坐标点
    aPoints[0] =CGPointMake(0, view_height_/2);//坐标1
    aPoints[1] =CGPointMake(view_long_, view_height_/2);//坐标2
    
    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
    
    //上，左，左

    aPoints[0] =CGPointMake(view_weight_/2, 0);//坐标1
    aPoints[1] =CGPointMake(view_weight_/2 , view_long_);//坐标2
    
    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径

    //上，右，顶
    
    aPoints[0] =CGPointMake(weight_-view_long_,view_height_/2);//坐标1
    aPoints[1] =CGPointMake(weight_, view_height_/2);//坐标2
    
    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径

    //上，右，右
 
    aPoints[0] =CGPointMake(weight_-view_weight_/2, 0);//坐标1
    aPoints[1] =CGPointMake(weight_-view_weight_/2 , view_long_);//坐标2
    
    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径

    //下，左，左
    
    aPoints[0] =CGPointMake(view_weight_/2, height_-view_long_);//坐标1
    aPoints[1] =CGPointMake(view_weight_/2 , height_);//坐标2
    
    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径

    //下，左，底

    aPoints[0] =CGPointMake(0, height_-view_height_/2);//坐标1
    aPoints[1] =CGPointMake(view_long_ , height_-view_height_/2);//坐标2
    
    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
    
    //下，右，右
    
    aPoints[0] =CGPointMake(weight_-view_weight_/2, height_-view_long_);//坐标1
    aPoints[1] =CGPointMake(weight_-view_weight_/2 , height_);//坐标2
    
    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径

    //下，右，底

    aPoints[0] =CGPointMake(weight_-view_long_, height_-view_height_/2);//坐标1
    aPoints[1] =CGPointMake(weight_ , height_-view_height_/2);//坐标2
    
    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
}

/**
 开始动画
 */
- (void)startAnimation
{
    if (animation_timer_) {
        [animation_timer_ invalidate];
    }
 
    animation_timer_=[NSTimer timerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        if (line_imageView_.frame.origin.y>=self.frame.size.height*3/4) {
            addOrCut_=-1;
        }
        else if (line_imageView_.frame.origin.y<=self.frame.size.height/4)
        {
            addOrCut_=1;
        }

        [line_imageView_ setFrame:CGRectMake(line_imageView_.frame.origin.x, line_imageView_.frame.origin.y+addOrCut_, line_imageView_.frame.size.width, line_imageView_.frame.size.height)];
    }];
    
    [[NSRunLoop mainRunLoop]addTimer:animation_timer_ forMode:NSDefaultRunLoopMode];

    
}
- (void)stopAnimation
{
    [animation_timer_ invalidate];
}
@end
