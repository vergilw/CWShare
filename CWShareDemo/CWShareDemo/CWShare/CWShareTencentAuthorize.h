//
//  CWShareTencentAuthorize.h
//  CWShareDemo
//
//  Created by Wang Jun on 12-10-10.
//
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@protocol CWShareTencentAuthorizeDelegate <NSObject>

@optional
- (void)tencentAuthorizeFinish:(NSString *)accessToken withExpireTime:(NSString *)expireTime withOpenID:(NSString *)theOpenID withUserInfo:(NSDictionary *)userInfo;
- (void)tencentAuthorizeFail;

@end

@interface CWShareTencentAuthorize : UIViewController <UIWebViewDelegate,ASIHTTPRequestDelegate> {
    UIWebView *webView;
    ASIFormDataRequest *authorizeRequest;
    id<CWShareTencentAuthorizeDelegate> delegate;
    NSString *accessToken;
    NSString *expiredTime;
    NSString *openID;
}

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) ASIFormDataRequest *authorizeRequest;
@property (weak) id<CWShareTencentAuthorizeDelegate> delegate;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *expiredTime;
@property (nonatomic, copy) NSString *openID;

@end
