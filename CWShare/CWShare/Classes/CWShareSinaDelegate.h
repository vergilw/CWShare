//
//  CWShareSinaProtocol.h
//  CWShareDemo
//
//  Created by Wang Jun on 12-10-15.
//
//

#import <Foundation/Foundation.h>

@protocol CWShareSinaDelegate <NSObject>

@optional
- (void)sinaShareAuthorizeFinish:(NSDictionary *)userInfo;
- (void)sinaShareAuthorizeFail;

- (void)sinaShareContentFinish;
- (void)sinaShareContentFail;

- (void)sinaShareContentAndImageFinish;
- (void)sinaShareContentAndImageFail;

@end
