//
//  MBSearchViewController.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/11/21.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "BkBaseViewController.h"
@class MBSearchViewController;

typedef void(^PYDidSearchBlock)(MBSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText); // 开始搜索时调用的block

typedef NS_ENUM(NSInteger, PYHotSearchStyle)  { // 热门搜索标签风格
    PYHotSearchStyleNormalTag,      // 普通标签(不带边框)
    PYHotSearchStyleColorfulTag,    // 彩色标签（不带边框，背景色为随机彩色）
    PYHotSearchStyleBorderTag,      // 带有边框的标签,此时标签背景色为clearColor
    PYHotSearchStyleARCBorderTag,   // 带有圆弧边框的标签,此时标签背景色为clearColor
    PYHotSearchStyleRankTag,        // 带有排名标签
    PYHotSearchStyleRectangleTag,   // 矩形标签,此时标签背景色为clearColor
    PYHotSearchStyleDefault = PYHotSearchStyleNormalTag // 默认为普通标签
};

typedef NS_ENUM(NSInteger, PYSearchHistoryStyle) {  // 搜索历史风格
    PYSearchHistoryStyleCell,           // UITableViewCell 风格
    PYSearchHistoryStyleNormalTag,      // PYHotSearchStyleNormalTag 标签风格
    PYSearchHistoryStyleColorfulTag,    // 彩色标签（不带边框，背景色为随机彩色）
    PYSearchHistoryStyleBorderTag,      // 带有边框的标签,此时标签背景色为clearColor
    PYSearchHistoryStyleARCBorderTag,   // 带有圆弧边框的标签,此时标签背景色为clearColor
    PYSearchHistoryStyleDefault = PYSearchHistoryStyleCell // 默认为 PYSearchHistoryStyleCell
};

typedef NS_ENUM(NSInteger, PYSearchResultShowMode) { // 搜索结果显示方式
    PYSearchResultShowModeCustom,   // 通过自定义显示
    PYSearchResultShowModePush,     // 通过Push控制器显示
    PYSearchResultShowModeEmbed,    // 通过内嵌控制器View显示
    PYSearchResultShowModeDefault = PYSearchResultShowModeCustom // 默认为用户自定义（自己处理）
};
typedef NS_ENUM(NSInteger, PYSearchResultSearchTypes) { // 搜索类型
    PYSearchResultShowModeGoods,   // 商品搜索
    PYSearchResultShowModeService, // 服务搜索
    PYSearchResultShowModePost,    // 帖子搜索
   
};

@protocol PYSearchViewControllerDelegate <NSObject, UITableViewDelegate>

@optional
/** 点击(开始)搜索时调用 */
- (void)searchViewController:(MBSearchViewController *)searchViewController didSearchWithsearchBar:(UISearchBar *)searchBar searchText:(NSString *)searchText;
/** 搜索框文本变化时，显示的搜索建议通过searchViewController的searchSuggestions赋值即可 */
- (void)searchViewController:(MBSearchViewController *)searchViewController  searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText;
/** 点击取消时调用 */
- (void)didClickCancel:(MBSearchViewController *)searchViewController;

@end
@interface MBSearchViewController : BkBaseViewController
/**
 * 排名标签背景色对应的16进制字符串（如：@"#ffcc99"）数组(四个颜色)
 * 前三个为分别为1、2、3 第四个为后续所有标签的背景色
 * 该属性只有在设置hotSearchStyle为PYHotSearchStyleColorfulTag才生效
 */
@property (nonatomic, strong) NSArray<NSString *> *rankTagBackgroundColorHexStrings;
/**
 * web安全色池,存储的是UIColor数组，用于设置标签的背景色
 * 该属性只有在设置hotSearchStyle为PYHotSearchStyleColorfulTag才生效
 */
@property (nonatomic, strong) NSMutableArray<UIColor *> *colorPol;
/** 热门搜索 */
@property (nonatomic, copy) NSArray<NSString *> *hotSearches;
/** 所有的热门标签 */
@property (nonatomic, copy) NSArray<UILabel *> *hotSearchTags;
/** 热门标签头部 */
@property (nonatomic, weak) UILabel *hotSearchHeader;
/** 搜索类型 */
@property (nonatomic, assign) PYSearchResultSearchTypes searchTypes;
/** 所有的搜索历史标签,只有当PYSearchHistoryStyle != PYSearchHistoryStyleCell才有值 */
@property (nonatomic, copy) NSArray<UILabel *> *searchHistoryTags;
/** 搜索历史标题,只有当PYSearchHistoryStyle != PYSearchHistoryStyleCell才有值 */
@property (nonatomic, weak) UILabel *searchHistoryHeader;

/** 代理 */
@property (nonatomic, weak) id<PYSearchViewControllerDelegate> delegate;

/** 热门搜索风格 （默认为：PYHotSearchStyleDefault）*/
@property (nonatomic, assign) PYHotSearchStyle hotSearchStyle;
/** 搜索历史风格 （默认为：PYSearchHistoryStyleDefault）*/
@property (nonatomic, assign) PYSearchHistoryStyle searchHistoryStyle;
/** 显示搜索结果模式（默认为自定义：PYSearchResultShowModeDefault） */
@property (nonatomic, assign) PYSearchResultShowMode searchResultShowMode;
/** 搜索栏 */
@property (nonatomic, weak) UISearchBar *searchBar;
/** 搜索栏的背景色 */
@property (nonatomic, strong) UIColor *searchBarBackgroundColor;
/** 取消按钮 */
@property (nonatomic, weak) UIBarButtonItem *cancelButton;

/** 搜索时调用此Block */
@property (nonatomic, copy) PYDidSearchBlock didSearchBlock;
/** 搜索建议,注意：给此属性赋值时，确保searchSuggestionHidden值为NO，否则赋值失效 */
@property (nonatomic, copy) NSArray<NSString *> *searchSuggestions;
/** 搜索建议是否隐藏 默认为：NO */
@property (nonatomic, assign) BOOL searchSuggestionHidden;

/** 搜索结果TableView (只有searchResultShowMode != PYSearchResultShowModeCustom才有值) */
@property (nonatomic, weak) UITableView *searchResultTableView;
/** 搜索结果控制器 */
@property (nonatomic, strong) UITableViewController *searchResultController;
/** 基本搜索TableView(显示历史搜索和搜索记录) */
@property (nonatomic, strong) UITableView *baseSearchTableView;
- (instancetype)init:(PYSearchResultSearchTypes)searchTypes;
/**
 * 快速创建PYSearchViewController对象
 *
 * hotSearches : 热门搜索数组
 * placeholder : searchBar占位文字
 *
 */

+ (MBSearchViewController *)searchViewControllerWithHotSearches:(NSArray<NSString *> *)hotSearches searchBarPlaceholder:(NSString *)placeholder;

/**
 * 快速创建PYSearchViewController对象
 *
 * hotSearches : 热门搜索数组
 * placeholder : searchBar占位文字
 * block: 点击（开始）搜索时调用block
 * 注意 : delegate(代理)的优先级大于block(即实现了代理方法则block失效)
 *
 */
+ (MBSearchViewController *)searchViewControllerWithHotSearches:(NSArray<NSString *> *)hotSearches searchBarPlaceholder:(NSString *)placeholder didSearchBlock:(PYDidSearchBlock)block;

@end
