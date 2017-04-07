//
//  MBPhoneticDetailTableViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/8/24.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBPhoneticDetailTableViewController.h"
#import "BkNavigationBarView.h"
#import "XHMessageVoiceFactory.h"
#import "MBAudioPlayerHelper.h"
@interface MBPhoneticDetailTableViewController ()<MBSTKDataSourceDelegate>
@property (weak, nonatomic) IBOutlet UILabel *abstract_text;
@property (weak, nonatomic) IBOutlet UILabel *author_title;
@property (weak, nonatomic) IBOutlet UILabel *author_desc;
@property (weak, nonatomic) IBOutlet UIImageView *voice_img;
@property (weak, nonatomic) IBOutlet UILabel *voiceTime;
@property (weak, nonatomic) IBOutlet UIImageView *voiceImageView;
@property (weak, nonatomic) IBOutlet UIImageView *head_img;
@property (weak, nonatomic) IBOutlet UIView *headView;

@end

@implementation MBPhoneticDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [XHMessageVoiceFactory messageVoiceAnimationImageView: self.voiceImageView ];
    _abstract_text.text = _dataDic[@"abstract_text"];
    [_abstract_text rowSpace:5];
    [_abstract_text columnSpace:1];
    
    _author_desc.text = _dataDic[@"author_desc"];
    [_author_desc rowSpace:5];
    [_author_desc columnSpace:1];
    _author_title.text =  string(string(_dataDic[@"author"], @"       "), _dataDic[@"author_title"]);
    [_voice_img sd_setImageWithURL:_dataDic[@"head_img"] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
     [_head_img sd_setImageWithURL:_dataDic[@"voice_img"]];
    
    
}
- (IBAction)voiceButton:(UIButton *)sender {
    [self.voiceImageView startAnimating];
    [[MBAudioPlayerHelper shareInstance] setDelegate:self];
    [[MBAudioPlayerHelper shareInstance] managerAudioWithFileName:_dataDic[@"voice_file"] toID:_dataDic[@"id"]];
}
- (void)didAudioPlayerPausePlay:(STKAudioPlayer*)audioPlayer{
[self.voiceImageView stopAnimating];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
     BkNavigationBarView *navBar = [BkNavigationBarView navigationBarView];
    navBar.backgroundColor = [UIColor    redColor];
    
    [self.navigationController.view addSubview:navBar];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
