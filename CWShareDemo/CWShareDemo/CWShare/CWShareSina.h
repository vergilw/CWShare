//
//  CWShareSina.h
//  CWShareDemo
//
//  Created by Wang Jun on 12-8-18.
//
//

#import <Foundation/Foundation.h>
#import "CWShareSinaAuthorize.h"
#import "ASIHTTPRequest.h"
#import "CWShareSinaDelegate.h"

typedef void(^SinaAuthorizeBlock)(void);

@interface CWShareSina : NSObject <CWShareSinaAuthorizeDelegate,ASIHTTPRequestDelegate> {
    NSString *sinaAccessToken;
    NSDate *sinaTokenExpireDate;
    NSString *sinaUID;
    id<CWShareSinaDelegate> delegate;
    ASIHTTPRequest *sinaGetRequest;
    ASIFormDataRequest *sinaPostRequest;
    UIViewController *parentViewController;
    SinaAuthorizeBlock authorizeBlock;
}

@property (nonatomic, copy) NSString *sinaAccessToken;
@property (nonatomic, strong) NSDate *sinaTokenExpireDate;
@property (nonatomic, copy) NSString *sinaUID;
@property (weak) id<CWShareSinaDelegate> delegate;
@property (nonatomic, strong) ASIHTTPRequest *sinaGetRequest;
@property (nonatomic, strong) ASIFormDataRequest *sinaPostRequest;
@property (weak) UIViewController *parentViewController;
@property (nonatomic, strong) SinaAuthorizeBlock authorizeBlock;
@property (assign) BOOL isSSOAuth;

- (void)shareWithContent:(NSString *)theContent;

- (void)shareWithContent:(NSString *)theContent withImage:(UIImage *)theImage;

- (void)startAuthorize;

- (BOOL)isAuthorizeExpired;

- (void)applicationDidBecomeActive;
- (BOOL)handleOpenURL:(NSURL *)url;

@end
