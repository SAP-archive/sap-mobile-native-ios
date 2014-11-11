//
//  AppDelegate.h
//  Flights_iOS
//
//  Created by Shin, Jin & Unnai, Kenichi on 7/15/14.
//  Copyright (c) 2014 CEG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlightsMAFLogonHandler.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *smpAppID;

//TODO: BEGIN (MAFLogonHandler #1)

@property (strong, nonatomic) FlightsMAFLogonHandler *logonHandler;

//TODO: END (MAFLogonHandler #1)

@end
