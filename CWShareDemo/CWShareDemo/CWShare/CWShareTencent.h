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

typedef enum {
    TencentShareNone,
    TencentShareContent,
    TencentShareContentAndImage
} TencentShareType;

@interface CWShareTencent : NSObject <CWShareTencentAuthorizeDelegate,ASIHTTPRequestDelegate> {
    NSString *tencentAccessToken;
    NSDate *tencentAccessTokenExpireDate;
    NSString *tencentOpenID;
    id<CWShareTencentDelegate> delegate;
    ASIFormDataRequest *tencentRequest;
    UIViewController *parentViewController;
    TencentShareType tencentShareType;
    NSString *shareContent;
    UIImage *shareImage;
}

@property (nonatomic, copy) NSString *tencentAccessToken;
@property (nonatomic, strong) NSDate *tencentAccessTokenExpireDate;
@property (nonatomic, copy) NSString *tencentOpenID;
@property (weak) id<CWShareTencentDelegate> delegate;
@property (nonatomic, strong) ASIFormDataRequest *tencentRequest;
@property (weak) UIViewController *parentViewController;
@property (nonatomic, copy) NSString *shareContent;
@property (nonatomic, strong) UIImage *shareImage;

- (void)shareToQQZoneWithDescription:(NSString *)theDesc withTitle:(NSString *)theTitle Content:(NSString *)theContent withSynchronizeWeibo:(BOOL)theBool;

- (void)shareToWeiBoWithContent:(NSString *)theContent;

- (void)shareToWeiBoWithContent:(NSString *)theContent withImage:(UIImage *)theImage;

- (void)startAuthorize;

- (BOOL)isAuthorizeExpired;

@end
