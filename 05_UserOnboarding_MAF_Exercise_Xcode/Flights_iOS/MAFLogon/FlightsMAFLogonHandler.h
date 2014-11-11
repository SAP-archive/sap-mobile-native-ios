//
//  FlightsMAFLogonHandler.h
//  Flights_iOS
//
//  Created by Shin, Jin & Unnai, Kenichi on 7/15/14.
//  Copyright (c) 2014 CEG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAFLogonNGPublicAPI.h"
#import "MAFLogonUIViewManager.h"
#import "MAFLogonNGDelegate.h"
#import "HttpConversationManager.h"

@interface FlightsMAFLogonHandler : NSObject <MAFLogonNGDelegate>

////TODO: BEGIN (MAF managers #1)
//
//@property (strong, nonatomic) MAFLogonUIViewManager *logonUIViewManager;
//@property (strong, nonatomic) NSObject<MAFLogonNGPublicAPI> *logonManager;
//@property (strong, nonatomic) HttpConversationManager* httpConvManager;
//
////TODO: END (MAF managers #1)

@end
