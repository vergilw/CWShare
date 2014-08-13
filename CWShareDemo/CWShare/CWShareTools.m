//
//  CWShareTools.m
//  CWShareDemo
//
//  Created by Wang Jun on 12-10-10.
//
//

#import "CWShareTools.h"

@implementation CWShareTools

+ (NSString *)getClientIp
{
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"http://www.whatismyip.com/automation/n09230945.asp"];
    NSString *ip = [NSString stringWithContentsOfURL:ipURL encoding:1 error:&error];
    NSString *currentIP = ip ? ip : [error localizedDescription];
    return currentIP;
}

@end
