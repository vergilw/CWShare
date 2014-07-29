//
//  CWShareWeChat.h
//  CWShareDemo
//
//  Created by Wang Jun on 14-3-26.
//
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

typedef enum {
    CWShareWechatSessionContent = 0,
    CWShareWechatSessionContentAndImage = 1,
    CWShareWechatTimelineContent = 2,
    CWShareWechatTimelineContentAndImage = 3
} CWShareWechatType;

@interface CWShareWeChat : NSObject <WXApiDelegate>

@property (assign) CWShareWechatType cwShareWechatType;

//分享文字到微信好友
- (void)sessionShareWithTitle:(NSString *)theTitle;
//分享新闻到微信好友
- (void)sessionShareWithTitle:(NSString *)theTitle withContent:(NSString *)theContent withImage:(UIImage *)theImage withWebUrl:(NSString *)theUrl;
//分享文字到微信朋友圈
- (void)timelineShareWithTitle:(NSString *)theTitle;
//分享新闻到微信朋友圈
- (void)timelineShareWithTitle:(NSString *)theTitle withContent:(NSString *)theContent withImage:(UIImage *)theImage withWebUrl:(NSString *)theUrl;

@end
