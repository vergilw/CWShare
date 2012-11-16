//
//  CWShareSina.h
//  CWShareDemo
//
//  Created by Wang Jun on 12-8-18.
//
//

#import <Foundation/Foundation.h>
#import "CWShareSinaAuthorize.h"
#import "ASIFormDataRequest.h"
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
    ASIFormDataRequest *sinaRequest;
    UIViewController *parentViewController;
    SinaShareType sinaShareType;
    NSString *shareContent;
    UIImage *shareImage;
}

@property (nonatomic, copy) NSString *sinaAccessToken;
@property (nonatomic, strong) NSDate *sinaExpireDate;
@property (nonatomic, copy) NSString *sinaUID;
@property (weak) id<CWShareSinaDelegate> delegate;
@property (nonatomic, strong) ASIFormDataRequest *sinaRequest;
@property (weak) UIViewController *parentViewController;
@property (nonatomic, copy) NSString *shareContent;
@property (nonatomic, strong) UIImage *shareImage;

- (void)shareWithContent:(NSString *)theContent;

- (void)shareWithContent:(NSString *)theContent withImage:(UIImage *)theImage;

- (void)startAuthorize;

- (BOOL)isAuthorizeExpired;



@end
