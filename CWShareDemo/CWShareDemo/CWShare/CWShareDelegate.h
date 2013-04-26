//
//  CWShareDelegate.h
//  CWShareDemo
//
//  Created by Wang Jun on 12-11-14.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    CWShareTypeSina,
    CWShareTypeTencent
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

@end
