//
//  AppDelegate.h
//  TravelAgency_RKT
//
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAFLogonHandler.h"


#import "MAFUIStyleParser.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *smpAppID;

@property (strong, nonatomic) MAFLogonHandler *logonHandler;



@end
