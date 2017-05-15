//
//  MBMedicalReportQueryViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/5/3.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBMedicalReportQueryViewController.h"
#import "MBMedicalReporTQueryResultsViewController.h"
@interface MBMedicalReportQueryViewController ()
@property (weak, nonatomic) IBOutlet UIView *promptView;
@property (weak, nonatomic) IBOutlet UIButton *queryButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *idCardtextField;
@end

@implementation MBMedicalReportQueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.nameTextField.text = @"sunxianglong";
    [self event];
    
    
}

- (void)event{
    
    @weakify(self);
    RAC(self.queryButton,enabled) =  [RACSignal combineLatest:@[self.nameTextField.rac_textSignal,self.idCardtextField.rac_textSignal] reduce:^id(NSString *name,NSString*idCard){
        if (name.length>1&&[idCard isValidWithIdentityNum]) {
            return @(1);
        }else{
            return @(0);
        }
    }];
   
    [RACObserve(self.queryButton,enabled) subscribeNext:^(id x) {
        @strongify(self);
        if ([x integerValue]) {
            [self.queryButton setBackgroundColor:UIcolor(@"e45f60")];
        }else{
            [self.queryButton setBackgroundColor:[UIColor lightGrayColor]];
        }
    }];
    
    [[_queryButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
        MMLog(@"button was pressed!");
         [self setData];
        
     }];
;

}
- (IBAction)promptButton:(id)sender {
    self.promptView.hidden = true;
}
-(NSString *)titleStr{
  return @"体检报告查询";
}
- (void)setData{

    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [self show];
    [MBNetworking POSTOrigin:string(BASE_URL_root, @"/health/check_tj_status") parameters:@{@"session":dict,@"name":self.nameTextField.text,@"idcard":self.idCardtextField.text} success:^(id responseObject) {
        [self dismiss];
        MMLog(@"%@",responseObject);
        switch ([responseObject[@"status"] integerValue]) {
            case 0:{
                 [self performSegueWithIdentifier:@"MBMedicalReporTQueryResultsViewController" sender:responseObject[@"data"]];
            }break;
            case 200:{
                self.promptView.hidden = false;
            }break;
            case 300:{
                 [self performSegueWithIdentifier:@"MBMedicalReporTQueryResultsViewController" sender:nil];
            }break;
            default:
                break;
        }
        
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败" time:.8];
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
 
    MBMedicalReporTQueryResultsViewController *VC = (MBMedicalReporTQueryResultsViewController *)segue.destinationViewController;
    VC.url = URL(sender);;
    
}


@end
