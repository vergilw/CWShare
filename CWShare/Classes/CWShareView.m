//
//  CWShareView.m
//  DYLifeStyle
//
//  Created by chufw on 16/2/19.
//  Copyright © 2016年 Vergil.Wang. All rights reserved.
//

#import "CWShareView.h"

#define kButtonTag_Sina             1
#define kButtonTag_WechatSession    2
#define kButtonTag_WechatTimeline   3
#define kButtonTag_Tencent          4
#define kButtonTag_TencentZone      5
#define kButtonTag_copyUrl          6

#define UI_ITEM_WIDTH 50

//分享菜单栏
#define CWImgNameQQZoneString @"cwshare_tencentZone"
#define CWImgNameQQString @"cwshare_qq"
#define CWImgNameWechatSessionString @"cwshare_wechat"
#define CWImgNameWechatTimelineString @"cwshare_timeline"
#define CWImgNameSinaString @"cwshare_sina"

#define kCWItemTag_Sina             1
#define kCWItemTag_WechatSession    2
#define kCWItemTag_WechatTimeline   3
#define kCWItemTag_QQ               4
#define kCWItemTag_QQZone           5

//功能菜单栏
#define CWImgNameFavoriteNormalString @"cwshare_favoriteNormal"
#define CWImgNameFavoriteSelectedString @"cwshare_favoriteSelected"
#define CWImgNameReportString @"cwshare_report"
#define CWImgNameDeleteString @"cwshare_delete"
#define CWImgNameCopyURLString @"cwshare_copyUrl"
#define CWImgNameBackIndexString @"cwshare_backIndex"
#define CWImgNameRecommendString @"cwshare_recommend"
#define CWImgNameHideString @"cwshare_hide"

#define kCWItemTag_Favorite 10
#define kCWItemTag_Report 11
#define kCWItemTag_Delete 12
#define kCWItemTag_CopyURL 13
#define kCWItemTag_BackIndex 14
#define kCWItemTag_Recommend 15
#define kCWItemTag_Hide 16

@interface CWShareView ()

@property (strong, nonatomic) UIView *btnBgView;

@end

@implementation CWShareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/*!
 * @method
 * @brief 显示水平滑动的分享菜单
 * @discussion
 * @param shareOptions 分享的类型
 * @param actionOptions 功能的类型
 */
