//
//  CWShareTencent.h
//  CWShareDemo
//
//  Created by Wang Jun on 12-10-9.
//
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "CWShareQQDelegate.h"
#import "TencentOAuth.h"
#import "QQApiInterface.h"
#import "CWShareDelegate.h"

typedef void(^TencentAuthorizeBlock)(void);

@interface CWShareQQ : NSObject <TencentSessionDelegate, QQApiInterfaceDelegate>

@property (nonatomic, copy) NSString *tencentAccessToken;
@property (nonatomic, strong) NSDate *tencentTokenExpireDate;
@property (nonatomic, copy) NSString *tencentOpenID;
@property (weak) id<CWShareQQDelegate> delegate;
@property (nonatomic, strong) AFHTTPSessionManager *tencentRequest;
@property (weak) UIViewController *parentViewController;
@property (nonatomic, strong) TencentAuthorizeBlock authorizeFinishBlock;
@property (nonatomic, strong) TencentAuthorizeBlock authorizeFailBlock;
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property (assign) CWShareType shareTencentType;

- (void)shareToQQZoneWithTitle:(NSString *)theTitle withDescription:(NSString *)theDesc withImage:(UIImage *)theImage targetUrl:(NSString *)theUrl;

- (void)shareToWeiBoWithContent:(NSString *)theContent;

- (void)shareToWeiBoWithContent:(NSString *)theContent withImage:(UIImage *)theImage;

- (void)shareToQQWithContent:(NSString *)theContent;

- (void)shareToQQWithImage:(UIImage *)theImage;

- (void)shareToQQWithTitle:(NSString *)theTitle withContent:(NSString *)theContent withImage:(UIImage *)theImage withTargetUrl:(NSString *)theUrl;

- (void)startAuthorize;

- (BOOL)isAuthorizeExpired;

- (void)clearAuthorizeInfo;

@end
