//
//  MBWeatherAndMoodViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/2/18.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBWeatherAndMoodViewController.h"
#import "MBWeatherMoodCollectionViewCell.h"
@interface MBWeatherAndMoodViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{

    MBWeatherMoodCollectionViewCell *_lastCell;
    NSInteger _lastRow;
    UIImage *_image;
    NSString *_row;
    
}
@property (weak, nonatomic) IBOutlet UILabel *topLabletext;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collviewHeight;

@end

@implementation MBWeatherAndMoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bottom.constant = UISCREEN_HEIGHT-TOP_Y-20;
    self.collviewHeight.constant = ((UISCREEN_WIDTH-15*6)/5+60)*2 ;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    flowLayout.minimumInteritemSpacing =5;
//    flowLayout.minimumLineSpacing = 5;
   
    [ self.collectionView registerNib:[UINib nibWithNibName:@"MBWeatherMoodCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MBWeatherMoodCollectionViewCell"];
    if (self.type==0) {
      self.infoArray = @[@"晴天",@"冰雹",@"多云",@"雨水",@"雷电",@"多云转晴",@"雾霾",@"下雪"];
        self.topLabletext.text = @" 今天天气如何？";
        self.collectionView.collectionViewLayout = flowLayout;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
    }else if  (self.type==1){
    self.infoArray = @[@"开心",@"窃喜",@"萌笑",@"害羞",@"困了",@"花痴",@"加油",@"委屈",@"伤心",@"棒棒"];
           self.topLabletext.text = @"今天心情如何？";
        self.collectionView.collectionViewLayout = flowLayout;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
    
    }else{
     
        [self setheadData];
        flowLayout.minimumLineSpacing = 45;
        flowLayout.minimumInteritemSpacing =10;
    }
    
}

#pragma mark --请求圈子信息
- (void)setheadData{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/communicate/categoryinfo"];
    if (! sid) {
        return;
    }
    [self show];
    [MBNetworking POST:url parameters:@{@"session":sessiondict}
               success:^(NSURLSessionDataTask *operation, MBModel *responseObject) {
                   
            NSLog(@"%@ %@",[responseObject valueForKey:@"status"],responseObject.data);
                   
                   
                   if(1 == [[responseObject valueForKey:@"status"]  intValue]){
                       [self dismiss];
                       
                          self.topLabletext.text = @"分享到那个圈子？";
                       self.infoArray = (NSArray *)responseObject.data;
                       
                       NSLog(@"%@",_infoArray);
                       
                       
                       
                       self.collectionView.dataSource = self;
                       self.collectionView.delegate = self;
                       
                   }
               } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                   
                   [self show:@"请求失败 " time:1];
                   NSLog(@"%@",error);
                   
               }
     ];
    
    
}
-(NSString *)rightStr{
    if (self.type ==MBcircleType) {
        return @"";
    }
    return @"确定" ;
}
-(NSString *)titleStr{
    
    return self.title?:@"";
}
-(void)rightTitleClick{
    
    if (self.type !=MBcircleType) {
        if (_image) {
            self.block(_image,self.type,_row);
            [self popViewControllerAnimated:YES];
        }else{
            [self show:@"请选择表情" time:1];
        }
    }
   
   
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
#pragma mark ---UICollectionViewDelegate
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{ if (self.type ==MBcircleType) {

    return UIEdgeInsetsMake(0, 20, 0, 20);
}
    UIEdgeInsets insets = UIEdgeInsetsMake(15, 15, 0,15);
   
    return insets;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type ==MBcircleType) {
        return CGSizeMake((UISCREEN_WIDTH-120)/3, (UISCREEN_WIDTH-120)/3+30);
        
    }else{
     return CGSizeMake((UISCREEN_WIDTH-15*6)/5,(UISCREEN_WIDTH-15*6)/5+30);
    }
   
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.infoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    MBWeatherMoodCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBWeatherMoodCollectionViewCell" forIndexPath:indexPath];
    
    if (self.type==0) {
        cell.lableText.text = self.infoArray[indexPath.row];
        cell.showImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"mWeather%ld",indexPath.row]];
    }else if(self.type==2){
        

        [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:_infoArray[indexPath.row][@"cat_icon"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
        cell.lableText.text = self.infoArray[indexPath.row][@"cat_name"];
    }else{
        cell.showImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"mood%ld",indexPath.row]];
          cell.lableText.text = self.infoArray[indexPath.row];
        
    }
    
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_lastCell) {
       
        if (self.type==0) {
              _lastCell.showImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"mWeather%ld",_lastRow]];
             _lastCell.lableText.textColor = [UIColor colorR:221 colorG:222 colorB:223];
        }else if(self.type==2){
            
            
            
        }else{
               _lastCell.showImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"mood%ld",_lastRow]];
             _lastCell.lableText.textColor = [UIColor colorR:221 colorG:222 colorB:223];
            
        }
     
    }
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath ];
    MBWeatherMoodCollectionViewCell *Mbcell = (MBWeatherMoodCollectionViewCell *)cell;
    Mbcell.lableText.textColor = [UIColor colorR:222 colorG:172 colorB:172];
    if (self.type==0) {
        Mbcell.showImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"mWeather%ld_image",indexPath.row]];
    }else if(self.type==2){
      self.circleBlock(_infoArray[indexPath.item]);
        [self popViewControllerAnimated:YES];
    }else{
        Mbcell.showImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"mood%ld_image",indexPath.row]];
        
    }
    
    _lastCell = Mbcell;
    _lastRow = indexPath.row;
    _image =   Mbcell.showImageView.image ;
    _row = [NSString stringWithFormat:@"%ld",indexPath.row];
}

@end
