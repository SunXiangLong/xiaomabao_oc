//
//  MBDetailsCircleController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/9.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBDetailsCircleController.h"
#import "MBDetailsCircleTbaleViewCell.h"
#import "MBDetailsCircleTableHeadView.h"
#import "MBReleaseTopicViewController.h"
@interface MBDetailsCircleController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MBDetailsCircleController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.tableHeaderView = [self setTableHeadView];;
  
}
-(UIView *)setTableHeadView{
  
         UIView *tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 70)];
        MBDetailsCircleTableHeadView *view = [MBDetailsCircleTableHeadView instanceView];
        [tableHeadView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(70);
        }];
        @weakify(self);
        [[view.myCircleViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *number) {
            @strongify(self);
           [self show:@"成功加入" and:@"1-3岁宝宝" time:1];
        }];

  
    return tableHeadView;

}
-(NSString *)titleStr{

    return self.title?:@"全部帖子";
}
-(void)rightTitleClick{
 [self prompt];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74+(UISCREEN_WIDTH -16*3)/3*133/184;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MBDetailsCircleTbaleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBDetailsCircleTbaleViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBDetailsCircleTbaleViewCell"owner:nil options:nil]firstObject];
    }
    
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)prompt{
    
    NSString *str = @"";
    NSString *str1 = [NSString stringWithFormat:@"加入话题所在的圈子才能发帖哦～%@?",str];
    NSRange range = [str1 rangeOfString:str];
    //修改title
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:str1];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:UIcolor(@"d66263") range:NSMakeRange(range.location, range.length)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(range.location, range.length)];
    
    
    UIAlertController *alertCancel = [UIAlertController alertControllerWithTitle:str1 message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertCancel setValue:alertControllerStr forKey:@"attributedTitle"];
    
    UIAlertAction *reloadAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }];
    [reloadAction setValue:UIcolor(@"575c65") forKey:@"titleTextColor"];
    
    UIAlertAction *reloadAction1 = [UIAlertAction actionWithTitle:@"加入圈子" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        MBReleaseTopicViewController *VC = [[MBReleaseTopicViewController    alloc] init];
        
        [self pushViewController:VC Animated:YES];
        
    }];
    [alertCancel addAction:reloadAction];
    [alertCancel addAction:reloadAction1];
    [reloadAction1 setValue:UIcolor(@"d66263") forKey:@"titleTextColor"];
    [self presentViewController:alertCancel animated:YES completion:nil];
}
-(void)show:(NSString *)str1 and:(NSString *)str2 time:(NSInteger)timer{
    
    NSString *comment_content = [NSString stringWithFormat:@"%@ %@",str1,str2];
    NSRange range = [comment_content rangeOfString:str2];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:comment_content];
    [att addAttributes:@{NSForegroundColorAttributeName:UIcolor(@"d66263")}  range:NSMakeRange(range.location, range.length)];
    [att addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} range:NSMakeRange(range.location, range.length )];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    UILabel *lable =    [hud valueForKeyPath:@"label"];
    
    hud.color = RGBCOLOR(219, 171, 171);
    hud.mode = MBProgressHUDModeText;
    hud.labelText = comment_content;
    hud.labelColor = UIcolor(@"575c65");
    lable.attributedText = att;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.minSize = CGSizeMake(235, 70);
    [hud hide:YES afterDelay:timer];
    [self dismiss];
    
}
@end
