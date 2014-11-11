//
//  MAFLogonHandler
//  TravelAgency_RKT
//
//  Created by Hameed, Thasneem Yasmin.
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAFLogonNGPublicAPI.h"
#import "MAFLogonUIViewManager.h"
#import "MAFLogonNGDelegate.h"
#import "HttpConversationManager.h"

@interface MAFLogonHandler : NSObject <MAFLogonNGDelegate>



@property (strong, nonatomic) MAFLogonUIViewManager *logonUIViewManager;
@property (strong, nonatomic) NSObject<MAFLogonNGPublicAPI> *logonManager;
@property (strong, nonatomic) HttpConversationManager* httpConvManager;


@end
