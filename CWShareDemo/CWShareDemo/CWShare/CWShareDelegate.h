//
//  CWShareDelegate.h
//  CWShareDemo
//
//  Created by Wang Jun on 12-11-14.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    CWShareTypeSina,            //新浪微博分享
    CWShareTypeTencent,         //腾讯微博分享
    CWShareTypeQQ,              //腾讯QQ分享
    CWShareTypeWechatSession,   //微信好友分享
    CWShareTypeWechatTimeline,  //微信朋友圈分享
    CWShareTypeMessage,         //短信分享
    CWShareTypeMail             //邮件分享
} CWShareType;

@protocol CWShareDelegate <NSObject>

@optional
//登录授权成功
- (void)loginFinishForShareType:(CWShareType)shareType withData:(NSDictionary *)userInfo;
//登录授权失败
- (void)loginFailForShareType:(CWShareType)shareType;

//分享成功
- (void)shareFinishForShareType:(CWShareType)shareType;
//分享失败
- (void)shareFailForShareType:(CWShareType)shareType;

- (void)shareMenuDidSelect:(CWShareType)shareType;


//以下方法弃用
- (void)shareContentFinishForShareType:(CWShareType)shareType
__deprecated_msg("用`shareFinishForShareType:`代替");
- (void)shareContentFailForShareType:(CWShareType)shareType
__deprecated_msg("用`shareFailForShareType:`代替");
- (void)shareContentAndImageFinishForShareType:(CWShareType)shareType
__deprecated_msg("用`shareFinishForShareType:`代替");
- (void)shareContentAndImageFailForShareType:(CWShareType)shareType
__deprecated_msg("用`shareFailForShareType:`代替");

@end
