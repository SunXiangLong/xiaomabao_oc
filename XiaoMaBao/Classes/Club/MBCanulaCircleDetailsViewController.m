//
//  MBCanulaCircleDetailsViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/4.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBCanulaCircleDetailsViewController.h"
#import "canulaCircleDetailsTableheaderView.h"
#import "MBCommentTableViewCell.h"
#import "MBMessageViewController.h"
#import "MBcanulaCirclesViewController.h"
#import "MBLoginViewController.h"
@interface MBCanulaCircleDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,SDPhotoBrowserDelegate>
{

    NSMutableArray *_evaluationArray;
    NSArray *_imageArray;
    UIView  *_notEvaluationView;
    NSMutableDictionary *_dataDic;
    BOOL    _isPusOrPop;
    NSInteger _page;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *ssssssss;

@end

@implementation MBCanulaCircleDetailsViewController
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBCanulaCircleDetailsViewController"];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBCanulaCircleDetailsViewController"];
    if (_isPusOrPop) {
        _page = 1;
         _evaluationArray = [NSMutableArray array];
        [self setheadData];
    }
    
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    _page = 1;
    _evaluationArray = [NSMutableArray array];
     [self setheadData];
    [self.ssssssss addTarget:self action:@selector(dianzan:) forControlEvents:UIControlEventTouchUpInside];
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self setheadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        
    }];
    // 默认先隐藏footer
    self.tableView.mj_footer.hidden = YES;
}

