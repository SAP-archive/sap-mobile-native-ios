//
//  AppDelegate.m
//  TravelAgency_RKT
//
//  Created by Hameed, Thasneem Yasmin on 6/28/14.
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingsUtilities.h"
#import "TravelAgencyDataController.h"
#import "Constants.h"
#import "Utilities.h"

#import "SODataOfflineStore.h"


@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
   
    //TODO: BEGIN (PUSH REGISTRATION)**************************************************
    
    
    
    //TODO: END (PUSH REGISTRATION)****************************************************
    
    [SODataOfflineStore GlobalInit];
    
    //Load app settings (for MAF enabled logon it's only Application ID)
    [SettingsUtilities updateConnectivitySettingsFromUserSettings];
    
    
    // Load the styles for the cutomizable controls, should be called before any MAF* control and MAFLogonUI created
    [MAFUIStyleParser loadSAPDefaultStyle];
   
    self.logonHandler = [[MAFLogonHandler alloc] init];
    self.window.rootViewController = [self.window.rootViewController.storyboard instantiateInitialViewController];
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // Execute logon operation, which will automatically present logon screen if needed.
    [self.logonHandler.logonManager logon];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    
    [SODataOfflineStore GlobalFini];
    
}

#pragma mark - APNS: Delegate Methods


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    
    
    //TODO: BEGIN (APNS DID REGISTER)**************************************************
    
	
    
    //TODO: END (APNS DID REGISTER)****************************************************
    
    
}


- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    
    
    //TODO: BEGIN (APNS DID FAIL to REGISTER)**************************************************
    
	
    
    //TODO: END (APNS DID FAIL to REGISTER)****************************************************
    
    
}


- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    
    
    //TODO: BEGIN (DID RECEIVE NOTIFICATION)**************************************************
    
    
    //TODO: END (DID RECEIVE NOTIFICATION)****************************************************
    
    
}



@end
