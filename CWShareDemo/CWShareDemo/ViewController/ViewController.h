//
//  ViewController.h
//  CWShareDemo
//
//  Created by Wang Jun on 12-8-17.
//
//

#import <UIKit/UIKit.h>
#import "CWShare.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface ViewController : UIViewController <CWShareDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

@end
