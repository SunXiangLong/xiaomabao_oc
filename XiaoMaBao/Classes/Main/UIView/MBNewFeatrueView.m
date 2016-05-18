//
//  MBNewFeatrueView.m
//  XiaoMaBao
//
//  Created by 朱理哲 on 15/8/27.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBNewFeatrueView.h"
#import "iCarousel.h"

@interface MBNewFeatrueView()<iCarouselDataSource,iCarouselDelegate>{
}//
@property(weak,nonatomic)iCarousel* carousel ;
@property(weak,nonatomic)UIPageControl* pageControl ;

@property(weak,nonatomic)UIButton* btnStart ;


@end
@implementation MBNewFeatrueView

-(instancetype)init{
    if (self = [super init]) {
        iCarousel *carousel = [[iCarousel alloc] init];
        carousel.delegate = self;
        carousel.dataSource = self;
        carousel.type = iCarouselTypeLinear;
        carousel.pagingEnabled = YES;
        carousel.scrollSpeed = 2;
        self.carousel = carousel;
        [self addSubview:self.carousel];
        
        UIButton* btnStart = [UIButton new];
        btnStart.alpha = 0 ;
        [btnStart addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
        btnStart.layer.masksToBounds = YES ;
        btnStart.layer.cornerRadius = 4 ;
        [btnStart setBackgroundColor:[UIColor colorWithHexString:@"6d4242"]];
        [btnStart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnStart setTitle:@"立即体验" forState:UIControlStateNormal];
        self.btnStart = btnStart ;
        [self addSubview:btnStart];
        
        UIPageControl *pageControl = [UIPageControl new];
        pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        pageControl.currentPageIndicatorTintColor = self.btnStart.backgroundColor;
        pageControl.numberOfPages = 4;
        self.pageControl = pageControl;
        [self addSubview:pageControl];

        
    }
    return self ;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.carousel.frame = self.bounds ;
    CGFloat btnW = 120 ;
    CGFloat btnH = 44 ;
    self.btnStart.frame = CGRectMake((self.frame.size.width-btnW)/2, self.frame.size.height - btnH - 36, btnW, btnH);
    self.pageControl.frame = CGRectMake((self.frame.size.width-btnW)/2, CGRectGetMaxY(self.btnStart.frame)-4, btnW, 24);
                                     
}


- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return 4 ;
}

-(CGFloat)carousel:(iCarousel * __nonnull)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option) {
        case iCarouselOptionWrap:
            return 1;
            break;
            
        default:
            break;
            
    }
    return value;
}


- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view{
    NSString* imgName = [NSString stringWithFormat:@"lanch%d",(int)index];
    UIImageView *v  = [[UIImageView alloc]init];
    v.image = [UIImage imageNamed:imgName];
    v.frame = self.carousel.bounds;
    
    return v;
}

-(void)carouselCurrentItemIndexDidChange:(iCarousel * __nonnull)carousel
{
    self.pageControl.currentPage = carousel.currentItemIndex;
}

-(void)carouselDidEndDecelerating:(iCarousel * __nonnull)carousel{
    NSInteger index = carousel.currentItemIndex ;
    if (index == 3) {
        self.btnStart.alpha = 1 ;
    }
}

#pragma mark - 立即启动
-(void)start{
    if (self.startNow!= nil) {
        self.startNow();
    }
}

@end
