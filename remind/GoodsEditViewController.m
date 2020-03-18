//
//  GoodsEdit2ViewController.m
//  remind
//
//  Created by 程恒 on 2020/3/1.
//  Copyright © 2020 程恒. All rights reserved.
//

#import "GoodsEditViewController.h"
#import "NetWorkRequest.h"
#import "AFNetworking.h"
#import <UIKit/UIKit.h>
#define BASE_URL @"http://param.optzg.cn"

@interface GoodsEditViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)NSArray *tagsDataSoruce;
@property(nonatomic,strong)NSArray *datePickerDataSouce;
@property(nonatomic,strong)NSArray *timeUnitArr;

@property(nonatomic,strong)NSString *tagId;
@property(nonatomic,strong)NSString *timeUnitValue;

@property(nonatomic,strong)  UITapGestureRecognizer * validTimeTapGesture;
@property(nonatomic,strong)  UITapGestureRecognizer * validUnitapGesture;
@property(nonatomic,strong)  UITapGestureRecognizer * createtapGesture;

@property (strong,nonatomic)UIButton * timeUnitTmpBtn;
@property (strong,nonatomic)UIButton * tagTmpBtn;

@property (strong,nonatomic)UILabel *validTimeValueLbl;
@property (strong,nonatomic)UILabel *validUnitValueLbl;
@property (strong,nonatomic)UILabel *createTimeValueLbl;

@property (strong,nonatomic)UITextField *validTimeTxt;

@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) NSString *imgUrl;

@property (strong, nonatomic) IBOutlet UIView *expiredTimeEditView;
@property (strong, nonatomic) IBOutlet UIView *expiredUnitEditView;
@property (strong, nonatomic) IBOutlet UIView *createTimeEditView;

@end

@implementation GoodsEditViewController

- (void)viewDidLoad {
    
    self.tagsDataSoruce = (NSArray *)[NetWorkRequest getRequest:@"/remind/getAllTags"];
//    NSLog(@"商品编码:%@商品名:%@",self.goodsNo,self.goodsName);
//
//    self.goodsNameLabel.text = self.goodsName;
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:238/255.0 blue:241/255.0 alpha:1/1.0];
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = true ;
    _validTimeTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
    [_validTimeTapGesture setNumberOfTapsRequired:1];
    
    _validUnitapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
    [_validUnitapGesture setNumberOfTapsRequired:1];
    
    _createtapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
    [_createtapGesture setNumberOfTapsRequired:1];
     _timeUnitArr = @[@"天",@"月",@"年"];
    
    _validTimeValueLbl = [[UILabel alloc]init];
    _validUnitValueLbl = [[UILabel alloc]init];
    _createTimeValueLbl = [[UILabel alloc]init];
    
    [self initFrameView];
}


-(void)initFrameView{
    UIImageView *goodsImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"goods_edit_img_bk_shadow"]];
    goodsImgView.frame = CGRectMake(3, 105, 145, 145);
    goodsImgView.layer.cornerRadius = 5;
//    goodsImgView.backgroundColor = [UIColor redColor];
    [self.view addSubview:goodsImgView];
    
    _imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"goods.png"]];
    _imgView.frame = CGRectMake(15, 13, 115, 115);
//    _imgView.backgroundColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.4/1];
//    _imgView.layer.cornerRadius = 5;
//
//     _imgView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_imgView.bounds].CGPath;//阴影的位置
//    _imgView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4/1].CGColor;//阴影颜色
//    _imgView.layer.shadowOffset = CGSizeMake(0, 2);//阴影的大小，x往右和y往下是正
    //        button.layer.shadowRadius = 5;     //阴影的扩散范围，相当于blur radius，也是shadow的渐变距离，从外围开始，往里渐变shadowRadius距离
