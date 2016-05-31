//
//  MBNewBabyController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/30.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBNewBabyController.h"
#import "MBNewBabyCell.h"
@interface MBNewBabyController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSArray *_dateArray;
    NSInteger _row;
}
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

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
// [self.collectionView setContentOffset:CGPointMake(_row*(UISCREEN_WIDTH -90)/3, 0) animated:YES];
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

@end
