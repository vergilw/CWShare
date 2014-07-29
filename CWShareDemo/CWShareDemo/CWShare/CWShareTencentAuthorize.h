//
//  CWShareTencentAuthorize.h
//  CWShareDemo
//
//  Created by Wang Jun on 12-10-10.
//
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperationManager.h"

@protocol CWShareTencentAuthorizeDelegate <NSObject>

@optional
- (void)tencentAuthorizeFinish:(NSString *)accessToken withExpireTime:(NSString *)expireTime withOpenID:(NSString *)theOpenID;
- (void)tencentAuthorizeFail;

@end

@interface CWShareTencentAuthorize : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) AFHTTPRequestOperationManager *authorizeRequest;
@property (weak) id<CWShareTencentAuthorizeDelegate> delegate;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *refreshToken;
@property (nonatomic, copy) NSString *expiredTime;
@property (nonatomic, copy) NSString *openID;

@end