//            _imgView.layer.shadowOpacity = 0.4;    //阴影的不透明度
//            _imgView.layer.masksToBounds = NO;
//    _imgView.layer.shadowPath =;

    [goodsImgView addSubview:_imgView];
    
    UIButton *takePhotoBtn = [[UIButton alloc]init];
    takePhotoBtn.frame = CGRectMake(108, 209, 32, 32);
    [takePhotoBtn setBackgroundImage:[UIImage imageNamed:@"take_photo_icon"] forState:UIControlStateNormal];
    [takePhotoBtn addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takePhotoBtn];
    
    UILabel *goodsNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(156, 118, 206, 88)];
    goodsNameLbl.numberOfLines = 0;
    goodsNameLbl.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    goodsNameLbl.text = self.goodsName;
    [goodsNameLbl sizeToFit];
    [self.view addSubview:goodsNameLbl];
    
    
    UIView *tagView = [[UIView alloc]init];
    tagView.frame = CGRectMake(16, 256, 340, 119);
    tagView.layer.cornerRadius = 5;
    tagView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    [self.view addSubview:tagView];
    
    UILabel *tagTypeLbl = [[UILabel alloc]init];
    tagTypeLbl.frame = CGRectMake(15, 10, 32, 22);
    tagTypeLbl.text = @"类型";
    tagTypeLbl.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [tagView addSubview:tagTypeLbl];
    

    CGFloat w = 5;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = 46;//用来控制button距离父视图的高
    for(int i = 0;i<self.tagsDataSoruce.count;i++){
        UIButton *button = [[UIButton alloc]init];
        button.tag = i;
        button.layer.cornerRadius =12;//2.0是圆角的弧度，根据需求自己更改
        button.layer.borderColor =  [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1/1.0].CGColor;
        button.layer.borderWidth = 1;
        [button addTarget:self action:@selector(tagClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0] forState:UIControlStateSelected];

        [button setFont: [UIFont fontWithName:@"PingFangSC-Regular" size:14]];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGFloat length = [self.tagsDataSoruce[i][@"tagName"] boundingRectWithSize:CGSizeMake(320, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        [button.titleLabel sizeToFit];
        //为button赋值
        [button setTitle:self.tagsDataSoruce[i][@"tagName"] forState:UIControlStateNormal];
        //设置button的frame
        button.frame = CGRectMake(10 + w, h, length + 32 , 25);
        //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
        if(10 + w + length + 15 > 320){
            w = 15; //换行时将w置为0
            h = h + button.frame.size.height + 10;//距离父视图也变化
            button.frame = CGRectMake(10 + w, h, length + 32, 25);//重设button的frame
        }
        w = button.frame.size.width + button.frame.origin.x;
        [tagView addSubview:button];
    }
    
    UIView *expiredView = [[UIView alloc]init];
    expiredView.frame = CGRectMake(16, 390, 340, 112);
    expiredView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    expiredView.layer.cornerRadius = 5;
    [self.view addSubview:expiredView];
    
    UILabel *expiredLbl = [[UILabel alloc]init];
    expiredLbl.frame = CGRectMake(15, 10, 48, 22);
    expiredLbl.text = @"保质期";
    expiredLbl.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [expiredView addSubview:expiredLbl];
    
    
    UILabel *validTimeLbl = [[UILabel alloc]init];
    validTimeLbl.frame =  CGRectMake(15, 41, 28, 20);
    validTimeLbl.text = @"时间";
    validTimeLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    validTimeLbl.textColor = [UIColor colorWithRed:156/255.0 green:157/255.0 blue:187/255.0 alpha:1/1.0];
    [expiredView addSubview:validTimeLbl];
    
    UILabel *expiredUnitLbl = [[UILabel alloc]init];
    expiredUnitLbl.frame = CGRectMake(231, 41, 28, 20);
    expiredUnitLbl.text = @"单位";
    expiredUnitLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    expiredUnitLbl.textColor = [UIColor colorWithRed:156/255.0 green:157/255.0 blue:187/255.0 alpha:1/1.0];
    [expiredView addSubview:expiredUnitLbl];
    
    UIView *validTimeView = [self inputLabelView:1 content:@"24" valueLbl:_validTimeValueLbl frame:CGRectMake(15, 66, 189, 30)];
    [expiredView addSubview:validTimeView];

    
    UIView *validUnitView = [self inputLabelView:2 content:@"月" valueLbl:_validUnitValueLbl frame:CGRectMake(231, 66, 94, 30)];
     [expiredView addSubview:validUnitView];
    
    
    UIView *createView = [[UIView alloc]init];
    createView.frame = CGRectMake(16, 522, 340, 101);
    createView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    createView.layer.cornerRadius = 5;
    [self.view addSubview:createView];
      
    UILabel *createLbl = [[UILabel alloc]init];
    createLbl.frame = CGRectMake(15, 10, 64, 22);
    createLbl.text = @"生产日期";
    createLbl.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [createView addSubview:createLbl];
    
    UIView *createTimeView = [self inputLabelView:3 content:[self dateConvert:[NSDate now]] valueLbl:_createTimeValueLbl frame:CGRectMake(15, 47, 313, 30)];
    
    [createView addSubview:createTimeView];
    UIButton *confirmBtn = [[UIButton alloc] init];
    confirmBtn.frame = CGRectMake(21, 653, 327, 50);
    confirmBtn.backgroundColor = [UIColor colorWithRed:103/255.0 green:96/255.0 blue:255/255.0 alpha:1/1.0];
    [confirmBtn setTitle:@"录入" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font =[UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [confirmBtn addTarget:self action:@selector(sbumit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    
    
    UIButton *continueBtn = [[UIButton alloc] init];
    continueBtn.frame = CGRectMake(21, 718, 327, 50);
    continueBtn.layer.cornerRadius = 2;
    continueBtn.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:250/255.0 alpha:1/1.0];
    continueBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
     [continueBtn setTitle:@"继续录入" forState:UIControlStateNormal];
    [continueBtn setTitleColor:[UIColor colorWithRed:103/255.0 green:96/255.0 blue:255/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    [continueBtn addTarget:self action:@selector(continueScan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:continueBtn];
    
}

-(UIView *)inputLabelView:(int) tag content:(NSString *)content valueLbl:(UILabel *)lbl frame:(CGRect )rect{
    UIView *view = [[UIView alloc]init];
    view.frame = rect;
    view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:250/255.0 alpha:1/1.0];
    view.layer.cornerRadius = 3;
    view.userInteractionEnabled = YES;
    if (tag == 1) {
        [view addGestureRecognizer:_validTimeTapGesture];
    }else if(tag == 2){
        [view addGestureRecognizer:_validUnitapGesture];
    }else{
        [view addGestureRecognizer:_createtapGesture];
    }
    lbl.frame = CGRectMake(10, 5, rect.size.width, 20);
    lbl.text = content;
    [view addSubview:lbl];
    int x = rect.size.width-15;
    UIImageView *valieTimeUpArrow = [[UIImageView alloc]initWithFrame:CGRectMake(x, 7, 8, 4.6)];
    [valieTimeUpArrow setImage:[UIImage imageNamed:@"goods_edit_arrow_up"]];
    [view addSubview:valieTimeUpArrow];
    
    UIImageView *validTimeDownArrow = [[UIImageView alloc]initWithFrame:CGRectMake(x, 19, 8, 4.6)];
    [validTimeDownArrow setImage:[UIImage imageNamed:@"goods_edit_arrow_down"]];
    [view addSubview:validTimeDownArrow];
    return view;
}

-(void)initValidUnitView{
    _expiredUnitEditView = [[UIView alloc]initWithFrame:CGRectMake(0, 587, 375, 225)];
    _expiredUnitEditView.backgroundColor = [UIColor colorWithRed:254/255.0 green:255/255.0 blue:254/255.0 alpha:1/1.0];
    _expiredUnitEditView.layer.cornerRadius = 5;
    [self.view addSubview:_expiredUnitEditView];


     UIView *header = [self createEditHeader:@"选择保质期单位" tag:2  confirmButton:@selector(expiredUnitConfirmClick:) cancelButton:@selector(expiredUnitcancelClick:)];
    [_expiredUnitEditView addSubview:header];
    int y=72;
    for (int i=0; i<3; i++) {
        UIButton *unit = [[UIButton alloc]init];
        unit.frame = CGRectMake(0, y, 375, 22);
        unit.tag = i;
        [unit setTitle:_timeUnitArr[i] forState:UIControlStateNormal];
        [unit setTitleColor: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        [unit setTitleColor:[UIColor colorWithRed:82/255.0 green:73/255.0 blue:252/255.0 alpha:1/1.0] forState:UIControlStateSelected];
        
        unit.titleLabel.font =[UIFont fontWithName:@"PingFangSC-Medium" size:16];
        [unit addTarget:self action:@selector(expiredTimeUnitValueClick:) forControlEvents:UIControlEventTouchUpInside];
//        [unit setImage:[UIImage imageNamed:@"null.png"] forState:UIControlStateNormal];
    
        [unit setImage:[UIImage imageNamed:@"goods_edit_time_unit_selected"] forState:UIControlStateSelected];
        [unit setImageEdgeInsets:UIEdgeInsetsMake(7.5, 60, 7.5, -60)];
        unit.imageView.backgroundColor = [UIColor redColor];
         unit.userInteractionEnabled = YES;
        
        [_expiredUnitEditView addSubview:unit];
        y = y+37;
    }
}

-(void)initExpiredTimeView{
    _expiredTimeEditView = [[UIView alloc]initWithFrame:CGRectMake(0, 410, 375, 402)];
    _expiredTimeEditView.backgroundColor = [UIColor colorWithRed:254/255.0 green:255/255.0 blue:254/255.0 alpha:1/1.0];
    _expiredTimeEditView.layer.cornerRadius = 5;
    [self.view addSubview:_expiredTimeEditView];
    
    UIView *header = [self createEditHeader:@"输入保质期时长" tag:1 confirmButton:@selector(expiredUnitConfirmClick:) cancelButton:@selector(expiredUnitcancelClick:)];
    [_expiredTimeEditView addSubview:header];
    
    _validTimeTxt = [[UITextField alloc]init];
    _validTimeTxt.layer.borderWidth = 1;
    _validTimeTxt.layer.borderColor = [UIColor colorWithRed:243 green:243 blue:243 alpha:1].CGColor;
    _validTimeTxt.layer.cornerRadius = 2;
    _validTimeTxt.placeholder = @"请输入保质时长...";
//    _validTimeTxt.backgroundColor = [UIColor redColor];
    _validTimeTxt.keyboardType = UIKeyboardTypeNumberPad;
    [_validTimeTxt becomeFirstResponder];
    _validTimeTxt.frame = CGRectMake(8, 74, 340, 45);
    [_expiredTimeEditView addSubview:_validTimeTxt];
}

-(void)initCreateTimeView{
   _createTimeEditView = [[UIView alloc]initWithFrame:CGRectMake(0, 488, 375, 324)];
   _createTimeEditView.backgroundColor = [UIColor colorWithRed:254/255.0 green:255/255.0 blue:254/255.0 alpha:1/1.0];
   _createTimeEditView.layer.cornerRadius = 5;
   [self.view addSubview:_createTimeEditView];

       
    UIView *header = [self createEditHeader:@"选择生产日期" tag:3  confirmButton:@selector(expiredUnitConfirmClick:) cancelButton:@selector(expiredUnitcancelClick:)];
    [_createTimeEditView addSubview:header];
    
    
    _producerTime = [[UIDatePicker alloc]init];
    _producerTime.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    _producerTime.frame = CGRectMake(2, 70, 375, 220);
    _producerTime.datePickerMode = UIDatePickerModeDate;
    [_createTimeEditView addSubview:_producerTime];

}


-(UIView *)createEditHeader:(NSString *)title tag:(int)tag confirmButton:(SEL )confirmMethod cancelButton:(SEL)cancelMethod{
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, 375, 57);
    
    UIImageView *smallRec = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"goods_edit_small_rectange"]];
    smallRec.frame = CGRectMake(154, 15, 70, 5);
    [view addSubview:smallRec];
    
    UIButton *expiredUnitcancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 35, 32, 22)];
     [expiredUnitcancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    expiredUnitcancelBtn.tag = tag;
     [expiredUnitcancelBtn setTitleColor:[UIColor colorWithRed:142/255.0 green:142/255.0 blue:142/255.0 alpha:1/1.0] forState:UIControlStateNormal];
     expiredUnitcancelBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [expiredUnitcancelBtn addTarget:self action:cancelMethod forControlEvents:UIControlEventTouchUpInside];
     [view addSubview:expiredUnitcancelBtn];
     
     UILabel *selectExpiredLbl = [[UILabel alloc]initWithFrame:CGRectMake(132, 35, 119, 24)];
    selectExpiredLbl.text = title;
     selectExpiredLbl.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
     [view addSubview:selectExpiredLbl];
     
     UIButton *confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(328, 35, 32, 22)];
     confirmBtn.tag = tag;
     [confirmBtn setTitleColor:[UIColor colorWithRed:109/255.0 green:96/255.0 blue:255/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
      [confirmBtn setTintColor:[UIColor colorWithRed:142/255.0 green:142/255.0 blue:142/255.0 alpha:1/1.0]];
    [confirmBtn addTarget:self action:confirmMethod forControlEvents:UIControlEventTouchUpInside];
     [view addSubview:confirmBtn];
    
    return view;
}

-(void)expiredUnitcancelClick:(UIButton *)btn{
    if (btn.tag == 1) {
        _expiredUnitEditView.hidden = YES;
    }else if(btn.tag == 2){
        [_validTimeTxt resignFirstResponder];
        _expiredTimeEditView.hidden = YES;
    }else if (btn.tag == 3){
        _createTimeEditView.hidden = YES;
    }else{
        NSLog(@"取消按钮的tag不存在");
    }
}

-(void)expiredUnitConfirmClick:(UIButton *)btn{
    NSLog(@"确认按钮被点击了tag= %ld",btn.tag);
    if (btn.tag == 1) {
        [_validTimeTxt resignFirstResponder];
        _expiredTimeEditView.hidden = YES;
        _validTimeValueLbl.text = _validTimeTxt.text;
    }else if (btn.tag == 2){
        NSArray *arr = @[@1,@30,@365];
        _timeUnitValue =arr[_timeUnitTmpBtn.tag];
        _expiredUnitEditView.hidden = YES;
        _validUnitValueLbl.text = _timeUnitTmpBtn.titleLabel.text;
    }else if (btn.tag == 3){
        NSLog(@"%@",self.producerTime.date);
        _createTimeValueLbl.text = [self dateConvert:self.producerTime.date];
        NSLog(@"选择的日期为:%@",_createTimeValueLbl.text);
        _createTimeEditView.hidden = YES;
    }else{
       NSLog(@"确认按钮的tag不存在");
    }
}


-(void)event:(UITapGestureRecognizer *)gesture
{
    NSLog(@"v自定义手势被点击了!");
    if (gesture == _validTimeTapGesture) {
        NSLog(@"保质期的view被点击了");
        [self initExpiredTimeView];
    }else if(gesture == _validUnitapGesture){
       NSLog(@"保质期单位的view被点击了");
        [self initValidUnitView];
    }else if(gesture == _createtapGesture){
        NSLog(@"生产日期的view被点击了");
        [self initCreateTimeView];
    }else{
        NSLog(@"无此手势！");
    }
}

-(void)expiredTimeUnitValueClick:(UIButton *)sender
{
    NSLog(@"按钮被点击了%@,tag:%ld",sender.titleLabel.text,(long)sender.tag);
    if (_timeUnitTmpBtn == nil) {
        sender.selected = YES;
        _timeUnitTmpBtn = sender;
    }else if (_timeUnitTmpBtn != nil && _timeUnitTmpBtn == sender){
        sender.selected = YES;
    }else if(_timeUnitTmpBtn !=nil && _timeUnitTmpBtn != sender){
        _timeUnitTmpBtn.selected = NO;
        sender.selected = YES;
        _timeUnitTmpBtn = sender;
    }else{
        NSLog(@"按钮出现了第四章情况");
    }
}

-(void)tagClick:(UIButton *)sender{
    NSLog(@"按钮被点击了,button tag=%ld",(long)sender.tag);
    _tagId = self.tagsDataSoruce[sender.tag][@"tagId"];
    [sender setBackgroundColor:[UIColor colorWithRed:103/255.0 green:96/255.0 blue:255/255.0 alpha:1/1.0]];
    sender.selected = YES;
    if (_tagTmpBtn == nil || _tagTmpBtn == sender) {
        sender.layer.borderWidth = 0;
        _tagTmpBtn = sender;
    
    }else if(_tagTmpBtn !=nil && _tagTmpBtn != sender){
        _tagTmpBtn.selected = NO;
        [_tagTmpBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0]];
         sender.layer.borderWidth = 1;
        _tagTmpBtn = sender;
    }else{
        NSLog(@"按钮出现了第三种情况!");
    }

}


#pragma 提交录入的内容到服务器
-(void)sbumit:(UIButton *)sender{
    NSLog(@"goodsNo:%@,保质期时间:%@,保质期单位:%@,生产日期:%@,标签id:%@,图片地址:%@"
      ,self.goodsNo,self.validTimeValueLbl.text,self.timeUnitValue,self.createTimeValueLbl.text,self.tagId,self.imgUrl);
    if (self.goodsNo == nil || [self.goodsNo isEqualToString:@""]) {
         [self alert:@"error" message:@"系统参数错误，请联系管理员" actionWithTitle:@"确定"];
    }
    
    if(self.timeUnitValue == nil ||
       self.createTimeValueLbl == nil ||
       self.tagId == nil||
       self.imgUrl == nil){
       [self alert:@"警告" message:@"请填写必填参数" actionWithTitle:@"确定"];
    }
    NSInteger time = [self.validTimeValueLbl.text intValue];
    NSInteger unit = [self.timeUnitValue intValue];
    
    NSDictionary *dict = [[NSDictionary alloc]init];
    dict = @{@"username":@"cheng",
                 @"goodsNo":self.goodsNo,
                 @"producerTime":self.createTimeValueLbl.text,
                 @"validTime":[NSString stringWithFormat:@"%ld",time * unit],
                 @"tagId":self.tagId,
             @"imgUrl":self.imgUrl
        };
    NSLog(@"请求后端添加物品的参数为:%@",dict);
    NSDictionary *res = [NetWorkRequest postRequestParam:@"/remind/user/addGoods" param:dict];
    NSLog(@"请求后端添加用户扫码信息结果为:%@",res);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"录入成功" message:@"录入成功" preferredStyle:UIAlertControllerStyleAlert];
       [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           [self continueScan];
       }]];
       [self presentViewController:alertController animated:YES completion:nil];
}

