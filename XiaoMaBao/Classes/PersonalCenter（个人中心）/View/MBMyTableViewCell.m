//
//  MBMyTableViewCell.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/6.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBMyTableViewCell.h"
#import "MBMyItem.h"

@interface MBMyTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;
@end

@implementation MBMyTableViewCell

- (void)setItem:(MBMyItem *)item{
    _item = item;
    
    self.iconImageView.image = [UIImage imageNamed:item.itemIcon];
    self.titleLbl.text = item.itemName;
    if (item.itemDesc.length) {
        self.phoneLbl.hidden = !item.itemDesc.length;
        self.phoneLbl.text = item.itemDesc;
    }
}


@end
