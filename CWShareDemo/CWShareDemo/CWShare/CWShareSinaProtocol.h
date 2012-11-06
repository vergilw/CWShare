//
//  CWShareSinaProtocol.h
//  CWShareDemo
//
//  Created by Wang Jun on 12-10-15.
//
//

#import <Foundation/Foundation.h>

@protocol CWShareSinaProtocol <NSObject>

@optional
- (void)sinaShareAuthorizeFinish;
- (void)sinaShareAuthorizeFail;

@end
