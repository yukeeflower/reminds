//
//  GoodsEdit2ViewController.h
//  remind
//
//  Created by 程恒 on 2020/3/1.
//  Copyright © 2020 程恒. All rights reserved.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoodsEdit2ViewController : ViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *producerTime;
@property (weak, nonatomic) IBOutlet UITextView *days;

@property (weak, nonatomic) IBOutlet UIPickerView *tags;
- (IBAction)submit:(id)sender;

@end

NS_ASSUME_NONNULL_END
