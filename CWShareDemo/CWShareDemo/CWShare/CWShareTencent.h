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
#import "CWShareTencentProtocol.h"

@interface CWShareTencent : NSObject <CWShareTencentAuthorizeDelegate,ASIHTTPRequestDelegate> {
    NSString *tencentAccessToken;
    NSDate *tencentExpireDate;
    NSString *tencentOpenID;
    id<CWShareTencentProtocol> delegate;
    ASIFormDataRequest *tencentRequest;
}

@property (nonatomic, copy) NSString *tencentAccessToken;
@property (nonatomic, strong) NSDate *tencentExpireDate;
@property (nonatomic, copy) NSString *tencentOpenID;
@property (weak) id<CWShareTencentProtocol> delegate;
@property (nonatomic, strong) ASIFormDataRequest *tencentRequest;

- (void)shareWithContent:(NSString *)theContent;

- (void)shareWithContent:(NSString *)theContent withImage:(UIImage *)theImage;

- (void)startAuthorize;

- (BOOL)isAuthorizeExpired;

@end
