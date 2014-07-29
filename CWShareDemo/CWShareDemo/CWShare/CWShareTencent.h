//
//  CWShareTencent.h
//  CWShareDemo
//
//  Created by Wang Jun on 12-10-9.
//
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "CWShareTencentAuthorize.h"
#import "CWShareTencentDelegate.h"
#import <TencentOpenAPI/TencentOAuth.h>

typedef void(^TencentAuthorizeBlock)(void);

@interface CWShareTencent : NSObject <CWShareTencentAuthorizeDelegate,TencentSessionDelegate>

@property (nonatomic, copy) NSString *tencentAccessToken;
@property (nonatomic, strong) NSDate *tencentTokenExpireDate;
@property (nonatomic, copy) NSString *tencentOpenID;
@property (weak) id<CWShareTencentDelegate> delegate;
@property (nonatomic, strong) AFHTTPRequestOperationManager *tencentRequest;
@property (weak) UIViewController *parentViewController;
@property (nonatomic, strong) TencentAuthorizeBlock authorizeFinishBlock;
@property (nonatomic, strong) TencentAuthorizeBlock authorizeFailBlock;
@property (nonatomic, strong) TencentOAuth *tencentOAuth;

- (void)shareToQQZoneWithDescription:(NSString *)theDesc withTitle:(NSString *)theTitle Content:(NSString *)theContent contentUrl:(NSString *)contentUrl withSynchronizeWeibo:(BOOL)theBool;

- (void)shareToWeiBoWithContent:(NSString *)theContent;

- (void)shareToWeiBoWithContent:(NSString *)theContent withImage:(UIImage *)theImage;

- (void)startAuthorize;

- (BOOL)isAuthorizeExpired;

@end
