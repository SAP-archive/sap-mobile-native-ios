//
//  SplashViewController.m
//  TravelAgency_RKT
//
//  Created by Hameed, Thasneem Yasmin.
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import "MainMenuViewController.h"
#import "ListViewController.h"
#import "TravelAgencyDataController.h"


#import "AppDelegate.h"
#import "Utilities.h"


#import "MAFLogonHandler.h"
#import "MAFLogonRegistrationData.h"


@interface MainMenuViewController ()

@property (nonatomic, strong) MAFLogonHandler *logonHandler;
@property (nonatomic, strong) TravelAgencyDataController *dataController;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    
    //Get MAF Logon Handler instance
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    self.logonHandler = appDelegate.logonHandler;
    self.logonHandler.logonUIViewManager.parentViewController = self; 
    
    //Show MAF settings
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"MAF Settings"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self action:@selector(showRegistrationInformation:)];
}

- (void)showRegistrationInformation:(id)sender
{
    
    [self.logonHandler.logonUIViewManager.logonManager registrationInfo];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goOnline"]) {
        [segue.destinationViewController setWorkingMode:WorkingModeOnline];
    } else if ([segue.identifier isEqualToString:@"goOffline"]) {
        [segue.destinationViewController setWorkingMode:WorkingModeOffline];
    }
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return YES;
}


- (IBAction)clearOfflineStore:(id)sender {
    
//TODO: BEGIN (UNCOMMENT OFFLINE ODATA EXERCISE) ########################################
    
//    self.dataController = [TravelAgencyDataController uniqueInstance];
//    [self.dataController clearStore];
    
//TODO: END (UNCOMMENT OFFLINE ODATA EXERCISE) ########################################
    }



- (IBAction)unregisterUser:(id)sender
{
    //Unregister user
    [self.logonHandler.logonUIViewManager.logonManager deleteUser];
    
}


@end
