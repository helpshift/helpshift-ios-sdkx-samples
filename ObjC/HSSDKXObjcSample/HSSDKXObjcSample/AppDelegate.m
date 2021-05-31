//
//  AppDelegate.m
//  HSSDKXObjcSample
//
//  Created by Sagar Dagdu on 24/05/21.
//  Copyright © 2021 Sagar Dagdu. All rights reserved.
//

#import "AppDelegate.h"
#import "HelpshiftEventsHandler.h"
#import <HelpshiftX/HelpshiftX.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
#warning TODO: To start using this project, copy-paste your APP_ID as the value of hsPlatformId and comment this line
    NSString *hsPlatformId = @"";

#warning TODO: To start using this project, copy-paste your DOMAIN as the value of hsDomain and comment this line
    NSString *hsDomain = @"";

    [Helpshift installWithPlatformId:hsPlatformId domain:hsDomain config:nil];
    
    // Set the delegate
    Helpshift.sharedInstance.delegate = HelpshiftEventsHandler.sharedInstance;
    
    [self registerForPush];
    
    //handle when app is not in background and opened for push notification
    if (launchOptions != nil)  {
        NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo != nil && [[userInfo objectForKey:@"origin"] isEqualToString:@"helpshift"]) {
            [Helpshift handleNotificationWithUserInfoDictionary:userInfo isAppLaunch:YES withController:self.window.rootViewController];
        }
    }
    
    return YES;
}

#pragma mark Push notifications

- (void) registerForPush {
#if TARGET_OS_SIMULATOR
    // there is no push on simulator so skip
#else
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
                          completionHandler:^(BOOL granted, NSError *_Nullable error) {
        if(error) {
            NSLog(@"Error while requesting Notification permissions.");
            return;
        }
        
        // Register for remote notifications
        if (granted) {
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
     }];
#endif
}

- (void) application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [Helpshift registerDeviceToken:deviceToken];
}

- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Error::%@", error.localizedDescription);
}

- (void) userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions)) completionHandler {
    if([[notification.request.content.userInfo objectForKey:@"origin"] isEqualToString:@"helpshift"]) {
        NSLog(@"userNotificationCenter:willPresentNotification for helpshift origin");
        [Helpshift handleNotificationWithUserInfoDictionary:notification.request.content.userInfo isAppLaunch:NO withController:self.window.rootViewController];
    }
    
    completionHandler(UNNotificationPresentationOptionNone);
}

@end
