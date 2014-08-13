//
//  CWShareSinaAuthorize.h
//  CWShareDemo
//
//  Created by Wang Jun on 12-9-18.
//
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperationManager.h"

@protocol CWShareSinaAuthorizeDelegate <NSObject>

@optional
- (void)sinaAuthorizeFinish:(NSString *)accessToken withExpireTime:(NSString *)expireTime withUID:(NSString *)theUID;
- (void)sinaAuthorizeFail;

@end

@interface CWShareSinaAuthorize : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) AFHTTPRequestOperationManager *authorizeRequest;
@property (weak) id<CWShareSinaAuthorizeDelegate> delegate;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end
