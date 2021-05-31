//
//  HelpshiftEventsHandler.m
//  HSSDKXObjcSample
//
//  Created by Sagar Dagdu on 24/05/21.
//  Copyright © 2021 Sagar Dagdu. All rights reserved.
//

#import "HelpshiftEventsHandler.h"

@implementation HelpshiftEventsHandler

+ (instancetype)sharedInstance {
    static HelpshiftEventsHandler *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HelpshiftEventsHandler alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark Helpshift Delegate Implementation

- (void)handleHelpshiftEvent:(NSString *)eventName withData:(NSDictionary *)data {
    //TODO: Handle events from HelpshiftX SDK here.
    
    NSLog(@"Helpshift Event: %@, event data: %@", eventName, data);
}

- (void)authenticationFailedForUserWithReason:(HelpshiftAuthenticationFailureReason)reason {
    //TODO: Handle authentication failed.
    
    NSLog(@"Helpshift: Failed to authenticate user, reason: %lu", (unsigned long)reason);
}

@end
