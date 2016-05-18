//
//  MBcanulaCirclesViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/4.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBcanulaCirclesViewController.h"
#import "MBCanulaCircleDetailsViewController.h"
@interface MBcanulaCirclesViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *lable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@end

@implementation MBcanulaCirclesViewController
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBcanulaCirclesViewController"];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBcanulaCirclesViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _bottom.constant = UISCREEN_HEIGHT-TOP_Y-75;
    _textView.delegate = self;
    [_textView becomeFirstResponder];
    if ([self.title isEqualToString:@"回复评论"]) {
        self.lable.text = @"回复评论...";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.textView resignFirstResponder];
    
}
#pragma mark --UITextViewDelegate
- (void)textViewDidChange:(UITextView*)textView{
    
    
    if (textView.text.length>0) {
        self.lable.text  = @"";
        
    }else{
        if ([self.title isEqualToString:@"回复评论"]) {
            self.lable.text = @"回复评论...";
        }else{
            self.lable.text = @"写评论...";
        }
    }
    
    
    
}


-(NSString *)titleStr{
    return self.title?:@"";
}
-(NSString *)rightStr{
    return @"发表";
}

-(void)rightTitleClick{
    
    if (_textView.text.length< 1) {
        if ([self.title isEqualToString:@"回复评论"]) {
            [self show:@"请输入回复内容" time:1] ;
            return;
        }else{
            [self show:@"请输入评论内容" time:1] ;
            return;
        }
        
    }
    [self setCommente];
    
    
}
#pragma mark --发表评论
- (void)setCommente{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    
    
    if (! sid) {
        return;
    }
    
    NSDictionary * parameters;
    if ([self.title isEqualToString:@"回复评论"]) {
        parameters = @{@"session":sessiondict,@"talk_id":self.talk_id,@"content":_textView.text,@"pid":self.comment_id};
    }else{
        
        parameters = @{@"session":sessiondict,@"talk_id":self.talk_id,@"content":_textView.text};
    }
    
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/communicate/talkcomment"];
    [self show];
    [MBNetworking POST:url parameters:parameters
               success:^(AFHTTPRequestOperation *operation, MBModel *responseObject) {
                   
                   NSLog(@"%@ %@",[responseObject valueForKey:@"status"],responseObject.data);
                   
                   
                   if(1 == [[responseObject valueForKey:@"status"]  intValue]){
                       [self dismiss];
                       
                       if (self.pusMessages) {
                           
                           MBCanulaCircleDetailsViewController *VC = [[MBCanulaCircleDetailsViewController   alloc] init];
                           VC.tid = self.talk_id;
                           VC.pusMessages = @"";
                           [self pushViewController:VC Animated:YES];
                       }else{
                           if (self.comment_id) {
                               [self show:@"回复成功" time:1];
                           }else{
                               [self show:@"评论成功" time:1];
                           }
                           
                           
                           [self popViewControllerAnimated:YES];
                       }
                       
                       
                   }
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   
                   [self show:@"请求失败 " time:1];
                   NSLog(@"%@",error);
                   
               }
     ];
    
    
}

@end
