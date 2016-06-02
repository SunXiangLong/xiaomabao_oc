//
//  MBNewBabyController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/30.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBNewBabyController.h"
#import "MBNewBabyCell.h"
#import "MBCollectionHeadView.h"
#import "MBNewBabyOneTableCell.h"
#import "MBNewBabyHeadView.h"
#import "MBNewBabyTwoTableCell.h"
#import "MBNewBabyThreeTableCell.h"
#import "MBNewBabyFourTableCell.h"
#import "MBBabyToolController.h"
@interface MBNewBabyController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_dateArray;
    NSInteger _row;
}
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;

@end

@implementation MBNewBabyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor    whiteColor];
    _dateArray = [NSArray arrayWithObjects:@"五月1日",@"五月2日",@"五月3日",@"五月4日",@"五月6日",@"五月7日", nil];
    _row = 1;
    UICollectionViewFlowLayout *flowLayout = ({
        UICollectionViewFlowLayout *flowLayout =  [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((UISCREEN_WIDTH-90)/3,45);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
       
        flowLayout;
    });
    self.collectionView.scrollEnabled = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
   [self.collectionView registerNib:[UINib nibWithNibName:@"MBNewBabyCell" bundle:nil] forCellWithReuseIdentifier:@"MBNewBabyCell"];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = ({
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 390)];
        MBNewBabyHeadView  *headView = [MBNewBabyHeadView instanceView];
        headView.frame = view.frame;
        [view addSubview:headView];
        
        view;
    });

}

- (IBAction)back:(UIButton *)sender {
    
    NSLog(@"%ld",_row);
  

    if (_row == _dateArray.count-1) {
        return;
    }
    _row ++;
    [self.collectionView reloadData];
    CGFloat width = (UISCREEN_WIDTH -90)/3;
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x + width, 0) animated:YES];
}
- (IBAction)next:(UIButton *)sender {

    
    CGFloat width = (UISCREEN_WIDTH -90)/3;
    
    NSLog(@"%ld",_row);
   
    if (_row ==0) {
        return;
    }
     _row --;
    [self.collectionView reloadData];
    
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x - width, 0) animated:YES];

    
}

-(NSString *)titleStr{

 return @"AngleBody";
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dateArray.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MBNewBabyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBNewBabyCell" forIndexPath:indexPath];
    cell.date.text = _dateArray[indexPath.item];
    cell.date.font = SYSTEMFONT(14);
    cell.time.font = SYSTEMFONT(10);
    if (_row == indexPath.row) {
        cell.date.font = SYSTEMFONT(18);
        cell.time.font = SYSTEMFONT(13);
    }
   return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0: return 5;
        case 1: return 1;
        case 2: return 5;
        default:return 1;
    
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    switch (indexPath.section) {
        case 0:  return 65;;
        case 1:  return 45;
        case 2:  return 140;
        default: return (UISCREEN_WIDTH-2)/2*200/375+2+((UISCREEN_WIDTH -6)/4-10)+54;
            
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    if (section == 2 || section == 3) {
        
        return 60;
    }
    
        return 0.00001;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 50)];
    MBCollectionHeadView  *headView = [MBCollectionHeadView instanceView];
    headView.frame = View.frame;
    switch (section) {
        case 0: headView.tishi.text = @"- 提醒事项 -";     break;
        case 1: headView.tishi.text = @"- 工具 -";         break;
        case 2: headView.tishi.text = @"- 麻包圈推荐 -";    break;
        case 3: headView.tishi.text = @"- 麻包精选活动 -";   break;
        default:
            break;
    }

    [View addSubview:headView];
    return View;

}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView *view = [[UIView alloc] init];
    
    
    
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    switch (indexPath.section) {
        case 0: {
            MBNewBabyOneTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBNewBabyOneTableCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"MBNewBabyOneTableCell"owner:nil options:nil]firstObject];
            }
            [self setUIEdgeInsetsZero:cell];
            return cell;
        }
        case 1: {  MBNewBabyTwoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBNewBabyOneTableCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"MBNewBabyTwoTableCell"owner:nil options:nil]firstObject];
            }
            [self setUIEdgeInsetsZero:cell];
            return cell;
        }
        case 2: {  MBNewBabyOneTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBNewBabyThreeTableCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"MBNewBabyThreeTableCell"owner:nil options:nil]firstObject];
            }
            [self setUIEdgeInsetsZero:cell];
            return cell;
        }
            
        default: {  MBNewBabyOneTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBNewBabyFourTableCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"MBNewBabyFourTableCell"owner:nil options:nil]firstObject];
            }
            [self setUIEdgeInsetsZero:cell];
            return cell;
        }
            

    }
  
    
}
/**
 *  让cell地下的边线挨着左边界
 */
- (void)setUIEdgeInsetsZero:(UITableViewCell *)cell{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins   = false;

}
/**
 *  移除cell最下的线
 */
- (void)setRemoveUIEdgeInsetsZero:(UITableViewCell *)cell{
    cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);
    cell.layoutMargins = UIEdgeInsetsMake(0, 10000, 0, 0);
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0: {}     break;
        case 1: {
            MBBabyToolController *VC = [[MBBabyToolController alloc] init];
            [self pushViewController:VC Animated:YES];
        
        }              break;
        case 2: {}     break;
        case 3: {}     break;
        default:
            break;
    }
}

@end
