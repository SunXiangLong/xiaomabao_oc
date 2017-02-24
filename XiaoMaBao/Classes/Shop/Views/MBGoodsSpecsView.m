//
//  MBGoodsSpecsView.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/2/23.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBGoodsSpecsView.h"
#import "MBSpecificationsCell.h"
#import "MBShoppingCartViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface MBGoodsSpecsView ()
{
    NSString *_spec;
}
@property (nonatomic, weak) MBGoodsSpecsRootModel *model;
@property (nonatomic, weak) UILabel *buyNumsLbl;
@property (nonatomic, weak) UILabel *priceLbl;
// 存放buttons的数组
@property (nonatomic, strong) NSMutableArray *selecterSpecsArr;
@property (nonatomic, strong) NSMutableArray *lastBtnsArr;
@property (nonatomic, strong) UIView *lastView;
/** 购买数量 */
@property (nonatomic, assign) int buyNum;
/**1 是规格选择   2 立即购买  3是加入购物车*/
@property (nonatomic,assign) NSInteger type;
@end
@implementation MBGoodsSpecsView
-(instancetype)initWithModel:(MBGoodsSpecsRootModel *)model type:(NSInteger)num{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, UISCREEN_WIDTH,UISCREEN_HEIGHT - UISCREEN_WIDTH/2);
        _model = model;
        _buyNum = 1;
        _type = num;
        _selecterSpecsArr = [NSMutableArray array];
        _lastBtnsArr = [NSMutableArray array];
        [_model.goodsSpecs enumerateObjectsUsingBlock:^(MBGoodsSpecsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_selecterSpecsArr addObject:@(0)];
            [_lastBtnsArr addObject:@(0)];
        }];
        self.backgroundColor = [UIColor whiteColor];
        [self setupBasicView];
    }
    return self;
}
/**
 *  设置视图的基本内容
 */
