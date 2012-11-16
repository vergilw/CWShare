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
    NSString *tencentRefreshToken;
    NSDate *tencentAccessTokenExpireDate;
    NSString *tencentOpenID;
    NSDate *tencentRefreshTokenExpireDate;
    id<CWShareTencentDelegate> delegate;
    ASIFormDataRequest *tencentRequest;
    UIViewController *parentViewController;
    TencentShareType tencentShareType;
    NSString *shareContent;
    UIImage *shareImage;
}

@property (nonatomic, copy) NSString *tencentAccessToken;
@property (nonatomic, copy) NSString *tencentRefreshToken;
@property (nonatomic, strong) NSDate *tencentAccessTokenExpireDate;
@property (nonatomic, copy) NSString *tencentOpenID;
@property (nonatomic, strong) NSDate *tencentRefreshTokenExpireDate;
@property (weak) id<CWShareTencentDelegate> delegate;
@property (nonatomic, strong) ASIFormDataRequest *tencentRequest;
@property (weak) UIViewController *parentViewController;
@property (nonatomic, copy) NSString *shareContent;
@property (nonatomic, strong) UIImage *shareImage;

- (void)shareWithContent:(NSString *)theContent;

- (void)shareWithContent:(NSString *)theContent withImage:(UIImage *)theImage;

- (void)startAuthorize;

- (BOOL)isAuthorizeExpired;

@end
