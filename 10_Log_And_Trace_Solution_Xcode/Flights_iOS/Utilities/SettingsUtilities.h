/*
 
 File: SettingsUtilities.h
 Abstract: A utility class responsible for reading the application settings (as the service URL, the SAP client and the authentication configurations).
 
 */

#import <Foundation/Foundation.h>


/**
 A utility class responsible for reading the application settings (as the service URL, the SAP client and the authentication configurations).
 */
@interface SettingsUtilities : NSObject

/**
 Update ConnectivitySettings parameters from the application settings.
 */
+ (void)updateConnectivitySettingsFromUserSettings;


@end
