//
//  MainMenuViewController.m
//  Flights_iOS
//
//  Created by Shin, Jin & Unnai, Kenichi on 7/25/14.
//  Copyright (c) 2014 CEG. All rights reserved.
//

#import "MainMenuViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ConnectivitySettings.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "Utilities.h"
#import "MAFLogonCore.h"
#import "MAFLogonContext.h"
#import "MAFLogonRegistrationContext.h"
#import "MAFLogonCoreState.h"

#import "MAFLogonNGPublicAPI.h"
#import "HttpConversationManager.h"
#import "SODataOnlineStore.h"
#import "MAFLogonUIViewManager.h"

@interface MainMenuViewController ()

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSString *appCID;

- (IBAction)unregisterUser:(id)sender;

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
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];

//TODO: BEGIN (Opening Online Store)
    
    NSError *error = nil;
    MAFLogonCore *lc = self.appDelegate.lc;
    MAFLogonUIViewManager *logonUIViewManager = [[MAFLogonUIViewManager alloc] init];
    NSObject<MAFLogonNGPublicAPI> *logonManager= logonUIViewManager.logonManager;
    HttpConversationManager* httpConvManager = [[HttpConversationManager alloc] init];
    [[logonManager logonConfigurator] configureManager:httpConvManager];
    
    MAFLogonContext *context;
    if ([lc unlockSecureStore:@"abcd1234" error:&error]) {
        
        context = [lc getContext:&error];
        
    }
    MAFLogonRegistrationContext *regContext = context.registrationContext;
    
    //logonUIViewManager.parentViewController = self;
    
    SODataOnlineStore *onlineStore = [[SODataOnlineStore alloc]
                                      initWithURL:[NSURL URLWithString:regContext.applicationEndpointURL]
                          httpConversationManager:httpConvManager];

    [onlineStore setOnlineStoreDelegate:self];
    [onlineStore openStoreWithError:&error];

//TODO: END (Opening Online Store)

}

#pragma mark - SODataOnlineStoreDelegate

-(void)onlineStoreOpenFinished:(SODataOnlineStore *)store
{
    [Utilities showAlertWithTitle:@"OnlineStoreOpenFinished!" andMessage:nil];
}

-(void)onlineStoreOpenFailed:(SODataOnlineStore *)store error:(NSError *)error
{
    NSString* msg = [NSString stringWithFormat:@"Error: %@", error.description];
    [Utilities showAlertWithTitle:@"OnlineStoreOpenFailed: " andMessage:msg];
}

#pragma mark local methods

- (IBAction)unregisterUser:(id)sender
{
    MAFLogonCore *lc = self.appDelegate.lc;
    MAFLogonCoreState *state = [lc state];
    
    if (!state.isRegistered) {
        [Utilities showAlertWithTitle:@"User is not registered"
                           andMessage:@"Register user first!"];
        return;
    }

    NSError *error = nil;
    MAFLogonContext *context = [lc getContext:&error];
    MAFLogonRegistrationContext *regContext = context.registrationContext;
    NSDictionary *settings = [regContext.connectionData objectForKey:@"keyMAFLogonConnectionDataApplicationSettings"];
    self.appCID = [settings objectForKey:[NSString stringWithFormat:@"d:%@", kApplicationConnectionId]];
    
//TODO: BEGIN (Unregister)
    
    lc.logonCoreDelegate = self;
    [lc unregister];

//TODO: END (Unregister)
    
}

#pragma mark - LogonCore Delegates

- (void) unregisterFinished:(NSError *)anError
{
    if (anError == nil) {
  
        NSString *appCIDMessage = [NSString stringWithFormat:@"Application Connection ID: %@", self.appCID];
        self.appCID = nil;
        [Utilities showAlertWithTitle:@"Unregistration Succeeded" andMessage:appCIDMessage];
        
        //Show Login Scene
        [self performSegueWithIdentifier:@"ShowLoginScreen" sender:self];
        
    } else {
        self.appCID = nil;
        NSString *errorMessage = [NSString stringWithFormat:@"Error deregistering SMP user: %@",[anError localizedDescription]];
        NSLog(@"%@", errorMessage);
        [Utilities showAlertWithTitle:@"Unregistration Failed" andMessage:errorMessage];
    }
}

-(void) registerFinished:(NSError*)anError {}

-(void) cancelRegistrationFinished:(NSError*)anError {}

-(void) refreshApplicationSettingsFinished:(NSError*)anError {}

-(void) changePasswordFinished:(NSError*)anError {}

-(void) uploadTraceFinished:(NSError*)anError {}

@end
