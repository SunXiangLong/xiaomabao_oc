//
//  MBMaoBaoElectronicCardViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/3/20.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBMaoBaoElectronicCardViewController.h"
#import "MBWelfareCardModel.h"
#import "MBWelfareCardCollectionViewCell.h"
#import "MBWelfareCardModel.h"
#import "MBElectronicConfirmationOrderViewController.h"
@interface MBMaoBaoElectronicCardViewController ()
{
    NSInteger _page;
    UIView *_makeView;
    MBElectronicCardModel *_cards_custom_model;
    MBElectronicCardOrderModel *_orderModel;
}
@property (weak, nonatomic) IBOutlet UILabel *topCardAllMoney;
@property (weak, nonatomic) IBOutlet UIButton *settlementBtn;
@property (weak, nonatomic) IBOutlet UILabel *cardAllMoney;
@property (weak, nonatomic) IBOutlet UILabel *cardCount;
@property (weak, nonatomic) IBOutlet UITextField *countTextField;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UICollectionView *topColleectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *bottomCollerctionView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) NSMutableArray <MBElectronicCardModel *> *modelArray;
@property (strong, nonatomic) NSMutableArray <MBElectronicCardModel *> *seleCtionModelArray;

@end

@implementation MBMaoBaoElectronicCardViewController
-(NSMutableArray<MBElectronicCardModel *> *)modelArray{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    
    return _modelArray;
}
-(NSMutableArray<MBElectronicCardModel *> *)seleCtionModelArray{
    if (!_seleCtionModelArray) {
        _seleCtionModelArray = [NSMutableArray array];
    }
    
    return _seleCtionModelArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self requestData];
}
- (void)setUI{
    _page = 1;
    [self.navBar removeFromSuperview];
    self.navBar = nil;
    self.view.backgroundColor = UIcolor(@"f3f3f3");
    [self.bottomView layoutIfNeeded];
    [self.topView layoutIfNeeded];
    [self addBottomLineView:self.topView];
    [self addTopLineView:self.bottomView];
    
    UIView *makeView = [[UIView alloc] initWithFrame:self.view.frame];
    makeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_makeView = makeView];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"electronicCardOrderReloadData" object:nil] subscribeNext:^(NSNotification *notification) {
        
        
        for (MBElectronicCardModel *moel in _seleCtionModelArray) {
            moel.isSelection  = false;
        }
        _countTextField.text = nil;
        [_seleCtionModelArray removeAllObjects];
        [self.topColleectionView reloadData];
        [self.bottomCollerctionView reloadData];
        [self statisticalCard];
    }];
}
-(void)requestData{
    
    [self show];
    [MBNetworking newGET:string(BASE_URL_root, string(@"/giftcard/electronic_card/", s_Integer(_page))) parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self dismiss];
        if (_page == 1) {
            _cards_custom_model = [MBElectronicCardModel yy_modelWithDictionary:responseObject[@"cards_custom"]];
            _cards_custom_model.isCustom = true;
            _countTextField.placeholder = [NSString stringWithFormat:@"请输入自定义面额（1-%@的整数）",_cards_custom_model.card_max_money];
            _makeView.hidden = true;
        }
        if ([responseObject[@"cards_list"] count] > 0) {
            [self.modelArray addObjectsFromArray:[NSArray modelDictionary:responseObject modelKey:@"cards_list" modelClassName:@"MBElectronicCardModel"]];
            _page ++;
            [self.topColleectionView reloadData];
        }else{
            return ;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self show:@"请求失败，请检查你的网络连接或稍后再试" time:.5];
    }];
    
}
- (IBAction)addElectronicMoney:(id)sender {
_cards_custom_model.card_money = [NSString stringWithFormat:@"%.2f",[_countTextField.text floatValue]];
    if ([_cards_custom_model.card_money integerValue] == 0) {
        [self show:@"请输入一个自定义金额" time:1];
        return;
    }
    [self.countTextField resignFirstResponder];
    __block BOOL isThree = false ;
    [_seleCtionModelArray enumerateObjectsUsingBlock:^(MBElectronicCardModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.card_money isEqualToString:_cards_custom_model.card_money]) {
            obj.count ++;
            isThree = true;
            return ;
        }
    }];
    
    if (!isThree) {
        [_modelArray enumerateObjectsUsingBlock:^(MBElectronicCardModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([_cards_custom_model.card_money isEqualToString:obj.card_money]) {
                obj.isSelection = true;
                obj.count = 1;
                [self.seleCtionModelArray addObject:obj];
                isThree = true;
                return ;
            }
        }];
        if (!isThree) {
            MBElectronicCardModel *model = _cards_custom_model;
            model.count = 1;
            model.isSelection = true;
            [self.seleCtionModelArray addObject:model];
        }
        
        

    }
    [self.topColleectionView reloadData];
    self.bottomCollerctionView.hidden = false;
    [self.bottomCollerctionView reloadData];
    [self statisticalCard];
    
    
}
- (IBAction)settlement:(id)sender {
   
    
    NSString *sid  = [MBSignaltonTool getCurrentUserInfo].sid;
    if (!sid) {
        [self  loginClicksss:@"mabao"];
        return ;
    }
    
   [self reloadData];
}

