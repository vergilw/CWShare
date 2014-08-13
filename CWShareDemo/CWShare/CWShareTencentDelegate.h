//
//  CWShareTencentProtocol.h
//  CWShareDemo
//
//  Created by Wang Jun on 12-10-15.
//
//

#import <Foundation/Foundation.h>

@protocol CWShareTencentDelegate <NSObject>

@optional
- (void)tencentShareAuthorizeFinish:(NSDictionary *)userInfo;
- (void)tencentShareAuthorizeFail;

- (void)tencentShareContentFinish;
- (void)tencentShareContentFail;

- (void)tencentShareContentAndImageFinish;
- (void)tencentShareContentAndImageFail;

@end
