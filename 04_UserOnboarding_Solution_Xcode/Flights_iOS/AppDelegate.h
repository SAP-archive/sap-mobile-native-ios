//
//  AppDelegate.h
//  Flights_iOS
//
//  Created by Shin, Jin & Unnai, Kenichi on 7/25/14.
//  Copyright (c) 2014 CEG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAFLogonCore.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//TODO: BEGIN (MAFLogonCore #1)
@property (strong, nonatomic) MAFLogonCore *lc;
//TODO: END (MAFLogonCore #1)

@end