- (void)showHorizontalShareMenu:(CWShareItemOptions)shareOptions andActionMenu:(CWActionItemOptions)actionOptions onView:(UIView *)theView menuBlock:(void (^)(CWMenuItem))menuItemBlock {
    
    self.menuItemBlock = menuItemBlock;
    
    [self setFrame:theView.bounds];
    [theView addSubview:self];
    
    UIButton *cancleBgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBgBtn setFrame:self.bounds];
    [cancleBgBtn addTarget:self action:@selector(cancleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancleBgBtn setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.6]];
    [cancleBgBtn setAlpha:0.0];
    [UIView animateWithDuration:0.25 animations:^{
        [cancleBgBtn setAlpha:1.0];
    }];
    [self addSubview:cancleBgBtn];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    self.btnBgView = [[UIView alloc] init];
    [self.btnBgView setBackgroundColor:[UIColor colorWithRed:0xf2/255.0 green:0xf2/255.0 blue:0xf2/255.0 alpha:1.0]];
    [self addSubview:self.btnBgView];
    
    //构建分享菜单栏
    UIScrollView *shareScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, UI_ITEM_WIDTH+10+15+44)];
    [shareScrollView setShowsHorizontalScrollIndicator:NO];
    [self.btnBgView addSubview:shareScrollView];
    
    CGFloat currentWidth = 15;
    
    if (shareOptions & CWShareItemWechatTimeline) {
        UIView *itemView = [self generateItemViewWithImage:CWImgNameWechatTimelineString withTitle:@"朋友圈"];
        [itemView setTag:kCWItemTag_WechatTimeline];
        [itemView setFrame:CGRectMake(currentWidth, 22, itemView.bounds.size.width, itemView.bounds.size.height)];
        [shareScrollView addSubview:itemView];
        currentWidth += itemView.bounds.size.width+22;
    }
    
    if (shareOptions & CWShareItemWechatSession) {
        UIView *itemView = [self generateItemViewWithImage:CWImgNameWechatSessionString withTitle:@"微信好友"];
        [itemView setTag:kCWItemTag_WechatSession];
        [itemView setFrame:CGRectMake(currentWidth, 22, itemView.bounds.size.width, itemView.bounds.size.height)];
        [shareScrollView addSubview:itemView];
        currentWidth += itemView.bounds.size.width+22;
    }
    
    if (shareOptions & CWShareItemQQZone) {
        UIView *itemView = [self generateItemViewWithImage:CWImgNameQQZoneString withTitle:@"QQ空间"];
        [itemView setTag:kCWItemTag_QQZone];
        [itemView setFrame:CGRectMake(currentWidth, 22, itemView.bounds.size.width, itemView.bounds.size.height)];
        [shareScrollView addSubview:itemView];
        currentWidth += itemView.bounds.size.width+22;
    }
    
    if (shareOptions & CWShareItemQQ) {
        UIView *itemView = [self generateItemViewWithImage:CWImgNameQQString withTitle:@"QQ好友"];
        [itemView setTag:kCWItemTag_QQ];
        [itemView setFrame:CGRectMake(currentWidth, 22, itemView.bounds.size.width, itemView.bounds.size.height)];
        [shareScrollView addSubview:itemView];
        currentWidth += itemView.bounds.size.width+22;
    }
    
    if (shareOptions & CWShareItemSina) {
        UIView *itemView = [self generateItemViewWithImage:CWImgNameSinaString withTitle:@"新浪微博"];
        [itemView setTag:kCWItemTag_Sina];
        [itemView setFrame:CGRectMake(currentWidth, 22, itemView.bounds.size.width, itemView.bounds.size.height)];
        [shareScrollView addSubview:itemView];
        currentWidth += itemView.bounds.size.width+22;
    }
    
    [shareScrollView setContentSize:CGSizeMake(currentWidth, shareScrollView.bounds.size.height)];
    
    UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(shareScrollView.frame)-1, screenWidth, 1)];
    [lineImgView setBackgroundColor:[UIColor colorWithRed:0xde/255.0 green:0xde/255.0 blue:0xde/255.0 alpha:1.0]];
    [self.btnBgView addSubview:lineImgView];
    
    //构建功能菜单栏
    UIScrollView *actionScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(shareScrollView.frame), screenWidth, UI_ITEM_WIDTH+10+15+44)];
    [actionScrollView setShowsHorizontalScrollIndicator:NO];
    [self.btnBgView addSubview:actionScrollView];
    
    currentWidth = 15;
    
    if (actionOptions & CWActionItemCopyURL) {
        UIView *itemView = [self generateItemViewWithImage:CWImgNameCopyURLString withTitle:@"复制链接"];
        [itemView setTag:kCWItemTag_CopyURL];
        [itemView setFrame:CGRectMake(currentWidth, 22, itemView.bounds.size.width, itemView.bounds.size.height)];
        [actionScrollView addSubview:itemView];
        currentWidth += itemView.bounds.size.width+22;
    }
    
    if (actionOptions & CWActionItemFavoriteNormal) {
        UIView *itemView = [self generateItemViewWithImage:CWImgNameFavoriteNormalString withTitle:@"收藏"];
        [itemView setTag:kCWItemTag_Favorite];
        [itemView setFrame:CGRectMake(currentWidth, 22, itemView.bounds.size.width, itemView.bounds.size.height)];
        [actionScrollView addSubview:itemView];
        currentWidth += itemView.bounds.size.width+22;
    }
    
    if (actionOptions & CWActionItemFavoriteSelected) {
        UIView *itemView = [self generateItemViewWithImage:CWImgNameFavoriteSelectedString withTitle:@"收藏"];
        [itemView setTag:kCWItemTag_Favorite];
        [itemView setFrame:CGRectMake(currentWidth, 22, itemView.bounds.size.width, itemView.bounds.size.height)];
        [actionScrollView addSubview:itemView];
        currentWidth += itemView.bounds.size.width+22;
    }
    
    if (actionOptions & CWActionItemReport) {
        UIView *itemView = [self generateItemViewWithImage:CWImgNameReportString withTitle:@"举报"];
        [itemView setTag:kCWItemTag_Report];
        [itemView setFrame:CGRectMake(currentWidth, 22, itemView.bounds.size.width, itemView.bounds.size.height)];
        [actionScrollView addSubview:itemView];
        currentWidth += itemView.bounds.size.width+22;
    }
    
    if (actionOptions & CWActionItemDelete) {
        UIView *itemView = [self generateItemViewWithImage:CWImgNameDeleteString withTitle:@"删除"];
        [itemView setTag:kCWItemTag_Delete];
        [itemView setFrame:CGRectMake(currentWidth, 22, itemView.bounds.size.width, itemView.bounds.size.height)];
        [actionScrollView addSubview:itemView];
        currentWidth += itemView.bounds.size.width+22;
    }
    
    if (actionOptions & CWActionItemBackIndex) {
        UIView *itemView = [self generateItemViewWithImage:CWImgNameBackIndexString withTitle:@"回到主页"];
        [itemView setTag:kCWItemTag_BackIndex];
        [itemView setFrame:CGRectMake(currentWidth, 22, itemView.bounds.size.width, itemView.bounds.size.height)];
        [actionScrollView addSubview:itemView];
        currentWidth += itemView.bounds.size.width+22;
    }
    
    if (actionOptions & CWActionItemRecommend) {
        UIView *itemView = [self generateItemViewWithImage:CWImgNameRecommendString withTitle:@"推荐"];
        [itemView setTag:kCWItemTag_Recommend];
        [itemView setFrame:CGRectMake(currentWidth, 22, itemView.bounds.size.width, itemView.bounds.size.height)];
        [actionScrollView addSubview:itemView];
        currentWidth += itemView.bounds.size.width+22;
    }
    
    if (actionOptions & CWActionItemHide) {
        UIView *itemView = [self generateItemViewWithImage:CWImgNameHideString withTitle:@"隐藏"];
        [itemView setTag:kCWItemTag_Hide];
        [itemView setFrame:CGRectMake(currentWidth, 22, itemView.bounds.size.width, itemView.bounds.size.height)];
        [actionScrollView addSubview:itemView];
        currentWidth += itemView.bounds.size.width+22;
    }
    
    [actionScrollView setContentSize:CGSizeMake(currentWidth, actionScrollView.bounds.size.height)];

    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(0, CGRectGetMaxY(actionScrollView.frame), screenWidth, 44)];
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnBgView addSubview:cancelBtn];
    
    [self.btnBgView setFrame:CGRectMake(0, screenHeight-CGRectGetMaxY(cancelBtn.frame), screenWidth, CGRectGetMaxY(cancelBtn.frame))];
    
    [self.btnBgView setTransform:CGAffineTransformMakeTranslation(0, self.btnBgView.bounds.size.height)];
    [UIView animateWithDuration:0.25 animations:^{
        [self.btnBgView setTransform:CGAffineTransformIdentity];
    }];
}

