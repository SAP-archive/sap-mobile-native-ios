//
//  DetailViewController.h
//  TravelAgency_RKT
//
//  Created by Hameed, Thasneem Yasmin.
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SODataEntity.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id<SODataEntity> detailItem;

@property (strong, nonatomic) IBOutlet UILabel *agencyName;
@property (strong, nonatomic) IBOutlet UILabel *agencyId;
@property (strong, nonatomic) IBOutlet UITextField *agencyNumber;

- (IBAction)updateAgency:(id)sender;
- (IBAction)keyboardOff:(id)sender;

@end
