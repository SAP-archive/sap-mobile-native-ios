//
//  FlightListViewController.h
//  Flights_iOS
//
//  Created by Shin, Jin & Unnai, Kenichi on 7/15/14.
//  Copyright (c) 2014 CEG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SODataRequestDelegate.h"
#import "SODataEntity.h"

@interface FlightListViewController : UITableViewController <SODataRequestDelegate>

@property (strong, nonatomic) id<SODataEntity> carrier;

@end