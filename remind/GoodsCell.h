//
//  goodsTableViewCell.h
//  remind
//
//  Created by 程恒 on 2020/2/22.
//  Copyright © 2020 程恒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsCellModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GoodsCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIView *goodsView;

@property (nonatomic, strong) IBOutlet UIImageView *goodsImgView;

@property (nonatomic, strong) IBOutlet UIView *titleContentView;

@property (nonatomic, strong) IBOutlet UILabel *goodsNameLabel;

@property (nonatomic, strong) IBOutlet UILabel *goodsExpiredLabel;

@property (nonatomic, strong)GoodsCellModel  *model;

@end

NS_ASSUME_NONNULL_END
