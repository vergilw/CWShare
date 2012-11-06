//
//  CWShareTencentProtocol.h
//  CWShareDemo
//
//  Created by Wang Jun on 12-10-15.
//
//

#import <Foundation/Foundation.h>

@protocol CWShareTencentProtocol <NSObject>

@optional
- (void)tencentShareAuthorizeFinish;
- (void)tencentShareAuthorizeFail;

@end
