//
//  HelpshiftEventsHandler.h
//  HSSDKXObjcSample
//
//  Created by Sagar Dagdu on 24/05/21.
//  Copyright © 2021 Sagar Dagdu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HelpshiftX/HelpshiftX.h>

NS_ASSUME_NONNULL_BEGIN

@interface HelpshiftEventsHandler : NSObject<HelpshiftDelegate>

+ (instancetype)sharedInstance;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
