//
//  MBCountryCityViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/5/19.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBCountryCityViewController.h"
#import "MobClick.h"
@interface MBCountryCityViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MBCountryCityViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBCountryCityViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBCountryCityViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ID];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"中国内陆"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"+86"];
    
    return cell;
    
}

- (NSString *)titleStr{
    return @"选择地区";
}
@end
