//
//  ViewController.m
//  remind
//
//  Created by 程恒 on 2020/2/21.
//  Copyright © 2020 程恒. All rights reserved.
//

#import "ViewController.h"
#import "GoodsCell.h"
#import "NetWorkRequest.h"
#import "GoodsCellModel.h"
@interface ViewController ()
@property(nonatomic,strong)NSDictionary *dataSource;

@property(nonatomic,strong)NSArray *isExpiredGoods;

@property(nonatomic,strong)NSArray *notExpiredGoods;

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UIView *headerStopView;

@end

@implementation ViewController

-(void) viewWillAppear:(BOOL)animated{
//    self.dataSource =  [NetWorkRequest getRequest:@"/remind/getMyGoods?userName=cheng"];
    
    NSLog(@"viewWillAppear");
       self.dataSource =  [NetWorkRequest getRequest:@"/remind/getMyGoods?userName=cheng"];
       NSLog(@"d响应为:%@",self.dataSource);
      _isExpiredGoods = self.dataSource[@"isExpiredGoods"];
       
       _notExpiredGoods = self.dataSource[@"notExpiredGoods"];
     NSLog(@"过期数:%lu,未过期数:%lu",(unsigned long)_isExpiredGoods.count, (unsigned long)_notExpiredGoods.count);
        
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        scrollView.frame = self.view.bounds;
        scrollView.scrollEnabled = YES;
    //    scrollView.contentSize =CGSizeMake(375, 3000);
        [self.view addSubview: scrollView];
        
        _headerStopView = [[UIView alloc]init];
        _headerStopView.frame = CGRectMake(0, 0, 375, 95);
        _headerStopView.backgroundColor = [UIColor colorWithRed:82/255.0 green:73/255.0 blue:252/255.0 alpha:1.0];
        _headerStopView.hidden = YES;
        [self.view addSubview:_headerStopView];
        

        
    //    创建一个TableView对象
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -50, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    //    _tableView.frame = self.view.bounds;
         //设置delegate和DataSouce
        _tableView.tableHeaderView = [self HeaderView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellAccessoryNone;
         //添加到界面上
        [scrollView addSubview:_tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    
    self.navigationController.navigationBar.hidden = YES;
    
   
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= 180) {
        _headerStopView.hidden = NO;
    }else{
        _headerStopView.hidden = YES;
    }
}

-(UIView *)HeaderView{
    UIView *background = [[UIView alloc]init];
    background.frame =CGRectMake(0, 0, 375, 242);
    background.backgroundColor = [UIColor colorWithRed:82/255.0 green:73/255.0 blue:252/255.0 alpha:1.0];
    
//    [scrollView addSubview:background];

    UIImageView *_imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 206.1,375, 41)];
    _imgView.image = [UIImage imageNamed:@"ware.png"];
    [background addSubview:_imgView];
    
    
    int count = _isExpiredGoods.count + _notExpiredGoods.count;
    
    UILabel *_all = [[UILabel alloc]init];
    _all.frame = CGRectMake(20, 77, 146, 30);
    _all.text = [NSString stringWithFormat:@"拥有%d件物品",count];
    _all.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    _all.font = [UIFont fontWithName:@"PingFangSC-Medium" size:22];


    UILabel *_expired = [[UILabel alloc]init];
    _expired.frame = CGRectMake(20, 100, 200, 20);
    _expired.text = [NSString stringWithFormat:@"过期物品%lu件",(unsigned long)_isExpiredGoods.count];
    _expired.textColor = [UIColor whiteColor];
    _expired.font = [UIFont systemFontOfSize:12];

    UILabel *_soonExpired = [[UILabel alloc]init];
    _soonExpired.frame = CGRectMake(20, 130, 200, 20);
    _soonExpired.text = [NSString stringWithFormat:@"即将过期物品4件"];
    _soonExpired.font = [UIFont systemFontOfSize:12];
    _soonExpired.textColor = [UIColor whiteColor];
    
    [background addSubview:_expired];
    [background addSubview:_soonExpired];
    [background addSubview:_all];
    
    
    return background;
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _isExpiredGoods.count;
    }else{
        return _notExpiredGoods.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"已过期物品";
    }else{
        return @"我的物品";
    }
}

//- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 120;
//}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * ID = [NSString stringWithFormat:@"goods_cell-%ld-%ld",(long)indexPath.section,(long)indexPath.row];
   
   //重用单元格
    GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //初始化单元格
    if(cell == nil){
        cell = [[GoodsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict;
    if (indexPath.section == 0) {
        dict = [_isExpiredGoods objectAtIndex:indexPath.row];

    }else{
        dict = [_notExpiredGoods objectAtIndex:indexPath.row];
    }
    NSLog(@"dict==>%@",dict);
    
    cell.model = [[GoodsCellModel alloc]initWithDictionary:dict];

   return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 
{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath){

        NSLog(@"点击了删除");
    }];
    

  return @[deleteAction];
 
}
 
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
   editingStyle = UITableViewCellEditingStyleDelete;
 
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     return 2;//6段
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 40;
    else
        return 40;
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    if(section == 0){
        UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 375, 100)];
        sectionView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(12, 2, 25, 25);
        imageView.image = [UIImage imageNamed:@"section_expired_icon.png"];
        [sectionView addSubview:imageView];
        
        UILabel *lbl = [[UILabel alloc]init];
        lbl.frame = CGRectMake(42, 2, 200, 22);
        [lbl setFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:16]];
        lbl.text = @"已过期的物品";
        [sectionView addSubview:lbl];
        return sectionView;
    }else{
        UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 375, 100)];
               sectionView.backgroundColor = [UIColor whiteColor];
               
               UIImageView *imageView = [[UIImageView alloc]init];
               imageView.frame = CGRectMake(12, 2, 25, 25);
               imageView.image = [UIImage imageNamed:@"section_expired_icon.png"];
               [sectionView addSubview:imageView];
               
               UILabel *lbl = [[UILabel alloc]init];
               lbl.frame = CGRectMake(42, 2, 200, 22);
               [lbl setFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:16]];
               lbl.text = @"我的物品";
               [sectionView addSubview:lbl];
            return sectionView;
    }


//        NSMutableAttributedString *selecter = [[NSMutableAttributedString alloc] initWithString:@"        即已经过期的物品"];
//        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
//        attach.bounds = CGRectMake(0, 0, 25, 25);
//        attach.image = [UIImage imageNamed:@"section_expired_icon.png"];
//        NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:attach];
//        [selecter insertAttributedString:imageStr atIndex:0];
//        UILabel *selectorLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 300, 22)];
//        selectorLabel.numberOfLines = 0;
//        [selectorLabel setFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:16]];
//        selectorLabel.attributedText = selecter;
//

//        [sectionView addSubview:selectorLabel];
    
}

@end