- (void)setupBasicView {
    
    UIView *iconView = [[UIView alloc] initWithFrame:(CGRect){10,-15,100,100}];
    iconView.layer.shadowOpacity = 0.8;// 阴影透明度
    iconView.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影的颜色
    iconView.layer.shadowRadius = 3;// 阴影扩散的范围控制
    iconView.layer.shadowOffset  = CGSizeMake(1, 1);// 阴影的范围
    iconView.layer.cornerRadius = 5;
//        iconView.layer.masksToBounds = YES;
    [self addSubview:iconView];
    
//    [iconView bezierPathWithRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:10];
    UIImageView *iconImgView = [[UIImageView alloc] init];
    [iconImgView sd_setImageWithURL:_model.goodsModel.goods_thumb placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    [iconView addSubview:iconImgView];
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    UIButton *XBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [XBtn setBackgroundImage:[UIImage imageNamed:@"goodsSpecsDelete"] forState:UIControlStateNormal];
    [XBtn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:XBtn];
    [XBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.width.height.mas_equalTo(8);
    }];
    UILabel *goodsPriceLbl = [[UILabel alloc] init];
    goodsPriceLbl.text = _model.goodsModel.shop_price_formatted;
    goodsPriceLbl.font =   BOLDSYSTEMFONT(15);
    goodsPriceLbl.textColor = [UIColor colorWithHexString:@"f11919"];
    [self addSubview:_priceLbl = goodsPriceLbl];
    [goodsPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(XBtn.mas_bottom).offset(5);
        make.left.equalTo(iconView.mas_right).offset(15);
    }];
    
    UILabel *goodsNameLbl = [[UILabel alloc] init];
    goodsNameLbl.text = _model.goodsModel.goods_name;
    goodsNameLbl.textColor = [UIColor colorWithHexString:@"999999"];;
    goodsNameLbl.font = SYSTEMFONT(14);
    goodsNameLbl.numberOfLines = 0;
    [self addSubview:goodsNameLbl];
    [goodsNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodsPriceLbl.mas_bottom).offset(2);
        make.left.equalTo(goodsPriceLbl);
        make.right.equalTo(XBtn.mas_left).offset(5);
    }];
    
    
    // 分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0,CGRectGetMaxY(iconView.frame)+10, UISCREEN_WIDTH, PX_ONE);
    lineView.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
    [self addSubview:lineView];
    
    UIScrollView *attrScrollView = [[UIScrollView alloc] init];
    attrScrollView.frame =  CGRectMake(0,CGRectGetMaxY(lineView.frame), UISCREEN_WIDTH,self.mj_h -  CGRectGetMaxY(lineView.frame) - 44);
    attrScrollView.bounces = YES;
    [self addSubview:attrScrollView];
    
    
    
    //加入购物车
    UIButton *shopingCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shopingCartBtn.tag = 2;
    shopingCartBtn.frame = CGRectMake( 0, CGRectGetMaxY(attrScrollView.frame), UISCREEN_WIDTH/2, 44);
    shopingCartBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    shopingCartBtn.backgroundColor = [UIColor colorWithHexString:@"e8465e"];
    [shopingCartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [shopingCartBtn addTarget:self action:@selector(purchaseGoods:) forControlEvents:UIControlEventTouchUpInside];
    //立即购买
    UIButton *purchaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    purchaseBtn.tag = 1;
    purchaseBtn.frame = CGRectMake(CGRectGetMaxX(shopingCartBtn.frame), CGRectGetMaxY(attrScrollView.frame), UISCREEN_WIDTH/2, 44);
    purchaseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    purchaseBtn.backgroundColor = [UIColor colorWithHexString:@"eeb94f"];
    [purchaseBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [purchaseBtn addTarget:self action:@selector(purchaseGoods:) forControlEvents:UIControlEventTouchUpInside];
    
    switch (_type) {
        case 1:{
            [self addSubview:shopingCartBtn];
            [self addSubview:purchaseBtn];
        }break;
        case 2:{
            purchaseBtn.ml_x = 0;
            purchaseBtn.ml_width = UISCREEN_WIDTH;
            [self addSubview:purchaseBtn];
        }break;
        case 3:{
            shopingCartBtn.ml_x = 0;
            shopingCartBtn.ml_width = UISCREEN_WIDTH;
            [self addSubview:shopingCartBtn];
        }break;
        default:break;
    }
    for (MBGoodsSpecsModel *model in _model.goodsSpecs) {
        
        NSInteger j = [_model.goodsSpecs indexOfObject:model];
        UILabel *lable =[[UILabel alloc] initWithFrame:CGRectMake(10, _lastView?CGRectGetMaxY(_lastView.frame)+10:10, UISCREEN_WIDTH, 20)];
        lable.text =  model.attr_name;
        lable.textColor = [UIColor colorWithHexString:@"777777"];
        lable.font= SYSTEMFONT(13);
        [attrScrollView addSubview:lable];
        CGFloat one_btnsX = 10;
        CGFloat one_btnY = CGRectGetMaxY(lable.frame) + 10;
        UIButton *lastBttn = nil;
        for (MBGoodsAttrListModel *listModel in model.goodsAttrList) {
            NSInteger i = [model.goodsAttrList indexOfObject:listModel];
            CGSize size = [listModel.goods_attr_name  sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SYSTEMFONT(13), NSFontAttributeName, nil]];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:listModel.goods_attr_name forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"444444"] forState:UIControlStateNormal];
            btn.layer.borderColor = [UIColor colorWithHexString:@"c4c5c7"].CGColor;
            btn.layer.borderWidth = 1;
            btn.titleLabel.font = SYSTEMFONT(13);
            btn.tag = i + j*100;
            btn.layer.cornerRadius = 2;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(one_btnsX, one_btnY, size.width + 30, 25);
            [attrScrollView addSubview:btn];
            lastBttn = btn;
            one_btnsX += (10 + btn.width);
            
            if (one_btnsX > UISCREEN_WIDTH) {
                one_btnY += 35;
                one_btnsX = 10;
                btn.mj_x = one_btnsX;
                btn.mj_y = one_btnY;
                one_btnsX += (10 + btn.width);
            }
            
            if ([listModel isEqual:model.goodsAttrList.lastObject]) {
                UIView *lineView = [[UIView alloc] init];
                lineView.frame = CGRectMake(0,CGRectGetMaxY(btn.frame)+10, UISCREEN_WIDTH, PX_ONE);
                lineView.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
                [attrScrollView addSubview:lineView];
                _lastView = lineView;
            }
        }
        
    }
    //    UILabel *lable =[[UILabel alloc] initWithFrame:CGRectMake(10, _lastView?CGRectGetMaxY(_lastView.frame)+10:10, UISCREEN_WIDTH, 20)];
    //    lable.text =  model.attr_name;
    //    lable.textColor = [UIColor colorWithHexString:@"777777"];
    //    lable.font= SYSTEMFONT(13);
    //    [attrScrollView addSubview:lable];
    
    
    
    UILabel *numLab=[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_lastView.frame) + 20, 80, 20)];
    [numLab setText:@"数量"];
    numLab.font = SYSTEMFONT(13);;
    numLab.textColor = [UIColor colorWithHexString:@"777777"];
    [attrScrollView addSubview: numLab];
    
    //    UILabel *stockLbl = [[UILabel alloc] init];
    //    stockLbl.font = [UIFont systemFontOfSize:15];
    //    stockLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
    //    stockLbl.text = [NSString stringWithFormat:@"库存量：%@件",_model.goodsModel.goods_number];
    //    [attrScrollView addSubview:stockLbl];
    //    [stockLbl mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.equalTo(self).offset(-10);
    //        make.centerY.equalTo(numLab);
    //    }];
    
    // +
    UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [plusBtn setImage:[UIImage imageNamed:@"addGoodsNum"] forState:UIControlStateNormal];
    plusBtn.layer.borderWidth = 1;
    plusBtn.layer.borderColor = [UIColor colorWithHexString:@"c4c5c7"].CGColor;
    [plusBtn addTarget:self action:@selector(plusBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [attrScrollView addSubview:plusBtn];
    
    [plusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(25);
        make.centerY.equalTo(numLab);
        make.right.equalTo(self).offset(-10);
    }];
    // cou
    UILabel *buyNumsLbl = [[UILabel alloc] init];
    buyNumsLbl.text = [NSString stringWithFormat:@"%d", self.buyNum];
    buyNumsLbl.textAlignment = NSTextAlignmentCenter;
    [attrScrollView addSubview: _buyNumsLbl = buyNumsLbl];
    
    [buyNumsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(plusBtn.mas_left);
        make.height.mas_equalTo(23);
        make.width.mas_equalTo(45);
        make.centerY.equalTo(numLab);
        
    }];
    
    // -
    UIButton *minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [minusBtn setImage:[UIImage imageNamed:@"reduceGoodsNum"] forState:UIControlStateNormal];
    [minusBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    minusBtn.titleLabel.font = SYSTEMFONT(17);
    minusBtn.layer.borderWidth = 1;
    minusBtn.layer.borderColor = [UIColor colorWithHexString:@"c4c5c7"].CGColor;
    [minusBtn addTarget:self action:@selector(minusBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [attrScrollView addSubview:minusBtn];
    [minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(buyNumsLbl.mas_left);
        make.height.width.mas_equalTo(25);
        make.centerY.equalTo(numLab);
        
    }];
    
    UIView *lineOnew = [[UIView alloc] init];
    lineOnew.backgroundColor = [UIColor colorWithHexString:@"c4c5c7"];
    [attrScrollView addSubview:lineOnew];
    [lineOnew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(plusBtn.mas_left);
        make.left.equalTo(minusBtn.mas_right);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(buyNumsLbl.mas_top);
    }];
    UIView *lineTwo = [[UIView alloc] init];
    lineTwo.backgroundColor = [UIColor colorWithHexString:@"c4c5c7"];
    [attrScrollView addSubview:lineTwo];
    [lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(plusBtn.mas_left);
        make.left.equalTo(minusBtn.mas_right);
        make.height.mas_equalTo(1);
        make.top.equalTo(buyNumsLbl.mas_bottom);
        
    }];
    
    if (!(CGRectGetMaxY(numLab.frame)+ 5 > attrScrollView.mj_h)) {
        attrScrollView.contentSize =CGSizeMake(0, attrScrollView.mj_h +10);
    }
    
    
    
    
    MMLog(@"%@",self);
    
}

