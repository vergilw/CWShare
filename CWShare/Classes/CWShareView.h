//
//  CWShareView.h
//  DYLifeStyle
//
//  Created by chufw on 16/2/19.
//  Copyright © 2016年 Vergil.Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWShareDelegate.h"

typedef NS_OPTIONS(NSInteger, CWShareItemOptions) {
    CWShareItemSina = 1 << 1,
    CWShareItemQQZone = 1 << 2,
    CWShareItemQQ = 1 << 3,
    CWShareItemWechatSession = 1 << 5,
    CWShareItemWechatTimeline = 1 << 7,
};

typedef NS_OPTIONS(NSInteger, CWActionItemOptions) {
    CWActionItemFavoriteNormal = 1 << 1, //Normal和Selected只能选其一，否则会绘制两个
    CWActionItemFavoriteSelected = 1 << 2, //Normal和Selected只能选其一，否则会绘制两个
    CWActionItemReport = 1 << 3,
    CWActionItemDelete = 1 << 4,
    CWActionItemCopyURL = 1 << 5,
    CWActionItemBackIndex = 1 << 6,
    CWActionItemHide = 1 << 7,
    CWActionItemRecommend = 1 << 9,
};

typedef NS_ENUM(NSInteger, CWMenuItem) {
    CWMenuItemSina,
    CWMenuItemQQZone,
    CWMenuItemQQ,
    CWMenuItemWechatSession,
    CWMenuItemWechatTimeline,
    CWMenuItemFavorite,
    CWMenuItemReport,
    CWMenuItemDelete,
    CWMenuItemCopyURL,
    CWMenuItemBackIndex,
    CWMenuItemHide,
    CWMenuItemRecommend
};

@interface CWShareView : UIView

@property (copy, nonatomic) void(^shareActionBlock)(CWShareType shareType);

@property (copy, nonatomic) void(^menuItemBlock)(CWMenuItem menuItem);

- (void)showWithType:(NSArray *)shareTypeArr onView:(UIView *)theView actionBlock:(void(^)(CWShareType shareType))shareActionBlock;

- (void)showHorizontalShareMenu:(CWShareItemOptions)shareOptions andActionMenu:(CWActionItemOptions)actionOptions onView:(UIView *)theView menuBlock:(void(^)(CWMenuItem menuItem))menuItemBlock;

@end
