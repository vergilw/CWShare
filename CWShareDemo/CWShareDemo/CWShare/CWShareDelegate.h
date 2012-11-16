//
//  CWShareDelegate.h
//  CWShareDemo
//
//  Created by Wang Jun on 12-11-14.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    CWShareTypeSina,
    CWShareTypeTencent
} CWShareType;

@protocol CWShareDelegate <NSObject>

@optional
- (void)authorizeFinishForShareType:(CWShareType)shareType;
- (void)authorizeFailForShareType:(CWShareType)shareType;

- (void)shareContentFinishForShareType:(CWShareType)shareType;
- (void)shareContentFailForShareType:(CWShareType)shareType;

- (void)shareContentAndImageFinishForShareType:(CWShareType)shareType;
- (void)shareContentAndImageFailForShareType:(CWShareType)shareType;

@end