- (void)showWithType:(NSArray *)shareTypeArr onView:(UIView *)theView actionBlock:(void (^)(CWShareType))shareActionBlock
{
    self.shareActionBlock = shareActionBlock;
    
    [self setFrame:theView.bounds];
    [theView addSubview:self];
    
    UIButton *cancleBgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBgBtn setFrame:self.bounds];
    [cancleBgBtn addTarget:self action:@selector(cancleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancleBgBtn setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.3]];
    [cancleBgBtn setAlpha:0.0];
    [UIView animateWithDuration:0.25 animations:^{
        [cancleBgBtn setAlpha:1.0];
    }];
    [self addSubview:cancleBgBtn];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat spaceFactor = (screenWidth-30-30*3)/4;
    
    CGFloat totalHeight = 20+(45+spaceFactor)+spaceFactor+10+20+25+44+20;
    self.btnBgView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-totalHeight, screenWidth, totalHeight)];
    [self.btnBgView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.btnBgView];
    
    //朋友圈
    UIButton *wechatTimelineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [wechatTimelineButton setFrame:CGRectMake(15, 20, spaceFactor, spaceFactor)];
    [wechatTimelineButton setImage:[UIImage imageNamed:@"cwshare_timeline"] forState:UIControlStateNormal];
    [wechatTimelineButton setTag:kButtonTag_WechatTimeline];
    [wechatTimelineButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnBgView addSubview:wechatTimelineButton];
    
    UILabel *wechatTimelineLabel = [[UILabel alloc] initWithFrame:CGRectMake(15-5, 20+spaceFactor+10, spaceFactor+10, 20)];
    [wechatTimelineLabel setBackgroundColor:[UIColor clearColor]];
    [wechatTimelineLabel setTextColor:[UIColor colorWithRed:0x1a/255.0 green:0x1a/255.0 blue:0x1a/255.0 alpha:1.0]];
    [wechatTimelineLabel setTextAlignment:NSTextAlignmentCenter];
    [wechatTimelineLabel setFont:[UIFont systemFontOfSize:14]];
    [wechatTimelineLabel setText:@"朋友圈"];
    [self.btnBgView addSubview:wechatTimelineLabel];
    
    //QQ好友
    UIButton *qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [qqButton setFrame:CGRectMake(15+spaceFactor+30, 20, spaceFactor, spaceFactor)];
    [qqButton setImage:[UIImage imageNamed:@"cwshare_qq"] forState:UIControlStateNormal];
    [qqButton setTag:kButtonTag_Tencent];
    [qqButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnBgView addSubview:qqButton];
    
    UILabel *qqLabel = [[UILabel alloc] initWithFrame:CGRectMake(15+spaceFactor+30-5, 20+spaceFactor+10, spaceFactor+10, 20)];
    [qqLabel setBackgroundColor:[UIColor clearColor]];
    [qqLabel setTextColor:[UIColor colorWithRed:0x1a/255.0 green:0x1a/255.0 blue:0x1a/255.0 alpha:1.0]];
    [qqLabel setTextAlignment:NSTextAlignmentCenter];
    [qqLabel setFont:[UIFont systemFontOfSize:14]];
    [qqLabel setText:@"QQ好友"];
    [self.btnBgView addSubview:qqLabel];
    
    //微信好友
    UIButton *wechatSessionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [wechatSessionButton setFrame:CGRectMake(15+(30+spaceFactor)*2, 20, spaceFactor, spaceFactor)];
    [wechatSessionButton setImage:[UIImage imageNamed:@"cwshare_wechat"] forState:UIControlStateNormal];
    [wechatSessionButton setTag:kButtonTag_WechatSession];
    [wechatSessionButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnBgView addSubview:wechatSessionButton];
    
    UILabel *wechatSessionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15+(30+spaceFactor)*2-5, 20+spaceFactor+10, spaceFactor+10, 20)];
    [wechatSessionLabel setBackgroundColor:[UIColor clearColor]];
    [wechatSessionLabel setTextColor:[UIColor colorWithRed:0x1a/255.0 green:0x1a/255.0 blue:0x1a/255.0 alpha:1.0]];
    [wechatSessionLabel setTextAlignment:NSTextAlignmentCenter];
    [wechatSessionLabel setFont:[UIFont systemFontOfSize:14]];
    [wechatSessionLabel setText:@"微信好友"];
    [self.btnBgView addSubview:wechatSessionLabel];
    
    //新浪微博
    UIButton *sinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sinaButton setFrame:CGRectMake(15+(30+spaceFactor)*3, 20, spaceFactor, spaceFactor)];
    [sinaButton setImage:[UIImage imageNamed:@"cwshare_sina"] forState:UIControlStateNormal];
    [sinaButton setTag:kButtonTag_Sina];
    [sinaButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnBgView addSubview:sinaButton];
    
    UILabel *sinaLabel = [[UILabel alloc] initWithFrame:CGRectMake(15+(30+spaceFactor)*3-5, 20+spaceFactor+10, spaceFactor+10, 20)];
    [sinaLabel setBackgroundColor:[UIColor clearColor]];
    [sinaLabel setTextColor:[UIColor colorWithRed:0x1a/255.0 green:0x1a/255.0 blue:0x1a/255.0 alpha:1.0]];
    [sinaLabel setTextAlignment:NSTextAlignmentCenter];
    [sinaLabel setFont:[UIFont systemFontOfSize:14]];
    [sinaLabel setText:@"新浪微博"];
    [self.btnBgView addSubview:sinaLabel];
    
    //QQ空间
    UIButton *qqZoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [qqZoneButton setFrame:CGRectMake(15+(30+spaceFactor)*0, 20+(spaceFactor+10+20+15), spaceFactor, spaceFactor)];
    [qqZoneButton setImage:[UIImage imageNamed:@"cwshare_tencentZone"] forState:UIControlStateNormal];
    [qqZoneButton setTag:kButtonTag_TencentZone];
    [qqZoneButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnBgView addSubview:qqZoneButton];
    
    UILabel *qqZoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(15+(30+spaceFactor)*0-5, 20+(spaceFactor+10+20+15)+spaceFactor+10, spaceFactor+10, 20)];
    [qqZoneLabel setBackgroundColor:[UIColor clearColor]];
    [qqZoneLabel setTextColor:[UIColor colorWithRed:0x1a/255.0 green:0x1a/255.0 blue:0x1a/255.0 alpha:1.0]];
    [qqZoneLabel setTextAlignment:NSTextAlignmentCenter];
    [qqZoneLabel setFont:[UIFont systemFontOfSize:14]];
    [qqZoneLabel setText:@"QQ空间"];
    [self.btnBgView addSubview:qqZoneLabel];
    
    //复制链接
    UIButton *copyUrlButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [copyUrlButton setFrame:CGRectMake(15+(30+spaceFactor)*1, 20+(spaceFactor+10+20+15), spaceFactor, spaceFactor)];
    [copyUrlButton setImage:[UIImage imageNamed:@"cwshare_copyUrl"] forState:UIControlStateNormal];
    [copyUrlButton setTag:kButtonTag_copyUrl];
    [copyUrlButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnBgView addSubview:copyUrlButton];
    
    UILabel *copyUrlLabel = [[UILabel alloc] initWithFrame:CGRectMake(15+(30+spaceFactor)*1-5, 20+(spaceFactor+10+20+15)+spaceFactor+10, spaceFactor+10, 20)];
    [copyUrlLabel setBackgroundColor:[UIColor clearColor]];
    [copyUrlLabel setTextColor:[UIColor colorWithRed:0x1a/255.0 green:0x1a/255.0 blue:0x1a/255.0 alpha:1.0]];
    [copyUrlLabel setTextAlignment:NSTextAlignmentCenter];
    [copyUrlLabel setFont:[UIFont systemFontOfSize:14]];
    [copyUrlLabel setText:@"复制链接"];
    [self.btnBgView addSubview:copyUrlLabel];
    
    //取消按钮
    UIButton *cancelBotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBotBtn setFrame:CGRectMake(15, 20+(45+spaceFactor)+spaceFactor+10+20+25, screenWidth-30, 44)];
    [cancelBotBtn setBackgroundColor:[UIColor colorWithRed:0xf2/255.0 green:0xf2/255.0 blue:0xf2/255.0 alpha:1.0]];
    [cancelBotBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBotBtn setTitleColor:[UIColor colorWithRed:0x1a/255.0 green:0x1a/255.0 blue:0x1a/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelBotBtn.layer setMasksToBounds:YES];
    [cancelBotBtn.layer setCornerRadius:6];
    [cancelBotBtn addTarget:self action:@selector(cancleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnBgView addSubview:cancelBotBtn];
    
    [self.btnBgView setTransform:CGAffineTransformMakeTranslation(0, self.btnBgView.bounds.size.height)];
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.btnBgView setTransform:CGAffineTransformIdentity];
    } completion:nil];
}