- (void)statisticalCard{

    __block NSInteger count = 0;
    __block   NSInteger money = 0;
    [_seleCtionModelArray enumerateObjectsUsingBlock:^(MBElectronicCardModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        count+= obj.count;
        money+= [obj.card_money integerValue]*obj.count;
    }];

    _cardCount.text = s_Integer(count);
    _cardAllMoney.text = string(@"￥", s_Integer(money));
    _topCardAllMoney.text = string(@"￥", s_Integer(money));
    [self.settlementBtn setTitle:[NSString stringWithFormat:@"去结算(%ld)",count] forState:UIControlStateNormal];
    
    if (self.seleCtionModelArray.count >0) {
        self.settlementBtn.backgroundColor = UIcolor(@"e8564e");
        self.settlementBtn.enabled = true;
        
    }else{
        self.settlementBtn.enabled = false;
        
        self.settlementBtn.backgroundColor = [UIColor grayColor];
    }
}


-(void)reloadData
{
    [self show];
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking POST:string(BASE_URL_root, @"/giftflow/checkout") parameters:@{@"session":sessiondict,@"mabao_card":@"",@"inv_type":@"",@"inv_payee":@"",@"inv_content":@""} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
       [self.seleCtionModelArray enumerateObjectsUsingBlock:^(MBElectronicCardModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           NSString *str = [NSString stringWithFormat:@"%@|%@|%ld",obj.card_id,obj.card_money,(long)obj.count];
           [formData appendPartWithFormData:[str dataUsingEncoding:NSUTF8StringEncoding] name:[NSString stringWithFormat:@"card[%ld]",idx]];

       }];
     
    } progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [self dismiss];
        MMLog(@"%@",responseObject);
    
        if ([responseObject[@"status"] isKindOfClass:[NSNumber class]]&&[responseObject[@"status"] integerValue] == 0) {
            
            [self show:@"登录超时,请重新登录!" time:.5];
            return ;
        }
        _orderModel = [MBElectronicCardOrderModel yy_modelWithDictionary:responseObject];
        [self performSegueWithIdentifier:@"MBElectronicConfirmationOrderViewController" sender:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败！" time:1];
    }];
    
    
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MBElectronicConfirmationOrderViewController *VC = (MBElectronicConfirmationOrderViewController *)segue.destinationViewController;
    VC.orderModel = _orderModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if ([collectionView isEqual:self.topColleectionView] ) {
         return self.modelArray.count;
    }
    
    return self.seleCtionModelArray.count;
   
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([collectionView isEqual:self.topColleectionView] ) {
        MBElectronicCardOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBElectronicCardOneCell" forIndexPath:indexPath];
        cell.model = _modelArray[indexPath.row];
        return cell;
    }
    MBElectronicCardTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBElectronicCardTwoCell" forIndexPath:indexPath];
    cell.model = _seleCtionModelArray[indexPath.row];
    WS(weakSelf)
    cell.delete = ^(MBElectronicCardModel *model){
        
        if (!model.isSelection) {
            NSInteger row = [weakSelf.modelArray indexOfObject:model];
            NSInteger idnex = [weakSelf.seleCtionModelArray indexOfObject:model];
            [weakSelf.seleCtionModelArray removeObject:model];
            [weakSelf.bottomCollerctionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:idnex inSection:0]]];
            if (weakSelf.seleCtionModelArray.count == 0) {
                weakSelf.bottomCollerctionView.hidden = true;
            }
            [weakSelf.topColleectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:row inSection:0]]];
            
        }
       
        [weakSelf statisticalCard];
    };
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:self.topColleectionView]&&!_modelArray[indexPath.row].isSelection ) {
        _modelArray[indexPath.row].isSelection = true;
        _modelArray[indexPath.row].count = 1;
         [self.seleCtionModelArray addObject:_modelArray[indexPath.row]];
        [self.topColleectionView reloadData];
        self.bottomCollerctionView.hidden = false;
        [self.bottomCollerctionView reloadData];
        [self statisticalCard];
    }

}
#pragma mark <UICollectionViewDelegate>
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if ([collectionView isEqual:self.topColleectionView]){
        return 15;
    }
    return 20;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if ([collectionView isEqual:self.topColleectionView]){
        return UIEdgeInsetsMake(0, 15, 0, 15);
    }
    return UIEdgeInsetsMake(0, 20, 0, 0);
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([collectionView isEqual:self.topColleectionView]){
        return  CGSizeMake(55,27);
    }
     return  CGSizeMake((UISCREEN_WIDTH*46/125-86)*64/45+50,UISCREEN_WIDTH*46/125);
   
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
     MMLog(@"%@",self.countTextField.text);
   
    
    if ([textField.text integerValue] > [_cards_custom_model.card_max_money integerValue]) {
        [self show:[NSString stringWithFormat:@"最大输入%@",_cards_custom_model.card_max_money] time:1];
        _countTextField.text = _cards_custom_model.card_max_money;
        return;
    }
    
    
    
    
}
@end
