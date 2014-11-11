//
//  FlightDetailsViewController.h
//  Flights_iOS
//
//  Created by Shin, Jin & Unnai, Kenichi on 7/15/14.
//  Copyright (c) 2014 CEG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SODataRequestDelegate.h"
#import "SODataEntity.h"
// REST
#import "RequestDelegate.h"

@interface FlightDetailsViewController : UITableViewController <SODataRequestDelegate, RequestDelegate>

@property (strong, nonatomic) id<SODataEntity> flight;

@end
