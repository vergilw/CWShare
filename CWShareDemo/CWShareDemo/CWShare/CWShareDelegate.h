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

//分享内容成功
- (void)shareContentFinishForShareType:(CWShareType)shareType;
//分享内容失败
- (void)shareContentFailForShareType:(CWShareType)shareType;

//分享图片和内容成功
- (void)shareContentAndImageFinishForShareType:(CWShareType)shareType;
//分享图片和内容失败
- (void)shareContentAndImageFailForShareType:(CWShareType)shareType;

- (void)shareMenuDidSelect:(CWShareType)shareType;

@end
