//
//  MBSMMessageCenterVC.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/7/4.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBSMMessageCenterVC.h"
#import "MBSMMessageCenterTabCell.h"
#import "XiaoMaBao-Swift.h"
@interface MBSMMessageCenterVC ()<JMessageDelegate,UITableViewDelegate>
@property(nonatomic,strong) NSMutableArray<JMSGConversation *> *datas;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MBSMMessageCenterVC

-(NSMutableArray<JMSGConversation *> *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
        
    }
    return _datas;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.tableFooterView = [UIView new];
    [self _init];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getConversations];
}
- (void)_init{
    
    [JMessage addDelegate:self withConversation:nil];
    
    //    [NSNotification ]
    
}
- (void)getConversations{
    [JMSGConversation    allConversations:^(id resultObject, NSError *error) {
        
        if (!resultObject) return ;
        
        self.datas = resultObject;
        [self.tableView reloadData];
        if (self.datas.count == 0) {
            
        }else{
        
        
        }
        [self updateBadge];
    }];
    
    
}

- (void)updateBadge{

   __block NSInteger count = 0;
  [self.datas enumerateObjectsUsingBlock:^(JMSGConversation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      if (obj.target) {
          
          JMSGUser *group =(JMSGUser *)obj.target;
          if (!group.isNoDisturb) {
              count += [obj.unreadCount integerValue];
          }
      }
      
  }];
    if (count >99) {
        
    }else{
    
    }
    [JMessage setBadge:count];
}
-(NSString *)titleStr{
    return @"消息中心" ;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - JMessageDelegate

- (void)onReceiveMessage:(JMSGMessage *)message
                   error:(NSError *)error{
    [self getConversations];
}
- (void)onSyncOfflineMessageConversation:(JMSGConversation *)conversation
                         offlineMessages:(NSArray JMSG_GENERIC(__kindof JMSGMessage *)*)offlineMessages{
 [self getConversations];

}
- (void)onSyncRoamingMessageConversation:(JMSGConversation *)conversatio{
 [self getConversations];
}
- (void)onConversationChanged:(JMSGConversation *)conversation{
 [self getConversations];
}

#pragma mark --UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return  45;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return  0.001;
//
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//
//    return UISCREEN_WIDTH * 35/75 + 170;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MBSMMessageCenterTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBSMMessageCenterTabCell" forIndexPath:indexPath];
    cell.model = _datas[indexPath.row];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MBSMMessageCenterTabCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.datas[indexPath.row] clearUnreadCount];
    cell.model = self.datas[indexPath.row];
    [self updateBadge];
    MBChatVC *VC =  [[MBChatVC alloc] initWithConversation:_datas[indexPath.row]];
    [self pushViewController:VC Animated:true];
    
//    let vc = JCChatViewController(conversation: conversation)
//    self.navigationController?.pushViewController(vc, animated: true)
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  true;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        JMSGConversation *conversation = self.datas[indexPath.row];
        JMSGUser *user = conversation.target;
        [JMSGConversation deleteSingleConversationWithUsername:user.username appKey:user.appKey];
        [self.datas removeObject:conversation];
        [self.tableView reloadData];
    }
    
    
}
//- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//
//{
//
//    // 添加一个删除按钮
//
//    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction *action,NSIndexPath *indexPath) {
//        [MobClick event:@"ShoppingCart5"];
//
//
//
//    }];
//
//
//
//    return@[deleteRowAction];
//
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
