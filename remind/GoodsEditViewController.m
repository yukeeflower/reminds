//
//  GoodsEdit2ViewController.m
//  remind
//
//  Created by 程恒 on 2020/3/1.
//  Copyright © 2020 程恒. All rights reserved.
//

#import "GoodsEdit2ViewController.h"
#import "NetWorkRequest.h"
@interface GoodsEdit2ViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong)NSArray *dataSouce;

@end

@implementation GoodsEdit2ViewController

- (void)viewDidLoad {
    self.tags.delegate = self;
    self.tags.dataSource = self;
    self.dataSouce = [NetWorkRequest getRequest:@"/remind/getAllTags"];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger) row forComponent:(NSInteger)component {
    return self.dataSouce[row][@"tagName"];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
        numberOfRowsInComponent:(NSInteger)component
{
        return self.dataSouce.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *selFood = self.dataSouce[row][@"tagName"];
    NSLog(@"%@", selFood);
}

- (IBAction)submit:(id)sender {
    
    
}
@end
