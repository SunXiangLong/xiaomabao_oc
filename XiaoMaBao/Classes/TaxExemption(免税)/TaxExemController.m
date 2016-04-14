//
//  TaxExemController.m
//  XiaoMaBao
//
//  Created by 朱理哲 on 15/8/29.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "TaxExemController.h"
#import "TaxController.h"

@interface TaxExemController()<ViewPagerDataSource, ViewPagerDelegate>


@end

@implementation TaxExemController
- (void)viewDidLoad {
    self.dataSource = self;
    self.delegate = self;
    self.titleStr = @"免税";

    [self getMenuItem:@"2"];
    [super viewDidLoad];
}

#pragma mark - 获取item菜单
-(void)getMenuItem:(NSString *)menu_type
{
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"home/getFavourableMenu"] parameters:@{@"menu_type":menu_type} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.menuIds = [responseObject valueForKeyPath:@"data"];
        [self reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 9;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(0, 0, 100, 44);
    label.backgroundColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:13.0];
    label.text = [NSString stringWithFormat:@"Content View #%i", index];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    UIView* line = [UIView new];
    line.backgroundColor = [UIColor redColor];
    line.frame = CGRectMake(CGRectGetMaxX(label.frame)+2, 0, 1, 44);
    [label addSubview:line];
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    TaxController *cvc = [[TaxController alloc]init];
//    cvc.menu_id = self.menuIds[index][@"menu_id"] ;
    cvc.menu_id = @"1" ;

    return cvc;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 1.0;
            break;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
            break;
        case ViewPagerOptionTabLocation:
            return 1.0;
            break;
        default:
            break;
    }
    
    return value;
}
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [[UIColor redColor] colorWithAlphaComponent:0.64];
            break;
        default:
            break;
    }
    
    return color;
}
@end
