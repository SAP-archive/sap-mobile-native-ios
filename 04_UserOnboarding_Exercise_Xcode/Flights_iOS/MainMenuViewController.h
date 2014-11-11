//
//  MainMenuViewController.h
//  Flights_iOS
//
//  Created by Shin, Jin & Unnai, Kenichi on 7/25/14.
//  Copyright (c) 2014 CEG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAFLogonCoreDelegate.h"
#import "SODataOnlineStoreDelegate.h"

@interface MainMenuViewController : UIViewController <MAFLogonCoreDelegate, SODataOnlineStoreDelegate>

@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *jsonSwitch;
@property (weak, nonatomic) IBOutlet UILabel *jsonLabel;

@end
