//  TravelAgency_RKT
//
//  Created by Hameed, Thasneem Yasmin.
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import "MAFLogonHandler.h"
#import "Constants.h"
#import "Utilities.h"
#import "AppDelegate.h"
#import "TravelAgencyDataController.h"
#import "SMPClientConnection.h"
#import "SMPAppSettings.h"



@interface MAFLogonHandler ()
@property (nonatomic, strong) TravelAgencyDataController *dataController;
@end


@implementation MAFLogonHandler

-(id) init{
    self = [super init];
    if(self){
        
        
        self.logonUIViewManager = [[MAFLogonUIViewManager alloc] init];
        // save reference to LogonManager for code readability
        self.logonManager = self.logonUIViewManager.logonManager;
        
        //Set up the logon manager: add unique application id
        //You must set your own application id, which is specified in the SMP Server Application Connection Template.
       
        
         AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        [self.logonManager setApplicationId:appDelegate.smpAppID];
        
        // set up the logon delegate
        [self.logonManager setLogonDelegate:self];
                
        
    }
    return self;
}


#pragma mark - MAFLogonNGDelegate implementation

-(void) logonFinishedWithError:(NSError*)anError {
    
    
    if (!anError) {
        
        self.httpConvManager = [[HttpConversationManager alloc] init];
        [[self.logonManager logonConfigurator] configureManager:self.httpConvManager];
        
        self.dataController = [TravelAgencyDataController uniqueInstance];
        
        //TODO: BEGIN (CALL REGISTER TOKEN WITH SMP)**************************************************
        
        
        //TODO: BEGIN (CALL REGISTER TOKEN WITH SMP)**************************************************

        
    } else {
        NSLog(@"logonFinishedWithError:%@", anError);
    }
        
    
}

-(void) lockSecureStoreFinishedWithError:(NSError*)anError {
    NSLog(@"lockSecureStoreFinishedWithError:%@", anError);
}

-(void) updateApplicationSettingsFinishedWithError:(NSError*)anError {
    NSLog(@"updateApplicationSettingsFinishedWithError:%@", anError);
}

-(void) uploadTraceFinishedWithError:(NSError *)anError {
    NSLog(@"uploadTraceFinishedWithError:%@", anError);
}

-(void) changeBackendPasswordFinishedWithError:(NSError*)anError {
    NSLog(@"Password change with error:%@", anError);
}

-(void) deleteUserFinishedWithError:(NSError*)anError {
    if (!anError) {
       
                //Show login
        [self.logonUIViewManager.logonManager logon];
    } else {
        NSLog(@"deleteUserFinishedWithError:%@", anError);
    }
}

-(void) changeSecureStorePasswordFinishedWithError:(NSError*)anError {
    NSLog(@"changeSecureStorePasswordFinishedWithError:%@", anError);
}

-(void) registrationInfoFinishedWithError:(NSError*)anError {
    NSLog(@"registrationInfoFinishedWithError:%@", anError);
}

-(void) startDemoMode {
    NSLog(@"startDemoMode");
}

-(void) refreshCertificateFinishedWithError:(NSError*)anError
{
    
}

- (void)registerAPNSToken {
    
    //Get MAF registration data
    NSError* localError = nil;
    MAFLogonRegistrationData* data = [self.logonUIViewManager.logonManager registrationDataWithError:&localError];
    
    SMPClientConnection *clientConnection = [SMPClientConnection initializeWithAppID:data.applicationId
                                                                              domain:@"default"
                                                                    secConfiguration:data.securityConfig];
    NSString *port = [NSString stringWithFormat:@"%d",data.serverPort];
    [clientConnection setConnectionProfileWithHost:data.serverHost port:port farm:nil relayServerUrlTemplate:nil enableHTTP:data.isHttps ? NO : YES];
    clientConnection.applicationConnectionID = data.applicationConnectionId;
    SMPAppSettings *appSettings = [SMPAppSettings initializeWithConnection:clientConnection userName:data.backendUserName
                                                                  password:data.backendPassword];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    //TODO: BEGIN (REGISTER TOKEN WITH SMP)**************************************************
    
    
    
    //TODO: END (REGISTER TOKEN WITH SMP)****************************************************
    
    
    
    [defaults setObject:nil forKey:@"apnsDeviceToken"];
    [defaults synchronize];
}


@end
