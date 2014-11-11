//
//  BatchResultViewController.h
//  Flights_iOS
//
//  Created by Shin, Jin & Unnai, Kenichi on 7/15/14.
//  Copyright (c) 2014 CEG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SODataRequestExecution.h"
#import "SODataResponseBatch.h"

@interface BatchResultViewController : UITableViewController

@property (strong, nonatomic) id<SODataResponseBatch> batchResponse;

@end