/** 取消显示视图*/
- (void)removeView{
    [self.VC dismissSemiModalView];
}
/** 增加要购买商品数量*/
- (void)plusBtnClick{
    _buyNum ++;
    if (_buyNum > [_model.goodsModel.goods_number intValue]) {
        _buyNum --;
        [self.VC show:@"库存不足" time:1];
        return;
    }else{
        _buyNumsLbl.text = [NSString stringWithFormat:@"%d", self.buyNum];
    }
}
/** 减少要购买商品数量*/
- (void)minusBtnClick{
    _buyNum --;
    if (_buyNum > 0) {
        _buyNumsLbl.text = [NSString stringWithFormat:@"%d", self.buyNum];
    }else{
        _buyNum ++;
    }
    
}
/** 购买商品或者添加到购物车*/
- (void)purchaseGoods:(UIButton *)btn{
    
    for (id model in _selecterSpecsArr) {
        if ([model isKindOfClass:[NSNumber class]]) {
            NSString *str = _model.goodsSpecs[[_selecterSpecsArr indexOfObject:model]].attr_name;
            [self.VC show:string(@"请选择", str) time:.8];
            return;
        }
        
    }
    
    
    if ([_buyNumsLbl.text integerValue] > _buyNum) {
        [self.VC show:@"商品库存不足" time:.8];
        return;
    }
    
    NSMutableArray *goodsAttrID = [NSMutableArray array];
    for (MBGoodsAttrListModel *model in _selecterSpecsArr) {
        
        [goodsAttrID addObject:model.goods_attr_id];
        
    }
    NSArray *strArrs  = [goodsAttrID sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *str in strArrs ) {
        if ([str isEqual:strArrs.firstObject]) {
            _spec = [NSString stringWithFormat:@"%@",str];
        }else{
            _spec = [NSString stringWithFormat:@"%@,%@",_spec,str];
        }
    }
    if (!_spec) {
        _spec = @"";
    }
    MMLog(@"%ld",(long)btn.tag);
    
    switch (btn.tag) {
        case 1:{
            
             [self addGoodsCart:false];
        }break;
        case 2:{
            [self addGoodsCart:true];
        }break;
        default:break;
    }
}
/**规格按钮点击选择*/
- (void)btnClick:(UIButton *)btn{
    NSInteger senton = btn.tag/100;
    NSInteger row = btn.tag%100;
    [btn setTitleColor:[UIColor colorWithHexString:@"f34444"] forState:UIControlStateNormal];
    btn.layer.borderColor = [UIColor colorWithHexString:@"f34444"].CGColor;
    
    if ([_lastBtnsArr[senton] isKindOfClass:[UIButton class]]) {
        UIButton *btn1 = _lastBtnsArr[senton];
        [btn1 setTitleColor:[UIColor colorWithHexString:@"444444"] forState:UIControlStateNormal];
        btn1.layer.borderColor = [UIColor colorWithHexString:@"c4c5c7"].CGColor;
        
    }
    
    _lastBtnsArr[senton] = btn;
    _selecterSpecsArr[senton] = _model.goodsSpecs[senton].goodsAttrList[row];
    
    [self  spaceRefreshData];
    
}

