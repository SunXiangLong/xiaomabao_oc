//
//  MBBabyShowViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/11/30.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBabyShowViewController.h"
#import "MBLovelyBabyImageCell.h"
#import "MBBabyDueDateController.h"
@interface MBBabyShowViewController ()
@property (copy, nonatomic) NSArray *imageArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomheight;
@property (weak, nonatomic) IBOutlet UITableView *tableVIew;
@end

@implementation MBBabyShowViewController
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    MMLog(@"%@",@(1111));
}

-(NSArray *)imageArray{
    if (!_imageArray) {
        _imageArray = @[[UIImage imageNamed:@"LovelyBaby01"],[UIImage imageNamed:@"LovelyBaby02"],[UIImage imageNamed:@"LovelyBaby03"]];
    }
    return _imageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
-(NSString *)titleStr{
return @"个性定制";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark ---UITableViewDelagate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.imageArray.count;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
        if (indexPath.row ==2) {
            return 676;
        }
        return 916;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
   
        MBLovelyBabyImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBLovelyBabyImageCell" forIndexPath:indexPath];
        cell.bandImageView.image = self.imageArray[indexPath.row];
        if (indexPath.row ==2) {
            _bottomheight.constant = 0 ;
        }
        return cell;
    
    
    
    
}
@end