#pragma mark - UIControl Event

- (IBAction)shareButtonAction:(UIButton *)sender
{

    if (sender.tag == kButtonTag_Sina) {
        self.shareActionBlock(CWShareTypeSina);
    } else if (sender.tag == kButtonTag_WechatSession) {
        self.shareActionBlock(CWShareTypeWechatSession);
    } else if (sender.tag == kButtonTag_WechatTimeline) {
        self.shareActionBlock(CWShareTypeWechatTimeline);
    } else if (sender.tag == kButtonTag_Tencent) {
        self.shareActionBlock(CWShareTypeQQ);
    } else if (sender.tag == kButtonTag_TencentZone) {
        self.shareActionBlock(CWShareTypeQQZone);
    } else if (sender.tag == kButtonTag_copyUrl) {
        self.shareActionBlock(CWShareTypeCopyUrl);
    }

    [self removeFromSuperview];
}

- (IBAction)cancleBtnAction:(id)sender
{
    [self removeFromSuperview];
}

/*!
 * @method
 * @brief 生成Item视图
 * @discussion
 * @param theImgStr 图标
 * @param theTitleStr 标题
 * @result Item视图
 */
- (UIView *)generateItemViewWithImage:(NSString *)theImgStr withTitle:(NSString *)theTitleStr {
    
    UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_ITEM_WIDTH, UI_ITEM_WIDTH+10+15)];
    
    UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemBtn setFrame:itemView.bounds];
    [itemBtn addTarget:self action:@selector(itemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [itemView addSubview:itemBtn];
    
    UIImageView *itemImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_ITEM_WIDTH, UI_ITEM_WIDTH)];
    [itemImgView setImage:[self fetchImage:theImgStr]];
    [itemView addSubview:itemImgView];
    
    UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(-5, UI_ITEM_WIDTH+10, UI_ITEM_WIDTH+10, 15)];
    [itemLabel setBackgroundColor:[UIColor clearColor]];
    [itemLabel setTextColor:[UIColor colorWithRed:0x33/255.0 green:0x33/255.0 blue:0x33/255.0 alpha:1.0]];
    [itemLabel setTextAlignment:NSTextAlignmentCenter];
    [itemLabel setFont:[UIFont systemFontOfSize:14]];
    [itemLabel setText:theTitleStr];
    [itemView addSubview:itemLabel];
    
    return itemView;
}