-(void)alert:(NSString *)title message:(NSString *)msg actionWithTitle:(NSString *)actionTitle{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"请输入必填内容" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}



#pragma 最底下继续录入按钮方法
-(void)continueScan{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma 进入相机
-(void)takePhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];

    picker.delegate=self;

    picker.sourceType = UIImagePickerControllerSourceTypeCamera;

    picker.allowsEditing=YES;

    [self presentViewController:picker animated:YES completion:nil];


}


#pragma 拍照的代理方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker{

    [picker dismissViewControllerAnimated:YES completion:nil];

}

#pragma 拍照的代理方法
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info{
    [picker dismissViewControllerAnimated:NO completion:^{

    [UIApplication sharedApplication].statusBarHidden=NO;

    NSString*mediaType = [info objectForKey:UIImagePickerControllerMediaType];

    if([mediaType isEqualToString:@"public.image"])

    {

        UIImage *originImage=[[UIImage alloc]init];

        originImage=[info objectForKey:UIImagePickerControllerEditedImage];
       //赋值控件
        self->_imgView.image = originImage;
        
        [self uploadImage:originImage uri:@"/remind/goods/fileUpload" userName:[@"cheng" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    }];

}


#pragma 时间转换会自动转换时区
-(NSString *)dateConvert:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
     //设置时间格式
    NSTimeZone *timeZone=[NSTimeZone systemTimeZone];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    formatter.timeZone = timeZone;
    return [formatter stringFromDate:date];
}








-(void)uploadImage:(UIImage *)img uri:(NSString *)uri userName:(NSData *)userName
{
    static NSDictionary * dict = nil;
    uri = [NSString stringWithFormat:@"%@%@",BASE_URL,uri];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:uri parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *data = UIImageJPEGRepresentation(img,0.7);
        //这里注意UIImageJPEGRepresentation 详情看下图格式
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];

        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpg"];
        [formData appendPartWithFormData:userName name:@"userName"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //成功后处理
        NSString *code = [responseObject valueForKey:@"code"];
        NSString *message = [responseObject valueForKey:@"msg"];
        if ([code isEqualToString:@"0"]) {
            dict = responseObject[@"data"];
            NSLog(@"图片上传请求成功，返回的结果是:%@",dict);
            self.imgUrl = (NSString *)dict;
        }
        else{
            NSLog(@"调用返回的结果是失败，失败原因:%@",message);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"调用后端上传图片过程中出现异常，原因:%@", error);
    }];
}

@end
