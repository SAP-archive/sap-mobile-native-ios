//
//  FlightsMAFLogonHandler.m
//  Flights_iOS
//
//  Created by Shin, Jin & Unnai, Kenichi on 7/15/14.
//  Copyright (c) 2014 CEG. All rights reserved.
//

#import "FlightsMAFLogonHandler.h"
#import "AppDelegate.h"
#import "MainMenuViewController.h"

@interface FlightsMAFLogonHandler ()

@end

@implementation FlightsMAFLogonHandler

-(id) init
{
    self = [super init];
    if(self){
       
////TODO: BEGIN (MAF managers #2)
//        
//        self.logonUIViewManager = [[MAFLogonUIViewManager alloc] init];
//        
//        // save reference to LogonManager for code readability
//        self.logonManager = self.logonUIViewManager.logonManager;
//        
//        //Set up the logon manager: add unique application id
//        //You must set your own application id, which is specified in the SMP Server Application Connection Template.
//        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//        [self.logonManager setApplicationId:appDelegate.smpAppID];
//        
//        // set up the logon delegate
//        [self.logonManager setLogonDelegate:self];
//        
////TODO: END (MAF managers #2)
        
    }
    return self;
}

#pragma mark - MAFLogonNGDelegate

-(void) logonFinishedWithError:(NSError*)anError
{
    if (!anError) {

////TODO: BEGIN (MAF onboarding)
//        
//        //Get MAF registration data
//        NSError *error = nil;
//        MAFLogonRegistrationData *data = [self.logonUIViewManager.logonManager registrationDataWithError:&error];
//        
//        self.httpConvManager = [[HttpConversationManager alloc] init];
//        [[self.logonManager logonConfigurator] configureManager:self.httpConvManager];
//
////TODO: END (MAF onboarding)
        
        //Set welcome label
        MainMenuViewController *mainMenuViewController = [[MainMenuViewController alloc] init];
        mainMenuViewController.welcomeLabel.text = [NSString stringWithFormat:@"Welcome %@", data.backendUserName];
        
    } else {
        NSLog(@"logonFinishedWithError:%@", anError);
    }
}

-(void) deleteUserFinishedWithError:(NSError*)anError
{
    if (!anError) {
        //Show login
        [self.logonUIViewManager.logonManager logon];
    } else {
        NSLog(@"deleteUserFinishedWithError:%@", anError);
    }
}

-(void) lockSecureStoreFinishedWithError:(NSError*)anError {}

-(void) updateApplicationSettingsFinishedWithError:(NSError*)anError {}

-(void) changeBackendPasswordFinishedWithError:(NSError*)anError {}

-(void) changeSecureStorePasswordFinishedWithError:(NSError*)anError {}

-(void) registrationInfoFinishedWithError:(NSError*)anError {}

-(void) uploadTraceFinishedWithError:(NSError*)anError {}

-(void) startDemoMode {}

-(void) refreshCertificateFinishedWithError:(NSError*)anError {}

@end
