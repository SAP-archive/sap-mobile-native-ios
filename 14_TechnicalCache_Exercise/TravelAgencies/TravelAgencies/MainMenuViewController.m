//
//  MainMenuViewController.m
//  TravelAgency_RKT
//
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import "MainMenuViewController.h"
#import "ListViewController.h"
#import "TravelAgencyDataController.h"


#import "AppDelegate.h"
#import "Utilities.h"
#import "Constants.h"


#import "MAFLogonHandler.h"
#import "MAFLogonRegistrationData.h"


@interface MainMenuViewController ()

@property (nonatomic, strong) MAFLogonHandler *logonHandler;
@property (nonatomic, strong) TravelAgencyDataController *dataController;
@property (strong, nonatomic) IBOutlet UISwitch *passiveModeSwitch;
@property (strong, nonatomic) IBOutlet UILabel *passiveModeLabel;

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
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(requestCompleted:) name:kRequestCompleted object:nil];
    
    //Show MAF settings
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"MAF Settings"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self action:@selector(showRegistrationInformation:)];
}

#pragma mark - Notification observer
-(void)requestCompleted:(NSNotification *)notification
{
    //TODO: BEGIN (UNCOMMENT TECHNICAL CACHE EXERCISE) ########################################
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.passiveModeSwitch.enabled = YES;
//        self.passiveModeLabel.enabled = YES;
//    });
    
    //TODO: END (UNCOMMENT TECHNICAL CACHE EXERCISE) ########################################
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
   
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return YES;
}




- (IBAction)unregisterUser:(id)sender
{
    //Unregister user
    [self.logonHandler.logonUIViewManager.logonManager deleteUser];
    
}

#pragma mark - Reset Cache
- (IBAction)resetCache:(id)sender {
    
    //TODO: BEGIN (UNCOMMENT TECHNICAL CACHE EXERCISE) ########################################
    
//    self.dataController = [TravelAgencyDataController uniqueInstance];
//    [self.dataController resetCache];
//    
//    if ( self.passiveModeSwitch.on == YES)
//    {
//        [self.dataController disablePassiveMode];
//        self.passiveModeSwitch.on = NO;
//        self.passiveModeSwitch.enabled = NO;
//        self.passiveModeLabel.enabled = NO;
//        [Utilities showAlertWithTitle:@"Successful" andMessage:@"Reset cache done. Passive mode disabled so that data can be read from server to populate cache again."];
//        
//    } else {
//        
//        [Utilities showAlertWithTitle:@"Successful" andMessage:@"Reset cache done"];
//    }
    
    //TODO: END (UNCOMMENT TECHNICAL CACHE EXERCISE) ########################################
   }

#pragma mark - Enable passive mode

- (IBAction)enablePassiveMode:(id)sender {
    
     //TODO: BEGIN (UNCOMMENT TECHNICAL CACHE EXERCISE) ########################################
    
//    self.dataController = [TravelAgencyDataController uniqueInstance];
//    
//    if (((UISwitch*)sender).isOn)
//    {
//        [self.dataController enablePassiveMode];
//    } else
//    {
//        [self.dataController disablePassiveMode];
//    }
//    
     //TODO: END (UNCOMMENT TECHNICAL CACHE EXERCISE) ########################################
}

@end
