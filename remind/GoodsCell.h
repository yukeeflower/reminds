//
//  goodsTableViewCell.h
//  remind
//
//  Created by 程恒 on 2020/2/22.
//  Copyright © 2020 程恒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface goodsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *good1;
@property (weak, nonatomic) IBOutlet UIImageView *goodImg1;

@property (weak, nonatomic) IBOutlet UILabel *goodName1;
@property (weak, nonatomic) IBOutlet UILabel *goodTag1;

@property (weak, nonatomic) IBOutlet UIView *good2;
@property (weak, nonatomic) IBOutlet UIImageView *goodImg2;

@property (weak, nonatomic) IBOutlet UILabel *goodName2;
@property (weak, nonatomic) IBOutlet UILabel *goodTag2;

@end

NS_ASSUME_NONNULL_END
