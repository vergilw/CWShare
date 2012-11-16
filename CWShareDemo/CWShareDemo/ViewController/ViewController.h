//
//  ViewController.h
//  CWShareDemo
//
//  Created by Wang Jun on 12-8-17.
//
//

#import <UIKit/UIKit.h>
#import "CWShare.h"

@interface ViewController : UIViewController <CWShareDelegate>

@property (nonatomic, strong) CWShare *cwShare;

@end
