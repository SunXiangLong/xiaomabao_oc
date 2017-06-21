//
//  MBNewBabyHeadView.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBNewBabyHeadView.h"
#import "MBLovelyBabyModel.h"
@interface MBNewBabyHeadView()
{
   
    NSArray *_urlArray;

}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *promptImageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *concentTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cencentTopImageWidth;

@property (weak, nonatomic) IBOutlet UILabel *baby_weight;
@property (weak, nonatomic) IBOutlet UILabel *baby_length;
@property (weak, nonatomic) IBOutlet UILabel *baby_date;
@property (weak, nonatomic) IBOutlet UILabel *babyWeight;
@property (weak, nonatomic) IBOutlet UILabel *babylenth;
@property (weak, nonatomic) IBOutlet UILabel *babyDate;
@property (weak, nonatomic) IBOutlet UILabel *baby_content;
@property (weak, nonatomic) IBOutlet UIView *cenView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view2_weith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view1_weith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view_weith;
@property (weak, nonatomic) IBOutlet UIImageView *came_image;

@property (weak, nonatomic) IBOutlet UIImageView *setThePregnancyImage;
@property (weak, nonatomic) IBOutlet UIView *pregnancyRatesView;

@end
@implementation MBNewBabyHeadView

-(void)awakeFromNib{
    [super awakeFromNib];
    

}
+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBNewBabyHeadView" owner:nil options:nil]  firstObject];
}
- (IBAction)setHeadOrForPregnantDate:(UITapGestureRecognizer *)sender {
    
    switch (sender.view.tag) {
        case 0:{
            
            if (_model.stateBabyType == readyToPregnantBaby) {
                self.sortingOptionsEvent(nil,setThePregnancy);
            }
        }break;
        case 1: {
        
            if (_model.stateBabyType == theBabyIsBorn) {
                self.sortingOptionsEvent(nil,setHead );
            }
        }break;
        case 2:{
            
            if (_model.stateBabyType == readyToPregnantBaby) {
                 self.sortingOptionsEvent(nil,setTheDueDate);
            }
        }break;
        default:break;
    }

}

- (IBAction)sortingOptions:(UIButton *)sender {
    
    if (sender.tag > -1) {
        if (sender.tag > 9) {
             self.sortingOptionsEvent(_urlArray[sender.tag-10], theJumpPage);
        }else{
         self.sortingOptionsEvent(_urlArray[sender.tag], theJumpPage);
        }
       
    }else{
        self.sortingOptionsEvent(nil, recordTheBaby);
    }
   
}


-(void)setModel:(MBDayInfoModel *)model{
    _model = model;
    self.baby_length.text = model.baby_length?:@" ";
    self.baby_weight.text = model.baby_weight?:@" ";
    self.baby_date.text = model.overdue_daynum?:@" ";
    self.baby_content.text = model.content;
    self.pregnancyRatesView.hidden = true;
    self.setThePregnancyImage.hidden = true;
    self.preparePregnantView.hidden = true;
    self.functionalClassificationView.hidden = true;
    self.came_image.hidden = YES;
    self.view_weith.constant = self.view1_weith.constant = self.view2_weith.constant = (UISCREEN_WIDTH - 2)/3;
    
    _promptImageWidth.constant = 10;
    _concentTop.constant = 10;
    _cencentTopImageWidth.constant = 5;
    if (!model.content) {
      

        _promptImageWidth.constant = 0;
        _concentTop.constant = 0;
        _cencentTopImageWidth.constant = 0;
    }
    
    _urlArray = @[@{@"url":URL(string(BASE_URL_root, @"/discovery/knowledge_index")),@"title":@"知识库"},
                  @{@"url":URL(string(BASE_URL_root, @"/safefood/category")),@"title":@"能不能吃"},
                  @{@"url":URL(@"http://www.xiaomabao.com/tools/jewel.html"),@"title":@"百宝箱"},
                  ];
    UIImage *image = self.baby_image.image?:V_IMAGE(@"headPortrait");
    [self.baby_image sd_setImageWithURL:model.images placeholderImage: image];
    switch (model.stateBabyType) {
        case isPregnantBaby:{
            
            self.functionalClassificationView.hidden = false;
            self.baby_image.userInteractionEnabled = NO;
            self.babyDate.text = @"距离预产期";
        }break;
        case theBabyIsBorn:{
            self.functionalClassificationView.hidden = false;
            [self.baby_image sd_setImageWithURL:model.baby_photo  placeholderImage: V_IMAGE(@"headPortrait")];
            self.came_image.hidden = NO;
            self.baby_image.userInteractionEnabled = YES;
            self.babylenth.text = @"宝宝身高";
            self.babyWeight.text = @"宝宝体重";
            self.view_weith.constant = self.view1_weith.constant = (UISCREEN_WIDTH -1)/2;
            self.view2_weith.constant =  0;
            self.babyDate.text = @"";
        }break;
        default:{
            
            _urlArray = @[@{@"url":URL(string(BASE_URL_root, @"/discovery/knowledge_list/73")),@"title":@"孕前检查"},
                          @{@"url":URL(string(BASE_URL_root, @"/discovery/knowledge_list/5")),@"title":@"备孕常识"},
                          @{@"url":URL(string(BASE_URL_root, @"/discovery/knowledge_list/7")),@"title":@"受孕技巧"},
                          @{@"url":URL(string(BASE_URL_root, @"/discovery/knowledge_list/6")),@"title":@"孕前调养"},
                          @{@"url":URL(string(BASE_URL_root, @"/discovery/beiyun_list/0")),@"title":@"准妈妈必吃"},
                          @{@"url":URL(string(BASE_URL_root, @"/discovery/beiyun_list/1")),@"title":@"准爸爸必吃"},
                         
                          ];
            self.preparePregnantView.hidden = false;
            self.babyWeight.text = @"距排卵日";
            self.pregnancyRatesView.hidden = false;
            self.setThePregnancyImage.hidden = false;
            self.baby_weight.text = model.day_num;
        }
            break;
    }
    
  

}

@end
