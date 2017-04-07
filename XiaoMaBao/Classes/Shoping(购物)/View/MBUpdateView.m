//
//  MBUpdateView.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/10/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBUpdateView.h"

@implementation MBUpdateView
+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBUpdateView" owner:nil options:nil] lastObject];
}
- (IBAction)buttonEvent:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/xiao-ma-bao/id1049237132?mt=8"]];
}
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    _ver_description.text = dataDic[@"version_description"];
    _version.text = string(@"最新版本：", dataDic[@"latest_version"]);
    _size.text = string(@"新版本大小：", dataDic[@"size"]);

}

@end
