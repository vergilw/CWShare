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
    CWShareTypeQQ,              //QQ好友分享
    CWShareTypeQQZone,          //QQ空间分享
    CWShareTypeWechatSession,   //微信好友分享
    CWShareTypeWechatTimeline,  //微信朋友圈分享
    CWShareTypeMessage,         //短信分享
    CWShareTypeMail,            //邮件分享
    CWShareTypeDtCode           //二维码
} CWShareType;

typedef enum {
    CWShareLoginTypeSina,       //新浪微博登录
    CWShareLoginTypeTencent,    //腾讯微博登录
    CWShareLoginTypeQQ,         //QQ登录
    CWShareLoginTypeWechat      //微信登录
} CWShareLoginType;

@protocol CWShareDelegate <NSObject>

@optional
//登录授权成功
- (void)loginFinishForShareType:(CWShareLoginType)shareLoginType withData:(NSDictionary *)userInfo;
//登录授权失败
- (void)loginFailForShareType:(CWShareLoginType)shareLoginType;

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

//以下方法弃用
- (void)wechatTimelineShareWithTitle:(NSString *)theTitle withContent:(NSString *)theContent withImage:(UIImage *)theImage withWebUrl:(NSString *)theUrl
__deprecated_msg("用`wechatSessionShareWithTitle:withImage:withWebUrl`代替");

@end
