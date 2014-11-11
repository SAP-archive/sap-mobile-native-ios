//
//  BatchRequestViewController.h
//  Flights_iOS
//
//  Created by Shin, Jin & Unnai, Kenichi on 7/15/14.
//  Copyright (c) 2014 CEG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SODataOnlineStoreDelegate.h"
#import "SODataRequestDelegate.h"

@interface BatchRequestViewController : UIViewController <SODataOnlineStoreDelegate, SODataRequestDelegate, UITextFieldDelegate>

- (IBAction)AddRequestToBatch:(UIButton *)sender;
- (IBAction)AddCloseChangeset:(UIButton *)sender;
- (IBAction)executeAsyncBatchRequest:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextField *agencyIDInput;
@property (weak, nonatomic) IBOutlet UITextField *agencyTelephone;

@property (weak, nonatomic) IBOutlet UILabel *CUDCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *changeSetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *retrievalCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalRequestCountLabel;
@property (nonatomic) int CUDCount;
@property (nonatomic) int changeSetCount;
@property (nonatomic) int retrievalCount;
@property (nonatomic) int totalRequestCount;

@end
