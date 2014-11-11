//
//  RegistrationViewController.m
//  Flights_iOS
//
//  Created by Shin, Jin & Unnai, Kenichi on 7/25/14.
//  Copyright (c) 2014 CEG. All rights reserved.
//

#import "RegistrationViewController.h"
#import "ConnectivitySettings.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "Utilities.h"
#import "MainMenuViewController.h"
#import "MAFLogonCore.h"
#import "MAFLogonContext.h"
#import "MAFLogonRegistrationContext.h"
#import "MAFLogonCoreState.h"

@interface RegistrationViewController ()

@property (strong, nonatomic) AppDelegate *appDelegate;

- (IBAction)registerUser:(id)sender;

@end


@implementation RegistrationViewController

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
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
}

#pragma mark - Registration

- (IBAction)registerUser:(id)sender
{

//TODO: BEGIN (Registering with Logon Context #1)
    
    MAFLogonCore *lc = self.appDelegate.lc;
    MAFLogonCoreState *state = [lc state];

//TODO: END (Registering with Logon Context #1)
    
    //Check that username and password fields are not empty
    if ([self.usernameInput.text length] == 0 || [self.passwordInput.text length] == 0) {
        [Utilities showAlertWithTitle:@"Required Fields Missing"
                           andMessage:@"Enter username and password"];
        return;
    }
    
    if ([[ConnectivitySettings SMPHost] length] == 0) {
        [Utilities showAlertWithTitle:@"SMP server is empty"
                           andMessage:@"Enter the server name in the app settings"];
        return;
    }
    
    if (!state.isRegistered) {

//TODO: BEGIN (Registering with Logon Context #2)
        
        NSError *error = nil;
        MAFLogonContext *mafContext = [lc getContext:&error];
        MAFLogonRegistrationContext *regContext = mafContext.registrationContext;
        
        regContext.applicationId = [ConnectivitySettings SMPAppID];
        regContext.serverHost = [ConnectivitySettings SMPHost];
        regContext.serverPort = [ConnectivitySettings SMPPort];
        regContext.backendUserName = self.usernameInput.text;
        regContext.backendPassword = self.passwordInput.text;
        regContext.isHttps = [ConnectivitySettings useSSL];
        regContext.securityConfig = [ConnectivitySettings SMPSecurityConfiguration];
        
        lc.logonCoreDelegate = self;
        
        [lc registerWithContext:mafContext];
        
//TODO: END (Registering with Logon Context #2)

    } else {
        NSLog(@"Already registered");    
        
        //Call MainMenu Scene
        [self performSegueWithIdentifier: @"ShowMainMenu" sender: self];
    }

    if ([self.usernameInput isFirstResponder]){
        [self.usernameInput resignFirstResponder];
    } else if ([self.passwordInput isFirstResponder]) {
        [self.passwordInput resignFirstResponder];
    }
}

#pragma mark - LogonCore Delegates

- (void)registerFinished:(NSError *)anError
{
    if (anError == nil) {
        
//TODO: BEGIN (Complete Registration Step)
        
        MAFLogonCore *lc = self.appDelegate.lc;
        
        NSError *error = nil;
        MAFLogonContext *context = [lc getContext:&error];
        MAFLogonRegistrationContext *regContext = context.registrationContext;
        
        [lc persistRegistration:@"abcd1234" logonContext:context error:&error];

//TODO: END (Complete Registration Step)
        
//TODO: BEGIN (Fetching Registration Context)
        
        NSDictionary *settings = [regContext.connectionData objectForKey:@"keyMAFLogonConnectionDataApplicationSettings"];
        NSString *appCID = settings[[NSString stringWithFormat:@"d:%@", kApplicationConnectionId]];

//TODO: END (Fetching Registration Context)
        
        NSString *appCIDMessage = [NSString stringWithFormat:@"Application Connection ID: %@", appCID];
        [Utilities showAlertWithTitle:@"Registration Succeeded" andMessage:appCIDMessage];
                        
        //Call MainMenu Scene
        [self performSegueWithIdentifier: @"ShowMainMenu" sender: self];
        
    } else {
        NSLog(@"Error on registration");
        NSLog(@"%@", anError);
    }
}

-(void) unregisterFinished:(NSError*)anError {}

-(void) cancelRegistrationFinished:(NSError*)anError {}

-(void) refreshApplicationSettingsFinished:(NSError*)anError {}

-(void) changePasswordFinished:(NSError*)anError {}

-(void) uploadTraceFinished:(NSError*)anError {}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}

@end