#pragma mark --请求说说信息
- (void)setheadData{

    
    NSString *page =[NSString stringWithFormat:@"%ld",_page];
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/communicate/talkdetail"];
   
    if (!_isPusOrPop) {
        [self show];
    }
    __unsafe_unretained __typeof(self) weakSelf = self;
    [MBNetworking POST:url parameters:@{@"tid":self.tid,@"page":page}
               success:^(AFHTTPRequestOperation *operation, MBModel *responseObject) {

                   NSLog(@"%@ %@",[responseObject valueForKey:@"status"],responseObject.data);


                   if(1 == [[responseObject valueForKey:@"status"]  intValue]){
                       [self dismiss];
                       if (_page==1) {
                           _dataDic =   [NSMutableDictionary dictionaryWithDictionary:[responseObject valueForKeyPath:@"data"][@"detail"]] ;
                           _imageArray = _dataDic[@"talk_photo"];
                           
                           [_evaluationArray addObjectsFromArray: responseObject.data[@"comments"]];
                           if ([_dataDic[@"is_praise"]isEqualToString:@"1"]) {
                               
                               weakSelf.ssssssss.selected = YES;
                           }else{
                               
                               weakSelf.ssssssss.selected = NO;
                           }
                           
                           self.tableView.tableHeaderView = [self setTableHeaderView];
                           if (_isPusOrPop) {
                               if (_evaluationArray.count<1) {
                                   _notEvaluationView.hidden = NO;
                               }else{
                                   _notEvaluationView.hidden = YES;
                               }
                               [weakSelf.tableView reloadData];
                           }else{
                               
                               weakSelf.tableView.delegate = self;
                               weakSelf.tableView.dataSource = self;
                               
                               
                               if (_evaluationArray.count<1) {
                                   _notEvaluationView  = [[UIView alloc] initWithFrame:CGRectMake(0, [self setTableHeaderView].ml_height, UISCREEN_WIDTH, UISCREEN_WIDTH)];
                                   
                                   [weakSelf.tableView addSubview:_notEvaluationView];
                                   UILabel *lable = [[UILabel alloc] init];
                                   lable.text = @"快来发表你的评论吧!";
                                   lable.font = [UIFont systemFontOfSize:13];
                                   lable.textColor = [UIColor colorR:179 colorG:179 colorB:179];
                                   [_notEvaluationView addSubview:lable];
                                   [lable mas_makeConstraints:^(MASConstraintMaker *make) {
                                       make.top.mas_equalTo(50);
                                       make.centerX.mas_equalTo(0);
                                   }];
                               }
                               
                              
                           }
                            _page++;
                       }else{
                       
                           if ([responseObject.data[@"comments"] count]==0) {
                                  [self.tableView.mj_footer endRefreshingWithNoMoreData];
                           }else{
                           
                            [_evaluationArray addObjectsFromArray: responseObject.data[@"comments"]];
                               [self.tableView reloadData];
                               _page++;
                           }
                       
                       }

                      

                   }
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                   [self show:@"请求失败 " time:1];
                   NSLog(@"%@",error);

               }
     ];


}
#pragma mark -- 跳转登陆页
- (void)loginClicksss{
    //跳转到登录页
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MBLoginViewController *myView = [story instantiateViewControllerWithIdentifier:@"MBLoginViewController"];
    myView.vcType = @"mabao";
    MBNavigationViewController *VC = [[MBNavigationViewController alloc] initWithRootViewController:myView];
    [self presentViewController:VC animated:YES completion:nil];
}
#pragma mark --发表评论
- (IBAction)pinglun:(UIButton *)sender {
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    if (! sid) {
        [self loginClicksss];
        return;
    }
    
    _isPusOrPop = YES;
    MBcanulaCirclesViewController *VC = [[MBcanulaCirclesViewController alloc] init];
    VC.talk_id = _dataDic[@"talk_id"];
     VC.title = @"发表评论";
    [self pushViewController:VC Animated:YES];
}
#pragma mark --点赞
- (void)dianzan:(UIButton *)sender {
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    if (! sid) {
        [self loginClicksss];
        return;
    }
    
    [self setPraise:sender];
}
#pragma mark --点赞请求
- (void)setPraise:(UIButton *)sender{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/communicate/praise"];
    if (!_dataDic) {
        return;
    }
    if (! sid) {
        [self loginClicksss];
        return;
    }
    sender.enabled = NO;
    [MBNetworking POST:url parameters:@{@"session":sessiondict,@"talk_id":_dataDic[@"talk_id"]}
               success:^(AFHTTPRequestOperation *operation, MBModel *responseObject) {
                   
                   NSLog(@"%@ %@",[responseObject valueForKey:@"status"],responseObject.data);
                   
                   
                   if(1 == [[responseObject valueForKey:@"status"]  intValue]){
                       [self dismiss];
                       NSInteger talk_praise = [_dataDic[@"talk_praise"] integerValue];
                       if (sender.selected) {
                           _dataDic[@"is_praise"] = @"0";
                           talk_praise--;
                           
                       }else{
                          _dataDic[@"is_praise"] = @"1";
                           talk_praise++;
                       }
                       _dataDic[@"talk_praise"] = [NSString stringWithFormat:@"%ld",talk_praise];
                       [sender setSelected:!sender.selected];
                        sender.enabled = YES;
                        self.tableView.tableHeaderView = [self setTableHeaderView];
                       
                   }
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   
                   [self show:@"请求失败 " time:1];
                       sender.enabled = NO;
                   NSLog(@"%@",error);
                   
               }
     ];
    
    
}
#pragma mark --删除说说
-(void)setDeleteRecords{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/communicate/talkdel"];
    [self show];
    [MBNetworking POST:url parameters:@{@"session":sessiondict,@"talk_id":self.tid}
               success:^(AFHTTPRequestOperation *operation, MBModel *responseObject) {
                   [self dismiss];
                   
                   if(1 == [[responseObject valueForKey:@"status"]  intValue]){
                       
                       NSDictionary *userData = [responseObject valueForKeyPath:@"status"];
                       NSLog(@"%@",userData);
                       [self show:@"删除成功"time:1];
                       self.block(self.indexPath);
                       [self popViewControllerAnimated:YES];
                   }
                   
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   
                   [self show:@"请求失败 " time:1];
                   NSLog(@"%@",error);
                   
               }
     ];
    
}
#pragma mark --删除评论
- (void)deleteComment:(NSString *)comment_id :(NSIndexPath *)indexPath{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/communicate/talkcommentdel"];
   
    if (! sid) {
        [self loginClicksss];
        return;
    }
    
    [self show];
    [MBNetworking POST:url parameters:@{@"session":sessiondict,@"comment_id":comment_id}
               success:^(AFHTTPRequestOperation *operation, MBModel *responseObject) {
                   
                   NSLog(@"%@ %@",[responseObject valueForKey:@"status"],responseObject.data);
                   
                   
                   if(1 == [[responseObject valueForKey:@"status"]  intValue]){
                       [self dismiss];
                       [self show:@"删除成功" time:1];
                       
                       [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic ];
                       
                       
                   }
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   
                   [self show:@"请求失败 " time:1];
                   NSLog(@"%@",error);
                   
               }
     ];
    
    
}
#pragma mark -- tableHeadersetTableHeaderView
- (UIView *)setTableHeaderView{
    NSString *str= _dataDic[@"talk_content"];
    CGFloat height =72 +[str sizeWithFont:[UIFont systemFontOfSize:14] withMaxSize:CGSizeMake(UISCREEN_WIDTH-30, MAXFLOAT)].height;
  
    
    UIView *view = [[UIView  alloc] init];
    canulaCircleDetailsTableheaderView *canulView = [canulaCircleDetailsTableheaderView instanceView];
    canulView.frame = CGRectMake(0, 0, UISCREEN_WIDTH, height);
    [canulView.guanzhuButton addTarget:self action:@selector(is_attention:) forControlEvents:UIControlEventTouchUpInside];
    if ([_dataDic[@"is_attention"]isEqualToString:@"1"]) {
        canulView.guanzhuButton.selected = YES;
    }
    [canulView.touxiangImageView sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"talk_avatar"]] placeholderImage:[UIImage imageNamed:@"placeholder_image"]];
    canulView.monthLable.text = _dataDic[@"talk_addtime"];
    canulView.userName.text  = _dataDic[@"talk_username"];
    canulView.centerLable.text = str;
    [view addSubview:canulView];


  //图片
    UIView *imageView = [[UIView alloc] init];
    CGFloat imageView_h = 0.0;
    CGFloat imageView_y =  height+0.0;
    
    
    if (_imageArray.count ==0) {
         imageView_y = height;
         imageView_h  = 0;
    }else if (_imageArray.count<4){
      
         imageView_h  = (UISCREEN_WIDTH-12)/3;
    }else{
        NSInteger shang = _imageArray.count/3;
        NSInteger yu = _imageArray.count%3;
        if (yu==0) {
          imageView_h = (UISCREEN_WIDTH-12)/3*shang+5;
        }else{
         imageView_h  = (UISCREEN_WIDTH-12)/3*(shang+1)+5;
            
        }
   
    }
     imageView.frame = CGRectMake(8, imageView_y, UISCREEN_WIDTH-16,imageView_h);
    CGFloat Width = (UISCREEN_WIDTH-12-16)/3;
    CGFloat Height = (UISCREEN_WIDTH-12-16)/3;
    for (NSInteger i = 0; i < _imageArray.count; i++) {
        CGFloat row = i / 3;
        CGFloat col = i % 3;
        
        UIImageView *imageViews = [[UIImageView alloc] init];
        imageViews.tag = i;
        imageViews.userInteractionEnabled = YES;
        imageViews.frame = CGRectMake(col == 0?col*Width:(col*(Width+5)),row == 0?row *Height:(row *Height+5), Width, Height);
        [imageViews sd_setImageWithURL:[NSURL URLWithString:_imageArray[i]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
        [imageView addSubview:imageViews];
       imageViews .contentMode =  UIViewContentModeScaleAspectFill;
       imageViews.autoresizingMask = UIViewAutoresizingFlexibleHeight;
       imageViews .clipsToBounds  = YES;
        
        [imageViews addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backView:)]];
    
    }
       [view addSubview:imageView];
    

    //评论
    NSString *sss = _dataDic[@"talk_comment"];//@"28个评论";
    NSString *www = _dataDic[@"talk_praise"];//@"9个赞";
    UIView *pinglunView = [[UIView alloc] init];
    
    pinglunView.frame = CGRectMake(15,CGRectGetMaxY(imageView.frame), UISCREEN_WIDTH-30, 40);
