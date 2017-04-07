#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "UIView+YNCategory.h"
#import "UIViewController+YNCategory.h"
#import "YNPageScrollHeaderView.h"
#import "YNPageScrollView.h"
#import "YNPageScrollViewController.h"
#import "YNPageScrollViewMenu.h"
#import "YNPageScrollViewMenuConfigration.h"

FOUNDATION_EXPORT double YNPageScrollViewControllerVersionNumber;
FOUNDATION_EXPORT const unsigned char YNPageScrollViewControllerVersionString[];

