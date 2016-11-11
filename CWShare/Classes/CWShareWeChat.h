//
//  CWShareWeChat.h
//  CWShareDemo
//
//  Created by Wang Jun on 14-3-26.
//
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "AFNetworking.h"
#import "CWShareDelegate.h"
#import "CWShareWeChatDelegate.h"

typedef enum {
    CWShareWechatSessionContent = 0,
    CWShareWechatSessionContentAndImage = 1,
    CWShareWechatTimelineContent = 2,
    CWShareWechatTimelineContentAndImage = 3
} CWShareWechatType;

@interface CWShareWeChat : NSObject <WXApiDelegate>

@property (nonatomic, copy) NSString *wechatAccessToken;
@property (nonatomic, strong) NSDate *wechatTokenExpireDate;
@property (nonatomic, copy) NSString *wechatOpenID;
@property (nonatomic, strong) NSString *wechatAppID;
@property (nonatomic, strong) NSString *wechatAppSecret;
@property (weak) id<CWShareWeChatDelegate> delegate;
@property (nonatomic, strong) AFHTTPSessionManager *wechatRequest;
@property (nonatomic, strong) AFHTTPSessionManager *wechatInfoRequest;
@property (assign, nonatomic) CWShareType shareWechatType;

//开始授权登录
- (void)startAuthorize;

- (void)clearAuthorizeInfo;

//分享文字到微信好友
- (void)sessionShareWithTitle:(NSString *)theTitle;
//分享新闻到微信好友
- (void)sessionShareWithTitle:(NSString *)theTitle withContent:(NSString *)theContent withImage:(UIImage *)theImage withWebUrl:(NSString *)theUrl;
//分享文字到微信朋友圈
- (void)timelineShareWithTitle:(NSString *)theTitle;
//分享新闻到微信朋友圈
- (void)timelineShareWithTitle:(NSString *)theTitle withImage:(UIImage *)theImage withWebUrl:(NSString *)theUrl;

@end
