//
//  CWShareSinaAuthorize.h
//  CWShareDemo
//
//  Created by Wang Jun on 12-9-18.
//
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@protocol CWShareSinaAuthorizeDelegate <NSObject>

@optional
- (void)sinaAuthorizeFinish:(NSString *)accessToken withExpireTime:(NSString *)expireTime withUID:(NSString *)theUID;
- (void)sinaAuthorizeFail;

@end

@interface CWShareSinaAuthorize : UIViewController <UIWebViewDelegate,ASIHTTPRequestDelegate> {
    UIWebView *webView;
    ASIFormDataRequest *authorizeRequest;
    id<CWShareSinaAuthorizeDelegate> delegate;
    UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) ASIFormDataRequest *authorizeRequest;
@property (weak) id<CWShareSinaAuthorizeDelegate> delegate;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end
