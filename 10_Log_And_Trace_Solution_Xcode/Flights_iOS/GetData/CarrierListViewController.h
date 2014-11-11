//
//  CarrierListViewController.h
//  Flights_iOS
//
//  Created by Shin, Jin & Unnai, Kenichi on 7/15/14.
//  Copyright (c) 2014 CEG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SODataOnlineStoreDelegate.h"
#import "SODataRequestDelegate.h"

@interface CarrierListViewController : UITableViewController <SODataOnlineStoreDelegate, SODataRequestDelegate>

@end
