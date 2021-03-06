//
//  CWShareSina.h
//  CWShareDemo
//
//  Created by Wang Jun on 12-8-18.
//
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "CWShareSinaDelegate.h"
#import "WeiboSDK.h"

typedef void(^SinaAuthorizeBlock)(void);

@interface CWShareSina : NSObject <WeiboSDKDelegate,WBHttpRequestDelegate>

@property (nonatomic, strong) NSString *sinaAccessToken;
@property (nonatomic, strong) NSDate *sinaTokenExpireDate;
@property (nonatomic, strong) NSString *sinaUID;
@property (nonatomic, strong) NSString *sinaAppKey;
@property (nonatomic, strong) NSString *sinaRedirectURL;
@property (weak) id<CWShareSinaDelegate> delegate;
@property (nonatomic, strong) AFHTTPSessionManager *sinaGetRequest;
@property (nonatomic, strong) AFHTTPSessionManager *sinaPostRequest;
@property (weak) UIViewController *parentViewController;
@property (nonatomic, strong) SinaAuthorizeBlock authorizeFinishBlock;
@property (nonatomic, strong) SinaAuthorizeBlock authorizeFailBlock;

- (void)shareWithContent:(NSString *)theContent;

- (void)shareWithContent:(NSString *)theContent withImage:(UIImage *)theImage;

- (void)startAuthorize;

- (BOOL)isAuthorizeExpired;

- (void)clearAuthorizeInfo;

@end
