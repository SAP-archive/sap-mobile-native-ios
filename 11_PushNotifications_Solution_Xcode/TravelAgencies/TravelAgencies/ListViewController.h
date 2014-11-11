//
//  MasterViewController.h
//  TravelAgency_RKT
//
//  Created by Hameed, Thasneem Yasmin.
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum WorkingModes {
    WorkingModeOnline,
    WorkingModeOffline
} WorkingModes;

@interface ListViewController : UITableViewController


@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (assign, nonatomic) BOOL shouldDownloadData;
@property (nonatomic, assign) WorkingModes workingMode;


@end