//    pinglunView.backgroundColor = [UIColor blueColor];
    [view addSubview:pinglunView];
    UIImage *imaeg =  [UIImage imageNamed:@"comment_image"] ;
    UIImage * image = [UIImage imageNamed:@"saved_image"];
    
    
    UIImageView *leftImageView = [[UIImageView alloc] init];
    leftImageView.image = imaeg;
    [pinglunView addSubview:leftImageView];
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(13);
        make.bottom.mas_equalTo(-12);
        make.width.mas_equalTo(15);
    }];
    
    UILabel *leftLable = [[UILabel alloc] init];
    leftLable.font = [UIFont systemFontOfSize:12];
    leftLable.text = [NSString stringWithFormat:@"%@个评论",sss];
    leftLable.textColor = [UIColor colorWithHexString:@"adadad"];
    [pinglunView addSubview:leftLable];
    [leftLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.equalTo (leftImageView.mas_right).offset(4);
    }];
    
    UIImageView *rightImageView = [[UIImageView alloc] init];
    rightImageView.image = image;
    [pinglunView addSubview:rightImageView];
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLable.mas_right).offset(12);
        make.top.mas_equalTo(13);
        make.bottom.mas_equalTo(-12);
        make.width.mas_equalTo(15);
    }];
    
    UILabel *rightLable = [[UILabel alloc] init];
    rightLable.font = [UIFont systemFontOfSize:12];
    rightLable.text = [NSString stringWithFormat:@"%@个赞",www];;
    rightLable.textColor = [UIColor colorWithHexString:@"adadad"];
    [pinglunView addSubview:rightLable];
    [rightLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.equalTo (rightImageView.mas_right).offset(4);
    }];

    
   
    
    
    
   view.frame = CGRectMake(0, 0, UISCREEN_WIDTH,CGRectGetMaxY(pinglunView.frame));
    return view;

}
- (void)is_attention:(UIButton *) btn{

    [self set_is_attention:btn];
    
    

}
#pragma mark --获取数据
- (void)set_is_attention:(UIButton *)btn{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/communicate/payattention"];
    if (! sid) {
        [self loginClicksss];
        return;
    }
    [MBNetworking POST:url parameters:@{@"session":sessiondict,@"user_id":_dataDic[@"talk_user_id"]}
               success:^(AFHTTPRequestOperation *operation, MBModel *responseObject) {
                   
                   NSLog(@"%@ %@",[responseObject valueForKey:@"status"],responseObject.data);
                   
                   
                   if(1 == [[responseObject valueForKey:@"status"]  intValue]){
                       
                       
                        btn.selected = !btn.selected;
                       
                   } }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       
                       
                       NSLog(@"%@",error);
                       
                   }
     ];
    
    
}
- (void)backView:(UITapGestureRecognizer *)TapGesture{


    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    
    browser.sourceImagesContainerView = TapGesture.view.superview;//原图的父控件;
    
    browser.imageCount = _imageArray.count;//原图的数量;
    
    browser.currentImageIndex = TapGesture.view.tag;//当前需要展示图片的index;
    
        browser.delegate = self;
    
        [browser show]; // 展示图片浏览器

}
-(NSString *)rightImage{
    if (!self.isdelete) {
        return @"";
    }
   return @"dian_image";
}

