//
//  GoodsEdit2ViewController.h
//  remind
//
//  Created by 程恒 on 2020/3/1.
//  Copyright © 2020 程恒. All rights reserved.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoodsEditViewController : ViewController


@property (strong, nonatomic) IBOutlet UIDatePicker *producerTime;
//
//@property (weak, nonatomic) IBOutlet UITextField *days;
//
//@property (weak, nonatomic) IBOutlet UIPickerView *datePicker;
//
//@property (weak, nonatomic) IBOutlet UIPickerView *tags;
//- (IBAction)submit:(id)sender;
//
//@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
//
@property (nonatomic,retain) NSString *goodsNo;

@property (nonatomic,retain) NSString *goodsName;
@end

NS_ASSUME_NONNULL_END