/*!
 * @method
 * @brief 菜单视图触发
 * @discussion
 * @param sender
 */
- (void)itemBtnAction:(UIButton *)sender {
    if (sender.superview.tag == kCWItemTag_Sina) {
        self.menuItemBlock(CWMenuItemSina);
    } else if (sender.superview.tag == kCWItemTag_WechatSession) {
        self.menuItemBlock(CWMenuItemWechatSession);
    } else if (sender.superview.tag == kCWItemTag_WechatTimeline) {
        self.menuItemBlock(CWMenuItemWechatTimeline);
    } else if (sender.superview.tag == kCWItemTag_QQ) {
        self.menuItemBlock(CWMenuItemQQ);
    } else if (sender.superview.tag == kCWItemTag_QQZone) {
        self.menuItemBlock(CWMenuItemQQZone);
    } else if (sender.superview.tag == kCWItemTag_CopyURL) {
        self.menuItemBlock(CWMenuItemCopyURL);
    } else if (sender.superview.tag == kCWItemTag_Favorite) {
        self.menuItemBlock(CWMenuItemFavorite);
    } else if (sender.superview.tag == kCWItemTag_Report) {
        self.menuItemBlock(CWMenuItemReport);
    } else if (sender.superview.tag == kCWItemTag_Delete) {
        self.menuItemBlock(CWMenuItemDelete);
    } else if (sender.superview.tag == kCWItemTag_CopyURL) {
        self.menuItemBlock(CWMenuItemCopyURL);
    } else if (sender.superview.tag == kCWItemTag_BackIndex) {
        self.menuItemBlock(CWMenuItemBackIndex);
    } else if (sender.superview.tag == kCWItemTag_Recommend) {
        self.menuItemBlock(CWMenuItemRecommend);
    } else if (sender.superview.tag == kCWItemTag_Hide) {
        self.menuItemBlock(CWMenuItemHide);
    }
    
    [self removeFromSuperview];
}

- (UIImage*)fetchImage:(NSString *)name {
    if ([UIImage respondsToSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:)]) {
        NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"CWShare" withExtension:@"bundle"]];
        return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    } else {
        return [UIImage imageNamed:name];
    }
}

@end
