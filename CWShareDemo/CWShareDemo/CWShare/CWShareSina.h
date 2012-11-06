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
#import "CWShareSinaProtocol.h"

@interface CWShareSina : NSObject <CWShareSinaAuthorizeDelegate,ASIHTTPRequestDelegate> {
    NSString *sinaAccessToken;
    NSDate *sinaExpireDate;
    NSString *sinaUID;
    id<CWShareSinaProtocol> delegate;
    ASIFormDataRequest *sinaRequest;
}

@property (nonatomic, copy) NSString *sinaAccessToken;
@property (nonatomic, strong) NSDate *sinaExpireDate;
@property (nonatomic, copy) NSString *sinaUID;
@property (weak) id<CWShareSinaProtocol> delegate;
@property (nonatomic, strong) ASIFormDataRequest *sinaRequest;

- (void)shareWithContent:(NSString *)theContent;

- (void)shareWithContent:(NSString *)theContent withImage:(UIImage *)theImage;

- (void)startAuthorize;

- (BOOL)isAuthorizeExpired;



@end
