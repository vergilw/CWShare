//
//  ViewController.h
//  CWShareDemo
//
//  Created by Wang Jun on 12-8-17.
//
//

#import <UIKit/UIKit.h>
#import "CWShareSina.h"
#import "CWShareTencent.h"

@interface ViewController : UIViewController <CWShareSinaDelegate,CWShareTencentDelegate>

@property (nonatomic, strong) CWShareSina *sinaShare;
@property (nonatomic, strong) CWShareTencent *tencentShare;

- (IBAction)sinaAuthorizeAction:(id)sender;

@end
