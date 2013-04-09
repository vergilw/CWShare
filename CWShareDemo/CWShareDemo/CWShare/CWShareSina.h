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

typedef enum {
    SinaShareNone,
    SinaShareContent,
    SinaShareContentAndImage
} SinaShareType;

@interface CWShareSina : NSObject <CWShareSinaAuthorizeDelegate,ASIHTTPRequestDelegate> {
    NSString *sinaAccessToken;
    NSDate *sinaExpireDate;
    NSString *sinaUID;
    id<CWShareSinaDelegate> delegate;
    ASIHTTPRequest *sinaGetRequest;
    ASIFormDataRequest *sinaPostRequest;
    UIViewController *parentViewController;
    SinaShareType sinaShareType;
    NSString *shareContent;
    UIImage *shareImage;
}

@property (nonatomic, copy) NSString *sinaAccessToken;
@property (nonatomic, strong) NSDate *sinaExpireDate;
@property (nonatomic, copy) NSString *sinaUID;
@property (weak) id<CWShareSinaDelegate> delegate;
@property (nonatomic, strong) ASIHTTPRequest *sinaGetRequest;
@property (nonatomic, strong) ASIFormDataRequest *sinaPostRequest;
@property (weak) UIViewController *parentViewController;
@property (nonatomic, copy) NSString *shareContent;
@property (nonatomic, strong) UIImage *shareImage;

- (void)shareWithContent:(NSString *)theContent;

- (void)shareWithContent:(NSString *)theContent withImage:(UIImage *)theImage;

- (void)startAuthorize;

- (BOOL)isAuthorizeExpired;



@end
