//
//  MBServiceListViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/8.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBServiceListViewController.h"
#import "MobClick.h"
@interface MBServiceListViewController ()

@end

@implementation MBServiceListViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBServiceListViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBServiceListViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.font = [UIFont systemFontOfSize:12];
    titleLbl.frame = CGRectMake(0, TOP_Y + MARGIN_10, self.view.ml_width, 20);
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor colorWithHexString:@"383737"];
    titleLbl.text = @"小麻包用户服务协议";
    [self.view addSubview:titleLbl];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.frame = CGRectMake(8, CGRectGetMaxY(titleLbl.frame), self.view.ml_width - 16, self.view.ml_height - CGRectGetMaxY(titleLbl.frame));
    textView.textColor = [UIColor colorWithHexString:@"898989"];
    textView.font = [UIFont systemFontOfSize:12];
    textView.text = @"本协议为您与小麻包平台（即小麻包网，域名为 xiaomabao.com）管理者之间所订立的契约，具有合同的法律效力，请您仔细阅读。一、 本协议内容、生效、变更 1.本协议内容包括协议正文及所有小麻包已经发布的或将来可能发布的各类规则。所有规则为本协议不可分割的组成部分，与协议正文具有同等法律效力。除另行明确声明外，任何小麻包及其关联公司提供的服务（以下称为小麻包平台服务）均受本协议约束。2.本协议中，“用户”、“会员”为买方、卖方的统称；可单指买方，平台注册的购物的会员；也可单指卖方。3.您应当在使用小麻包平台服务之前认真阅读全部协议内容。如您对协议有任何疑问，应向小麻包咨询。您在同意所有协议条款并完成注册程序，才能成为本站的正式用户，您点击“我已经阅读并同意遵守《小麻包用户服务协议》”按钮后，本协议即生效，对双方产生约束力。4.只要您使用小麻包平台服务，则本协议即对您产生约束，届时您不应以未阅读本协议的内容或者未获得小麻包对您问询的解答等理由，主张本协议无效，或要求撤销本协议。5.您确认：本协议条款是处理双方权利义务的契约，始终有效，法律另有强制性规定或双方另有特别约定的，依其规定。6.您承诺接受并遵守本协议的约定。如果您不同意本协议的约定，您应立即停止注册程序或停止使用小麻包平台服务。7.小麻包有权根据需要不定期地制订、修改本协议及/或各类规则，并在小麻包平台公示，不再另行单独通知用户。变更后的协议和规则一经在网站公布，立即生效。如您不同意相关变更，应当立即停止使用小麻包平台服务。您继续使用小麻包平台服务的，即表明您接受修订后的协议和规则。二、 注册 1.注册资格 用户须具有法定的相应权利能力和行为能力的自然人、法人或其他组织，能够独立承担法律责任。您完成注册程序或其他小麻包平台同意的方式实际使用本平台服务时，即视为您确认自己具备主体资格，能够独立承担法律责任。若因您不具备主体资格，而导致的一切后果，由您及您的监护人自行承担。2.注册资料 2.1用户应自行诚信向本站提供注册资料，用户同意其提供的注册资料真实、准确、完整、合法有效，用户注册资料如有变动的，应及时更新其注册资料。如果用户提供的注册资料不合法、不真实、不准确、不详尽的，用户需承担因此引起的相应责任及后果，并且小麻包保留终止用户使用本平台各项服务的权利。2.2用户在本站进行浏览、下单购物等活动时，涉及用户真实姓名/名称、通信地址、联系电话、电子邮箱等隐私信息的，本站将予以严格保密，除非得到用户的授权或法律另有规定，本站不会向外界披露用户隐私信息。3.账户    3.1您注册成功后，即成为小麻包平台的会员，将持有小麻包平台唯一编号的会员名和密码等账户信息，您可以根据本站规定改变您的密码。3.2您设置的会员名不得侵犯或涉嫌侵犯他人合法权益。否则，小麻包有权终止向您提供小麻包平台服务，注销您的账户。账户注销后，相应的会员名将开放给任意用户注册登记使用。3.3您应谨慎合理的保存、使用您的会员名和密码，应对通过您的会员名和密码实施的行为负责。除非有法律规定或司法裁定，且征得小麻包的同意，否则，会员名和密码不得以任何方式转让、赠与或继承（与账户相关的财产权益除外）。3.4用户不得将在本站注册获得的账户借给他人使用，否则用户应承担由此产生的全部责任，并与实际使用人承担连带责任。3.5如果发现任何非法使用等可能危及您的账户安全的情形时，您应当立即以有效方式通知小麻包，要求小麻包暂停相关服务，并向公安机关报案。您理解小麻包对您的请求采取行动需要合理时间，小麻包对在采取行动前已经产生的后果（包括但不限于您的任何损失）不承担任何责任。";
    
    [self.view addSubview:textView];
}

- (NSString *)titleStr{
    return @"服务条款";
}

@end