/**加入购物车*/
-(void)addGoodsCart:(BOOL)isAddCar
{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    
    if (sid == nil && uid == nil) {
        
        [self.VC loginClicksss:@"shop"];
        return;
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [self.VC show];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/flow/addtocart"] parameters:@{@"session":dict, @"goods_id":_model.goodsModel.goods_id,@"number":_buyNumsLbl.text,@"spec":_spec} success:^(NSURLSessionDataTask *operation, id responseObject) {
        [self.VC dismiss];
        NSString *status = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:@"status"][@"succeed"]];
        
        if ([status isEqualToString:@"1"]) {
            WS(weakSelf)
            [self.VC dismissSemiModalViewWithCompletion:^{
                if (isAddCar) {
                    weakSelf.getCarData();
                    [self.VC show:@"加入购物车成功!" time:1];
                }else{
                    MBShoppingCartViewController *payVc = [[MBShoppingCartViewController alloc] init];
                    [self.VC pushViewController:payVc Animated:YES];
                }
               
            }];
            
            
            
        }else{
            [self.VC show:[responseObject valueForKeyPath:@"status"][@"error_desc"] time:1];
            [self.VC dismissSemiModalView];
            
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self.VC show:@"请求失败！" time:1];
    }];
    
}

-(void)spaceRefreshData{
    NSMutableArray *goodsAttrID = [NSMutableArray array];
    for (MBGoodsAttrListModel *model in _selecterSpecsArr) {
        if (![model isKindOfClass:[NSNumber class]]) {
            [goodsAttrID addObject:model.goods_attr_id];
            
        }
        
    }
    
    
    
    NSString *attr = @"";
    NSArray *strArrs  = [goodsAttrID sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *str in strArrs ) {
        if ([str isEqual:strArrs.firstObject]) {
            attr = [NSString stringWithFormat:@"%@",str];
        }else{
            attr = [NSString stringWithFormat:@"%@,%@",_spec,str];
        }
    }
    if (!attr) {
        attr = @"";
    }
    
    [self.VC show];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/goods/getgoodsspecinfos"] parameters:@{@"goods_id":_model.goodsModel.goods_id,@"number":_buyNumsLbl.text,@"attr":attr} success:^(NSURLSessionDataTask *operation, id responseObject) {
        [self.VC dismiss];
        NSDictionary *dic = [responseObject valueForKey:@"data"];
        MMLog(@"%@",dic);
        if (dic) {
            _priceLbl.text = dic[@"result"];
            _buyNumsLbl.text =[NSString stringWithFormat:@"%@", dic[@"qty"]];
            
            if (dic[@"num"]) {
                _buyNum = [dic[@"num"] intValue];
            }
            
        }
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self.VC show:@"请求失败" time:1];
    }];
    
    
    
}
-(void)dealloc{
    MMLog(@"delloc");
}
@end
