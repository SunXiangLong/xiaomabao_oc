//
//  MBReleaseTopicViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/9.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBReleaseTopicViewController.h"
#import "MBWeatherTableViewCell.h"
#import "MBWeatherAndMoodViewController.h"
@interface MBReleaseTopicViewController ()
{
    NSString *_quanzhi;
    NSString *_cat_id;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MBReleaseTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MBWeatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBWeatherTableViewCell"];
    
    if (indexPath.row==0) {
        static NSString *idfent = @"ssss";
        UITableViewCell *sss = [tableView dequeueReusableCellWithIdentifier:idfent];
        if (!cell) {
            sss = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idfent];
        }
        return sss;
        
    }
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBWeatherTableViewCell" owner:nil options:nil]firstObject];
    }
    
    if (_quanzhi) {
        cell.showImageView.image = [UIImage imageNamed:@"mCircle_image"];
        cell.labletext.text = @"分享到那个圈子？";
        [cell.biaoziImageView sd_setImageWithURL:[NSURL URLWithString:_quanzhi] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
        
    }else{
        cell.showImageView.image = [UIImage imageNamed:@"mCircle_image"];
        cell.labletext.text = @"分享到那个圈子？";;
        
        
    }
    
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    MBWeatherAndMoodViewController *VC = [[MBWeatherAndMoodViewController alloc] init];
    VC.circleBlock = ^(NSDictionary *dic){
        _quanzhi = dic[@"cat_icon"];
        _cat_id = dic[@"cat_id"];
        [self.tableView reloadData];
    };
    
    [self pushViewController:VC Animated:YES];
    
    VC.title = @"发帖子";
    VC.type = MBcircleType ;
    
    
}


@end
