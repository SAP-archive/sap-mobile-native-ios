//
//  MainMenuViewController.m
//  Flights_iOS
//
//  Created by Shin, Jin & Unnai, Kenichi on 7/15/14.
//  Copyright (c) 2014 CEG. All rights reserved.
//

#import "MainMenuViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ConnectivitySettings.h"
#import "AppDelegate.h"
#import "MAFLogonRegistrationData.h"
#import "FlightsMAFLogonHandler.h"

@interface MainMenuViewController ()

@property (strong, nonatomic) FlightsMAFLogonHandler *logonHandler;

- (IBAction)unregisterUser:(id)sender;
- (IBAction)jsonSwitchToggled:(id)sender;
- (IBAction)showRegistrationInformation:(id)sender;

@end

@implementation MainMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _jsonLabel.layer.cornerRadius = 8;
    [_jsonSwitch setOn:NO];
 
    //Get MAF Logon Handler instance
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.logonHandler = appDelegate.logonHandler;
    
    //Show MAF settings
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"MAF Settings"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(showRegistrationInformation:)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSError* error = nil;
    MAFLogonRegistrationData* data = [self.logonHandler.logonManager registrationDataWithError:&error];
    
    //Set welcome label
    _welcomeLabel.text = [NSString stringWithFormat:@"Welcome %@", data.backendUserName];
    
////TODO: BEGIN (Set the topmost viewcontroller)
//
//    self.logonHandler.logonUIViewManager.parentViewController = self;
//
////TODO: END (Set the topmost viewcontroller)

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showRegistrationInformation:(id)sender
{
    [self.logonHandler.logonManager registrationInfo];
}


- (IBAction)unregisterUser:(id)sender
{
  
////TODO: BEGIN (Unregister)
//    
//    [self.logonHandler.logonManager deleteUser];
// 
////TODO: END (Unregister)
    
}

- (IBAction)jsonSwitchToggled:(id)sender
{
    [ConnectivitySettings setUseJSON:self.jsonSwitch.isOn];
}

- (IBAction)subscribeForNotification:(id)sender
{
}


@end
