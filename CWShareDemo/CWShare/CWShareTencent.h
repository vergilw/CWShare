//
//  CWShareTencent.h
//  CWShareDemo
//
//  Created by Wang Jun on 12-10-9.
//
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "CWShareTencentDelegate.h"
#import <TencentOpenAPI/TencentOpenSDK.h>
#import "CWShareDelegate.h"

typedef void(^TencentAuthorizeBlock)(void);

@interface CWShareTencent : NSObject <TencentSessionDelegate,QQApiInterfaceDelegate>

@property (nonatomic, copy) NSString *tencentAccessToken;
@property (nonatomic, strong) NSDate *tencentTokenExpireDate;
@property (nonatomic, copy) NSString *tencentOpenID;
@property (weak) id<CWShareTencentDelegate> delegate;
@property (nonatomic, strong) AFHTTPRequestOperationManager *tencentRequest;
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

@end
