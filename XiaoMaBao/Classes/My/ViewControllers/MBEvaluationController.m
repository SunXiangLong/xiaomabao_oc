//
//  MBEvaluationController.m
//  XiaoMaBao
//
//  Created by liulianqi on 15/12/29.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import "MBEvaluationController.h"
#import "MBEvaluationViewView.h"
#import "MBEvaluationTableViewCell.h"
@interface MBEvaluationController ()<UITableViewDataSource,UITableViewDelegate,MBEvaluationTableViewCellDelegate>
{
    NSArray *_goodsListArray;
    UIView *_lastView;
    NSMutableArray *_shopArray;
    NSMutableArray *_evaluationArray;
    UILabel *_lable;
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation MBEvaluationController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBEvaluationController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBEvaluationController"];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.top.constant = TOP_Y;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _shopArray = [NSMutableArray arrayWithArray:self.array];
    _evaluationArray = [NSMutableArray array];
    for (id dic in self.array) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@[] forKey:@"fileNames"];
        [dict setObject:@"" forKey:@"xinde"];
        [dict setObject:@"" forKey:@"comment_rank"];
        [_evaluationArray addObject:dict];
    }
    
    [self ListeningKeyboard];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _evaluationArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 237;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MBEvaluationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBEvaluationTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBEvaluationTableViewCell" owner:self options:nil] firstObject];
    }
    
    NSDictionary *dic = _evaluationArray[indexPath.row];
    cell.textView.text = [dic[@"xinde"]isEqualToString:@""]?nil:dic[@"xinde"];
    cell.num = [dic[@"comment_rank"]isEqualToString:@""]?0:[dic[@"comment_rank"] integerValue];
    cell.photoArr = [dic[@"fileNames"] count]>0?dic[@"fileNames"]:nil;
    
    cell.ViewControlle =self;
    cell.delegate =self;
    cell.row = indexPath.row;
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    NSURL *url = [NSURL URLWithString:_shopArray[indexPath.row][@"img"]];
    [cell.showImage  sd_setImageWithURL:url ];
    [cell setinit];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark -- UIScrollViewdelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
#pragma mark -- MBEvaluationTableViewCellDelegate
/**
 *  代理传过来的商品评价数据
 *
 *  @param str 商品评价
 *  @param row 第几个商品
 */
-(void)ProductEvaluation:(NSString *)str row:(NSInteger)row{

    NSMutableDictionary *dic = _evaluationArray[row];
    dic[@"xinde"] = str;
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
//    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    [_tableView reloadData];
}
/**
 *  代理传过来的商品上传图片数据
 *
 *  @param array 商品上传图片
 *  @param row   第几个商品
 */
-(void)CommodityImages:(NSArray *)array row:(NSInteger)row{
    NSMutableDictionary *dic = _evaluationArray[row];
    dic[@"fileNames"]=array;
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}
/**
 *  代理传过来的商品评分数据
 *
 *  @param num 商品评分
 *  @param row 第几个商品
 */
-(void)CommodityGrade:(NSInteger)num row:(NSInteger)row{
    NSMutableDictionary *dic = _evaluationArray[row];
    dic[@"comment_rank"] = [NSString stringWithFormat:@"%ld",num];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}
-(void)label:(NSString *)str row:(NSInteger)row{

    _lable.text = str;
}
/**
 *  提交评价数据
 *
 *  @param row 第几个商品
 */
-(void)SubmitEvaluation:(NSInteger)row{
    NSMutableDictionary *dic = _evaluationArray[row];
    //NSLog(@"%@",dic);
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSArray *photoArray = [dic[@"fileNames"]count]>0?dic[@"fileNames"]:@[];
    
    NSString *fileNames;
    
    for (int i = 0; i<photoArray.count; i++) {
        if (i==0) {
            fileNames =@"file_name_0";
            
        }else{
            
            fileNames = [NSString stringWithFormat:@"%@;file_name_%d;",fileNames,i];
        }
    }
    if (!fileNames) {
        fileNames = @"";
    }
    
    
    NSDictionary *parmeters =@{@"session":sessiondict,@"order_id":self.order_id,@"goods_id":_shopArray[row][@"goods_id"],@"xinde":dic[@"xinde"],@"comment_rank":dic[@"comment_rank"],@"fileNames":fileNames};
    
    [self showProgress];
    
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/order/order_comment"] parameters:parmeters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int i = 0; i<photoArray.count; i++) {
            NSData * data;
            if ([photoArray[i]isKindOfClass:[UIImage class]] ) {
                data =  [UIImage reSizeImageData:photoArray[i] maxImageSize:800 maxSizeWithKB:800];
            }
            
            if(data != nil){
                [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"file_name_%d",i] fileName:[NSString stringWithFormat:@"file_name_%d.jpg",i] mimeType:@"image/jpeg"];
            }
            
        }
    } progress:^(NSProgress *progress) {
        self.progress = progress.fractionCompleted;
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([dic[@"succeed"]isEqualToNumber:@1]) {
            [self dismiss];
            [_evaluationArray removeObjectAtIndex:row];
            
            [_tableView reloadData];
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_array[row]];
            dic[@"is_comment"] = @"1";
            NSDictionary *dict = @{@"dic":dic,@"section":[NSString stringWithFormat:@"%ld",self.section]};
            NSNotification *notification =[NSNotification notificationWithName:@"MBEvaluationController" object:nil userInfo:dict];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            if (_evaluationArray.count == 0) {
                [self popViewControllerAnimated:YES];
            }
        }else{
            [self show:dic[@"error_desc"] time:1];
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [self show:@"请求失败！" time:1];
    }];
    
    
    
}

#pragma mark --注册监听键盘的通知
- (void)ListeningKeyboard{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    _lable =    [[UILabel alloc] initWithFrame:CGRectMake(0, UISCREEN_HEIGHT, UISCREEN_WIDTH, 30)];
    _lable.backgroundColor = [UIColor grayColor];
    _lable.textColor = [UIColor whiteColor];
    _lable.textAlignment = 2;
    [self.view addSubview:_lable];
    
    
    
    
}
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    if (_lable) {
        [self.view addSubview:_lable];
            _lable.frame = CGRectMake(0, UISCREEN_HEIGHT-height-29, UISCREEN_WIDTH, 30);
        
    }
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    
        _lable.frame = CGRectMake(0, UISCREEN_HEIGHT, UISCREEN_WIDTH, 30);

    [_lable removeFromSuperview];
}

@end
