//
//  CWShareSina.h
//  CWShareDemo
//
//  Created by Wang Jun on 12-8-18.
//
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "CWShareSinaDelegate.h"
#import "WeiboSDK.h"

typedef void(^SinaAuthorizeBlock)(void);

@interface CWShareSina : NSObject <WeiboSDKDelegate>

@property (nonatomic, copy) NSString *sinaAccessToken;
@property (nonatomic, strong) NSDate *sinaTokenExpireDate;
@property (nonatomic, copy) NSString *sinaUID;
@property (weak) id<CWShareSinaDelegate> delegate;
@property (nonatomic, strong) AFHTTPRequestOperationManager *sinaGetRequest;
@property (nonatomic, strong) AFHTTPRequestOperationManager *sinaPostRequest;
@property (weak) UIViewController *parentViewController;
@property (nonatomic, strong) SinaAuthorizeBlock authorizeFinishBlock;
@property (nonatomic, strong) SinaAuthorizeBlock authorizeFailBlock;

- (void)shareWithContent:(NSString *)theContent;

- (void)shareWithContent:(NSString *)theContent withImage:(UIImage *)theImage;

- (void)startAuthorize;

- (BOOL)isAuthorizeExpired;

@end
