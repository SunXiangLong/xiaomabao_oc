//
//  FSCalendarHeader.m
//  Pods
//
//  Created by Wenchao Ding on 29/1/15.
//
//

#import "FSCalendarHeader.h"
#import "FSCalendar.h"
#import "UIView+FSExtension.h"
#import "NSDate+FSExtension.h"
#import "NSCalendar+FSExtension.h"

#define kBlueText [UIColor colorWithRed:14/255.0 green:69/255.0 blue:221/255.0 alpha:1.0]


@interface FSCalendarHeader ()

@property (copy, nonatomic) NSDateFormatter *dateFormatter;
@property (copy, nonatomic) NSDateFormatter *titleDateFormatter;
@property (weak,nonatomic ) UILabel         *timeTitleLabel;
@property (copy, nonatomic) NSDate          *minimumDate;
@property (copy, nonatomic) NSDate          *maximumDate;
@property (assign,nonatomic) NSUInteger currentMonth;

@property (strong,nonatomic) UIView *headerView;

@end

@implementation FSCalendarHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _dateFormat                    = @"MMMM yyyy";
    _dateFormatter                 = [[NSDateFormatter alloc] init];
    _titleDateFormatter            = [[NSDateFormatter alloc] init];
    _titleDateFormatter.dateFormat = @"yyyy年MMMM";
    _dateFormatter.dateFormat      = _dateFormat;
    _minDissolveAlpha              = 0.2;
    _scrollDirection               = UICollectionViewScrollDirectionHorizontal;
    _minimumDate                   = [NSDate fs_dateWithYear:1970 month:1 day:1];
    _maximumDate                   = [NSDate fs_dateWithYear:2099 month:12 day:31];

    CGFloat width                  = [UIScreen mainScreen].bounds.size.width;
    _headerView                    = [[UIView alloc] init];
    _headerView.frame              = CGRectMake(0, 0, width, self.fs_height);
    UILabel *timeTitleLabel            = [[UILabel alloc] init];
    timeTitleLabel.frame               = _headerView.frame;
    timeTitleLabel.textAlignment       = NSTextAlignmentCenter;

    NSDate *date = [[NSDate date] fs_dateByAddingMonths:self.currentMonth];
    timeTitleLabel.text = [_titleDateFormatter stringFromDate:date];
    [_headerView addSubview:_timeTitleLabel = timeTitleLabel];
    [self addSubview:_headerView];

    UIButton *prevButton           = [UIButton buttonWithType:UIButtonTypeCustom];
    [prevButton addTarget:self action:@selector(prev) forControlEvents:UIControlEventTouchUpInside];
    [prevButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    prevButton.frame               = CGRectMake(8, 0, 30, 30);
    [prevButton setTitle:@"上" forState:UIControlStateNormal];
    [_headerView addSubview:prevButton];

    UIButton *nextButton           = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    nextButton.frame               = CGRectMake(width - 38, 0, 30, 30);
    [nextButton setTitle:@"下" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:nextButton];
    
}

- (void)prev{
    --self.currentMonth;
    NSDate *date = [[NSDate date] fs_dateByAddingMonths:self.currentMonth];
    _timeTitleLabel.text = [_titleDateFormatter stringFromDate:date];
    
    if (self.currentMonth == 0) {
        [self.calendar scrollToDate:date animate:YES];
    }else{
        [self.calendar setSelectedDate:date animate:YES];
    }
}

- (void)next{
    ++self.currentMonth;
    NSDate *date = [[NSDate date] fs_dateByAddingMonths:self.currentMonth];
    _timeTitleLabel.text = [_titleDateFormatter stringFromDate:date];

    if (self.currentMonth == 0) {
        [self.calendar scrollToDate:date animate:YES];
    }else{
        [self.calendar setSelectedDate:date animate:YES];
    }
}


- (void)setScrollOffset:(CGFloat)scrollOffset
{
    if (_scrollOffset != scrollOffset) {
        _scrollOffset = scrollOffset;
        
        NSUInteger index = (_scrollOffset / self.frame.size.width);
//        NSLog(@"%ld", index);
        
//                if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
//                    _collectionView.contentOffset = CGPointMake((_scrollOffset-0.5)*_collectionViewFlowLayout.itemSize.width, 0);
//                } else {
//                    _collectionView.contentOffset = CGPointMake(0, _scrollOffset * _collectionViewFlowLayout.itemSize.height);
//                }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSArray *cells = _collectionView.visibleCells;
//            [cells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                //                [self updateAlphaForCell:obj];
//            }];
//        });
    }
}


- (void)setDateFormat:(NSString *)dateFormat
{
    if (![_dateFormat isEqualToString:dateFormat]) {
        _dateFormat = [dateFormat copy];
        _dateFormatter.dateFormat = dateFormat;
        [self reloadData];
    }
}

- (void)setMinDissolveAlpha:(CGFloat)minDissolveAlpha
{
    if (_minDissolveAlpha != minDissolveAlpha) {
        _minDissolveAlpha = minDissolveAlpha;
        [self reloadData];
    }
}

#pragma mark - Public

- (void)reloadData
{
    
}
@end
