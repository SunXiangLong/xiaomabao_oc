//
//  MBVideoDetailsViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/8/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBVideoDetailsViewController.h"
#import "MBVideoDetailsViewCell.h"
#import "MBVideoView.h"
#import "MBVideoPlaybackViewController.h"
@interface MBVideoDetailsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MBVideoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView registerNib:    [UINib nibWithNibName:@"MBVideoDetailsViewCell" bundle:nil] forCellReuseIdentifier:@"MBVideoDetailsViewCell"];
    _tableView.tableHeaderView = ({
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 105+(UISCREEN_WIDTH-22)*350/706)];
        
        MBVideoView *view = [MBVideoView instanceView];
        [headerView    addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            CGFloat height = 105+(UISCREEN_WIDTH-22)*350/706;
            make.height.mas_equalTo(height);
            
        }];
        
        headerView;
    
    
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureCell:(MBVideoDetailsViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return [tableView fd_heightForCellWithIdentifier:@"MBVideoDetailsViewCell" cacheByIndexPath:indexPath configuration:^(MBVideoDetailsViewCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
        
    }];
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 30)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(11, 0, UISCREEN_WIDTH, 29.5)];
    lable.text = @"推荐视频";
    lable.textColor = UIcolor(@"555555");
    lable.font = YC_YAHEI_FONT(12);
    [view addSubview:lable];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = UIcolor(@"cccccc");
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    return view;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] init];
    return footerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MBVideoDetailsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBVideoDetailsViewCell"];
    [self configureCell:cell atIndexPath:indexPath];
    [self setUIEdgeInsetsZero:cell];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

   MBVideoPlaybackViewController *VC = [[MBVideoPlaybackViewController   alloc] init];
    VC.videoURL = URL(@"http://baobab.wdjcdn.com/14571455324031.mp4");
    [self pushViewController:VC Animated:YES];
    
    
    
}

/**
 *  让cell地下的边线挨着左边界
 */
- (void)setUIEdgeInsetsZero:(UITableViewCell *)cell{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins   = false;
    
}

@end
