//
//  CWShareTencent.h
//  CWShareDemo
//
//  Created by Wang Jun on 12-10-9.
//
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "CWShareTencentAuthorize.h"
#import "CWShareTencentDelegate.h"

typedef void(^TencentAuthorizeBlock)(void);

@interface CWShareTencent : NSObject <CWShareTencentAuthorizeDelegate,ASIHTTPRequestDelegate> {
    NSString *tencentAccessToken;
    NSDate *tencentTokenExpireDate;
    NSString *tencentOpenID;
    id<CWShareTencentDelegate> delegate;
    ASIFormDataRequest *tencentRequest;
    UIViewController *parentViewController;
    TencentAuthorizeBlock authorizeBlock;
} 

@property (nonatomic, copy) NSString *tencentAccessToken;
@property (nonatomic, strong) NSDate *tencentTokenExpireDate;
@property (nonatomic, copy) NSString *tencentOpenID;
@property (weak) id<CWShareTencentDelegate> delegate;
@property (nonatomic, strong) ASIFormDataRequest *tencentRequest;
@property (weak) UIViewController *parentViewController;
@property (nonatomic, strong) TencentAuthorizeBlock authorizeBlock;

- (void)shareToQQZoneWithDescription:(NSString *)theDesc withTitle:(NSString *)theTitle Content:(NSString *)theContent withSynchronizeWeibo:(BOOL)theBool;

- (void)shareToWeiBoWithContent:(NSString *)theContent;

- (void)shareToWeiBoWithContent:(NSString *)theContent withImage:(UIImage *)theImage;

- (void)startAuthorize;

- (BOOL)isAuthorizeExpired;

@end
