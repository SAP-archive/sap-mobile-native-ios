//
//  CreateAgencyViewController.h
//  TravelAgency_RKT
//
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SODataEntity.h"

@interface CreateAgencyViewController : UITableViewController

@property (strong, nonatomic) id<SODataEntity> travelAgency;

@property (weak, nonatomic) IBOutlet UITextField *agencyIDInput;
@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UITextField *streetInput;
@property (weak, nonatomic) IBOutlet UITextField *cityInput;
@property (weak, nonatomic) IBOutlet UITextField *regionInput;

@property (weak, nonatomic) IBOutlet UITextField *zipInput;
@property (weak, nonatomic) IBOutlet UITextField *countryInput;
@property (weak, nonatomic) IBOutlet UITextField *telephoneInput;
@property (weak, nonatomic) IBOutlet UITextField *urlInput;




@end