-(void)rightTitleClick{
    if (!self.isdelete) {
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定要删除这条记录吗？"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                   
                                                         handler:^(UIAlertAction * action) {}];
    UIAlertAction* fromPhotoAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive                                                                 handler:^(UIAlertAction * action) {
        [self setDeleteRecords];
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:fromPhotoAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark --UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    
    return _evaluationArray.count;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
      NSDictionary *dic = _evaluationArray[indexPath.row];
    NSString *comment_content;
    if ([dic[@"comment_parent_name"]isEqualToString:@""]) {
       comment_content =  _evaluationArray[indexPath.row][@"comment_content"];
   
    }else{
         comment_content =   [NSString stringWithFormat:@"%@%@",dic[@"comment_username"],dic[@"comment_content"]];
    
    }

    CGFloat comment_content_h = [comment_content sizeWithFont:[UIFont systemFontOfSize:13] withMaxSize:CGSizeMake(UISCREEN_WIDTH-90, MAXFLOAT)].height;
    
    return 50+comment_content_h+6;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _evaluationArray[indexPath.row];
    MBCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBCommentTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBCommentTableViewCell" owner:nil options:nil]firstObject];
    }
    [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:_evaluationArray[indexPath.row][@"comment_avatar"]] placeholderImage:[UIImage imageNamed:@"placeholder_image"]];
    if ([dic[@"comment_parent_name"]isEqualToString:@""]) {
        cell.userCenter.text =  dic[@"comment_content"];
        cell.userTime.text   =  dic[@"comment_addtime"];
        cell.userName.text   =  dic[@"comment_username"];
    }else{
        cell.userTime.text   =  dic[@"comment_addtime"];
        cell.userName.text   =  dic[@"comment_username"];
        NSString *comment_content = [NSString stringWithFormat:@"回复:%@  %@",dic[@"comment_parent_name"],dic[@"comment_content"]];
        cell.userCenter.text = comment_content;
        
          NSRange range = [comment_content rangeOfString:dic[@"comment_content"]];
     
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:comment_content];
        [att addAttributes:@{NSForegroundColorAttributeName:[UIColor colorR:120 colorG:154 colorB:192]}  range:NSMakeRange(3, range.location-3)];
        [att addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(3, range.location-3)];
        cell.userCenter.attributedText  = att;
        
   
    }

  
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                     message:nil
                                                                              preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                           
                                                                 handler:^(UIAlertAction * action) {}];
    
    
            UIAlertAction* fromCameraAction = [UIAlertAction actionWithTitle:@"回复" style:UIAlertActionStyleDefault                                                             handler:^(UIAlertAction * action) {
                MBcanulaCirclesViewController *VC = [[MBcanulaCirclesViewController alloc] init];
                VC.comment_id = _evaluationArray[indexPath.row][@"comment_id"];
                VC.talk_id = _evaluationArray[indexPath.row][@"comment_talk_id"];
                VC.title = @"回复评论";
                _isPusOrPop = YES;
                
                [self pushViewController:VC Animated:YES];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:fromCameraAction];
            [self presentViewController:alertController animated:YES completion:nil];
 
   


}
#pragma mark -- 在滑动手势删除某一行的时候，显示出更多的按钮

//- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//
//{
//    // 添加一个删除按钮
//    
//    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction *action,NSIndexPath *indexPath) {
//        NSLog(@"%lu %lu",(unsigned long)indexPath.row,_evaluationArray.count);
//
//        [_evaluationArray removeObjectAtIndex:indexPath.row];
//        
//        
//        [self deleteComment:_evaluationArray[indexPath.row][@"comment_id"] :indexPath];
//       
//        
//        
//    }];
//    
//    
//    //添加一个收藏按钮
//    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"回复"handler:^(UITableViewRowAction *action,NSIndexPath *indexPath) {
//        
//               
//        
//    }];
//    
//    //将设置好的按钮放到数组中返回
//    return@[deleteRowAction,moreRowAction];
//    
//}


#pragma mark -- SDPhotoBrowserdelegate
// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[index]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    return imageView.image;
}
// 返回高质量图片的url

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    return [NSURL URLWithString:_imageArray[index]];
}
-(UIViewController *)popViewControllerAnimated:(BOOL)animated{

    if (self.pusMessages) {
        for (BkBaseViewController *VC in self.navigationController.viewControllers) {
            if ([VC isKindOfClass:[MBMessageViewController class]]) {
               [self.navigationController popToViewController:VC animated:YES];
                return nil;
               
            }
        }
    }
    
     return    [self.navigationController popViewControllerAnimated:animated];
   
}
@end
