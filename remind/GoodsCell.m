//
//  goodsTableViewCell.m
//  remind
//
//  Created by 程恒 on 2020/2/22.
//  Copyright © 2020 程恒. All rights reserved.
//

#import "GoodsCell.h"
@implementation GoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setUpView];
    }
    return self;
}


-(void)setUpView{
        _goodsView = [[UIView alloc]init];
        _goodsView.frame = CGRectMake(9,self.contentView.frame.origin.y,350,100);
        _goodsView.layer.cornerRadius = 5;
        _goodsView.layer.borderWidth = 0.5;

        _goodsView.layer.borderColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0].CGColor;
//        goodsView.layer.bor
        [self.contentView addSubview:_goodsView];
        
        
        _goodsImgView = [[UIImageView alloc] init];
        _goodsImgView.frame =  CGRectMake(8, 15, 70, 70);
        _goodsImgView.image = [UIImage imageNamed:@"goods.jpeg"];
        [_goodsView addSubview:_goodsImgView];
    
    
        _goodsNameLabel= [[UILabel alloc]initWithFrame:CGRectMake(87, 0, 260, 60)];
        _goodsNameLabel.numberOfLines = 0;
//        _goodsNameLabel.backgroundColor = [UIColor redColor];
//        [_goodsNameLabel sizeToFit];
        _goodsNameLabel.textAlignment =  NSTextAlignmentLeft;
        [_goodsNameLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:14]];
        [_goodsView addSubview:_goodsNameLabel];
                
        _goodsExpiredLabel = [[UILabel alloc]initWithFrame:CGRectMake(87, 76, 300, 14)];
        _goodsExpiredLabel.numberOfLines = 0;
        _goodsExpiredLabel.textColor =  [UIColor colorWithRed:142/255.0 green:142/255.0 blue:142/255.0 alpha:1/1.0];
        [_goodsExpiredLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:10]];
        [_goodsView addSubview:_goodsExpiredLabel];
}


- (void)setModel:(GoodsCellModel *)model
{
    _model = model;
    
    
    self.goodsNameLabel.attributedText = [self titleWithTag:model.tag withGoodsName:model.goodsName];
    
    self.goodsExpiredLabel.attributedText = [self expiredText:model.expiredInfo];
    
    static UIImage *img;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
            img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.imgUrl]]];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            self.goodsImgView.image = img;
        });
            
    });
}


-(NSMutableAttributedString *)expiredText:(ExpiredInfo *)expiredInfo{
   NSMutableAttributedString *txt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",expiredInfo.goodsExpiredNameText,expiredInfo.goodsExpiredTimeText]];
    [txt addAttribute:NSForegroundColorAttributeName value:expiredInfo.goodsExpiredNameColor range:NSMakeRange(0,expiredInfo.goodsExpiredNameText.length)];
    [txt addAttribute:NSForegroundColorAttributeName value:expiredInfo.goodsExpiredTimeColor range:NSMakeRange(expiredInfo.goodsExpiredNameText.length,txt.length-expiredInfo.goodsExpiredNameText.length)];
    return txt;
}



- (UIImage*) imageWithUIView:(UIView*) view{
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tImage;
}


-(NSMutableAttributedString *) titleWithTag:(Tag *)tag
                                withGoodsName:(NSString *)goodsName{
    //创建  NSMutableAttributedString 富文本对象
    NSMutableAttributedString *maTitleString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",goodsName]];
    //创建一个小标签的Label
    
    CGFloat tagW = 12*tag.tagName.length +4*3;
    UILabel *tagLabel = [UILabel new];
    tagLabel.frame = CGRectMake(0, 0, tagW*3, 16*3);
    tagLabel.text = tag.tagName;
    tagLabel.font = [UIFont boldSystemFontOfSize:12*3];
    tagLabel.textColor = tag.textColor;

    tagLabel.layer.borderColor = tag.borderColor.CGColor;
    tagLabel.layer.borderWidth = 1 * 3;
    tagLabel.clipsToBounds = YES;
    tagLabel.layer.cornerRadius = 7.5 *3;
    tagLabel.textAlignment = NSTextAlignmentCenter;
    //调用方法，转化成Image
    UIImage *image = [self imageWithUIView:tagLabel];
    //创建Image的富文本格式
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.bounds = CGRectMake(0, -2.5, tagW, 16); //这个-2.5是为了调整下标签跟文字的位置
    attach.image = image;
    //添加到富文本对象里
    NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:attach];
    [maTitleString insertAttributedString:imageStr atIndex:0];//加入文字前面
    //[maTitleString appendAttributedString:imageStr];//加入文字后面
    //[maTitleString insertAttributedString:imageStr atIndex:4];//加入文字第4的位置

    //注意 ：创建这个Label的时候，frame，font，cornerRadius要设置成所生成的图片的3倍，也就是说要生成一个三倍图，否则生成的图片会虚，同学们可以试一试。
    return maTitleString;
}
@end
